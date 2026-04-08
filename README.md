# 🏙️ EcoPulse: The Smart City Demo (LDM Sample Assets)

Welcome to **EcoPulse**, a high-fidelity Liferay "Smart City" portal. This workspace is the **source-of-truth for sample assets** bundled with the [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-manager).

## 🎯 The Purpose: Confidence-Driven Selling

For a Sales Engineer, "Demo Risk" is the enemy. EcoPulse is designed to prove that complex, data-driven Liferay environments can be:

1. **Reset in minutes** without manual configuration.
2. **Version-controlled** via a single source folder.
3. **Identical** across local laptops and cloud staging.

This repository builds the **Client Extensions**, **Objects**, and **Fragments** that LDM orchestrates into a "Perfect 10" demo.

---

## 🏗️ The Tech Stack (12 LDM Orchestrated Extensions)

### 🎨 Branding & UI

- **`ecopulse-theme`**: Foundational CSS and **Style Book** definition for the Veridian Shift.
- **`ecopulse-spritemap`**: Custom SVG iconography (`leaf`, `bolt`, `map-marker`).
- **`ecopulse-favicon`**: Professional SVG branding for the browser tab.
- **`ecopulse-custom-element-vanilla`**: A lightweight, frontend-only custom element.

### 📊 Intelligence & Logic

- **`ecopulse-grid-map`**: A React-based Energy Grid Monitor with live status pulses and Headless API integration.
- **`ecopulse-impact-calculator`**: A React widget calculating real-time CO2 savings from `GreenInitiative` data.
- **`ecopulse-object-action`**: A Node.js backend that validates and enriches sustainability data.
- **`ecopulse-workflow-action`**: Handles automated city approval steps via "Machine Approver" logic.
- **`ecopulse-microservice`**: A Node.js service providing "Advanced Metrics" (Efficiency, Carbon Intensity) to the grid.
- **`ecopulse-headless-auth`**: Demonstrates secure Headless API communication via OAuth2.

### 🚀 Data & Site Provisioning

- **`ecopulse-batch`**: Deploys localized `GreenInitiative` and `EnergySector` schemas with multi-language seed data.
- **`ecopulse-site-initializer`**: The "master orchestrator" that assembles the theme, civic identity (City of Veridian), fragments, and the "Veridian News" portal.

---

## 🛠️ LCP & Docker Configuration

All extensions include a full **`LCP.json`** compliant with Liferay Cloud standards:

- **Jobs** (Batch, Initializer): Optimized to **50MB**.
- **Deployments** (Theme, React Apps): Configured with `targetPort: 80`.
- Backend Nodes: Configured with `targetPort: 3001-3004`.

---

_Built with ❤️ for Sales Engineers and the Liferay Docker Manager._
