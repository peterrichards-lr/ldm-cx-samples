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
- **Never add `clay.scss` or `main.scss`** to a theme CSS extension's `src/css`. They replace the base theme's entry points, so the build ships a `clay.css` and `main.css` without Clay or Liferay's styles. A theme CSS extension replaces Classic's CSS entirely, so the site loses its styling. Use the hooks, as Liferay's `liferay-sample-theme-css-4` does:
    - `_clay_variables.scss`: imports the brand palette (`@import 'brand_<brand>';`) and sets Clay variables. It is brand-specific.
    - `_custom.scss`: imports `brand_<brand>` and `core`, then adds rules. It is brand-specific.
    - `_core.scss` and `_brand_*.scss`: shared, copied from `common-theme-assets`.
      A healthy build has a `clay.css` of roughly 900 KB; the E2E Boot Test fails below 100 KB.
- **Style book tokens**: each brand declares `frontendTokenDefinitionJSON: src/frontend-token-definition.json` (the brand colours, the headings font family, weight and H1 size, and the button radius, as CSS variables). Without it, Liferay applies no style book to pages using the brand. `_core.scss` and `_custom.scss` read the variables with the brand values as fallbacks (`var(--primary, #{$brand-primary})`).

### Branding Enforcement

- **Variables**: Use semantic mappings (`$brand-primary`, `$brand-secondary`) in `_core.scss` to ensure component styles automatically adapt to the active brand.
- **Explicit Styles**: Component-specific overrides (e.g., `.ecopulse-card`, `.btn-brand`) should be defined in the shared core but use CSS variables for color values.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-11-25_ | _Last Reviewed: 2026-11-25_
