# Publishing to GitHub Packages

This document explains how to publish the `@xplnhub/lockedin` package to the GitHub Packages registry.

## 1. Automated Publishing (Recommended)

The project is configured with a GitHub Action that automatically publishes the package whenever a new **release** is created on GitHub.

1.  Bump the version in `package.json`.
2.  Commit and push the change.
3.  Go to the "Releases" section of your GitHub repository.
4.  Create a new release with a tag (e.g., `v1.0.6`).
5.  The `Publish Package to GitHub Packages` workflow will trigger and publish the package.

## 2. Manual Publishing

If you need to publish manually from your terminal, follow these steps:

### Authentication

1.  **Generate a Personal Access Token (classic):**
    *   Go to **GitHub Settings** -> **Developer settings** -> **Personal access tokens** -> **Tokens (classic)**.
    *   Generate a new token with at least `write:packages` and `read:packages` scopes.
    *   Copy the token.

2.  **Login to the registry:**
    ```bash
    npm login --scope=@xplnhub --registry=https://npm.pkg.github.com
    ```
    *   **Username**: Your GitHub username.
    *   **Password**: The Personal Access Token you generated.
    *   **Email**: Your GitHub email.

### Publishing

Once authenticated, you can publish the package:

```bash
npm publish
```

## 3. Installing the Package

To install this package globally:

```bash
npm install -g @xplnhub/lockedin --registry=https://npm.pkg.github.com
```

> [!NOTE]
> If the package is private, you will also need to authenticate your terminal before installing.
