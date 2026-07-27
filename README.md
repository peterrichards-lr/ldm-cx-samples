# 🏙️ EcoPulse: The Smart City Demo (LDM Sample Assets)

Welcome to **EcoPulse**, a high-fidelity Liferay "Smart City" portal. This workspace is the **source-of-truth for sample assets** bundled with the [Liferay Docker Manager (LDM)](https://github.com/peterrichards-lr/liferay-docker-manager).

## 📚 Documentation

The complete documentation for this repository, including architectural overviews, configuration guides, and tutorials, has been restructured using the Diátaxis framework.

Please refer to the [docs/](./docs/) directory or view the compiled MkDocs site for full details.

### 🐳 Custom Container Binary Isolation Standards

All custom container client extensions (such as `ecopulse-microservice`) MUST include a `.dockerignore` file containing:

```
node_modules
build
dist
.env
```

This prevents host-compiled native C++ addon binaries (`.node` files) from being copied into the container build context, ensuring clean native compilation during `docker build`.

---

_Built with ❤️ for Sales Engineers and the Liferay Docker Manager._

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-27* | *Last Reviewed: 2026-07-27*
