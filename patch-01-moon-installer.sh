#!/usr/bin/env bash
# =============================================================================
# ardtire-platform — Patch 01: Fix Moon installation method
# =============================================================================
# @moonrepo/cli as a Bun devDependency does not correctly resolve the
# platform-specific native binary under Bun's optional dependency handling.
# Moon must be installed via its standalone installer script.
#
# This patch:
#   1. Rewrites .devcontainer/devcontainer.json — installs Moon via installer
#   2. Rewrites .github/workflows/ci.yml — uses moonrepo/setup-moon action (unchanged, already correct)
#   3. Removes @moonrepo/cli from root package.json
#
# Run from repo root: bash patch-01-moon-installer.sh
# =============================================================================

set -euo pipefail

GREEN="\033[0;32m"
CYAN="\033[0;36m"
RESET="\033[0m"

log() { echo -e "${CYAN}▶ $1${RESET}"; }
ok()  { echo -e "${GREEN}✔ $1${RESET}"; }

# =============================================================================
# 1. Patch devcontainer.json — install Moon via standalone script
# =============================================================================
log "Patching .devcontainer/devcontainer.json"

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
  "postCreateCommand": "curl -fsSL https://moonrepo.dev/install/moon.sh | bash && export PATH=\"$HOME/.moon/bin:$PATH\" && bun install && bun run prepare",
  "postStartCommand": "echo '✅ ardtire-platform Codespace ready. Moon: '$(moon --version)",
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
    "NODE_ENV": "development",
    "PATH": "${containerEnv:PATH}:/root/.moon/bin"
  },
  "forwardPorts": [3000, 3001, 3002, 4000, 5432, 8080]
}
EOF

ok ".devcontainer/devcontainer.json patched"

# =============================================================================
# 2. Remove @moonrepo/cli from root package.json
# =============================================================================
log "Removing @moonrepo/cli from root package.json"

bun remove @moonrepo/cli

ok "@moonrepo/cli removed"

# =============================================================================
# 3. Ensure ~/.moon/bin is on PATH in the current shell profile
# =============================================================================
log "Adding ~/.moon/bin to shell PATH"

MOON_PATH_LINE='export PATH="$HOME/.moon/bin:$PATH"'

for profile in ~/.zshrc ~/.bashrc ~/.profile; do
  if [ -f "$profile" ] && ! grep -q '.moon/bin' "$profile"; then
    echo "$MOON_PATH_LINE" >> "$profile"
    ok "Added to $profile"
  fi
done

# Apply to current session
export PATH="$HOME/.moon/bin:$PATH"

# =============================================================================
# 4. Verify
# =============================================================================
log "Verifying Moon"

if command -v moon &> /dev/null; then
  ok "Moon $(moon --version) is available on PATH"
else
  echo "Moon not found on PATH yet — run: source ~/.zshrc && moon --version"
fi

echo ""
echo -e "${GREEN}✔ Patch 01 complete. Run: moon check --all${RESET}"
EOF
