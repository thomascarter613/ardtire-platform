#!/usr/bin/env bash
# =============================================================================
# ardtire-platform — Step 02: packages/tokens
# =============================================================================
# Scaffolds the shared design token package.
#
# This package is the ONLY permitted sharing boundary between the SolidJS
# application layer and the Fumadocs/Next.js documentation layer.
#
# Outputs:
#   - CSS custom properties (consumed as a stylesheet by all apps)
#   - TypeScript constants (for JS/TS consumers that need token values)
#   - Full build pipeline (copy CSS + tsc for TS)
#
# Run from repo root: bash scaffold-step-02-tokens.sh
# =============================================================================

set -euo pipefail

BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RESET="\033[0m"

log()    { echo -e "${CYAN}▶ $1${RESET}"; }
ok()     { echo -e "${GREEN}✔ $1${RESET}"; }
header() { echo -e "\n${BOLD}━━━ $1 ━━━${RESET}\n"; }

cd packages/tokens

# =============================================================================
# 1. package.json
# =============================================================================
header "1 / package.json"

cat > package.json << 'EOF'
{
  "name": "@ardtire/tokens",
  "version": "0.1.0",
  "private": true,
  "description": "Ardtire platform design tokens — shared CSS custom properties and TypeScript constants.",
  "type": "module",
  "exports": {
    ".": {
      "import": "./dist/index.js",
      "types": "./dist/index.d.ts"
    },
    "./styles": "./dist/tokens.css",
    "./tokens.css": "./dist/tokens.css"
  },
  "files": [
    "dist"
  ],
  "scripts": {
    "build": "bun run build:css && bunx tsc -p tsconfig.build.json",
    "build:css": "mkdir -p dist && cp src/tokens.css dist/tokens.css",
    "build:ts": "bunx tsc -p tsconfig.build.json",
    "dev": "bun run --watch build:ts",
    "lint": "bunx biome lint --no-errors-on-unmatched ./src",
    "format": "bunx biome format --no-errors-on-unmatched --write ./src",
    "typecheck": "tsc --noEmit",
    "test": "bunx vitest run"
  },
  "devDependencies": {
    "typescript": "5.8.3",
    "vitest": "^1.0.0"
  }
}
EOF

ok "package.json written"

# =============================================================================
# 2. tsconfig.json
# =============================================================================
header "2 / tsconfig.json"

cat > tsconfig.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "rootDir": "src",
    "outDir": "dist",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
EOF

cat > tsconfig.build.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./tsconfig.json",
  "exclude": ["node_modules", "dist", "**/*.test.ts", "src/**/*.test.ts"]
}
EOF

ok "tsconfig files written"

# =============================================================================
# 3. moon.yml — override build task for this package's specific pipeline
# =============================================================================
header "3 / moon.yml"

cat > moon.yml << 'EOF'
$schema: "https://moonrepo.dev/schemas/project.json"

id: "@ardtire/tokens"
language: "typescript"

tasks:
  build:
    script: "bash -lc 'mkdir -p dist && cp src/tokens.css dist/tokens.css && bunx tsc -p tsconfig.build.json'"
    inputs:
      - "src/**/*"
      - "tsconfig.json"
      - "tsconfig.build.json"
    outputs:
      - "dist/**/*"

  dev:
    command: "bun run dev"
    options:
      persistent: true
EOF

ok "moon.yml written"

# =============================================================================
# 4. src/tokens.css — Design tokens as CSS custom properties
# =============================================================================
header "4 / src/tokens.css"

mkdir -p src

cat > src/tokens.css << 'EOF'
/**
 * @ardtire/tokens — Ardtire Platform Design Tokens
 *
 * All design tokens are declared as CSS custom properties on :root.
 * Import this stylesheet once at the top level of each app:
 *
 *   SolidJS (apps/www, apps/my, apps/admin):
 *     import "@ardtire/tokens/tokens.css"
 *
 *   Next.js (apps/docs, apps/log):
 *     import "@ardtire/tokens/tokens.css" in layout.tsx
 *
 * Token naming convention:
 *   --ardtire-{category}-{scale}
 *   --ardtire-{semantic}-{variant}
 *   --ardtire-register-{exterior|interior}-{role}
 */

