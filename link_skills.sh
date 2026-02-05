#!/bin/bash

# Script to symlink skills from a cloned Skills repository to various AI agents
# Usage: ./link_skills.sh <agent_name> [path_to_skills_repo]
#
# If path is not provided, the current directory will be used.
#
# Supported agents:
#   - claude-code
#   - codex
#   - cursor
#   - windsurf
#
# Examples:
#   cd ~/Developer/agent/Skills && ./link_skills.sh claude-code
#   ./link_skills.sh claude-code ~/Developer/agent/Skills
#   ./link_skills.sh codex ~/my/Skills
#   cd /path/to/Skills && ./link_skills.sh cursor

set -e

# Function to show usage
show_usage() {
    echo "Usage: $0 <agent_name> [path_to_skills_repo]"
    echo ""
    echo "If path is not provided, the current directory will be used."
    echo ""
    echo "Supported agents:"
    echo "  claude-code    Claude Code"
    echo "  codex          Codex"
    echo "  cursor         Cursor"
    echo "  windsurf       Windsurf"
    echo ""
    echo "Examples:"
    echo "  cd ~/Developer/agent/Skills && $0 claude-code"
    echo "  $0 claude-code ~/Developer/agent/Skills"
    echo "  $0 codex ~/my/Skills"
    echo "  cd /path/to/Skills && $0 cursor"
    exit 1
}

# Parse arguments
AGENT_NAME=""
SKILLS_REPO=""

# If no arguments, show help
if [ $# -eq 0 ]; then
    show_usage
fi

# Check if first argument looks like an agent name or a path
if [ -n "$1" ]; then
    case "$1" in
        claude-code|codex|cursor|windsurf)
            AGENT_NAME="$1"
            # Use provided path or current directory
            SKILLS_REPO="${2:-$(pwd)}"
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            echo "Error: Unknown agent '$1'"
            echo ""
            show_usage
            ;;
    esac
fi

# Validate that we have an agent name
if [ -z "$AGENT_NAME" ]; then
    echo "Error: Agent name is required"
    echo ""
    show_usage
fi

# Determine the skills directory based on the agent
case "$AGENT_NAME" in
    claude-code)
        AGENT_SKILLS_DIR="$HOME/.claude/skills"
        AGENT_DISPLAY_NAME="Claude Code"
        ;;
    codex)
        AGENT_SKILLS_DIR="$HOME/.codex/skills"
        AGENT_DISPLAY_NAME="Codex"
        ;;
    cursor)
        AGENT_SKILLS_DIR="$HOME/.cursor/skills"
        AGENT_DISPLAY_NAME="Cursor"
        ;;
    windsurf)
        AGENT_SKILLS_DIR="$HOME/.windsurf/skills"
        AGENT_DISPLAY_NAME="Windsurf"
        ;;
    *)
        echo "Error: Unknown agent '$AGENT_NAME'"
        show_usage
        ;;
esac

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "AI Agent Skills Symlink Setup"
echo "=========================================="
echo -e "${BLUE}Agent: $AGENT_DISPLAY_NAME${NC}"
echo -e "${BLUE}Skills Directory: $AGENT_SKILLS_DIR${NC}"
echo "=========================================="
echo ""

# Check if the skills repository exists
if [ ! -d "$SKILLS_REPO" ]; then
    echo -e "${RED}Error: Skills repository not found at: $SKILLS_REPO${NC}"
    echo ""
    echo "Please provide the correct path:"
    echo "  $0 $AGENT_NAME /path/to/Skills"
    exit 1
fi

# Create agent skills directory if it doesn't exist
if [ ! -d "$AGENT_SKILLS_DIR" ]; then
    echo -e "${YELLOW}Creating $AGENT_DISPLAY_NAME skills directory: $AGENT_SKILLS_DIR${NC}"
    mkdir -p "$AGENT_SKILLS_DIR"
fi

# Counter for statistics
linked_count=0
skipped_count=0
failed_count=0

echo "Scanning for skills in: $SKILLS_REPO"
echo ""

# Loop through all subdirectories in the Skills repo
for skill_path in "$SKILLS_REPO"/*/ ; do
    # Skip if no directories found
    [ -e "$skill_path" ] || continue
    
    skill_name=$(basename "$skill_path")
    target_link="$AGENT_SKILLS_DIR/$skill_name"
    
    # Skip hidden directories
    if [[ "$skill_name" == .* ]]; then
        continue
    fi
    
    # Check if SKILL.md exists in the directory
    if [ ! -f "$skill_path/SKILL.md" ]; then
        echo -e "${YELLOW}⚠ Skipping $skill_name (no SKILL.md found)${NC}"
        ((skipped_count++))
        continue
    fi
    
    # Check if symlink already exists
    if [ -L "$target_link" ]; then
        # Check if it points to the correct location
        current_target=$(readlink "$target_link")
        if [ "$current_target" = "$skill_path" ]; then
            echo -e "${GREEN}✓ $skill_name (already linked)${NC}"
            ((linked_count++))
        else
            echo -e "${YELLOW}⚠ $skill_name (symlink exists but points to different location)${NC}"
            echo "  Current: $current_target"
            echo "  Expected: $skill_path"
            ((skipped_count++))
        fi
    # Check if directory already exists (not a symlink)
    elif [ -e "$target_link" ]; then
        echo -e "${YELLOW}⚠ Skipping $skill_name (directory already exists, not a symlink)${NC}"
        ((skipped_count++))
    else
        # Create the symlink
        if ln -s "$skill_path" "$target_link" 2>/dev/null; then
            echo -e "${GREEN}✓ Linked: $skill_name${NC}"
            ((linked_count++))
        else
            echo -e "${RED}✗ Failed to link: $skill_name${NC}"
            ((failed_count++))
        fi
    fi
done

echo ""
echo "=================================="
echo "Summary:"
echo "  Linked: $linked_count"
echo "  Skipped: $skipped_count"
echo "  Failed: $failed_count"
echo "=================================="
echo ""

if [ $linked_count -gt 0 ]; then
    echo -e "${GREEN}Skills have been symlinked successfully!${NC}"
    echo -e "${YELLOW}Please restart $AGENT_DISPLAY_NAME to load the new skills.${NC}"
else
    echo -e "${YELLOW}No new skills were linked.${NC}"
fi

echo ""
echo "Agent: $AGENT_DISPLAY_NAME"
echo "Skills location: $AGENT_SKILLS_DIR"
echo "Source repository: $SKILLS_REPO"
