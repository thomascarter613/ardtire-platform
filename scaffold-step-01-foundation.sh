moon check --all#!/usr/bin/env bash
# =============================================================================
# ardtire-platform — Step 01: Monorepo Foundation
# =============================================================================
# Scaffolds the complete monorepo tooling layer:
#   - Directory structure (apps/*, packages/*)
#   - Bun workspaces (root package.json)
#   - deps.json canonical version manifest
#   - syncpack config
#   - Biome config (root)
#   - TypeScript config (root)
#   - Lefthook config
#   - Moon workspace, toolchain, and inherited tasks
#   - .gitignore
#   - devcontainer.json
#   - GitHub Actions CI (foundation)
#   - README stub
#
# Run from the repo root in your Codespace:
#   bash scaffold-step-01-foundation.sh
# =============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
RESET="\033[0m"

log()  { echo -e "${CYAN}▶ $1${RESET}"; }
ok()   { echo -e "${GREEN}✔ $1${RESET}"; }
warn() { echo -e "${YELLOW}⚠ $1${RESET}"; }
header() { echo -e "\n${BOLD}━━━ $1 ━━━${RESET}\n"; }

# =============================================================================
# 1. DIRECTORY STRUCTURE
# =============================================================================
header "1 / Directory Structure"

mkdir -p \
  apps/www \
  apps/my \
  apps/admin \
  apps/gov-api \
  apps/worker \
  apps/cms \
  apps/docs \
  apps/log \
  packages/ui \
  packages/tokens \
  packages/ui-docs \
  packages/db \
  packages/types \
  packages/config \
  packages/auth \
  packages/logger \
  .moon \
  .github/workflows \
  .devcontainer

ok "Directory tree created"

# =============================================================================
# 2. DEPS.JSON — Canonical version manifest (replaces pnpm catalog)
# =============================================================================
header "2 / deps.json — Canonical Version Manifest"

cat > deps.json << 'EOF'
{
  "_comment": "Single source of truth for shared dependency versions across all workspace packages. All generators must read from here. syncpack enforces coherence at CI time.",
  "runtimes": {
    "bun": "1.1.38",
    "node": "22.12.0",
    "ruby": "3.3.6"
  },
  "core": {
    "typescript": "5.8.3",
    "zod": "3.24.2"
  },
  "frontend": {
    "solid-js": "1.9.5",
    "@solidjs/router": "0.15.3",
    "@tanstack/solid-router": "1.114.0",
    "@tanstack/solid-query": "5.74.4"
  },
  "backend": {
    "hono": "4.7.7",
    "@hono/node-server": "1.14.1"
  },
  "database": {
    "prisma": "6.6.0",
    "@prisma/client": "6.6.0"
  },
  "tooling": {
    "@biomejs/biome": "1.9.4",
    "vitest": "3.1.1",
    "lefthook": "1.11.12",
    "syncpack": "13.1.1",
    "typescript": "5.8.3"
  },
  "next": {
    "next": "15.3.1",
    "react": "19.1.0",
    "react-dom": "19.1.0"
  },
  "fumadocs": {
    "fumadocs-core": "15.0.2",
    "fumadocs-mdx": "11.1.3",
    "fumadocs-openapi": "6.0.0",
    "fumadocs-ui": "15.0.2"
  }
}
EOF

ok "deps.json written"

# =============================================================================
# 3. ROOT PACKAGE.JSON
# =============================================================================
header "3 / Root package.json"

cat > package.json << 'EOF'
{
  "name": "ardtire-platform",
  "version": "0.0.0",
  "private": true,
  "description": "Monorepo for the Ardtire Society's digital platform — member governance, participation, identity, content, and institutional records.",
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "build":        "moon run :build",
    "dev":          "moon run :dev",
    "lint":         "moon run :lint",
    "format":       "moon run :format",
    "typecheck":    "moon run :typecheck",
    "test":         "moon run :test",
    "check":        "moon check --all",
    "ci":           "moon ci",
    "syncpack":     "syncpack list-mismatches",
    "syncpack:fix": "syncpack fix-mismatches",
    "prepare":      "lefthook install"
  },
  "devDependencies": {
    "@biomejs/biome":        "1.9.4",
    "@moonrepo/cli":         "1.31.0",
    "lefthook":              "1.11.12",
    "syncpack":              "13.1.1",
    "typescript":            "5.8.3"
  }
}
EOF

ok "root package.json written"

# =============================================================================
# 4. SYNCPACK CONFIG
# =============================================================================
header "4 / syncpack config"

