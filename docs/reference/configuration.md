# 🛠️ LCP & Docker Configuration

All extensions include a full **`LCP.json`** compliant with Liferay Cloud standards:

- **Jobs** (Batch, Initializer): Optimized to **50MB**.
- **Deployments** (Theme, React Apps): Configured with `targetPort: 80` but explicit `ports` array mapping is disabled (empty array) to prevent port 80 collisions when running locally.
- **Backend Nodes**: Configured with `targetPort: 3001-3004` and explicit `ports` array mapping (`external: true`).

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
