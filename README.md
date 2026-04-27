# ardtire-platform

Monorepo for the Ardtire Society's digital platform — member governance, participation, identity, content, and institutional records.

## Stack

| Layer | Technology |
|---|---|
| Package manager | Bun |
| Task orchestration | Moon |
| App framework | TanStack Start + SolidJS |
| Docs & Log | Fumadocs (Next.js App Router) |
| CMS | Payload CMS 3.x |
| Participation | Decidim (Ruby on Rails) |
| Identity | Keycloak |
| API | Hono + Node |
| Database | PostgreSQL + Prisma + pgvector |
| Linter / Formatter | Biome |
| Testing | Vitest |
| Git hooks | Lefthook |

## Workspaces

| Path | Name | Purpose |
|---|---|---|
| `apps/www` | ardtire-www | Public site |
| `apps/my` | ardtire-my | Member portal |
| `apps/admin` | ardtire-admin | Internal admin |
| `apps/gov-api` | ardtire-gov-api | Governance API (Hono) |
| `apps/worker` | ardtire-worker | Background worker |
| `apps/cms` | ardtire-cms | Payload CMS |
| `apps/docs` | ardtire-docs | Public documentation (Fumadocs) |
| `apps/log` | ardtire-log | Captain's Log (Fumadocs) |
| `packages/ui` | @ardtire/ui | SolidJS component library |
| `packages/tokens` | @ardtire/tokens | Shared CSS design tokens |
| `packages/ui-docs` | @ardtire/ui-docs | Fumadocs-specific shared components |
| `packages/db` | @ardtire/db | Prisma schema + client |
| `packages/types` | @ardtire/types | Shared TypeScript types + Zod schemas |
| `packages/config` | @ardtire/config | Shared TS/Biome/Vitest configs |
| `packages/auth` | @ardtire/auth | Auth utilities (Keycloak PKCE) |
| `packages/logger` | @ardtire/logger | Structured logger |

## Commands

```bash
bun install          # Install all dependencies
moon check --all     # Run lint + typecheck + test across all projects
moon ci              # CI mode — affected projects only
moon run <id>:<task> # Run a specific task in a specific project
bun run syncpack     # Check version coherence across workspace packages
```

## Architecture Decisions

See `docs/adr/` for all Architecture Decision Records.
