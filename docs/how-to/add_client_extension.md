# ➕ Adding a new Client Extension

When contributing a new Client Extension to the `ldm-cx-samples` repository, ensure it strictly adheres to the Liferay DXP 2026.q1 LTS Client Extension standards.

## Steps

1. Create a new directory under `client-extensions/` with the name of your extension.
2. Ensure you have a valid `client-extension.yaml` definition.
3. If your extension is a static asset (React App, Custom Element, Theme, Favicon), you **must** include an `LCP.json` file in the root with an empty `ports` array to prevent port collisions during LDM orchestrations:

    ```json
    {
    	"id": "mycustomextension",
    	"ports": []
    }
    ```

4. If your extension is a backend node/microservice, assign a unique port in your `LCP.json` between `3005-3099` (e.g. `3005`).
5. If your extension has a `Dockerfile`, base it on a supported Node LTS image (currently `node:22-slim`, matching CI), and add a `.dockerignore` containing `node_modules`, `build`, `dist` and `.env`. This stops host-compiled native binaries from being copied into the image.
6. Run `./gradlew build` locally and verify that it compiles successfully without any warnings.

<!-- markdownlint-disable MD049 -->

---

_Last Updated: 2026-11-23_ | _Last Reviewed: 2026-11-23_
