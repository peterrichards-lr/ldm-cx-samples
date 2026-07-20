---
name: ecopulse-brand
description: Activate this skill whenever working on UI components, SASS styles, Clay CSS, or brand consistency.
---
# EcoPulse Brand Consistency

All assets and UI components must align with the **Veridian Shift** visual identity.

### Palette

- **Emerald Green (`#00C853`)**: Vitality, Energy, Success.
- **Tech Navy (`#1A237E`)**: Trust, Infrastructure, Reliability.
- **Innovation Blue (`#00B0FF`)**: Data, Real-time Metrics, Future.

### Metadata (ERC)

- Always use the `ecopulse-` prefix for folder names and `externalReferenceCode`.
- Names should be professional and descriptive (e.g., `EcoPulse Energy Grid Monitor`).

# Theme & Brand Development (Clay & SASS)

### Brand Separation Architecture

- **Shared Core**: All shared SASS logic, component styles, and Clay variables reside in `client-extensions/common-theme-assets/src/css/`.
- **Syncing**: Because the Liferay CSS builder requires all imported SASS files to be in the local `src/css` directory, any changes to the shared core must be copied to both `ecopulse-brand/src/css/` and `veridian-brand/src/css/` before building.
- **Entity Themes**: `ecopulse-brand` and `veridian-brand` are **themeCSS** extensions that provide the specific branding variables and core components for their respective entities.

### Branding Enforcement

- **Variables**: Use semantic mappings (`$brand-primary`, `$brand-secondary`) in `_core.scss` to ensure component styles automatically adapt to the active brand.
- **Explicit Styles**: Component-specific overrides (e.g., `.ecopulse-card`, `.btn-brand`) should be defined in the shared core but use CSS variables for color values.

<!-- markdownlint-disable MD049 -->
---
*Last Updated: 2026-07-20* | *Last Reviewed: 2026-07-20*
