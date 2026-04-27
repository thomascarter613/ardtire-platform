# ADR-0001: Adopt Bun as Monorepo Package Manager

Date: 2026-04-27

## Status

Accepted

## Context

The ardtire-platform monorepo is built around modern JavaScript tooling and aims for fast installs, simple dependency management, and a consistent developer experience across packages.

The repo already uses Bun for task execution and package management in generated package scripts and devcontainer setup.

## Decision

We will adopt Bun as the monorepo package manager and dependency runtime for local development, installs, and package script execution.

## Consequences

- ✅ Faster dependency installation and package execution in the dev container.
- ✅ Reduced complexity by keeping package scripts aligned with Bun and Bunx.
- ✅ Consistency with the scaffolded package setup and existing `bun.lock` lockfile.
- ⚠️ Requires team members to use Bun-compatible workflows or install the Bun runtime in supported environments.

## Alternatives

- **npm / Yarn / pnpm**: More widely adopted but would introduce a second package manager and duplicate lockfile considerations.
- **Package manager agnostic scripts**: Would increase tooling complexity and reduce the benefits of Bun's integrated runtime and performance.
