---
name: liferay-cloud
description: Activate this skill whenever modifying LCP.json files, configuring Docker deployments, or tuning memory for Liferay Cloud.
---
# Liferay Cloud (LCP.json) Standards

To ensure compatibility with the **Liferay Docker Manager (LDM)** and real Liferay Cloud environments, all `LCP.json` files must be **explicit**.

### Kind & Scaling

- **Jobs**: Use for `batch` and `siteInitializer`. Set `kind: "Job"`.
- **Deployments**: Use for all other extensions. Set `kind: "Deployment"`.
- **Scaling**: For sample assets, always default to `scale: 1`.

### Port Mapping

- **Frontend (Caddy)**: `targetPort: 80`.
- Backend (Node.js): `targetPort: 3001-3004`.
- **LDM Validation**: All Deployments with a `loadBalancer` must include an explicit `ports` array with `external: true` matching the `targetPort`.
  _Note: Ensure the Dockerfile EXPOSE matches the LCP targetPort._

### Memory Management

- **Target**: 50MB (Hard-gate).
- **Learning**: Liferay Gradle plugins default Jobs to 300MB. We must explicitly override this in the root of the extension folder to keep the demo environment lean.

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
