# Skills Public

A collection of specialized skills for iOS and Swift development workflows.

## Overview

This repository contains a set of focused skills designed to assist with common iOS development tasks, from generating release notes to debugging apps and maintaining code quality.

## Skills

### 📝 App Store Changelog

**Purpose**: Generate user-facing App Store release notes from git history.

Automatically collects commits and changes since the last git tag (or a specified ref) and transforms them into clear, benefit-focused release notes suitable for the App Store. Filters out internal-only changes and groups user-visible improvements by theme.

**Key Features**:
- Collects commits and touched files since the last tag
- Identifies user-visible changes vs internal work
- Generates concise, benefit-focused bullet points
- Validates changes map back to actual commits

**Use When**: You need to create App Store "What's New" text or release notes based on git history.

---

### 🐛 iOS Debugger Agent

**Purpose**: Build, run, and debug iOS projects on simulators using XcodeBuildMCP.

Provides a comprehensive workflow for building iOS apps, launching them on simulators, interacting with the UI, and capturing logs. Handles simulator discovery, session setup, and runtime debugging.

**Key Features**:
- Discovers and manages booted simulators
- Builds and runs apps on simulators
- Interacts with UI (tap, type, swipe, gestures)
- Captures and analyzes app logs
- Screenshots and UI inspection

**Use When**: You need to run an iOS app, interact with the simulator UI, inspect on-screen state, or diagnose runtime behavior.

---

### ⚡ Swift Concurrency Expert

**Purpose**: Review and fix Swift Concurrency issues for Swift 6.2+ codebases.

Applies actor isolation, Sendable safety, and modern concurrency patterns to resolve compiler errors and improve concurrency compliance. Focuses on minimal behavior changes while ensuring data-race safety.

**Key Features**:
- Identifies actor context and isolation issues
- Applies safe fixes preserving existing behavior
- Handles UI-bound types, protocols, and background work
- Ensures Sendable compliance

**Use When**: You need to review Swift Concurrency usage, improve concurrency compliance, or fix Swift concurrency compiler errors.

---

### 💎 SwiftUI Liquid Glass

**Purpose**: Implement and review SwiftUI features using iOS 26+ Liquid Glass API.

Helps adopt the native Liquid Glass API in SwiftUI interfaces, ensuring correct usage, performance, and design alignment. Supports both new implementations and refactoring existing features.

**Key Features**:
- Uses native `glassEffect` and `GlassEffectContainer` APIs
- Ensures proper modifier ordering and composition
- Handles iOS 26+ availability with fallbacks
- Implements interactive glass for tappable elements
- Supports morphing transitions

**Use When**: You need to adopt Liquid Glass in new SwiftUI UI, refactor existing features to Liquid Glass, or review Liquid Glass usage for correctness.

---

### 🔧 SwiftUI View Refactor

**Purpose**: Refactor SwiftUI view files for consistent structure and dependency patterns.

Applies standardized ordering, Model-View (MV) patterns, and correct Observation usage to SwiftUI views. Focuses on making views lightweight, composable, and maintainable.

**Key Features**:
- Enforces consistent view ordering (Environment → State → init → body → helpers)
- Promotes MV patterns over view models when possible
- Handles view models safely (non-optional when possible)
- Ensures correct `@Observable` and `@State` usage
- Supports dependency injection via `@Environment`

**Use When**: You need to clean up a SwiftUI view's structure, handle view models safely, or standardize dependency injection and Observation usage.

---

## Usage

Each skill is self-contained with its own documentation. Refer to the `SKILL.md` file in each skill's directory for detailed workflows, guidelines, and examples.

## Contributing

Skills are designed to be focused and reusable. When adding new skills, ensure they:
- Have a clear, single purpose
- Include comprehensive documentation
- Follow consistent patterns with existing skills
- Include reference materials when applicable
