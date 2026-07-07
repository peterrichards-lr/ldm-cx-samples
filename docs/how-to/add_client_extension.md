# ➕ Adding a new Client Extension

When contributing a new Client Extension to the `ldm-cx-samples` repository, ensure it strictly adheres to the Liferay 7.4 Client Extension standards.

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
5. Run `./gradlew build` locally and verify that it compiles successfully without any warnings.
