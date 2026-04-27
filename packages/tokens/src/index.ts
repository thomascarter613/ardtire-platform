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
  50: "#eef2ff",
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
  50: "#f5f3ff",
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
  50: "#fffbeb",
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
  0: "#ffffff",
  50: "#f8fafc",
  100: "#f1f5f9",
  200: "#e2e8f0",
  300: "#cbd5e1",
  400: "#94a3b8",
  500: "#64748b",
  600: "#475569",
  700: "#334155",
  800: "#1e293b",
  900: "#0f172a",
  950: "#020617",
  1000: "#000000",
} as const;

// ---------------------------------------------------------------------------
// Register tokens
// ---------------------------------------------------------------------------
export const register = {
  exterior: {
    bg: neutral[0],
    surface: indigo[50],
    border: indigo[200],
    accent: indigo[600],
    accentFg: "#ffffff",
    text: indigo[900],
  },
  interior: {
    bg: violet[950],
    surface: violet[900],
    border: gold[600],
    accent: gold[400],
    accentFg: violet[950],
    text: neutral[50],
  },
} as const;

// ---------------------------------------------------------------------------
// Typography
// ---------------------------------------------------------------------------
export const fontFamily = {
  sans: '"Inter", ui-sans-serif, system-ui, -apple-system, sans-serif',
  serif: '"EB Garamond", "Garamond", "Georgia", ui-serif, serif',
  mono: '"JetBrains Mono", "Fira Code", ui-monospace, monospace',
} as const;

export const fontSize = {
  xs: "0.75rem",
  sm: "0.875rem",
  base: "1rem",
  lg: "1.125rem",
  xl: "1.25rem",
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
  0: "0",
  px: "1px",
  0.5: "0.125rem",
  1: "0.25rem",
  1.5: "0.375rem",
  2: "0.5rem",
  2.5: "0.625rem",
  3: "0.75rem",
  3.5: "0.875rem",
  4: "1rem",
  5: "1.25rem",
  6: "1.5rem",
  8: "2rem",
  10: "2.5rem",
  12: "3rem",
  16: "4rem",
  20: "5rem",
  24: "6rem",
  32: "8rem",
} as const;

// ---------------------------------------------------------------------------
// Breakpoints — for use in JS (e.g., charting, ResizeObserver logic)
// ---------------------------------------------------------------------------
export const breakpoint = {
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
  "2xl": 1536,
} as const;

// ---------------------------------------------------------------------------
// Classification tiers
// ---------------------------------------------------------------------------
export const classificationTier = {
  T0: { label: "Public", level: 0 },
  T1: { label: "Member", level: 1 },
  T2: { label: "Officer", level: 2 },
  T3: { label: "Restricted", level: 3 },
  T4: { label: "Constitutional", level: 4 },
} as const;

export type ClassificationTier = keyof typeof classificationTier;

// ---------------------------------------------------------------------------
// Membership tiers
// ---------------------------------------------------------------------------
export const membershipTier = {
  associate: { label: "Associate Member", level: 0 },
  full: { label: "Full Member", level: 1 },
} as const;

export type MembershipTier = keyof typeof membershipTier;
