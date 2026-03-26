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

## 🏗️ Phase 4: Remote Intelligence & Veridican Microservices (IN PROGRESS)

**Objective**: Expand the demo with distributed logic and multi-language support.

- **Remote Calculation Microservice**: Implement the Node service to handle "Advanced Metrics" for the Grid Map.
- **Global Verification**: Localize the "Veridian Manifesto" and Object labels (e.g., German, Spanish, French).
- **Snapshot Expansion**: Expand the SQL dump to include a full "News Portal."

---

## 🌍 Phase 5: Enterprise Verification (FUTURE)

**Objective**: Scale the demo for enterprise-level requirements.

- **Multi-Language Support**: Localize the "Veridian Manifesto" and Object labels (e.g., German, Spanish, French).
- **Workflow Integration**: Enable a workflow on `GreenInitiative` entries so citizens can submit them, but only approved ones appear on the public map.
- **Snapshot Expansion**: Expand the SQL dump to include a full "News Portal" with 50+ articles, testing LDM's high-volume asset restoration.

---

_Built to prove that complex orchestration can be simple._
