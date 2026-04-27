# ADR-0002: Adopt Moon as Monorepo Task Orchestrator

Date: 2026-04-27

## Status

Accepted

## Context

The ardtire-platform repository contains multiple applications and packages that need coordinated build, lint, typecheck, and test workflows.

Moon is designed for monorepo task orchestration and provides affected-task detection, a shared workspace model, and consistent project task definitions.

## Decision

We will adopt Moon as the primary monorepo task orchestrator for build, lint, format, typecheck, and test pipelines.

## Consequences

- ✅ Centralized task definitions via the root and package-level `moon.yml` files.
- ✅ Affected project detection and efficient incremental execution.
- ✅ Better alignment with CI workflows and monorepo orchestration patterns.
- ⚠️ Team contributors need to use Moon-aware commands (`moon run`, `moon check`, etc.) when working across the repo.

## Alternatives

- **npm scripts only**: Simpler but less scalable for large monorepos and missing affected-task orchestration.
- **Turborepo / nx**: Powerful alternatives, but would introduce additional complexity and migration overhead for the current repo structure.