:root {
  /* ===========================================================================
   * COLOR — Primary Scale (Indigo)
   * The dominant heraldic colour of the Ardtire Society.
   * =========================================================================*/

  --ardtire-indigo-50:  #eef2ff;
  --ardtire-indigo-100: #e0e7ff;
  --ardtire-indigo-200: #c7d2fe;
  --ardtire-indigo-300: #a5b4fc;
  --ardtire-indigo-400: #818cf8;
  --ardtire-indigo-500: #6366f1;
  --ardtire-indigo-600: #4f46e5;
  --ardtire-indigo-700: #4338ca;
  --ardtire-indigo-800: #3730a3;
  --ardtire-indigo-900: #312e81;
  --ardtire-indigo-950: #1e1b4b;

  /* ===========================================================================
   * COLOR — Secondary Scale (Violet)
   * Used for interior/Kingdom register surfaces and elevated formality.
   * =========================================================================*/

  --ardtire-violet-50:  #f5f3ff;
  --ardtire-violet-100: #ede9fe;
  --ardtire-violet-200: #ddd6fe;
  --ardtire-violet-300: #c4b5fd;
  --ardtire-violet-400: #a78bfa;
  --ardtire-violet-500: #8b5cf6;
  --ardtire-violet-600: #7c3aed;
  --ardtire-violet-700: #6d28d9;
  --ardtire-violet-800: #5b21b6;
  --ardtire-violet-900: #4c1d95;
  --ardtire-violet-950: #2e1065;

  /* ===========================================================================
   * COLOR — Gold / Amber
   * Heraldic accent for interior Kingdom register; awards, ratification.
   * =========================================================================*/

  --ardtire-gold-50:  #fffbeb;
  --ardtire-gold-100: #fef3c7;
  --ardtire-gold-200: #fde68a;
  --ardtire-gold-300: #fcd34d;
  --ardtire-gold-400: #fbbf24;
  --ardtire-gold-500: #f59e0b;
  --ardtire-gold-600: #d97706;
  --ardtire-gold-700: #b45309;
  --ardtire-gold-800: #92400e;
  --ardtire-gold-900: #78350f;
  --ardtire-gold-950: #451a03;

  /* ===========================================================================
   * COLOR — Neutral (Slate)
   * Base neutral palette for UI surfaces, borders, text.
   * =========================================================================*/

  --ardtire-neutral-0:   #ffffff;
  --ardtire-neutral-50:  #f8fafc;
  --ardtire-neutral-100: #f1f5f9;
  --ardtire-neutral-200: #e2e8f0;
  --ardtire-neutral-300: #cbd5e1;
  --ardtire-neutral-400: #94a3b8;
  --ardtire-neutral-500: #64748b;
  --ardtire-neutral-600: #475569;
  --ardtire-neutral-700: #334155;
  --ardtire-neutral-800: #1e293b;
  --ardtire-neutral-900: #0f172a;
  --ardtire-neutral-950: #020617;
  --ardtire-neutral-1000: #000000;

  /* ===========================================================================
   * COLOR — Semantic
   * =========================================================================*/

  /* Success */
  --ardtire-success-subtle:   #f0fdf4;
  --ardtire-success-muted:    #bbf7d0;
  --ardtire-success-default:  #16a34a;
  --ardtire-success-emphasis: #15803d;
  --ardtire-success-fg:       #ffffff;

  /* Warning */
  --ardtire-warning-subtle:   #fffbeb;
  --ardtire-warning-muted:    #fde68a;
  --ardtire-warning-default:  #d97706;
  --ardtire-warning-emphasis: #b45309;
  --ardtire-warning-fg:       #ffffff;

  /* Danger */
  --ardtire-danger-subtle:    #fef2f2;
  --ardtire-danger-muted:     #fecaca;
  --ardtire-danger-default:   #dc2626;
  --ardtire-danger-emphasis:  #b91c1c;
  --ardtire-danger-fg:        #ffffff;

  /* Info */
  --ardtire-info-subtle:      #eff6ff;
  --ardtire-info-muted:       #bfdbfe;
  --ardtire-info-default:     #2563eb;
  --ardtire-info-emphasis:    #1d4ed8;
  --ardtire-info-fg:          #ffffff;

  /* ===========================================================================
   * COLOR — Register-specific tokens
   * These tokens make the two-register boundary visually explicit in the UI.
   * =========================================================================*/

  /* Exterior register — Society (Indigo-dominant) */
  --ardtire-register-exterior-bg:        var(--ardtire-neutral-0);
  --ardtire-register-exterior-surface:   var(--ardtire-indigo-50);
  --ardtire-register-exterior-border:    var(--ardtire-indigo-200);
  --ardtire-register-exterior-accent:    var(--ardtire-indigo-600);
  --ardtire-register-exterior-accent-fg: #ffffff;
  --ardtire-register-exterior-text:      var(--ardtire-indigo-900);

  /* Interior register — Kingdom (Violet + Gold) */
  --ardtire-register-interior-bg:        var(--ardtire-violet-950);
  --ardtire-register-interior-surface:   var(--ardtire-violet-900);
  --ardtire-register-interior-border:    var(--ardtire-gold-600);
  --ardtire-register-interior-accent:    var(--ardtire-gold-400);
  --ardtire-register-interior-accent-fg: var(--ardtire-violet-950);
  --ardtire-register-interior-text:      var(--ardtire-neutral-50);

  /* ===========================================================================
   * COLOR — UI semantic aliases
   * Consumed by components rather than raw palette tokens.
   * =========================================================================*/

  --ardtire-color-bg:              var(--ardtire-neutral-0);
  --ardtire-color-bg-subtle:       var(--ardtire-neutral-50);
  --ardtire-color-bg-muted:        var(--ardtire-neutral-100);
  --ardtire-color-surface:         var(--ardtire-neutral-0);
  --ardtire-color-surface-raised:  var(--ardtire-neutral-50);
  --ardtire-color-surface-overlay: var(--ardtire-neutral-0);

  --ardtire-color-border:          var(--ardtire-neutral-200);
  --ardtire-color-border-strong:   var(--ardtire-neutral-300);
  --ardtire-color-border-focus:    var(--ardtire-indigo-500);

  --ardtire-color-text:            var(--ardtire-neutral-900);
  --ardtire-color-text-muted:      var(--ardtire-neutral-500);
  --ardtire-color-text-subtle:     var(--ardtire-neutral-400);
  --ardtire-color-text-on-primary: #ffffff;
  --ardtire-color-text-link:       var(--ardtire-indigo-600);
  --ardtire-color-text-link-hover: var(--ardtire-indigo-700);

  --ardtire-color-primary:         var(--ardtire-indigo-600);
  --ardtire-color-primary-hover:   var(--ardtire-indigo-700);
  --ardtire-color-primary-active:  var(--ardtire-indigo-800);
  --ardtire-color-primary-subtle:  var(--ardtire-indigo-50);
  --ardtire-color-primary-muted:   var(--ardtire-indigo-100);

  /* ===========================================================================
   * TYPOGRAPHY — Font families
   * =========================================================================*/

  /* UI sans — used for all interface text */
  --ardtire-font-sans: "Inter", ui-sans-serif, system-ui, -apple-system,
    BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;

  /* Formal serif — used for constitutional instruments, proclamations, formal documents */
  --ardtire-font-serif: "EB Garamond", "Garamond", "Georgia", ui-serif, serif;

  /* Monospace — used for code, IDs, reference numbers */
  --ardtire-font-mono: "JetBrains Mono", "Fira Code", ui-monospace, "Cascadia Code",
    "Source Code Pro", Menlo, Monaco, Consolas, monospace;

  /* ===========================================================================
   * TYPOGRAPHY — Scale
   * Base: 16px (1rem). Scale ratio: 1.25 (Major Third).
   * =========================================================================*/

  --ardtire-text-xs:   0.75rem;    /* 12px */
  --ardtire-text-sm:   0.875rem;   /* 14px */
  --ardtire-text-base: 1rem;       /* 16px */
  --ardtire-text-lg:   1.125rem;   /* 18px */
  --ardtire-text-xl:   1.25rem;    /* 20px */
  --ardtire-text-2xl:  1.5rem;     /* 24px */
  --ardtire-text-3xl:  1.875rem;   /* 30px */
  --ardtire-text-4xl:  2.25rem;    /* 36px */
  --ardtire-text-5xl:  3rem;       /* 48px */
  --ardtire-text-6xl:  3.75rem;    /* 60px */

  /* ===========================================================================
   * TYPOGRAPHY — Line heights
   * =========================================================================*/

  --ardtire-leading-none:    1;
  --ardtire-leading-tight:   1.25;
  --ardtire-leading-snug:    1.375;
  --ardtire-leading-normal:  1.5;
  --ardtire-leading-relaxed: 1.625;
  --ardtire-leading-loose:   2;

  /* ===========================================================================
   * TYPOGRAPHY — Font weights
   * =========================================================================*/

  --ardtire-weight-light:    300;
  --ardtire-weight-normal:   400;
  --ardtire-weight-medium:   500;
  --ardtire-weight-semibold: 600;
  --ardtire-weight-bold:     700;
  --ardtire-weight-black:    900;

  /* ===========================================================================
   * SPACING — 4px base grid
   * =========================================================================*/

  --ardtire-space-0:    0;
  --ardtire-space-px:   1px;
  --ardtire-space-0-5:  0.125rem;  /* 2px  */
  --ardtire-space-1:    0.25rem;   /* 4px  */
  --ardtire-space-1-5:  0.375rem;  /* 6px  */
  --ardtire-space-2:    0.5rem;    /* 8px  */
  --ardtire-space-2-5:  0.625rem;  /* 10px */
  --ardtire-space-3:    0.75rem;   /* 12px */
  --ardtire-space-3-5:  0.875rem;  /* 14px */
  --ardtire-space-4:    1rem;      /* 16px */
  --ardtire-space-5:    1.25rem;   /* 20px */
  --ardtire-space-6:    1.5rem;    /* 24px */
  --ardtire-space-7:    1.75rem;   /* 28px */
  --ardtire-space-8:    2rem;      /* 32px */
  --ardtire-space-10:   2.5rem;    /* 40px */
  --ardtire-space-12:   3rem;      /* 48px */
  --ardtire-space-14:   3.5rem;    /* 56px */
  --ardtire-space-16:   4rem;      /* 64px */
  --ardtire-space-20:   5rem;      /* 80px */
  --ardtire-space-24:   6rem;      /* 96px */
  --ardtire-space-32:   8rem;      /* 128px */

  /* ===========================================================================
   * BORDER RADIUS
   * =========================================================================*/

  --ardtire-radius-none:  0;
  --ardtire-radius-sm:    0.125rem;  /* 2px  */
  --ardtire-radius-base:  0.25rem;   /* 4px  */
  --ardtire-radius-md:    0.375rem;  /* 6px  */
  --ardtire-radius-lg:    0.5rem;    /* 8px  */
  --ardtire-radius-xl:    0.75rem;   /* 12px */
  --ardtire-radius-2xl:   1rem;      /* 16px */
  --ardtire-radius-3xl:   1.5rem;    /* 24px */
  --ardtire-radius-full:  9999px;

  /* ===========================================================================
   * SHADOWS
   * =========================================================================*/

  --ardtire-shadow-xs:  0 1px 2px 0 rgb(0 0 0 / 0.05);
  --ardtire-shadow-sm:  0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
  --ardtire-shadow-md:  0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --ardtire-shadow-lg:  0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
  --ardtire-shadow-xl:  0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
  --ardtire-shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25);
  --ardtire-shadow-inner: inset 0 2px 4px 0 rgb(0 0 0 / 0.05);
  --ardtire-shadow-none: none;

  /* Focus ring — used on interactive elements */
  --ardtire-shadow-focus: 0 0 0 3px rgb(99 102 241 / 0.4);

  /* ===========================================================================
   * Z-INDEX
   * =========================================================================*/

  --ardtire-z-base:    0;
  --ardtire-z-raised:  10;
  --ardtire-z-dropdown: 100;
  --ardtire-z-sticky:  200;
  --ardtire-z-overlay: 300;
  --ardtire-z-modal:   400;
  --ardtire-z-popover: 500;
  --ardtire-z-toast:   600;
  --ardtire-z-tooltip: 700;

  /* ===========================================================================
   * MOTION
   * Governance-appropriate: deliberate, not playful.
   * =========================================================================*/

  --ardtire-duration-instant:  0ms;
  --ardtire-duration-fast:     100ms;
  --ardtire-duration-normal:   200ms;
  --ardtire-duration-slow:     300ms;
  --ardtire-duration-slower:   500ms;

  --ardtire-ease-default:  cubic-bezier(0.4, 0, 0.2, 1);
  --ardtire-ease-in:       cubic-bezier(0.4, 0, 1, 1);
  --ardtire-ease-out:      cubic-bezier(0, 0, 0.2, 1);
  --ardtire-ease-in-out:   cubic-bezier(0.4, 0, 0.2, 1);

  /* ===========================================================================
   * DOCUMENT CLASSIFICATION — Visual indicators
   * Five-tier T-0 through T-4 classification system.
   * =========================================================================*/

  --ardtire-classification-t0-bg:     var(--ardtire-neutral-100);
  --ardtire-classification-t0-border: var(--ardtire-neutral-300);
  --ardtire-classification-t0-text:   var(--ardtire-neutral-700);

  --ardtire-classification-t1-bg:     var(--ardtire-indigo-50);
  --ardtire-classification-t1-border: var(--ardtire-indigo-300);
  --ardtire-classification-t1-text:   var(--ardtire-indigo-700);

  --ardtire-classification-t2-bg:     #eff6ff;
  --ardtire-classification-t2-border: #93c5fd;
  --ardtire-classification-t2-text:   #1d4ed8;

  --ardtire-classification-t3-bg:     var(--ardtire-warning-subtle);
  --ardtire-classification-t3-border: var(--ardtire-warning-muted);
  --ardtire-classification-t3-text:   var(--ardtire-warning-emphasis);

  --ardtire-classification-t4-bg:     var(--ardtire-danger-subtle);
  --ardtire-classification-t4-border: var(--ardtire-danger-muted);
  --ardtire-classification-t4-text:   var(--ardtire-danger-emphasis);

  /* ===========================================================================
   * MEMBERSHIP TIER — Visual indicators
   * =========================================================================*/

  --ardtire-tier-associate-bg:     var(--ardtire-neutral-100);
  --ardtire-tier-associate-border: var(--ardtire-neutral-300);
  --ardtire-tier-associate-text:   var(--ardtire-neutral-700);

  --ardtire-tier-full-bg:          var(--ardtire-indigo-50);
  --ardtire-tier-full-border:      var(--ardtire-indigo-400);
  --ardtire-tier-full-text:        var(--ardtire-indigo-800);

  /* ===========================================================================
   * BREAKPOINTS — declared as tokens for reference (not usable in media queries)
   * Use these values in JS/TS for programmatic breakpoint logic.
   * =========================================================================*/

  --ardtire-breakpoint-sm:  640px;
  --ardtire-breakpoint-md:  768px;
  --ardtire-breakpoint-lg:  1024px;
  --ardtire-breakpoint-xl:  1280px;
  --ardtire-breakpoint-2xl: 1536px;
}

