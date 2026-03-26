# 🏙️ EcoPulse: The Smart City Demo (LDM Sample Assets)

Welcome to **EcoPulse**, a high-fidelity Liferay "Smart City" portal. This workspace is the **source-of-truth for sample assets** bundled with the [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-manager).

## 🎯 The Purpose: Confidence-Driven Selling

For a Sales Engineer, "Demo Risk" is the enemy. EcoPulse is designed to prove that complex, data-driven Liferay environments can be:

1. **Reset in minutes** without manual configuration.
2. **Version-controlled** via a single source folder.
3. **Identical** across local laptops and cloud staging.

This repository builds the **Client Extensions**, **Objects**, and **Fragments** that LDM orchestrates into a "Perfect 10" demo.

---

## 🏗️ The Tech Stack (11 LDM Orchestrated Extensions)

### 🎨 Branding & UI

- **`ecopulse-theme`**: Foundational CSS and **Style Book** definition.
- **`ecopulse-spritemap`**: Custom SVG iconography (`leaf`, `bolt`, `map-marker`).
- **`ecopulse-favicon`**: Professional SVG branding.
- **`ecopulse-custom-element-vanilla`**: A lightweight, frontend-only custom element.

### 📊 Intelligence & Logic

- **`ecopulse-grid-map`**: A React-based Energy Grid Monitor with live status simulation.
- **`ecopulse-object-action`**: A Node.js backend that validates and enriches `GreenInitiative` energy data.
- **`ecopulse-workflow-action`**: Handles automated city approval steps for sustainability projects.
- **`ecopulse-microservice`**: A standalone Node.js microservice for advanced grid calculations.
- **`ecopulse-headless-auth`**: Demonstrates secure Headless API communication via OAuth2.

### 🚀 Data & Site Provisioning

- **`ecopulse-batch`**: Deploys the `GreenInitiative` Object schema and seeds the portal with sustainable city data.
- **`ecopulse-site-initializer`**: The "master orchestrator" that assembles the theme, favicon, fragments, and initial documents.

---

## 🛠️ LCP & Docker Configuration

All extensions include a full **`LCP.json`** compliant with Liferay Cloud standards:

- **Jobs** (Batch, Initializer): Optimized to **50MB**.
- **Deployments** (Theme, React Apps): Configured with `targetPort: 80`.
- **Backend Nodes**: Configured with `targetPort: 8080`.

---

_Built with ❤️ for Sales Engineers and the Liferay Docker Manager._
