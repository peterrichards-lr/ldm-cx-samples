# Implementation Plan: Phase 3 - CO2 Impact Calculator

This plan outlines the creation of the **EcoPulse Impact Calculator**, a React-based widget that demonstrates Liferay's Headless API capabilities and real-time data orchestration.

## Objective

Provide a dynamic, visually impressive "Total CO2 Saved" counter that fetches data directly from the `GreenInitiative` Object.

## Key Files & Context

- **Target Extension**: `client-extensions/ecopulse-impact-calculator/` (New Custom Element)
- **Data Source**: Liferay Headless Object API (`/o/c/greeninitiatives/`)
- **Accent Color**: Innovation Blue (`#00B0FF`)

## Implementation Steps

### 1. Initialize the Extension

1. Create `client-extensions/ecopulse-impact-calculator/` using the Vite/React template.
2. Configure `client-extension.yaml` with:
    - `name: EcoPulse Impact Calculator`
    - `htmlElementName: ecopulse-impact-calculator`

### 2. Develop the Calculator Logic

1. **API Integration**: Implement a service using `Liferay.Util.fetch()` to retrieve the `totalCount` of entries in the `GreenInitiative` Object.
2. **Impact Algorithm**:
    - `Total Tons = (Entry Count * 1.5) + (Average Impact Level * 0.8)`
3. **Animated Counter**: Use a library or custom hook to create a "rolling number" effect for the CO2 tons display.

### 3. UI/UX Design

1. **EcoPulse Branding**: Apply the Emerald and Navy theme with a prominent Blue accent for the data value.
2. **Visual Feedback**: Add an SVG "Eco-Scale" that shifts based on the calculated total.

## Verification & Testing

1. **Data Accuracy**: Manually add a `GreenInitiative` entry and verify the counter increments.
2. **LDM Deployment**: Verify the new extension is correctly orchestrated by the LDM tool.
3. **API Resilience**: Ensure the widget handles "empty" states or API timeouts gracefully.
