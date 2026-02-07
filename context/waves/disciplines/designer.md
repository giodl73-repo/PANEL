---
format_version: "4.0"
---

# Designer Discipline Guidelines

Comprehensive design and accessibility standards for all web applications in the App Manager monorepo.

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Accessibility Standards (WCAG 2.1 AA)](#accessibility-standards-wcag-21-aa)
3. [Design System](#design-system)
4. [Visual Quality Standards](#visual-quality-standards)
5. [Cross-Browser Compatibility](#cross-browser-compatibility)
6. [Assessment Requirements](#assessment-requirements)

---

## Design Philosophy

### Core Principles

1. **Accessibility First**: All users, regardless of ability, should have equal access
2. **Consistency**: Use design system components and patterns consistently
3. **Clarity**: Information architecture should be intuitive and easy to navigate
4. **Responsiveness**: Designs work across all devices and screen sizes
5. **Performance**: Visual design doesn't compromise load times or performance

### Design Goals

- **Inclusive**: WCAG 2.1 AA compliance (minimum)
- **Maintainable**: Design system ensures consistency and reduces tech debt
- **User-Centered**: Designs solve real user problems with clear affordances
- **Scalable**: Patterns work across all apps in the monorepo

---

## Accessibility Standards (WCAG 2.1 AA)

### WCAG 2.1 AA Compliance Checklist

All web applications MUST meet these standards before wave completion.

#### Automated Checks

Tools: axe-core, Lighthouse, WAVE

**Requirements**:
- [ ] **axe-core**: 0 violations
- [ ] **Lighthouse Accessibility**: ≥95 score
- [ ] **WAVE**: 0 errors, 0 contrast errors

**Running automated checks**:
```bash
# Lighthouse (Chrome DevTools)
# Open DevTools → Lighthouse → Accessibility audit

# axe DevTools extension
# Install axe DevTools extension → Run scan

# WAVE
# Install WAVE extension → Analyze page
```

#### Manual Checks

**Keyboard Navigation**:
- [ ] Tab order is logical and complete
- [ ] All interactive elements reachable via keyboard
- [ ] Enter/Space activates buttons and links
- [ ] Escape closes modals and dismisses popups
- [ ] Arrow keys navigate within components (tabs, menus, etc.)
- [ ] Focus never gets trapped (except modals with proper escape)

**Screen Reader Testing** (NVDA/JAWS/VoiceOver):
- [ ] All content is announced in logical order
- [ ] Images have appropriate alt text (decorative images: alt="")
- [ ] Form inputs have associated labels
- [ ] Dynamic content changes are announced (aria-live)
- [ ] Page title describes current page/view
- [ ] Headings create proper document outline (h1 → h2 → h3)

**Focus Management**:
- [ ] Focus indicators visible on all interactive elements
- [ ] Focus indicator contrast ≥3:1 against background
- [ ] Custom focus styles meet or exceed browser defaults
- [ ] Focus not obscured by sticky headers or overlays

**Color & Contrast**:
- [ ] Color is not the only means of conveying information
- [ ] Provide text labels/icons in addition to color
- [ ] Links distinguishable from surrounding text (underline, bold, etc.)

#### ARIA Requirements

**Buttons & Links**:
- [ ] All buttons have accessible name (aria-label or visible text)
- [ ] Icon-only buttons have aria-label
- [ ] Links describe their destination

**Forms**:
- [ ] All form inputs have associated labels
- [ ] Error messages linked to inputs (aria-describedby)
- [ ] Required fields indicated (aria-required or visual indicator)
- [ ] Form validation errors announced

**Dynamic Content**:
- [ ] Loading states announced (aria-live="polite")
- [ ] Error messages announced (aria-live="assertive")
- [ ] Content updates announced when appropriate

**Modal Dialogs**:
- [ ] Modal has aria-modal="true"
- [ ] Modal has aria-labelledby pointing to title
- [ ] Focus trapped within modal while open
- [ ] Escape key closes modal
- [ ] Focus returns to trigger element on close

**Interactive Regions**:
- [ ] Custom interactive components have proper ARIA roles
- [ ] Expandable sections use aria-expanded
- [ ] Tabs use role="tablist", role="tab", role="tabpanel"
- [ ] Menus use role="menu", role="menuitem"

#### Color Contrast (WCAG AA)

**Text Contrast**:
- [ ] **Normal text** (16px): ≥4.5:1 contrast ratio
- [ ] **Large text** (18px+ or 14px+ bold): ≥3:1 contrast ratio
- [ ] **Interactive elements**: ≥3:1 against background
- [ ] **Disabled state**: Clearly distinguishable visually

**Testing Contrast**:
```bash
# Use WebAIM Contrast Checker
https://webaim.org/resources/contrastchecker/

# Or Lighthouse/axe-core automated checks
```

**Common violations to avoid**:
- Light gray text (#999) on white background ❌ (2.8:1)
- Yellow (#FFEB3B) on white background ❌ (1.4:1)
- Link blue (#2196F3) too light ❌ (check ratio)

**Approved color combinations** (examples):
- Dark gray (#333) on white ✅ (12.6:1)
- Blue (#1976D2) on white ✅ (4.7:1)
- White on dark blue (#1565C0) ✅ (8.6:1)

#### Semantic HTML

**Proper structure**:
- [ ] Use semantic elements (`<header>`, `<nav>`, `<main>`, `<footer>`, `<article>`, `<section>`)
- [ ] Headings create logical outline (h1 → h2 → h3, no skipping levels)
- [ ] Lists use `<ul>`, `<ol>`, `<li>` (not divs styled as lists)
- [ ] Tables use `<table>`, `<thead>`, `<tbody>`, `<th>`, `<td>`
- [ ] Forms use `<form>`, `<label>`, `<input>`, `<select>`, `<textarea>`

#### Responsive Design (Accessibility)

- [ ] **Mobile (375px)**: Fully functional, readable text (≥16px)
- [ ] **Tablet (768px)**: Optimized layout, easy navigation
- [ ] **Desktop (1024px+)**: Full feature set, no horizontal scroll
- [ ] **Touch targets**: ≥44×44px (WCAG 2.1 Level AAA, recommended)
- [ ] **Zoom**: Content usable at 200% zoom (WCAG AA)

---

## Design System

### Design Tokens

**Colors** (Tailwind CSS):
```css
/* Primary */
--color-primary: theme('colors.blue.600');
--color-primary-hover: theme('colors.blue.700');

/* Secondary */
--color-secondary: theme('colors.gray.600');

/* Success, Warning, Error */
--color-success: theme('colors.green.600');
--color-warning: theme('colors.yellow.600');
--color-error: theme('colors.red.600');

/* Text */
--color-text-primary: theme('colors.gray.900');
--color-text-secondary: theme('colors.gray.600');

/* Background */
--color-background: theme('colors.white');
--color-surface: theme('colors.gray.50');
```

**Typography**:
```css
/* Headings */
--font-heading: Inter, system-ui, sans-serif;
--text-h1: 2.5rem; /* 40px */
--text-h2: 2rem;   /* 32px */
--text-h3: 1.5rem; /* 24px */

/* Body */
--font-body: Inter, system-ui, sans-serif;
--text-base: 1rem;     /* 16px */
--text-sm: 0.875rem;   /* 14px */
--text-lg: 1.125rem;   /* 18px */
```

**Spacing**:
```css
/* Consistent spacing scale (Tailwind) */
--space-1: 0.25rem;  /* 4px */
--space-2: 0.5rem;   /* 8px */
--space-3: 0.75rem;  /* 12px */
--space-4: 1rem;     /* 16px */
--space-6: 1.5rem;   /* 24px */
--space-8: 2rem;     /* 32px */
```

### Component Patterns

**Buttons**:
```tsx
// Primary button (CTA)
<button className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 focus:ring-2 focus:ring-blue-500">
  Save
</button>

// Secondary button
<button className="px-4 py-2 bg-gray-200 text-gray-800 rounded hover:bg-gray-300 focus:ring-2 focus:ring-gray-400">
  Cancel
</button>

// Icon button with accessibility
<button aria-label="Close" className="p-2 rounded hover:bg-gray-100">
  <XIcon className="w-5 h-5" />
</button>
```

**Cards**:
```tsx
<div className="bg-white rounded-lg shadow p-6">
  <h3 className="text-lg font-semibold mb-2">Card Title</h3>
  <p className="text-gray-600">Card content...</p>
</div>
```

**Forms**:
```tsx
<div className="space-y-4">
  <div>
    <label htmlFor="name" className="block text-sm font-medium text-gray-700">
      Name
    </label>
    <input
      id="name"
      type="text"
      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
    />
  </div>
</div>
```

### Design System Consistency

**MUST follow**:
- [ ] Use design system components (no custom one-offs)
- [ ] Typography matches design tokens
- [ ] Spacing uses consistent scale (4px, 8px, 12px, 16px, 24px, 32px)
- [ ] Colors from approved palette only
- [ ] Icons from approved icon set (Heroicons, Lucide, etc.)

**Common violations**:
- Custom yellow (#F59E0B) instead of system primary color ❌
- Card padding: 12px instead of system 16px ❌
- Button variant not in design system ❌
- Random spacing values (13px, 19px, etc.) ❌

---

## Visual Quality Standards

### Information Architecture

- [ ] **Clear hierarchy**: Visual hierarchy guides user attention appropriately
- [ ] **Scannable**: Important information stands out
- [ ] **Logical grouping**: Related content grouped together
- [ ] **Consistent navigation**: Navigation patterns consistent across app

### Interactive Elements

- [ ] **Clear affordances**: Interactive elements look interactive
  - Buttons appear clickable (shadow, color, hover state)
  - Links underlined or visually distinct
  - Form inputs have visible borders
- [ ] **Hover states**: All interactive elements have hover feedback
- [ ] **Active states**: Clear feedback when element is pressed/active
- [ ] **Disabled states**: Visually distinct from enabled (but still readable)

### Loading & Error States

- [ ] **Loading indicators**: Show when content is loading (spinners, skeletons)
- [ ] **Error messages**: Clear, actionable error messages
- [ ] **Empty states**: Helpful guidance when no data exists
- [ ] **Success feedback**: Confirm successful actions (toasts, messages)

**Example**:
```tsx
// Loading state
{isLoading && <Spinner aria-label="Loading cards..." />}

// Error state
{error && (
  <Alert variant="error">
    <p>Failed to load cards. Please try again.</p>
    <button onClick={retry}>Retry</button>
  </Alert>
)}

// Empty state
{data.length === 0 && (
  <EmptyState
    icon={<CardIcon />}
    title="No cards yet"
    description="Get started by adding your first card."
    action={<Button onClick={openAddCard}>Add Card</Button>}
  />
)}
```

---

## Cross-Browser Compatibility

### Testing Requirements

**Browsers**:
- [ ] **Chrome** (latest): Primary browser
- [ ] **Firefox** (latest): Test layout and functionality
- [ ] **Safari** (latest): Test on macOS/iOS
- [ ] **Edge** (latest): Test on Windows

**Mobile**:
- [ ] **iOS Safari**: Test on iPhone (portrait & landscape)
- [ ] **Chrome Android**: Test on Android device

### Common Issues to Check

- [ ] CSS Grid/Flexbox work across browsers
- [ ] Custom fonts load correctly
- [ ] Forms work on mobile (autocomplete, input types)
- [ ] Touch gestures work (swipe, tap, pinch-zoom)
- [ ] Modal focus trap works on mobile

---

## Assessment Requirements

### Quality Gate Standards

When reviewing completed waves, enforce these standards:

#### 1. Accessibility Compliance

**CRITICAL** (Block completion):
- All WCAG 2.1 AA automated checks pass (axe-core, Lighthouse, WAVE)
- Color contrast violations fixed
- Keyboard navigation functional
- ARIA labels on interactive elements

**MAJOR** (Should fix):
- Manual accessibility checks (screen reader, focus management)
- Touch target sizes (<44×44px)
- Responsive design issues

#### 2. Design System Consistency

**CRITICAL**:
- All components use design system patterns
- No custom colors outside approved palette
- Typography follows design tokens

**MAJOR**:
- Spacing inconsistencies
- Component variants not in system
- Icon inconsistencies

#### 3. Visual Quality

- Information architecture clear and intuitive
- Interactive elements have clear affordances
- Loading/error/empty states implemented
- Responsive across breakpoints

#### 4. Cross-Browser Compatibility

- Tested in Chrome, Firefox, Safari
- Mobile responsiveness verified
- Touch targets ≥44×44px

### Assessment Output Format

```markdown
## Design Assessment

**Status**: NEEDS_WORK | APPROVED

**Accessibility Issues**: X violations

**Critical** (Block completion):
- [ ] Color contrast: text-yellow-600 fails WCAG AA (3.2:1, needs ≥4.5:1)
- [ ] Missing ARIA labels on filter buttons (lines 234-256)
- [ ] Keyboard navigation broken: modal doesn't trap focus

**Major** (Should fix):
- [ ] Grid not responsive on mobile (375px viewport)
- [ ] Touch targets too small: 32px (need ≥44px)
- [ ] Screen reader doesn't announce filter changes

**Design System Issues**: Y inconsistencies

- [ ] Using custom yellow (#F59E0B) instead of system primary color
- [ ] Card padding: 12px instead of system 16px
- [ ] Button variant not in design system

**Follow-up Enhancement**: Create EXX to fix accessibility and design issues

**Approval Criteria**:
- All WCAG 2.1 AA checks pass
- Design system consistency: 100%
- Responsive across all breakpoints
- Cross-browser compatible
```

---

## Tools & Resources

### Accessibility Testing Tools

**Automated**:
- [axe DevTools](https://www.deque.com/axe/devtools/) - Browser extension
- [Lighthouse](https://developers.google.com/web/tools/lighthouse) - Built into Chrome DevTools
- [WAVE](https://wave.webaim.org/extension/) - Browser extension

**Manual**:
- Screen readers: NVDA (Windows), JAWS (Windows), VoiceOver (macOS/iOS)
- Keyboard navigation testing
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

### Design Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [A11y Project Checklist](https://www.a11yproject.com/checklist/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Heroicons](https://heroicons.com/) - Icon set

---

**Last Updated**: 2026-01-29
**Version**: 1.0
**Status**: Active
