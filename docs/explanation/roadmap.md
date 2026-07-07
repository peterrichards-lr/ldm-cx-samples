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

## ✅ Phase 2: Live Data & Interaction (COMPLETED)

**Objective**: Transition from static UI to a data-driven "Digital Twin."

- **Grid Monitor (React)**: Finalized the `ecopulse-grid-map` with real-time sector load pulses and live fetch from Object API.
- **Green Initiatives (Object)**: Deployed the `C_GreenInitiative` and `C_EnergySector` schemas via `ecopulse-batch`.
- **Site Provisioning**: Refined the `ecopulse-site-initializer` to auto-map core extensions and fragments onto a pre-configured home page.

---

## ✅ Phase 3: The "Intelligence" Layer (COMPLETED)

**Objective**: Showcase LDM's ability to handle multi-container logic and complex APIs.

### 1. The Impact Calculator (React + Headless)

- **Concept**: A dedicated widget that fetches the total number of `GreenInitiative` entries via the Headless API.
- **Logic**: Performs a client-side calculation to show "Estimated CO2 Tons Saved."
- **Status**: Finalized and integrated into the Home page.

### 2. City of Veridian Civic Identity

- **Concept**: Official municipal branding ("The Emerald Spire") for governmental projects.
- **Assets**: `veridian-logo.svg`, `veridian-official.png`, and a civic asset library.
- **Municipal Web Content**: Automated deployment of the "Veridian News" portal with official branding.
- **Status**: Completed; integrated into the `ecopulse-site-initializer`.

---

## ✅ Phase 4: Remote Intelligence & Veridican Microservices (COMPLETED)

**Objective**: Expand the demo with distributed logic and multi-language support.

- **Remote Calculation Microservice**: Implemented the Node service to handle "Advanced Metrics" for the Grid Map.
- **Global Verification**: Localized the "Veridian Manifesto" and Object labels (`GreenInitiative`, `EnergySector`) into German, Spanish, and French.
- **Snapshot Expansion**: Expanded the journal article collection to 7+ articles, simulating a full "News Portal."

---

## ✅ Phase 5: Enterprise Verification (COMPLETED)

**Objective**: Scale the demo for enterprise-level requirements.

- **Workflow Integration**: Enabled the "Machine Approver" workflow on `GreenInitiative` and `EnergySector` entries, demonstrating business process orchestration.
- **Validation**: Performed a full build and validated the expanded asset snapshot for LDM deployment.

---

_Built to prove that complex orchestration can be simple._
