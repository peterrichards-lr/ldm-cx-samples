# Liferay Client Extension Samples (LDM)

This repository contains a collection of **Liferay Client Extension** samples, demonstrating how to build, deploy, and integrate external applications with Liferay DXP (2025.Q4+).

**Note:** This repository is specifically used to build the client extensions utilized in the [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-scripts) project.

## Project Overview

Each sample is located in the `client-extensions/` directory and is configured as a standalone project within this Liferay Workspace. The samples include:

### 1. Sample Custom Element (`sample-custom-element`)

A frontend-only extension that renders a custom HTML element within Liferay.
- **Type:** `customElement`
- **Frontend:** Vanilla JS + CSS.
- **Features:** Environment detection (detects if it's running inside Liferay) and interactive elements.

### 2. Sample Headless Auth Node (`sample-headless-auth-node`)

A Node.js backend application that demonstrates the **Client Credentials** grant flow.
- **Type:** `oAuthApplicationHeadlessServer`
- **Grant Type:** `client_credentials`
- **Features:** Automatically fetches an OAuth2 access token and calls the Liferay Headless Delivery API (`/o/headless-delivery/v1.0/sites`) to list available sites.

### 3. Sample Microservice Node (`sample-microservice-node`)

A simple Node.js microservice prepared for Liferay Cloud or local hosting.
- **Type:** `oAuthApplicationHeadlessServer`
- **Features:** A lightweight Express.js server that can be scaled as a microservice and integrated with Liferay's OAuth2 framework.

### 4. Sample Object Action Node (`sample-object-action-node`)

A Node.js backend action that is triggered by events in **Liferay Objects** (e.g., when an entry is created or updated).
- **Type:** `objectAction`
- **Features:** Receives a JSON payload from Liferay containing the object entry data for server-side processing.

### 5. Sample Workflow Action Node (`sample-workflow-action-node`)

A Node.js backend action that is triggered by **Liferay Workflow** (e.g., when a task is moved to a specific status).
- **Type:** `workflowAction`
- **Features:** Receives a JSON payload from Liferay containing the workflow task details for automated backend processing.

---

## Getting Started

### Prerequisites
- **Blade CLI** installed.
- **Liferay DXP 2025.Q4+** running locally.
- **Node.js 18+** (for running backend samples locally).

### Build and Package

To build all client extensions and package them for deployment:

```bash
blade gw clean build
```

*This command generates the `.zip` packages in the `client-extensions/[extension-name]/dist/` folders.*

### Deploy to Liferay

To deploy the client extensions to your local Liferay instance:

```bash
blade gw deploy
```

*This will copy the configurations and assets to `bundles/osgi/client-extensions`.*

### Local Development (Node.js Apps)

To run a backend extension locally while developing:

1. Navigate to the extension directory:

   ```bash
   cd client-extensions/sample-headless-auth-node
   ```
2. Install dependencies and start the server:

   ```bash
   npm install && npm start
   ```
3. The server will start on `http://localhost:8080`.

---

## Key Configurations

- **`client-extension.yaml`**: The primary configuration file that defines the extension type, scopes, and resource paths.
- **`LCP.json`**: Required for the workspace build process as it signals Liferay Cloud readiness.
- **`Dockerfile`**: Used to containerize the Node.js applications for deployment.