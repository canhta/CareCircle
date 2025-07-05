---
type: 'always_apply'
---

# Package Management

- **Never edit package files manually** (package.json, pubspec.yaml, etc.)
- **Always use proper commands:**

```bash
# npm/yarn/pnpm
npm/yarn/pnpm install/add <pkg>      # Add dependency
npm/yarn/pnpm remove/uninstall <pkg> # Remove dependency

# Flutter
flutter pub add <pkg>                # Add dependency
flutter pub remove <pkg>             # Remove dependency
```

- **Rationale:** Manual edits cause inconsistencies between manifest and lock files