cat > .syncpackrc.json << 'EOF'
{
  "$schema": "https://unpkg.com/syncpack/dist/config.schema.json",
  "indent": "  ",
  "semverGroups": [],
  "versionGroups": [
    {
      "label": "Fumadocs and Next.js — permitted only in apps/docs, apps/log, packages/ui-docs",
      "packages": ["ardtire-www", "ardtire-my", "ardtire-admin", "ardtire-gov-api", "ardtire-worker", "ardtire-cms", "@ardtire/ui", "@ardtire/db", "@ardtire/types", "@ardtire/config", "@ardtire/auth", "@ardtire/logger", "@ardtire/tokens"],
      "dependencies": ["next", "react", "react-dom", "fumadocs-core", "fumadocs-ui", "fumadocs-mdx", "fumadocs-openapi"],
      "isBanned": true
    },
    {
      "label": "Shared platform deps — must be identical across all TS/JS packages",
      "packages": ["**"],
      "dependencies": ["typescript", "zod", "@biomejs/biome", "vitest"],
      "policy": "sameRange"
    }
  ]
}
EOF

ok ".syncpackrc.json written"

# =============================================================================
# 5. BIOME CONFIG (ROOT)
# =============================================================================
header "5 / Biome root config"

cat > biome.json << 'EOF'
{
  "$schema": "https://biomejs.dev/schemas/1.9.4/schema.json",
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  },
  "files": {
    "ignoreUnknown": false,
    "ignore": [
      "**/node_modules/**",
      "**/dist/**",
      "**/.next/**",
      "**/build/**",
      "**/.moon/**",
      "**/prisma/migrations/**",
      "bun.lock"
    ]
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100
  },
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedImports": "warn",
        "noUnusedVariables": "warn"
      },
      "style": {
        "useImportType": "error"
      }
    }
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "double",
      "trailingCommas": "es5",
      "semicolons": "always"
    }
  },
  "overrides": [
    {
      "include": ["apps/docs/**", "apps/log/**"],
      "linter": {
        "rules": {
          "correctness": {
            "useExhaustiveDependencies": "off"
          }
        }
      }
    }
  ]
}
EOF

ok "biome.json written"

# =============================================================================
# 6. ROOT TSCONFIG.JSON
# =============================================================================
header "6 / Root tsconfig.json"

cat > tsconfig.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "strict": true,
    "exactOptionalPropertyTypes": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noPropertyAccessFromIndexSignature": true,
    "isolatedModules": true,
    "allowImportingTsExtensions": false,
    "verbatimModuleSyntax": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "baseUrl": ".",
    "paths": {}
  },
  "exclude": [
    "**/node_modules",
    "**/dist",
    "**/.next",
    "**/build"
  ]
}
EOF

ok "tsconfig.json written"

# =============================================================================
# 7. LEFTHOOK CONFIG
# =============================================================================
header "7 / Lefthook config"

cat > lefthook.yml << 'EOF'
# =============================================================================
# Lefthook — Git hooks for ardtire-platform
# =============================================================================

pre-commit:
  parallel: true
  commands:
    biome-check:
      glob: "*.{js,jsx,ts,tsx,json}"
      run: bunx biome check --no-errors-on-unmatched --files-ignore-unknown=true {staged_files}
    syncpack-check:
      run: bun run syncpack
      root: true

commit-msg:
  commands:
    conventional-commits:
      run: |
        commit_msg=$(cat {1})
        pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,100}$"
        if ! echo "$commit_msg" | grep -qP "$pattern"; then
          echo "❌ Commit message does not follow Conventional Commits."
          echo "   Format: type(scope): description"
          echo "   Example: feat(gov-api): add proposal creation endpoint"
          exit 1
        fi

pre-push:
  commands:
    typecheck:
      run: moon run :typecheck
EOF

ok "lefthook.yml written"

# =============================================================================
# 8. MOON — workspace.yml
# =============================================================================
header "8 / Moon — workspace.yml"

cat > .moon/workspace.yml << 'EOF'
# =============================================================================
# Moon workspace configuration — ardtire-platform
# =============================================================================
$schema: "https://moonrepo.dev/schemas/workspace.json"

# Project discovery
projects:
  globs:
    - "apps/*"
    - "packages/*"

# Version control
vcs:
  manager: "git"
  defaultBranch: "main"
  syncHooks: true

# Caching
runner:
  cacheLifetime: "7 days"
  inheritColorsForPipedTasks: true
  logRunningCommand: true

# Telemetry — off
telemetry: false

# Constraints — enforce the React containment boundary at the project graph level
constraints:
  enforceProjectTypeRelationships: true
