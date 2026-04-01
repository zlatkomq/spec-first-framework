# UIX/UI Specification

## Metadata

| Field | Value |
|-------|-------|
| ID | XXX |
| Name | |
| Status | DRAFT / APPROVED |
| Author | |
| Reviewer | |
| Date | |
| Approved By | |
| Approval Date | |
| Jira Ticket | |

---

## Overview

[1-2 paragraphs: What is the UI approach? How does this feature present itself to the user? Reference the tech stack and component library from CONSTITUTION.md.]

---

## Screen Inventory

Map every screen/view to the user stories from SPEC.md.

| Screen / View | User Story | Route / Path | Description |
|---------------|------------|--------------|-------------|
| | | | |

---

## Component Specifications

For each screen listed above, define the component hierarchy, props, state, and data bindings.

### [Screen Name]

**Component Hierarchy:**

```
ScreenRoot
├── ComponentA
│   ├── SubComponentA1
│   └── SubComponentA2
└── ComponentB
```

**Component Details:**

| Component | Props | State | Data Binding (API Endpoint) |
|-----------|-------|-------|-----------------------------|
| | | | |

---

## Design Token Mapping

Map design tokens (from Figma or design system) to the project's design system as defined in CONSTITUTION.md.

| Token Category | Design Token | Project Value | Notes |
|----------------|-------------|---------------|-------|
| Color | | | |
| Typography | | | |
| Spacing | | | |
| Border Radius | | | |
| Shadow | | | |

Write "No Figma tokens provided — using project design system defaults from CONSTITUTION.md." if no Figma data is available.

---

## Interaction Patterns

### User Flows

[Describe the primary user flows through the screens. Use numbered steps or a flow diagram.]

### Transitions & Animations

| From | To | Trigger | Transition |
|------|----|---------|------------|
| | | | |

Write "Standard framework transitions — no custom animations required." if not applicable.

### State Handling

| State | Visual Treatment | Trigger |
|-------|-----------------|---------|
| Loading | | |
| Empty | | |
| Error | | |
| Success | | |

---

## Responsive / Adaptive Layout

| Breakpoint | Layout Changes | Components Affected |
|------------|----------------|---------------------|
| | | |

Write "Single layout — no responsive breakpoints required." if not applicable.

---

## Accessibility Requirements

Per CONSTITUTION.md accessibility standards, each component must meet the following:

| Component | ARIA Role / Label | Keyboard Navigation | Focus Management | Color Contrast |
|-----------|-------------------|---------------------|------------------|----------------|
| | | | | |

---

## Asset Inventory

List all assets required from Figma or other design sources.

| Asset | Type | Source | Notes |
|-------|------|--------|-------|
| | Icon / Image / Illustration / Font | Figma / Local / CDN | |

Write "No external assets required." if not applicable.

---

## Open Questions

[Optional: Unresolved UI/UX decisions that need answers before implementation]

- [ ] 
- [ ] 
