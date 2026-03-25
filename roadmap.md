# 🗺️ EcoPulse Roadmap: The Veridian Shift

This document outlines the technical evolution of the EcoPulse Smart City demo. Each phase is designed to test and showcase specific orchestration capabilities of the **Liferay Docker Manager (LDM)**.

---

## ✅ Phase 1: Core Branding & Identity (COMPLETED)

**Objective**: Establish the "Veridian" visual signature.

- **Theme & Palette**: Injected Emerald (`#00C853`) and Navy (`#1A237E`) into `ecopulse-theme`.
- **Icons**: Custom SVGs (`leaf`, `bolt`, `map-marker`) in `ecopulse-spritemap`.
- **Favicon**: Professional SVG branding via `ecopulse-favicon`.
- **Fragments**: Initial "Eco Hero" and "Initiative Card" components.

---

## 🏗️ Phase 2: Live Data & Interaction (IN PROGRESS)

**Objective**: Transition from static UI to a data-driven "Digital Twin."

- **Grid Monitor (React)**: Finalize the `ecopulse-grid-map` with real-time sector load pulses.
- **Green Initiatives (Object)**: Deploy the `C_GreenInitiative` schema via `ecopulse-batch`.
- **Site Provisioning**: Refine the `ecopulse-site-initializer` to auto-map all 6 core extensions and fragments.

---

## 🚀 Phase 3: The "Intelligence" Layer (PLANNED)

**Objective**: Showcase LDM's ability to handle multi-container logic and complex APIs.

### 1. The Impact Calculator (React + Headless)

- **Concept**: A dedicated widget that fetches the total number of `GreenInitiative` entries via the Headless API.
- **Logic**: Performs a client-side calculation to show "Estimated CO2 Tons Saved."
- **Demo Value**: Tests Liferay's Headless API performance and CORS/Auth configuration.

### 2. Remote Calculation Microservice (Node/Spring Boot)

- **Concept**: A separate service (hosted as a Client Extension) that performs heavy data crunching.
- **Interaction**: The React map calls this remote service instead of Liferay for specific "Advanced Metrics."
- **Demo Value**: Tests LDM's **multi-container orchestration** (Liferay + Remote App) and environment variable injection.

---

## 🌍 Phase 4: Global Verification (FUTURE)

**Objective**: Scale the demo for enterprise-level requirements.

- **Multi-Language Support**: Localize the "Veridian Manifesto" and Object labels (e.g., German, Spanish, French).
- **Workflow Integration**: Enable a workflow on `GreenInitiative` entries so citizens can submit them, but only approved ones appear on the public map.
- **Snapshot Expansion**: Expand the SQL dump to include a full "News Portal" with 50+ articles, testing LDM's high-volume asset restoration.

---

_Built to prove that complex orchestration can be simple._
