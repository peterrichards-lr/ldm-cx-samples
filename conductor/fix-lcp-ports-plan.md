# Implementation Plan: Fix LCP.json Load Balancer Port Configuration

## Objective

Resolve the Liferay Docker Manager (LDM) validation errors indicating "loadBalancer defined but no ports are marked as 'external: true'" across all `Deployment` kind client extensions in the workspace.

## Key Files & Context

The validation error stems from a strict LDM requirement that any LCP deployment exposing a `loadBalancer` must explicitly define a corresponding `ports` array with `external: true`. While the Liferay Gradle plugins automatically inject `loadBalancer` blocks for frontend extensions during the build process, they do not automatically generate the required `ports` array, causing LDM to flag the generated configuration as invalid.

This plan addresses the 13 `Deployment` client extensions by explicitly defining both the `loadBalancer` and `ports` configuration in their source `LCP.json` files to override the incomplete auto-generated configuration and satisfy LDM.

### Affected Files

1. `client-extensions/ecopulse-brand/LCP.json`
2. `client-extensions/ecopulse-custom-element-vanilla/LCP.json`
3. `client-extensions/ecopulse-favicon/LCP.json`
4. `client-extensions/ecopulse-grid-map/LCP.json`
5. `client-extensions/ecopulse-headless-auth/LCP.json`
6. `client-extensions/ecopulse-impact-calculator/LCP.json`
7. `client-extensions/ecopulse-microservice/LCP.json`
8. `client-extensions/ecopulse-object-action/LCP.json`
9. `client-extensions/ecopulse-spritemap/LCP.json`
10. `client-extensions/ecopulse-theme/LCP.json`
11. `client-extensions/ecopulse-workflow-action/LCP.json`
12. `client-extensions/veridian-brand/LCP.json`
13. `client-extensions/veridian-favicon/LCP.json`

## Implementation Steps

For each of the affected files, we will apply the following targeted updates to their `LCP.json`:

### 1. Frontend & Static Assets (Port 80)

For the frontend/static extensions (`ecopulse-brand`, `ecopulse-custom-element-vanilla`, `ecopulse-favicon`, `ecopulse-grid-map`, `ecopulse-impact-calculator`, `ecopulse-spritemap`, `ecopulse-theme`, `veridian-brand`, `veridian-favicon`):

- Ensure the `loadBalancer` explicitly defines `"cdn": true` and `"targetPort": 80`.
- Add a `ports` array marking port `80` as `external: true`.

_Example:_

```json
  "loadBalancer": {
    "cdn": true,
    "targetPort": 80
  },
  "ports": [
    {
      "external": true,
      "port": 80
    }
  ],
```

### 2. Backend Services (Custom Ports)

For the backend services, we will retain their specific `targetPort` and add the matching `ports` array:

- `ecopulse-microservice`: targetPort 3001
- `ecopulse-headless-auth`: targetPort 3002
- `ecopulse-object-action`: targetPort 3003
- `ecopulse-workflow-action`: targetPort 3004

_Example (for ecopulse-microservice):_

```json
  "loadBalancer": {
    "targetPort": 3001
  },
  "ports": [
    {
      "external": true,
      "port": 3001
    }
  ],
```

## Verification & Testing

1.  Run a complete build in the project root: `blade gw clean build`
2.  Inspect the generated `LCP.json` files in the `build/liferay-client-extension-build/` directories to ensure the `ports` array successfully carried over from the source overrides.
3.  Run the Liferay Docker Manager (LDM) validation to confirm the warning "loadBalancer defined but no ports are marked as 'external: true'" is no longer present for any of the client extensions.
