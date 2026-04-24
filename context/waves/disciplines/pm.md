---
format_version: "4.0"
---

# Product Management Patterns

This document defines the product management patterns and best practices for defining user value, success metrics, and feature prioritization in the App Manager system.

---

## Table of Contents

1. [PM Philosophy](#pm-philosophy)
2. [User Value Definition](#user-value-definition)
3. [Success Metrics](#success-metrics)
4. [Feature Prioritization](#feature-prioritization)
5. [User Research](#user-research)
6. [Adoption Strategy](#adoption-strategy)
7. [Feature Discovery](#feature-discovery)
8. [Competitive Analysis](#competitive-analysis)
9. [Product Requirements](#product-requirements)
10. [User Feedback Integration](#user-feedback-integration)

---

## PM Philosophy

### Core Principles

1. **User Value First**: Features exist to solve user problems, not showcase technology
2. **Measure What Matters**: Success metrics should reflect actual user outcomes
3. **Simplicity Wins**: The best feature is often the one you don't build
4. **Data-Informed, Not Data-Driven**: Use data to inform decisions, not make them
5. **Iterate Based on Feedback**: Ship, learn, improve, repeat
6. **Say No More Than Yes**: Protect scope ruthlessly

### PM Success Metrics

- **User Adoption**: % of target users actively using the feature
- **User Satisfaction**: NPS or satisfaction score
- **Task Success Rate**: % of users successfully completing intended task
- **Time to Value**: How quickly users get value from the feature
- **Retention**: % of users returning to use the feature
- **Feature Usage**: Frequency and depth of feature engagement

---

## User Value Definition

### Jobs-to-be-Done Framework

Every feature should answer:
- **What job** is the user trying to do?
- **What outcome** do they want to achieve?
- **What problem** does this solve for them?
- **Why** would they choose our solution?

### Value Proposition Pattern

```markdown
## User Value Proposition

**For** [target user]
**Who** [has this need/problem]
**Our solution** [provides this capability]
**That** [delivers this benefit]
**Unlike** [alternative solution]
**Our approach** [key differentiator]
```

**Example**:
```markdown
## Portal - User Value Proposition

**For** developers managing multiple applications
**Who** need to switch between TCM, NHL, and Apportionment frequently
**Our solution** provides a unified portal with tab-based navigation
**That** eliminates the need to remember URLs and reduces context switching
**Unlike** bookmarking each app separately or using the app manager
**Our approach** keeps all apps in one window with preserved state
```

### User Persona Pattern

**Primary Persona**: App Manager Developer
- **Goals**: Build and deploy features quickly, monitor app health
- **Pain Points**: Too many URLs to remember, context switching between apps
- **Technical Level**: High (comfortable with CLI, Git, PM2)
- **Usage Pattern**: Daily, multiple times per day

**Secondary Persona**: Product Owner
- **Goals**: Track feature progress, view metrics, understand system health
- **Pain Points**: Need to check multiple dashboards for status
- **Technical Level**: Medium (can navigate UIs, prefers visual over CLI)
- **Usage Pattern**: Weekly check-ins, occasional deep dives

---

## Success Metrics

### Metric Types

**Adoption Metrics**:
- **WAU/MAU**: Weekly/Monthly Active Users
- **First-Time Usage**: % of eligible users who try feature
- **Adoption Rate**: % of target users actively using
- **Time to First Use**: How long after release do users try it

**Engagement Metrics**:
- **Usage Frequency**: How often users engage with feature
- **Session Duration**: Time spent in feature
- **Feature Depth**: % using advanced vs. basic capabilities
- **Return Rate**: % of users returning within 7 days

**Outcome Metrics**:
- **Task Success Rate**: % completing intended task
- **Time to Complete**: Duration to achieve goal
- **Error Rate**: % of failed attempts
- **User Satisfaction**: NPS, CSAT, or custom survey

**Business Metrics**:
- **Development Velocity**: Features shipped per wave
- **Bug Rate**: Post-launch issues
- **Support Tickets**: User-reported problems
- **Team Productivity**: Time saved by feature

### Success Metrics Pattern

```markdown
## Success Metrics

| Metric | Baseline | Target | Measurement |
|--------|----------|--------|-------------|
| User adoption | 0% (new feature) | 80% within 2 weeks | Analytics tracking |
| Tab switches per session | N/A | 5+ (frequent use) | Event tracking |
| Time to navigate to app | 30s (manual URL) | <5s (one click) | User timing |
| User satisfaction | N/A (new) | NPS 8+ | Post-launch survey |
| Context switching overhead | 5 apps × 30s = 150s | <10s | User timing |
```

### SMART Goals Pattern

Goals should be:
- **Specific**: Enable users to access all apps from one portal
- **Measurable**: 80% adoption within 2 weeks
- **Achievable**: Based on current user behavior patterns
- **Relevant**: Addresses #1 user pain point (context switching)
- **Time-bound**: Launch within 3 weeks

---

## Feature Prioritization

### Prioritization Framework: RICE

**RICE Score** = (Reach × Impact × Confidence) / Effort

**Reach**: How many users affected (per time period)
- Example: 10 developers × 20 uses/week = 200 uses/week

**Impact**: How much it helps (scale 0.25 to 3)
- 3.0 = Massive impact
- 2.0 = High impact
- 1.0 = Medium impact
- 0.5 = Low impact
- 0.25 = Minimal impact

**Confidence**: How sure are you (%)
- 100% = High confidence (data-backed)
- 80% = Medium confidence (some data)
- 50% = Low confidence (hypothesis)

**Effort**: Person-hours required
- Include design, development, testing, deployment

**Example**:
```
Portal Feature:
- Reach: 10 users × 20 uses/week = 200
- Impact: 2.0 (high - solves major pain point)
- Confidence: 80% (user feedback confirms need)
- Effort: 60 hours

RICE = (200 × 2.0 × 0.8) / 60 = 5.33
```

### Priority Buckets

**P0 - Critical** (RICE > 10):
- Must have for launch
- Blocks other features
- Severe user pain if missing
- Do first

**P1 - High** (RICE 5-10):
- Strongly desired
- Significant user value
- Competitive necessity
- Do next

**P2 - Medium** (RICE 2-5):
- Nice to have
- Moderate user value
- Can defer if needed
- Do later

**P3 - Low** (RICE < 2):
- Minimal impact
- Few users affected
- Expensive to build
- Consider not doing

### Feature Scope Pattern

```markdown
## Feature Scope

### In Scope (MVP)
- Tab navigation between TCM, NHL, Apportionment
- Shared header with app selector
- Responsive design (desktop, tablet, mobile)
- Tab state preservation during session

### Out of Scope (Future Waves)
- Cross-app search (Wave 7)
- Unified notifications (Wave 8)
- Single sign-on (Wave 7)
- User preferences/settings (Wave 9)

### Explicitly Not Doing
- Iframe approach (performance concerns)
- Separate portal backend (unnecessary complexity)
- Custom tab styling per app (maintain consistency)
```

---

## User Research

### Research Methods

**Qualitative Research**:
- **User Interviews**: 1-on-1 conversations (5-7 users)
- **Usability Testing**: Watch users attempt tasks
- **Field Studies**: Observe users in natural environment
- **Feedback Sessions**: Open discussion with users

**Quantitative Research**:
- **Surveys**: Collect data from many users
- **Analytics**: Track actual behavior
- **A/B Tests**: Compare variations
- **Metrics Analysis**: Review usage patterns

### User Interview Pattern

**Before Building**:
```
Questions:
1. How do you currently switch between TCM, NHL, and Apportionment?
2. How often do you need to access multiple apps in one session?
3. What's frustrating about the current experience?
4. If you could change one thing, what would it be?
5. How would you describe the ideal navigation experience?

Goal: Validate problem, not solution
```

**After Prototyping**:
```
Tasks:
1. "Show me how you'd navigate to the TCM app"
2. "Now switch to NHL and find your recent projects"
3. "Go back to TCM without losing your place"

Observe: Where do they struggle? What's intuitive?
Ask: "What did you expect to happen here?"
```

### Usability Testing Pattern

**Test Plan**:
- 5-7 users (80% of usability issues found)
- 30-45 minutes per session
- Specific tasks to complete
- Think-aloud protocol
- No leading questions

**Success Criteria**:
- 80%+ complete task on first try
- <10s to understand navigation
- No critical confusion points
- Positive feedback on concept

---

## Adoption Strategy

### Launch Plan Pattern

**Pre-Launch** (1 week before):
- Announce feature in team channel
- Share benefits and use cases
- Create quick start guide
- Record demo video

**Launch** (Day 0):
- Release announcement
- Email to all users
- Post demo video
- Office hours for questions

**Post-Launch** (Weeks 1-4):
- Week 1: Daily usage monitoring, quick fixes
- Week 2: Collect initial feedback, address issues
- Week 3: Survey users, measure adoption
- Week 4: Analyze metrics, plan improvements

### Feature Education Pattern

**In-App Guidance**:
- First-time user tour (optional, dismissible)
- Tooltips on key features
- Empty state messaging ("Get started by...")
- Help links to documentation

**Documentation**:
- Quick start guide (5 minutes to value)
- Feature overview (what it does, why it's useful)
- FAQs (common questions)
- Video walkthrough (3-5 minutes)

### Adoption Metrics Tracking

```markdown
## Adoption Tracking

### Week 1
- Eligible Users: 10
- Activated: 6 (60%)
- Active (3+ uses): 4 (40%)
- Status: On track for 80% target

### Week 2
- Eligible Users: 10
- Activated: 8 (80%) ✅ Target met
- Active (3+ uses): 7 (70%)
- Status: Exceeding expectations
```

---

## Feature Discovery

### Discoverability Patterns

**Navigation Discoverability**:
- Prominent placement (header, sidebar)
- Clear labeling (no jargon)
- Visual affordance (looks clickable)
- Contextual hints (when relevant)

**Feature Promotion**:
- "New" badge (first 2 weeks)
- Contextual tips (first use)
- Guided tour (optional)
- Email announcement

**Progressive Disclosure**:
- Show basic features first
- Reveal advanced features as needed
- Don't overwhelm with options
- Layer complexity thoughtfully

### Menu Architecture

```
Portal Header
├── Logo (home)
├── Tabs
│   ├── TCM (primary)
│   ├── NHL (primary)
│   └── Apportionment (primary)
├── Search (Wave 7)
├── Notifications (Wave 8)
└── Settings
    ├── Theme
    └── Admin Dashboard (link)
```

**Principles**:
- Primary actions in main navigation
- Secondary actions in settings/menu
- Maximum 7 items in any menu (Miller's Law)
- Group related items

---

## Competitive Analysis

### Competitive Landscape

**Alternative Solutions**:

1. **Bookmarks** (Current approach)
   - Pros: No development needed, works everywhere
   - Cons: Still multiple windows, no state sharing
   - User pain: Context switching overhead

2. **Browser tabs** (Manual management)
   - Pros: Native browser feature
   - Cons: Easy to lose tabs, no app-specific state
   - User pain: Tab overload

3. **App Manager Dashboard** (Current)
   - Pros: Central monitoring, service control
   - Cons: Designed for admin, not daily use
   - User pain: Extra click to launch apps

**Competitive Positioning**:
```
Our Portal:
- Single-window experience ✅
- Tab-based navigation ✅
- Preserved state ✅
- Designed for developers ✅
- Admin tools separate ✅
```

### Feature Comparison

| Feature | Bookmarks | Browser Tabs | App Manager | Portal |
|---------|-----------|--------------|-------------|--------|
| One window | ❌ | ⚠️ | ❌ | ✅ |
| State preserved | ❌ | ❌ | ❌ | ✅ |
| Fast switching | ❌ | ⚠️ | ❌ | ✅ |
| No URLs to remember | ❌ | ❌ | ⚠️ | ✅ |
| Developer-focused | ❌ | ❌ | ⚠️ | ✅ |

---

## Product Requirements

### PRD Pattern

```markdown
# Product Requirements: Portal

## Problem Statement
Developers waste 150+ seconds per session navigating between TCM, NHL, and Apportionment apps using separate URLs and windows.

## Proposed Solution
Unified portal with tab-based navigation, shared layout, and preserved state.

## User Stories

**As a** developer
**I want to** access all apps from one portal
**So that** I don't waste time switching windows and URLs

**As a** developer
**I want** my work to be preserved when I switch tabs
**So that** I don't lose context or have to reload

**As a** product owner
**I want** a streamlined navigation experience
**So that** I can quickly check multiple app statuses

## Success Metrics
[See Success Metrics section above]

## User Experience Requirements
- One-click tab switching
- <100ms tab switch latency
- State preserved during session
- Responsive design (desktop, tablet, mobile)
- Keyboard navigation support
- Accessibility (WCAG 2.1 AA)

## Technical Requirements
- React Router for navigation
- Shared QueryClient for state
- Code splitting for performance
- <500KB initial bundle
- PM2 integration

## Out of Scope
[See Feature Scope section above]

## Dependencies
- React Router v6 implementation
- Component export from existing apps
- Shared layout components

## Launch Plan
[See Adoption Strategy section above]
```

### Acceptance Criteria Pattern

```markdown
## Acceptance Criteria

### Portal Foundation
- [ ] Portal loads at http://localhost:3000
- [ ] Header displays with logo and nav
- [ ] Tabs render for TCM, NHL, Apportionment
- [ ] Click tab switches to that app
- [ ] URL updates to reflect active tab
- [ ] Responsive on mobile (tabs → hamburger menu)

### State Preservation
- [ ] User scrolls in TCM, switches to NHL, returns → scroll position preserved
- [ ] User fills form in TCM, switches tabs, returns → form data intact
- [ ] API data cached and shared across tabs (QueryClient)

### Performance
- [ ] Initial load <3 seconds
- [ ] Tab switch <100ms
- [ ] Bundle size <500KB gzipped
- [ ] Lighthouse score >90

### Accessibility
- [ ] Keyboard navigation works (Tab, Enter, Arrow keys)
- [ ] Screen reader announces tab changes
- [ ] Focus management correct
- [ ] WCAG 2.1 AA compliant
```

---

## User Feedback Integration

### Feedback Collection

**In-App Feedback**:
- Feedback widget (always available)
- Post-feature survey (2 weeks after launch)
- Bug reporting (integrated)
- Feature requests (captured)

**Direct Feedback**:
- User interviews (monthly)
- Usability testing (per wave)
- Office hours (weekly)
- Slack channel (ongoing)

**Passive Feedback**:
- Analytics (usage patterns)
- Error tracking (what breaks)
- Support tickets (pain points)
- Feature usage (what's popular)

### Feedback Processing Pattern

```markdown
## Feedback Analysis - Portal (Week 2)

### Themes
1. **Love the concept** (8/10 users)
   - "So much faster than bookmarks"
   - "Exactly what I needed"

2. **Tab switching feels slow** (5/10 users)
   - Current: 300ms, Target: <100ms
   - Action: Implement code splitting + lazy loading

3. **Want keyboard shortcuts** (4/10 users)
   - Request: Cmd+1, Cmd+2, Cmd+3 for tab switching
   - Priority: P1 (High value, low effort)

4. **Mobile experience unclear** (3/10 users)
   - Tabs don't fit on small screens
   - Action: Hamburger menu for mobile (P0)

### Action Items
- [ ] P0: Implement code splitting (Wave 6 Phase 5)
- [ ] P0: Responsive mobile menu (Wave 6 Phase 2 - add)
- [ ] P1: Keyboard shortcuts (Wave 7 Phase 1)
- [ ] P2: Tab reordering (Wave 7 Phase 3)
```

### Iteration Pattern

**Feedback → Analysis → Decision → Action**

1. **Collect**: Gather feedback from multiple sources
2. **Analyze**: Identify themes and patterns
3. **Prioritize**: Use RICE framework
4. **Plan**: Add to roadmap with appropriate priority
5. **Build**: Implement in upcoming wave
6. **Measure**: Track if improvement achieved desired outcome

---

## Roadmap Planning

### Roadmap Pattern

```markdown
# Portal Roadmap

## Wave 6: Portal Foundation (Current)
- Basic tab navigation
- Shared layout
- State preservation
- **Goal**: 80% adoption

## Wave 7: Enhanced Navigation (4 weeks)
- Keyboard shortcuts
- Cross-app search
- Recent apps list
- **Goal**: Reduce navigation time 50%

## Wave 8: Unified Notifications (6 weeks)
- Centralized notification center
- Cross-app alerts
- Notification preferences
- **Goal**: Never miss important updates

## Wave 9: Personalization (4 weeks)
- Tab reordering
- Favorite apps
- Custom theme
- **Goal**: Tailored experience per user

## Future (Not Scheduled)
- Single sign-on (depends on auth infrastructure)
- Admin tools integration
- Mobile app
```

---

## Best Practices Summary

### Do's ✅
- Start with user problems, not solutions
- Measure outcomes, not outputs
- Keep features simple and focused
- Validate assumptions with research
- Iterate based on feedback
- Say no to protect scope
- Define success metrics upfront
- Track adoption and engagement

### Don'ts ❌
- Don't build features users don't need
- Don't assume you know what users want
- Don't skip user research
- Don't launch without success metrics
- Don't ignore negative feedback
- Don't add features without removing complexity elsewhere
- Don't forget about discoverability
- Don't skip the adoption plan

---

## Templates

### Quick PRD Template

```markdown
# [Feature Name]

## Problem
[What user problem are we solving?]

## Solution
[How will we solve it?]

## User Value
[What benefit does this provide?]

## Success Metrics
[How will we measure success?]

## In Scope
- [Specific capability 1]
- [Specific capability 2]

## Out of Scope
- [Explicitly not doing]

## Launch Plan
[How will users discover and adopt?]
```

---

**Last Updated**: 2026-01-28
**Version**: 1.0
**Status**: Active
