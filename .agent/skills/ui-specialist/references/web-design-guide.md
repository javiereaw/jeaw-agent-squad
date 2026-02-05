# Web Design Guide (UI Specialist Reference)

## Design Philosophy

### The Anti-AI-Slop Manifesto

Create distinctive, production-grade interfaces that avoid generic "AI slop" aesthetics.

**NEVER use:**
- Overused font families (Inter, Roboto, Arial, system fonts)
- Cliched color schemes (purple gradients on white backgrounds)
- Predictable layouts and component patterns
- Cookie-cutter design that lacks context-specific character
- Excessive centered layouts with uniform rounded corners

**ALWAYS:**
- Choose a BOLD aesthetic direction
- Commit to intentionality over intensity
- Make unexpected but justified design choices
- Create interfaces that are memorable
- Vary between light/dark themes, different fonts, different aesthetics

---

## Design Thinking Process

Before coding, understand the context and commit to a direction:

### 1. Purpose
- What problem does this interface solve?
- Who uses it?
- What is the primary user goal?

### 2. Tone
Pick an extreme aesthetic direction:
- Brutally minimal
- Maximalist chaos
- Retro-futuristic
- Organic/natural
- Luxury/refined
- Playful/toy-like
- Editorial/magazine
- Brutalist/raw
- Art deco/geometric
- Soft/pastel
- Industrial/utilitarian

### 3. Constraints
- Framework requirements (React, Vue, vanilla)
- Performance budget
- Accessibility requirements (WCAG level)
- Browser support

### 4. Differentiation
- What makes this UNFORGETTABLE?
- What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity.

---

## Frontend Aesthetics Guidelines

### Typography

- Choose fonts that are beautiful, unique, and interesting
- Avoid generic fonts (Arial, Inter, Roboto, system fonts)
- Opt for distinctive choices that elevate the frontend's aesthetics
- Unexpected, characterful font choices
- Pair a distinctive display font with a refined body font

**Resources:**
- Google Fonts (curated selection)
- Adobe Fonts
- Variable fonts for performance

### Color & Theme

- Commit to a cohesive aesthetic
- Use CSS variables for consistency
- Dominant colors with sharp accents outperform timid, evenly-distributed palettes
- Consider both light and dark modes from the start

```css
:root {
  /* Primary palette */
  --color-primary: #...;
  --color-primary-light: #...;
  --color-primary-dark: #...;

  /* Accent */
  --color-accent: #...;

  /* Neutrals */
  --color-background: #...;
  --color-surface: #...;
  --color-text: #...;
  --color-text-muted: #...;

  /* Semantic */
  --color-success: #...;
  --color-warning: #...;
  --color-error: #...;
}
```

### Motion & Animation

- Use animations for effects and micro-interactions
- Prioritize CSS-only solutions for HTML
- Use Motion library (Framer Motion) for React when available
- Focus on high-impact moments: one well-orchestrated page load with staggered reveals creates more delight than scattered micro-interactions
- Use scroll-triggering and hover states that surprise

**Principles:**
- `animation-delay` for staggered reveals
- `transition` for interactive states
- Respect `prefers-reduced-motion`

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Spatial Composition

- Unexpected layouts
- Asymmetry
- Overlap
- Diagonal flow
- Grid-breaking elements
- Generous negative space OR controlled density

**Avoid:**
- Everything centered
- Uniform spacing everywhere
- Predictable grid patterns

### Backgrounds & Visual Details

Create atmosphere and depth rather than defaulting to solid colors:
- Gradient meshes
- Noise textures
- Geometric patterns
- Layered transparencies
- Dramatic shadows
- Decorative borders
- Custom cursors
- Grain overlays

---

## Component Architecture

### Structure Principles

```
Component Checklist:
✓ Single responsibility (one purpose)
✓ Props interface defined (TypeScript)
✓ Accessible by default (ARIA, keyboard)
✓ Responsive without media query soup
✓ Themeable via CSS variables
✓ Composable (slots, children)
```