EOF

ok ".moon/workspace.yml written"

# =============================================================================
# 9. MOON — toolchain.yml
# =============================================================================
header "9 / Moon — toolchain.yml"

cat > .moon/toolchain.yml << 'EOF'
# =============================================================================
# Moon toolchain — ardtire-platform
# Single source of truth for all runtime versions.
# Do NOT use .nvmrc, .ruby-version, or .tool-versions alongside this file.
# =============================================================================
$schema: "https://moonrepo.dev/schemas/toolchain.json"

bun:
  version: "1.1.38"
  installArgs: ["--frozen-lockfile"]

node:
  version: "22.12.0"
  packageManager: "bun"

# Ruby is required for apps/cms-decidim (Decidim participation layer).
# Pinned to the version compatible with the Decidim release in use.
ruby:
  version: "3.3.6"
EOF

ok ".moon/toolchain.yml written"

# =============================================================================
# 10. MOON — tasks.yml (inherited workspace-level tasks)
# =============================================================================
header "10 / Moon — tasks.yml"

cat > .moon/tasks.yml << 'EOF'
# =============================================================================
# Moon inherited task definitions — ardtire-platform
# All projects inherit these tasks unless they override in their moon.yml.
# =============================================================================
$schema: "https://moonrepo.dev/schemas/tasks.json"

implicitInputs:
  - "package.json"
  - "tsconfig.json"
  - "biome.json"

tasks:
  # ---------------------------------------------------------------------------
  # Build
  # ---------------------------------------------------------------------------
  build:
    command: "bun run build"
    inputs:
      - "src/**/*"
      - "tsconfig.json"
    outputs:
      - "dist/**/*"
    options:
      runInCI: true
      cache: true

  # ---------------------------------------------------------------------------
  # Development server
  # ---------------------------------------------------------------------------
  dev:
    command: "bun run dev"
    local: true
    options:
      persistent: true

  # ---------------------------------------------------------------------------
  # Lint (Biome)
  # ---------------------------------------------------------------------------
  lint:
    command: "bunx biome lint ./src"
    inputs:
      - "src/**/*.{ts,tsx,js,jsx}"
      - "biome.json"
    options:
      runInCI: true

  # ---------------------------------------------------------------------------
  # Format (Biome)
  # ---------------------------------------------------------------------------
  format:
    command: "bunx biome format ./src"
    inputs:
      - "src/**/*.{ts,tsx,js,jsx,json}"
    options:
      runInCI: false

  # ---------------------------------------------------------------------------
  # Type checking
  # ---------------------------------------------------------------------------
  typecheck:
    command: "bun run typecheck"
    inputs:
      - "src/**/*.{ts,tsx}"
      - "tsconfig.json"
    options:
      runInCI: true

  # ---------------------------------------------------------------------------
  # Tests (Vitest)
  # ---------------------------------------------------------------------------
  test:
    command: "bun run test"
    inputs:
      - "src/**/*"
      - "test/**/*"
      - "vitest.config.ts"
    options:
      runInCI: true

  # ---------------------------------------------------------------------------
  # Syncpack version coherence check
  # Applied at workspace root only (override suppresses in individual packages)
  # ---------------------------------------------------------------------------
  syncpack:check:
    command: "bun run syncpack"
    inputs:
      - "**/package.json"
      - "!**/node_modules/**"
    options:
      runInCI: true
      runFromWorkspaceRoot: true
EOF

ok ".moon/tasks.yml written"

# =============================================================================
# 11. STUB moon.yml FOR EACH APP AND PACKAGE
# =============================================================================
header "11 / moon.yml stubs — apps and packages"

# Helper to write a moon.yml stub
write_moon_yml() {
  local dir=$1
  local id=$2
  local type=$3
  local lang=${4:-"typescript"}
  cat > "$dir/moon.yml" << EOF
\$schema: "https://moonrepo.dev/schemas/project.json"

id: "$id"
type: "$type"
language: "$lang"

# Task overrides go here. Omit to inherit workspace defaults from .moon/tasks.yml.
tasks: {}
EOF
}