/* ===========================================================================
 * DARK MODE — register interior surfaces always dark regardless of mode.
 * Light/dark mode token overrides go here when dark mode is implemented.
 * =========================================================================*/

@media (prefers-color-scheme: dark) {
  :root {
    /* Placeholder — dark mode token overrides to be defined in a future slice. */
  }
}
EOF

ok "src/tokens.css written"

# =============================================================================
# 5. src/index.ts — TypeScript constants mirroring the CSS tokens
# =============================================================================
header "5 / src/index.ts"

cat > src/index.ts << 'EOF'
/**
 * @ardtire/tokens — TypeScript constants
 *
 * These constants mirror the CSS custom properties in tokens.css.
 * Use them in JS/TS contexts where CSS variables cannot be used directly
 * (e.g., canvas rendering, charting libraries, inline style generation).
 *
 * For all standard CSS styling, import the stylesheet instead:
 *   import "@ardtire/tokens/tokens.css"
 */

// ---------------------------------------------------------------------------
// Color — Primary (Indigo)
// ---------------------------------------------------------------------------
export const indigo = {
  50:  "#eef2ff",
  100: "#e0e7ff",
  200: "#c7d2fe",
  300: "#a5b4fc",
  400: "#818cf8",
  500: "#6366f1",
  600: "#4f46e5",
  700: "#4338ca",
  800: "#3730a3",
  900: "#312e81",
  950: "#1e1b4b",
} as const;

