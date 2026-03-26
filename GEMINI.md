# EcoPulse Workspace: Engineering Standards & Learnings

This file tracks the foundational patterns and "Learnings" discovered during the development of the EcoPulse Smart City demo.

## 1. Liferay Cloud (LCP.json) Standards

To ensure compatibility with the **Liferay Docker Manager (LDM)** and real Liferay Cloud environments, all `LCP.json` files must be **explicit**.

### Kind & Scaling

- **Jobs**: Use for `batch` and `siteInitializer`. Set `kind: "Job"`.
- **Deployments**: Use for all other extensions. Set `kind: "Deployment"`.
- **Scaling**: For sample assets, always default to `scale: 1`.

### Port Mapping

- **Frontend (Caddy)**: `targetPort: 80`.
- **Backend (Node.js/Spring Boot)**: `targetPort: 8080`.
  _Note: Ensure the Dockerfile EXPOSE matches the LCP targetPort._

### Memory Management

- **Target**: 50MB (Hard-gate).
- **Learning**: Liferay Gradle plugins default Jobs to 300MB. We must explicitly override this in the root of the extension folder to keep the demo environment lean.

## 2. EcoPulse Brand Consistency

All assets and UI components must align with the **Veridian Shift** visual identity.

### Palette

- **Emerald Green (`#00C853`)**: Vitality, Energy, Success.
- **Tech Navy (`#1A237E`)**: Trust, Infrastructure, Reliability.
- **Innovation Blue (`#00B0FF`)**: Data, Real-time Metrics, Future.

### Metadata (ERC)

- Always use the `ecopulse-` prefix for folder names and `externalReferenceCode`.
- Names should be professional and descriptive (e.g., `EcoPulse Energy Grid Monitor`).

## 3. Site Orchestration

The `ecopulse-site-initializer` is the source-of-truth for the demo's initial state.

- **Documents**: High-res assets must be placed in `site-initializer/documents/group/`.
- **Wiring**: The `site-initializer.json` must explicitly link to the `ecopulse-theme`, `ecopulse-favicon`, and `ecopulse-spritemap` ERCs.

## 4. Development Workflow

- **Linting**: Prettier is enforced via Husky pre-commit hooks.
- **Packaging**: Use `./gradlew clean build` to generate the LDM-ready ZIPs in `dist/` folders.
- **Verification**: Always check the generated `build/liferay-client-extension-build/LCP.json` to ensure source overrides were applied correctly.

## 5. Liferay Objects & Reserved Names

- **Status & Type**: `status` and `type` are reserved keywords in Liferay Objects. Use `operationalStatus` or `categoryType` instead.
- **Identifier**: Prefer using `externalReferenceCode` as the primary identifier for records (e.g., 'N-1', 'gi-solar-grid') instead of a custom `id` or `sectorId` field to avoid confusion with internal Liferay IDs.
- **Reserved List**: Always check the [Liferay Reserved Field Names](https://learn.liferay.com/w/dxp/low-code/objects/creating-and-managing-objects/fields/adding-fields-to-objects#reserved-field-names) before defining a schema.
