---
description: How to safely update code and push to remote
---

# Git Update and Push Workflow

Follow these steps when making changes to the codebase and pushing them to the remote repository.

1. **Pull Latest Changes**
Before starting any work, ensure you have the latest code from the remote.
// turbo
```bash
git pull origin main
```

2. **Make Changes**
Apply your code edits, bug fixes, or new features as requested by the user.

3. **Verify Locally**
Run a quick sanity check to ensure the tool still works.
// turbo
```bash
./lockedin --version
```

4. **Stage and Commit**
Stage all changes and create a descriptive commit message.
// turbo
```bash
git add .
git commit -m "Your descriptive commit message"
```

5. **Final Push**
Push the changes back to the main branch.
// turbo
```bash
git push origin main
```

6. **Optional: NPM Release**
If the changes warrant a new release, follow the NPM release workflow.