// ---------------------------------------------------------------------------
// Color — Secondary (Violet)
// ---------------------------------------------------------------------------
export const violet = {
  50:  "#f5f3ff",
  100: "#ede9fe",
  200: "#ddd6fe",
  300: "#c4b5fd",
  400: "#a78bfa",
  500: "#8b5cf6",
  600: "#7c3aed",
  700: "#6d28d9",
  800: "#5b21b6",
  900: "#4c1d95",
  950: "#2e1065",
} as const;

// ---------------------------------------------------------------------------
// Color — Gold
// ---------------------------------------------------------------------------
export const gold = {
  50:  "#fffbeb",
  100: "#fef3c7",
  200: "#fde68a",
  300: "#fcd34d",
  400: "#fbbf24",
  500: "#f59e0b",
  600: "#d97706",
  700: "#b45309",
  800: "#92400e",
  900: "#78350f",
  950: "#451a03",
} as const;

// ---------------------------------------------------------------------------
// Color — Neutral
// ---------------------------------------------------------------------------
export const neutral = {
  0:    "#ffffff",
  50:   "#f8fafc",
  100:  "#f1f5f9",
  200:  "#e2e8f0",
  300:  "#cbd5e1",
  400:  "#94a3b8",
  500:  "#64748b",
  600:  "#475569",
  700:  "#334155",
  800:  "#1e293b",
  900:  "#0f172a",
  950:  "#020617",
  1000: "#000000",
} as const;