### Component Token Usage

Components should ONLY use design tokens, never hardcoded values:

```css
/* GOOD */
.button {
  background: var(--color-primary);
  font-family: var(--font-body);
  padding: var(--space-sm) var(--space-md);
  border-radius: var(--radius-md);
}

/* BAD */
.button {
  background: #3b82f6;
  font-family: Inter, sans-serif;
  padding: 8px 16px;
  border-radius: 4px;
}
```

### File Organization

```
components/
├── ui/           # Primitive components (Button, Input, Card)
├── layout/       # Layout components (Container, Grid, Stack)
├── patterns/     # Composite patterns (Header, Footer, Sidebar)
└── features/     # Feature-specific components
```

---

## Responsive Design

### Mobile-First Approach

1. Base styles for mobile (no media query)
2. Progressive enhancement for larger screens
3. Touch targets minimum 44x44px
4. Avoid hover-only interactions

```css
/* Base: mobile */
.card {
  padding: var(--space-md);
}

/* Tablet and up */
@media (min-width: 768px) {
  .card {
    padding: var(--space-lg);
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .card {
    padding: var(--space-xl);
  }
}
```

### Breakpoint System

```css
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
  --breakpoint-2xl: 1536px;
}
```

### Container Queries (Modern)

```css
.card-container {
  container-type: inline-size;
}

@container (min-width: 400px) {
  .card {
    display: grid;
    grid-template-columns: 1fr 2fr;
  }
}
```

---

## Design System Structure

### Token Hierarchy

```css
:root {
  /* === SPACING === */
  --space-xs: 0.25rem;   /* 4px */
  --space-sm: 0.5rem;    /* 8px */
  --space-md: 1rem;      /* 16px */
  --space-lg: 1.5rem;    /* 24px */
  --space-xl: 2rem;      /* 32px */
  --space-2xl: 3rem;     /* 48px */
  --space-3xl: 4rem;     /* 64px */

  /* === TYPOGRAPHY === */
  --font-display: 'Display Font', serif;
  --font-body: 'Body Font', sans-serif;
  --font-mono: 'Mono Font', monospace;

  --text-xs: 0.75rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 1.875rem;
  --text-4xl: 2.25rem;

  /* === SHADOWS === */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
  --shadow-xl: 0 20px 25px rgba(0,0,0,0.15);

  /* === RADII === */
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 1rem;
  --radius-full: 9999px;

  /* === TRANSITIONS === */
  --transition-fast: 150ms ease;
  --transition-base: 250ms ease;
  --transition-slow: 350ms ease;
}
```

### Theme Switching

```css
[data-theme="dark"] {
  --color-background: #0a0a0a;
  --color-surface: #1a1a1a;
  --color-text: #fafafa;
  --color-text-muted: #a1a1a1;
}
```

```javascript
// Theme toggle
function toggleTheme() {
  const current = document.documentElement.dataset.theme;
  document.documentElement.dataset.theme = current === 'dark' ? 'light' : 'dark';
}
```

---

## Implementation Complexity

**IMPORTANT**: Match implementation complexity to the aesthetic vision.

- **Maximalist designs** need elaborate code with extensive animations and effects
- **Minimalist or refined designs** need restraint, precision, and careful attention to spacing, typography, and subtle details

Elegance comes from executing the vision well.

---

## Quality Checklist

Before shipping:

- [ ] Typography is distinctive (not default system fonts)
- [ ] Color palette is cohesive with clear hierarchy
- [ ] Animations respect `prefers-reduced-motion`
- [ ] All interactive elements have visible focus states
- [ ] Touch targets are at least 44x44px
- [ ] Design works at all breakpoints
- [ ] Dark mode supported (or intentionally excluded)
- [ ] No hardcoded values (all tokens)
- [ ] Contrast ratios meet WCAG AA (4.5:1 text, 3:1 UI)
