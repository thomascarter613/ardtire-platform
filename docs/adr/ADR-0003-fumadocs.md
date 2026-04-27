# ADR-0003: Adopt Fumadocs for apps/docs and apps/log

Date: 2026-04-27

## Status

Accepted

## Context

The platform includes user-facing documentation and operational site requirements that benefit from a documentation-focused rendering pipeline.

Fumadocs is referenced as the docs generator for the `apps/docs` and `apps/log` applications.

## Decision

We will adopt Fumadocs for the `apps/docs` and `apps/log` projects, enabling shared documentation tooling and consistent content generation.

## Consequences

- ✅ Standardized documentation rendering for content-driven apps.
- ✅ Aligns the docs and log applications under a single docs-oriented toolchain.
- ⚠️ Requires Fumadocs-specific configuration and familiarity for docs contributors.

## Alternatives

- **Next.js only**: Could work for all apps, but would blur the distinction between documentation-first and application-first workflows.
- **MkDocs / Docusaurus**: Other static documentation generators, but would require additional integration effort and may not match the repo's chosen framework.