// ---------------------------------------------------------------------------
// Register tokens
// ---------------------------------------------------------------------------
export const register = {
  exterior: {
    bg:       neutral[0],
    surface:  indigo[50],
    border:   indigo[200],
    accent:   indigo[600],
    accentFg: "#ffffff",
    text:     indigo[900],
  },
  interior: {
    bg:       violet[950],
    surface:  violet[900],
    border:   gold[600],
    accent:   gold[400],
    accentFg: violet[950],
    text:     neutral[50],
  },
} as const;

// ---------------------------------------------------------------------------
// Typography
// ---------------------------------------------------------------------------
export const fontFamily = {
  sans:  '"Inter", ui-sans-serif, system-ui, -apple-system, sans-serif',
  serif: '"EB Garamond", "Garamond", "Georgia", ui-serif, serif',
  mono:  '"JetBrains Mono", "Fira Code", ui-monospace, monospace',
} as const;

export const fontSize = {
  xs:   "0.75rem",
  sm:   "0.875rem",
  base: "1rem",
  lg:   "1.125rem",
  xl:   "1.25rem",
  "2xl": "1.5rem",
  "3xl": "1.875rem",
  "4xl": "2.25rem",
  "5xl": "3rem",
  "6xl": "3.75rem",
} as const;

// ---------------------------------------------------------------------------
// Spacing
// ---------------------------------------------------------------------------
export const space = {
  0:    "0",
  px:   "1px",
  0.5:  "0.125rem",
  1:    "0.25rem",
  1.5:  "0.375rem",
  2:    "0.5rem",
  2.5:  "0.625rem",
  3:    "0.75rem",
  3.5:  "0.875rem",
  4:    "1rem",
  5:    "1.25rem",
  6:    "1.5rem",
  8:    "2rem",
  10:   "2.5rem",
  12:   "3rem",
  16:   "4rem",
  20:   "5rem",
  24:   "6rem",
  32:   "8rem",
} as const;