write_moon_yml apps/www       "ardtire-www"       "application"
write_moon_yml apps/my        "ardtire-my"        "application"
write_moon_yml apps/admin     "ardtire-admin"     "application"
write_moon_yml apps/gov-api   "ardtire-gov-api"   "application"
write_moon_yml apps/worker    "ardtire-worker"    "application"
write_moon_yml apps/cms       "ardtire-cms"       "application"
write_moon_yml apps/docs      "ardtire-docs"      "application"
write_moon_yml apps/log       "ardtire-log"       "application"
write_moon_yml packages/ui    "@ardtire/ui"       "library"
write_moon_yml packages/tokens "@ardtire/tokens"  "library"
write_moon_yml packages/ui-docs "@ardtire/ui-docs" "library"
write_moon_yml packages/db    "@ardtire/db"       "library"
write_moon_yml packages/types "@ardtire/types"    "library"
write_moon_yml packages/config "@ardtire/config"  "library"
write_moon_yml packages/auth  "@ardtire/auth"     "library"
write_moon_yml packages/logger "@ardtire/logger"  "library"

ok "moon.yml stubs written for all apps and packages"

# =============================================================================
# 12. STUB PACKAGE.JSON FOR EACH APP AND PACKAGE
# =============================================================================
header "12 / package.json stubs — apps and packages"

write_pkg() {
  local dir=$1
  local name=$2
  cat > "$dir/package.json" << EOF
{
  "name": "$name",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "build":     "echo 'TODO: configure build'",
    "dev":       "echo 'TODO: configure dev'",
    "lint":      "biome lint ./src",
    "format":    "biome format ./src",
    "typecheck": "tsc --noEmit",
    "test":      "vitest run"
  }
}
EOF
  mkdir -p "$dir/src"
}

write_pkg apps/www        "ardtire-www"
write_pkg apps/my         "ardtire-my"
write_pkg apps/admin      "ardtire-admin"
write_pkg apps/gov-api    "ardtire-gov-api"
write_pkg apps/worker     "ardtire-worker"
write_pkg apps/cms        "ardtire-cms"
write_pkg apps/docs       "ardtire-docs"
write_pkg apps/log        "ardtire-log"
write_pkg packages/ui     "@ardtire/ui"
write_pkg packages/tokens "@ardtire/tokens"
write_pkg packages/ui-docs "@ardtire/ui-docs"
write_pkg packages/db     "@ardtire/db"
write_pkg packages/types  "@ardtire/types"
write_pkg packages/config "@ardtire/config"
write_pkg packages/auth   "@ardtire/auth"
write_pkg packages/logger "@ardtire/logger"

ok "package.json stubs written for all apps and packages"

# =============================================================================
# 13. .GITIGNORE
# =============================================================================
header "13 / .gitignore"

cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
dist/
build/
out/
.next/
.turbo/

# Bun
bun.lockb

# Moon
.moon/cache/
.moon/docker/

# Environment
.env
.env.*
!.env.example

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo

# Type generation
*.generated.ts
*.generated.d.ts

# Prisma
prisma/migrations/.migration_lock.toml

# Test
coverage/
.vitest/

# Payload CMS
media/

# Ruby / Decidim
*.gem
*.rbc
.bundle/
vendor/bundle/
.ruby-version
EOF

ok ".gitignore written"

# =============================================================================
# 14. DEVCONTAINER
# =============================================================================
header "14 / devcontainer.json"

cat > .devcontainer/devcontainer.json << 'EOF'
{
  "name": "ardtire-platform",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "configureZshAsDefaultShell": true
    },
    "ghcr.io/devcontainers/features/node:1": {
      "version": "22"
    },
    "ghcr.io/shyim/devcontainers-features/bun:0": {
      "version": "1.1.38"
    },
    "ghcr.io/devcontainers/features/ruby:1": {
      "version": "3.3.6"
    },
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "postCreateCommand": "bun install && bun run prepare",
  "postStartCommand": "echo '✅ ardtire-platform Codespace ready'",
  "customizations": {
    "vscode": {
      "extensions": [
        "biomejs.biome",
        "prisma.prisma",
        "moonrepo.moon-console",
        "bradlc.vscode-tailwindcss",
        "ms-azuretools.vscode-docker",
        "GitHub.copilot"
      ],
      "settings": {
        "editor.defaultFormatter": "biomejs.biome",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "quickfix.biome": "explicit",
          "source.organizeImports.biome": "explicit"
        },
        "typescript.tsdk": "node_modules/typescript/lib",
        "typescript.enablePromptUseWorkspaceTsdk": true,
        "[typescript]": {
          "editor.defaultFormatter": "biomejs.biome"
        },
        "[typescriptreact]": {
          "editor.defaultFormatter": "biomejs.biome"
        },
        "[javascript]": {
          "editor.defaultFormatter": "biomejs.biome"
        },
        "[json]": {
          "editor.defaultFormatter": "biomejs.biome"
        }
      }
    }
  },
  "remoteEnv": {
    "NODE_ENV": "development"
  },
  "forwardPorts": [3000, 3001, 3002, 4000, 5432, 8080]
}
EOF

