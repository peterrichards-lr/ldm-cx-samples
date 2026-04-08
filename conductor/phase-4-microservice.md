# Implementation Plan: Phase 4 - Remote Intelligence Microservice [COMPLETED]

This plan outlines the creation of the **EcoPulse Remote Intelligence** microservice, a Node.js-based service that provides advanced data crunching for the smart city grid.

## Objective

Demonstrate multi-container orchestration and cross-extension communication by providing an external API for sector-specific energy metrics.

## Key Files & Context

- **Target Extension**: `client-extensions/ecopulse-microservice/` (New Node.js etc-node)
- **Port**: 3001
- **Endpoints**:
    - `/api/metrics/grid-efficiency`: Returns mock efficiency and carbon intensity data.
    - `/ready`: Health check endpoint for LDM orchestration.

## Implementation Steps

### 1. Initialize the Node.js Service

1. Create `client-extensions/ecopulse-microservice/` with `package.json`, `server.js`, and `Dockerfile`.
2. Configure `client-extension.yaml` as an `oAuthApplicationHeadlessServer` to allow secure discovery.

### 2. Develop the Metrics Logic

1. **Express API**: Implement a route that accepts a `sectorId` and returns randomized but realistic energy metrics.
2. **CORS Configuration**: Enable CORS to allow the `ecopulse-grid-map` (React) to fetch data directly from the microservice.

### 3. Integration with Grid Map

1. Update `ecopulse-grid-map/src/App.tsx` to call the microservice when a sector is selected.
2. Use Liferay Style Book variables for any UI elements served by the microservice.

## Verification & Testing

1. **Local Test**: Run the service locally and verify `curl http://localhost:3001/api/metrics/grid-efficiency`.
2. **LDM Sync**: Verify that LDM correctly maps port 3001 and provides the internal URL to the frontend.