// ---------------------------------------------------------------------------
// Breakpoints — for use in JS (e.g., charting, ResizeObserver logic)
// ---------------------------------------------------------------------------
export const breakpoint = {
  sm:  640,
  md:  768,
  lg:  1024,
  xl:  1280,
  "2xl": 1536,
} as const;

// ---------------------------------------------------------------------------
// Classification tiers
// ---------------------------------------------------------------------------
export const classificationTier = {
  T0: { label: "Public",          level: 0 },
  T1: { label: "Member",          level: 1 },
  T2: { label: "Officer",         level: 2 },
  T3: { label: "Restricted",      level: 3 },
  T4: { label: "Constitutional",  level: 4 },
} as const;

export type ClassificationTier = keyof typeof classificationTier;

// ---------------------------------------------------------------------------
// Membership tiers
// ---------------------------------------------------------------------------
export const membershipTier = {
  associate: { label: "Associate Member", level: 0 },
  full:      { label: "Full Member",      level: 1 },
} as const;

export type MembershipTier = keyof typeof membershipTier;
EOF

ok "src/index.ts written"

# =============================================================================
# 6. src/index.test.ts — Basic token sanity tests
# =============================================================================
header "6 / src/index.test.ts"

cat > src/index.test.ts << 'EOF'
import { describe, expect, it } from "vitest";
import {
  classificationTier,
  fontFamily,
  gold,
  indigo,
  membershipTier,
  neutral,
  register,
  violet,
} from "./index.js";

