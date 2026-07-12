# Vibes Stack Patterns — Vanilla CSS

*Pattern CSS yang terbukti bekerja di Vibes Coding Workflow. Sesuai design-system.md dan standar CSS 2026.*

---

## Pattern 1: Full @layer Setup (Template Siap Pakai)

```css
/* === LAYER ORDER — Baris PERTAMA di CSS global === */
@layer reset, tokens, base, components, utilities, overrides;

/* === RESET LAYER === */
@layer reset {
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  html { -webkit-text-size-adjust: 100%; text-size-adjust: 100%; }
  body { min-height: 100dvh; -webkit-font-smoothing: antialiased; }
  img, picture, video, canvas, svg { display: block; max-width: 100%; }
  input, button, textarea, select { font: inherit; }
  p, h1, h2, h3, h4, h5, h6 { overflow-wrap: break-word; }
  #root, #__next { isolation: isolate; }

  /* Anti-tap flash — REQUIRED mobile */
  * { -webkit-tap-highlight-color: transparent; }
}
```

---

## Pattern 2: Token System Lengkap (oklch + Extended)

```css
@layer tokens {
  :root {
    /* === BASE DNA PALET — Dari wawancara === */
    --raw-palette-bg:       oklch(15% 0.03 250);
    --raw-palette-surface:  oklch(20% 0.03 250);
    --raw-palette-text:     oklch(92% 0.01 250);
    --raw-palette-accent-1: oklch(55% 0.25 275);
    --raw-palette-accent-2: oklch(68% 0.15 175);

    /* === TYPOGRAPHY === */
    --font-sans: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
    --font-serif: 'Playfair Display', Georgia, serif;
    --font-mono: 'JetBrains Mono', 'Fira Code', monospace;

    /* === SPACING 8-POINT GRID === */
    --space-xs: 4px;
    --space-s:  8px;
    --space-m:  16px;
    --space-l:  24px;
    --space-xl: 32px;

    /* === RADIUS === */
    --radius-none: 0px;
    --radius-sm:   4px;
    --radius-md:   8px;
    --radius-lg:   16px;
    --radius-full: 9999px;

    /* === SHADOWS === */
    --shadow-soft: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
    --shadow-hover: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);

    /* === TRANSITION === */
    --vibe-transition: all 0.2s ease-in-out;

    /* === STATUS (Universal) === */
    --vibe-error:   oklch(60% 0.22 25);
    --vibe-success: oklch(72% 0.20 152);
    --vibe-warning: oklch(82% 0.18 85);

    /* === INTERACTIVE STATES === */
    --vibe-border:     rgba(128,128,128,0.2);
    --vibe-divider:    rgba(128,128,128,0.12);
    --vibe-input-bg:   rgba(128,128,128,0.06);
    --vibe-hover:      rgba(128,128,128,0.08);
    --vibe-focus-ring: var(--raw-palette-accent-1);
    --vibe-overlay:    rgba(0,0,0,0.5);
    --vibe-skeleton:   rgba(128,128,128,0.15);
  }

  /* === LIGHT MODE === */
  [data-theme="light"] {
    --vibe-background: var(--raw-palette-bg);
    --vibe-surface:    var(--raw-palette-surface);
    --vibe-text-main:  var(--raw-palette-text);
    --vibe-text-muted: rgba(0,0,0,0.6);
    --vibe-primary:    var(--raw-palette-accent-1);
    --vibe-secondary:  var(--raw-palette-accent-2);
  }

  /* === DARK MODE (Deep Tonal — BUKAN #000000) === */
  [data-theme="dark"] {
    --vibe-background: oklch(8% 0.02 250);
    --vibe-surface:    oklch(12% 0.02 250);
    --vibe-text-main:  oklch(90% 0.01 250);
    --vibe-text-muted: rgba(255,255,255,0.6);
    --vibe-primary:    var(--raw-palette-accent-1);
    --vibe-secondary:  var(--raw-palette-accent-2);
    --vibe-border:     rgba(255,255,255,0.12);
    --vibe-divider:    rgba(255,255,255,0.08);
    --vibe-input-bg:   rgba(255,255,255,0.05);
    --vibe-hover:      rgba(255,255,255,0.06);
    --vibe-overlay:    rgba(0,0,0,0.7);
    --vibe-skeleton:   rgba(255,255,255,0.08);
  }
}
```

---

## Pattern 3: Base Typography + text-wrap

```css
@layer base {
  body {
    font-family: var(--font-sans);
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    background: var(--vibe-background);
    color: var(--vibe-text-main);
    transition: var(--vibe-transition);
  }

  h1 { font-size: clamp(1.75rem, 4vw, 2.5rem); font-weight: 700; line-height: 1.25; }
  h2 { font-size: 1.5rem; font-weight: 600; line-height: 1.35; }
  h3 { font-size: 1.25rem; font-weight: 600; line-height: 1.4; }
  small, .text-sm { font-size: 0.875rem; line-height: 1.4; }

  /* REQUIRED 2026: text-wrap modern */
  h1, h2, h3 { text-wrap: balance; }
  p, li, blockquote { text-wrap: pretty; }

  /* Focus indicator — REQUIRED A11Y */
  :focus-visible {
    outline: 2px solid var(--vibe-focus-ring);
    outline-offset: 2px;
  }

  /* Smooth scroll — respect reduced motion */
  @media (prefers-reduced-motion: no-preference) {
    html { scroll-behavior: smooth; }
  }
}
```

---

## Pattern 4: Component Patterns (Card, Button, Badge, Input)

