# Accessibility Guide (UI Specialist Reference)

## WCAG 2.1 Quick Reference

### Level A (Must Have)

| Criterion | Requirement |
|-----------|-------------|
| 1.1.1 | Non-text content has text alternatives |
| 1.3.1 | Information and relationships are programmatic |
| 1.4.1 | Color is not the only means of conveying information |
| 2.1.1 | All functionality is keyboard accessible |
| 2.4.1 | Skip navigation mechanism provided |
| 4.1.1 | HTML is valid and well-formed |
| 4.1.2 | All UI components have accessible names and roles |

### Level AA (Standard Target)

| Criterion | Requirement |
|-----------|-------------|
| 1.4.3 | Text contrast ratio >= 4.5:1 |
| 1.4.11 | UI component contrast >= 3:1 |
| 2.4.7 | Focus indicator is visible |
| 1.4.4 | Text resizable to 200% without loss |
| 2.4.6 | Headings and labels are descriptive |

---

## ARIA Patterns

### Buttons

```html
<!-- Text button - no ARIA needed -->
<button>Save Changes</button>

<!-- Icon-only button - NEEDS aria-label -->
<button aria-label="Close menu">
  <svg aria-hidden="true">...</svg>
</button>

<!-- Toggle button -->
<button aria-pressed="false">
  Notifications
</button>
```

### Expandable Elements

```html
<!-- Disclosure pattern -->
<button aria-expanded="false" aria-controls="panel-1">
  Show Details
</button>
<div id="panel-1" hidden>
  Panel content...
</div>

<!-- Accordion -->
<h3>
  <button aria-expanded="true" aria-controls="sect1">
    Section 1
  </button>
</h3>
<div id="sect1" role="region" aria-labelledby="sect1-btn">
  Content...
</div>
```

### Navigation

```html
<nav aria-label="Main">
  <ul>
    <li><a href="/" aria-current="page">Home</a></li>
    <li><a href="/about">About</a></li>
    <li><a href="/contact">Contact</a></li>
  </ul>
</nav>
```

### Modals/Dialogs

```html
<dialog
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-desc"
>
  <h2 id="modal-title">Confirm Action</h2>
  <p id="modal-desc">Are you sure you want to delete this item?</p>
  <button>Cancel</button>
  <button>Delete</button>
</dialog>
```

**Modal requirements:**
- `role="dialog"` or use `<dialog>` element
- `aria-modal="true"` to indicate it blocks interaction
- `aria-labelledby` pointing to the title
- Focus trap inside modal
- Escape key closes modal
- Return focus to trigger element on close

### Forms

```html
<form>
  <!-- Required field -->
  <label for="email">Email (required)</label>
  <input
    type="email"
    id="email"
    name="email"
    aria-required="true"
    aria-describedby="email-hint email-error"
  >
  <span id="email-hint">We'll never share your email</span>
  <span id="email-error" role="alert" hidden>
    Please enter a valid email
  </span>
</form>
```

### Live Regions

```html
<!-- Status messages (polite) -->
<div role="status" aria-live="polite">
  Form saved successfully
</div>

<!-- Alerts (assertive) -->
<div role="alert" aria-live="assertive">
  Error: Connection lost
</div>
```

### Decorative Elements

```html
<!-- Decorative images -->
<img src="divider.png" alt="" role="presentation">

<!-- Decorative icons -->
<span aria-hidden="true">🎉</span>

<!-- Icons next to text -->
<button>
  <svg aria-hidden="true">...</svg>
  Download
</button>
```

---

## Color Contrast

### Minimum Requirements

| Element | Ratio | Example |
|---------|-------|---------|
| Normal text | 4.5:1 | `#595959` on `#ffffff` |
| Large text (18px+ or 14px+ bold) | 3:1 | `#767676` on `#ffffff` |
| UI components (borders, icons) | 3:1 | `#949494` on `#ffffff` |
| Focus indicators | 3:1 | Against adjacent colors |

### Testing Tools

```bash
# Online
# - WebAIM Contrast Checker
# - Colour Contrast Analyser (CCA)

# Browser DevTools
# Chrome: Elements > Computed > contrast ratio
# Firefox: Accessibility Inspector
```

### Color-Only Information

**BAD:**
```html
<span style="color: green">Available</span>
<span style="color: red">Sold Out</span>
```

**GOOD:**
```html
<span style="color: green">✓ Available</span>
<span style="color: red">✗ Sold Out</span>
```

---

## Keyboard Navigation

### Focus Order