describe("@ardtire/tokens", () => {
  describe("color palettes", () => {
    it("indigo palette has all required stops", () => {
      const stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950] as const;
      for (const stop of stops) {
        expect(indigo[stop]).toMatch(/^#[0-9a-f]{6}$/i);
      }
    });

    it("violet palette has all required stops", () => {
      const stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950] as const;
      for (const stop of stops) {
        expect(violet[stop]).toMatch(/^#[0-9a-f]{6}$/i);
      }
    });

    it("gold palette has all required stops", () => {
      const stops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950] as const;
      for (const stop of stops) {
        expect(gold[stop]).toMatch(/^#[0-9a-f]{6}$/i);
      }
    });

    it("neutral palette includes 0 and 1000 sentinel values", () => {
      expect(neutral[0]).toBe("#ffffff");
      expect(neutral[1000]).toBe("#000000");
    });
  });

  describe("register tokens", () => {
    it("exterior register has all required keys", () => {
      expect(register.exterior).toHaveProperty("bg");
      expect(register.exterior).toHaveProperty("surface");
      expect(register.exterior).toHaveProperty("border");
      expect(register.exterior).toHaveProperty("accent");
      expect(register.exterior).toHaveProperty("accentFg");
      expect(register.exterior).toHaveProperty("text");
    });

    it("interior register has all required keys", () => {
      expect(register.interior).toHaveProperty("bg");
      expect(register.interior).toHaveProperty("surface");
      expect(register.interior).toHaveProperty("border");
      expect(register.interior).toHaveProperty("accent");
      expect(register.interior).toHaveProperty("accentFg");
      expect(register.interior).toHaveProperty("text");
    });

    it("exterior accent is indigo-600", () => {
      expect(register.exterior.accent).toBe(indigo[600]);
    });

    it("interior accent is gold-400", () => {
      expect(register.interior.accent).toBe(gold[400]);
    });
  });

  describe("typography", () => {
    it("font families are defined", () => {
      expect(fontFamily.sans).toBeTruthy();
      expect(fontFamily.serif).toBeTruthy();
      expect(fontFamily.mono).toBeTruthy();
    });
  });

  describe("classification tiers", () => {
    it("has all five tiers T0–T4", () => {
      expect(classificationTier.T0.level).toBe(0);
      expect(classificationTier.T1.level).toBe(1);
      expect(classificationTier.T2.level).toBe(2);
      expect(classificationTier.T3.level).toBe(3);
      expect(classificationTier.T4.level).toBe(4);
    });

    it("T4 is Constitutional", () => {
      expect(classificationTier.T4.label).toBe("Constitutional");
    });
  });

  describe("membership tiers", () => {
    it("has associate and full tiers", () => {
      expect(membershipTier.associate.level).toBe(0);
      expect(membershipTier.full.level).toBe(1);
    });
  });
});
EOF

ok "src/index.test.ts written"

# =============================================================================
# 7. vitest.config.ts
# =============================================================================
header "7 / vitest.config.ts"

cat > vitest.config.ts << 'EOF'
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: false,
    environment: "node",
    include: ["src/**/*.test.ts"],
    coverage: {
      provider: "v8",
      include: ["src/**/*.ts"],
      exclude: ["src/**/*.test.ts"],
    },
  },
});
EOF

ok "vitest.config.ts written"

# =============================================================================
# 8. Install deps and build
# =============================================================================
header "8 / Install and build"

cd ../..

bun install

moon run "@ardtire/tokens:build"
moon run "@ardtire/tokens:test"

# =============================================================================
# DONE
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}${GREEN}  Step 02 complete — packages/tokens${RESET}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "  What was created:"
echo "    ✔  package.json with exports (CSS stylesheet + TS constants)"
echo "    ✔  tsconfig.json + tsconfig.build.json"
echo "    ✔  moon.yml with build task override"
echo "    ✔  src/tokens.css — full CSS custom properties"
echo "         Primary (Indigo), Violet, Gold, Neutral palettes"
echo "         Register tokens (exterior Society / interior Kingdom)"
echo "         UI semantic aliases"
echo "         Typography, spacing, radius, shadow, z-index, motion"
echo "         Classification tier indicators (T0–T4)"
echo "         Membership tier indicators"
echo "    ✔  src/index.ts — TypeScript constants mirroring CSS tokens"
echo "    ✔  src/index.test.ts — token sanity tests"
echo "    ✔  vitest.config.ts"
echo ""
echo "  Next step: commit, then Step 03 — packages/config"
echo ""
