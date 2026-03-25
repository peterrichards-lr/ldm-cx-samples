# 🏙️ EcoPulse: The Smart City Demo (LDM Sample Assets)

Welcome to **EcoPulse**, a high-fidelity Liferay "Smart City" portal. This workspace is the **source-of-truth for sample assets** bundled with the [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-manager).

## 🎯 The Purpose: Confidence-Driven Selling

For a Sales Engineer, "Demo Risk" is the enemy. EcoPulse is designed to prove that complex, data-driven Liferay environments can be:

1. **Reset in minutes** without manual configuration.
2. **Version-controlled** via a single source folder.
3. **Identical** across local laptops and cloud staging.

This repository builds the **Client Extensions**, **Objects**, and **Fragments** that LDM orchestrates into a "Perfect 10" demo.

---

## 📖 The Backstory: "The Veridian Shift"

The fictional city of **Veridian** is transitioning to a 100% green energy grid. The **EcoPulse Portal** serves as the public "Digital Twin" of this infrastructure, allowing citizens to monitor grid health and submit their own sustainability initiatives.

### Why this works for the LDM Tool

This setup creates a "litmus test" for the Docker management tool:

- **Snapshots**: Correctly restores large SQL dumps and `document_library` volumes (testing asset persistence).
- **Objects**: Handles the "Ready" state of Liferay’s internal API engines during deployment.
- **Client Extensions**: Configures Environment Variables and external URLs for modern, remote applications.
- **Fragments**: Successfully pushes UI resources into a running container via Liferay APIs.

---

## 🛠️ The Tech Stack (LDM Orchestrated)

### 1. The Theme & UI (`ecopulse-theme`, `ecopulse-spritemap`)

- **Palette**: Emerald Green (`#00C853`), Tech Navy (`#1A237E`), and Innovation Blue (`#00B0FF`).
- **Icons**: Custom SVGs for `leaf` (Sustainability), `bolt` (Energy), and `map-marker` (Grid Map).
- **Style Book**: Brand tokens are exposed for real-time UI customization.

### 2. Liferay Objects (`ecopulse-batch`)

- **Entity**: `GreenInitiative` (System Name: `C_GreenInitiative`).
- **Fields**: `Title`, `Description`, `ImpactLevel (1-100)`.
- **Value**: Deploys the schema and seeds 20+ records automatically so the demo looks "lived-in."

### 3. Client Extensions (`ecopulse-grid-map`)

- **React Custom Element**: A "Live" Energy Grid Monitor that simulates real-time data pulses across five city sectors.

### 4. Site Initializer (`ecopulse-site-initializer`)

- **The Master Orchestrator**: Automates the assembly of the theme, favicon, fragments, and initial documents (like the **Veridian Manifesto** and high-res imagery).
- **Root Fragments (`/fragments/*.zip`)**: Demonstrates automated ZIP-based fragment deployment. LDM and Liferay Workspace auto-deploy these collection ZIPs into the portal upon container initialization.

---

## 🎨 Branding & Asset Guide

The `assets/` directory contains the "Multi-Variant PNG Kit" used to test asset restoration. These are also automatically included in the **Site Initializer Document Library** for immediate demo use:

- **Logo**: `ecopulse-logo.svg` (The master branding).
- **Hero Images**:
    - `hero-highres-[1-4].png`: High-fidelity cityscapes and wind turbines.
    - `hero-variant-[1-4].png`: Optimized variants for testing responsive backgrounds.
- **Asset Sheets**:
    - `asset-sheet-[1-2].png`: Branding guides showing logo variants and palette.
    - `asset-sheet-grey.png`: The grey-background design guide.

---

## 🚀 Development Workflow

### Build and Package

To build all client extensions for LDM distribution:

```bash
./gradlew clean build
```

### Local Deployment

To test against a running local Liferay instance:

```bash
./gradlew deploy
```

---

_Built with ❤️ for Sales Engineers and the Liferay Docker Manager._