- Tab moves forward through focusable elements
- Shift+Tab moves backward
- Focus order follows visual/reading order
- No keyboard traps (user can always Tab away)

### Focus Indicators

```css
/* NEVER do this without replacement */
:focus {
  outline: none; /* BAD */
}

/* Custom focus style */
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* High contrast mode support */
@media (forced-colors: active) {
  :focus-visible {
    outline: 3px solid CanvasText;
  }
}
```

### Interactive Elements

| Element | Expected Keys |
|---------|--------------|
| Links | Enter |
| Buttons | Enter, Space |
| Checkboxes | Space |
| Radio buttons | Arrow keys (within group) |
| Select | Arrow keys, Enter |
| Tabs | Arrow keys (horizontal), Enter |
| Menus | Arrow keys, Escape |
| Sliders | Arrow keys |

### Skip Links

```html
<body>
  <a href="#main-content" class="skip-link">
    Skip to main content
  </a>
  <header>...</header>
  <main id="main-content" tabindex="-1">
    ...
  </main>
</body>
```

```css
.skip-link {
  position: absolute;
  left: -10000px;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

.skip-link:focus {
  position: fixed;
  top: 0;
  left: 0;
  width: auto;
  height: auto;
  padding: 1rem;
  background: var(--color-background);
  z-index: 9999;
}
```

---

## Screen Reader Support

### Headings

```html
<!-- Correct hierarchy -->
<h1>Page Title</h1>
  <h2>Section</h2>
    <h3>Subsection</h3>
  <h2>Another Section</h2>

<!-- Never skip levels -->
<h1>Title</h1>
<h3>Wrong - skipped h2</h3>
```

### Landmark Regions

```html
<header role="banner">...</header>
<nav role="navigation" aria-label="Main">...</nav>
<main role="main">...</main>
<aside role="complementary">...</aside>
<footer role="contentinfo">...</footer>
```

### Tables

```html
<table>
  <caption>Monthly Sales Report</caption>
  <thead>
    <tr>
      <th scope="col">Product</th>
      <th scope="col">Q1</th>
      <th scope="col">Q2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Widget A</th>
      <td>$1,000</td>
      <td>$1,200</td>
    </tr>
  </tbody>
</table>
```

### Hiding Content

```css
/* Hidden from everyone */
[hidden], .hidden {
  display: none;
}

/* Visually hidden, available to screen readers */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Hidden from screen readers only */
[aria-hidden="true"] {
  /* visible but not announced */
}
```

---

## Testing & Audit

### Automated Tools

```bash
# CLI
npx axe-core-cli http://localhost:3000

# CI/CD integration
npx pa11y http://localhost:3000

# In-browser
# - axe DevTools extension
# - WAVE extension
# - Lighthouse (Chrome DevTools)
```

### Manual Checks

1. **Keyboard only:** Navigate entire page with Tab, Shift+Tab, Enter, Space, Arrow keys
2. **Screen reader:** Test with NVDA (Windows), VoiceOver (Mac), TalkBack (Android)
3. **Zoom:** Ensure content works at 200% zoom
4. **Color blindness:** Use simulation tools
5. **Motion:** Test with `prefers-reduced-motion`

### Common Issues Finder

```bash
# Find buttons without labels
grep -rn "<button" --include="*.tsx" . | grep -v "aria-label" | grep -v node_modules | head -20

# Find images without alt
grep -rn "<img" --include="*.tsx" . | grep -v "alt=" | grep -v node_modules | head -20

# Find inputs without labels
grep -rn "<input" --include="*.tsx" . | grep -v "aria-label\|id=" | grep -v node_modules | head -20
```

---

## Report Format

```markdown
## A11y Fix [ID] - DONE

**WCAG Criterion:** [e.g., 4.1.2 Name, Role, Value]
**Level:** [A/AA/AAA]
**Issue:** [What was wrong]
**Fix:** [What was changed]
**Before:** [Code/behavior before]
**After:** [Code/behavior after]
**Testing:** [How verified - automated + manual]
```

---

## Quick Checklist

Before shipping any component:

- [ ] Semantic HTML (correct elements for purpose)
- [ ] Keyboard accessible (Tab, Enter, Space work)
- [ ] Focus visible (clear indicator)
- [ ] Labels present (visible or `aria-label`)
- [ ] Contrast sufficient (4.5:1 text, 3:1 UI)
- [ ] No color-only meaning
- [ ] Error messages linked to inputs
- [ ] Motion respects user preferences
- [ ] Tested with screen reader
- [ ] Automated scan passes (axe)