ok ".devcontainer/devcontainer.json written"

# =============================================================================
# 15. GITHUB ACTIONS CI
# =============================================================================
header "15 / GitHub Actions CI"

cat > .github/workflows/ci.yml << 'EOF'
# =============================================================================
# ardtire-platform — CI Pipeline
# Runs on: push to main, all PRs
# Orchestrated via Moon — only affected projects run on each commit.
# =============================================================================
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  # ---------------------------------------------------------------------------
  # Foundation checks — run on every commit regardless of affected projects
  # ---------------------------------------------------------------------------
  foundation:
    name: Foundation
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
        with:
          bun-version: "1.1.38"

      - name: Install Moon
        uses: moonrepo/setup-moon@v2

      - name: Install dependencies
        run: bun install --frozen-lockfile

      - name: Syncpack — version coherence check
        run: bun run syncpack

  # ---------------------------------------------------------------------------
  # Affected project tasks — Moon resolves which projects changed
  # ---------------------------------------------------------------------------
  check:
    name: Check (affected)
    runs-on: ubuntu-latest
    needs: foundation
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
        with:
          bun-version: "1.1.38"

      - name: Install Moon
        uses: moonrepo/setup-moon@v2

      - name: Install dependencies
        run: bun install --frozen-lockfile

      - name: Moon CI — lint, typecheck, test (affected projects only)
        run: moon ci
        env:
          MOON_AFFECTED_BY: ${{ github.base_ref }}
EOF

ok ".github/workflows/ci.yml written"

# =============================================================================
# 16. README
# =============================================================================
header "16 / README"

cat > README.md << 'EOF'
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
EOF

ok "README.md written"

# =============================================================================
# 17. ADR DIRECTORY
# =============================================================================
header "17 / ADR directory"

mkdir -p docs/adr

cat > docs/adr/README.md << 'EOF'
# Architecture Decision Records

All significant architectural decisions for the ardtire-platform are recorded here in MADR format.

| ADR | Title | Status |
|---|---|---|
| [ADR-0001](ADR-0001-bun-package-manager.md) | Adopt Bun as Monorepo Package Manager | Accepted |
| [ADR-0002](ADR-0002-moon-task-orchestrator.md) | Adopt Moon as Monorepo Task Orchestrator | Accepted |
| [ADR-0003](ADR-0003-fumadocs.md) | Adopt Fumadocs for apps/docs and apps/log | Accepted |
EOF

ok "docs/adr/ directory and index created"

# =============================================================================
# 18. BUN INSTALL
# =============================================================================
header "18 / bun install"

if command -v bun &> /dev/null; then
  bun install
  ok "bun install complete — bun.lock generated"
else
  warn "Bun not found in PATH. Run 'bun install' manually after installing Bun."
  warn "Install: curl -fsSL https://bun.sh/install | bash"
fi

# =============================================================================
# 19. LEFTHOOK INSTALL
# =============================================================================
header "19 / Lefthook git hooks"

if command -v bun &> /dev/null && [ -f bun.lock ]; then
  bunx lefthook install
  ok "Lefthook git hooks installed"
else
  warn "Run 'bunx lefthook install' after bun install completes."
fi

# =============================================================================
# DONE
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}${GREEN}  Step 01 complete — Monorepo Foundation${RESET}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "  What was created:"
echo "    ✔  Directory tree (apps/*, packages/*)"
echo "    ✔  deps.json — canonical version manifest"
echo "    ✔  Root package.json with Bun workspaces"
echo "    ✔  .syncpackrc.json — version coherence + React containment"
echo "    ✔  biome.json — root Biome config"
echo "    ✔  tsconfig.json — root TypeScript config (strict)"
echo "    ✔  lefthook.yml — pre-commit, commit-msg, pre-push hooks"
echo "    ✔  .moon/workspace.yml — project discovery"
echo "    ✔  .moon/toolchain.yml — runtime version pins (Bun, Node, Ruby)"
echo "    ✔  .moon/tasks.yml — inherited task definitions"
echo "    ✔  moon.yml — in all 16 apps and packages"
echo "    ✔  package.json stubs — in all 16 apps and packages"
echo "    ✔  .gitignore"
echo "    ✔  .devcontainer/devcontainer.json"
echo "    ✔  .github/workflows/ci.yml"
echo "    ✔  README.md"
echo "    ✔  docs/adr/ — ADR index"
echo ""
echo "  Next: Copy your three ADR files into docs/adr/, then run Step 02."
echo ""
EOF