```css
@layer components {
  /* === CARD === */
  .card {
    background: var(--vibe-surface);
    border: 1px solid var(--vibe-border);
    border-radius: var(--radius-md);
    padding: var(--space-m);
    box-shadow: var(--shadow-soft);
    transition: var(--vibe-transition);
  }
  .card:hover {
    box-shadow: var(--shadow-hover);
    transform: translateY(-4px);
  }

  /* === BUTTON === */
  .btn {
    display: inline-flex; align-items: center; justify-content: center; gap: var(--space-xs);
    padding: var(--space-s) var(--space-m);
    border: none; border-radius: var(--radius-md);
    font-weight: 500; cursor: pointer;
    min-height: 44px; min-width: 44px; /* A11Y touch target */
    transition: var(--vibe-transition);
  }
  .btn-primary {
    background: var(--vibe-primary); color: #fff;
  }
  .btn-primary:hover {
    filter: brightness(1.1); transform: translateY(-1px);
  }

  /* === BADGE === */
  .badge { display: inline-flex; padding: 2px var(--space-s); border-radius: var(--radius-full); font-size: 0.75rem; font-weight: 600; }
  .badge-success { background: var(--vibe-success); color: #000; }
  .badge-warning { background: var(--vibe-warning); color: #000; }
  .badge-danger  { background: var(--vibe-error);   color: #fff; }

  /* === INPUT === */
  .form-input {
    width: 100%; padding: var(--space-s) var(--space-m);
    background: var(--vibe-input-bg);
    border: 1px solid var(--vibe-border);
    border-radius: var(--radius-md);
    color: var(--vibe-text-main);
    transition: var(--vibe-transition);
    min-height: 44px;
  }
  .form-input:focus {
    border-color: var(--vibe-primary);
    box-shadow: 0 0 0 3px rgba(var(--vibe-primary), 0.15);
  }

  /* === TOAST === */
  .toast {
    position: fixed; bottom: var(--space-l); right: var(--space-l);
    padding: var(--space-s) var(--space-m);
    border-radius: var(--radius-md); color: #fff; z-index: 999;
    transform: translateY(100%); opacity: 0;
    transition: transform 0.3s ease, opacity 0.3s ease;
  }
  .toast--visible { transform: translateY(0); opacity: 1; }

  /* === SKELETON LOADER === */
  .skeleton {
    background: var(--vibe-skeleton);
    border-radius: var(--radius-md);
    animation: skeleton-pulse 1.5s ease-in-out infinite;
  }
  @keyframes skeleton-pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
  }
}
```

---

## Pattern 5: Responsive Layout (Mobile-First + Container Queries)

```css
@layer components {
  /* === BOTTOM NAV (Mobile) === */
  @media (max-width: 768px) {
    .top-navbar { display: none; }
    .bottom-nav {
      display: flex; position: fixed; bottom: 0; left: 0; right: 0;
      z-index: 100; background: var(--vibe-surface);
      border-top: 1px solid var(--vibe-border);
      padding-bottom: max(env(safe-area-inset-bottom), 8px);
    }
    .bottom-nav__item {
      flex: 1; display: flex; flex-direction: column; align-items: center;
      min-height: 48px; gap: 4px; padding: var(--space-s) var(--space-xs);
    }
    .main-content { padding-bottom: calc(64px + env(safe-area-inset-bottom, 0px)); }
  }

  @media (min-width: 769px) {
    .bottom-nav { display: none; }
    .top-navbar { display: flex; }
  }

  /* === CONTAINER QUERIES (2026) === */
  .card-grid { container-type: inline-size; container-name: card-grid; }
  @container card-grid (min-width: 600px) {
    .card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: var(--space-m); }
  }
  @container card-grid (max-width: 599px) {
    .card-grid { display: flex; flex-direction: column; gap: var(--space-m); }
  }
}
```

---

## Pattern 6: Utility Classes (Minimal — No Framework Needed)

```css
@layer utilities {
  .d-flex { display: flex; }
  .d-grid { display: grid; }
  .flex-col { flex-direction: column; }
  .items-center { align-items: center; }
  .justify-between { justify-content: space-between; }
  .justify-center { justify-content: center; }
  .gap-xs { gap: var(--space-xs); }
  .gap-s  { gap: var(--space-s); }
  .gap-m  { gap: var(--space-m); }
  .gap-l  { gap: var(--space-l); }
  .w-full { width: 100%; }
  .text-center { text-align: center; }
  .text-muted { color: var(--vibe-text-muted); }
  .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); }
  .object-cover { object-fit: cover; width: 100%; height: 100%; }
  .rounded-full { border-radius: var(--radius-full); }
}
```

---

## Pattern 7: View Transitions + :has() (Modern CSS 2026)

```css
@layer overrides {
  /* View Transitions — navigasi halaman native */
  @view-transition { navigation: auto; }
  ::view-transition-old(root) { animation: fade-out 0.15s ease; }
  ::view-transition-new(root) { animation: fade-in 0.15s ease; }

  @keyframes fade-in  { from { opacity: 0; } }
  @keyframes fade-out { to   { opacity: 0; } }

  /* :has() — parent styling based on child state */
  .form-group:has(input:invalid:not(:placeholder-shown)) {
    border-color: var(--vibe-error);
  }
  .form-group:has(input:valid:not(:placeholder-shown)) {
    border-color: var(--vibe-success);
  }

  /* Card grid dim effect on hover */
  .card-grid:has(.card:hover) .card:not(:hover) {
    opacity: 0.7;
    transform: scale(0.98);
  }
}
```
