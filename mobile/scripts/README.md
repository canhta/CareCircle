# Flutter Scripts

Simple Flutter development scripts for iOS and Android.

## Available Scripts

### `./scripts/setup.sh`

Sets up the Flutter development environment

- Checks Flutter installation
- Installs dependencies
- Sets up iOS and Android

### `./scripts/dev.sh`

Starts Flutter development server

```bash
./scripts/dev.sh                    # Run on default device
./scripts/dev.sh -d device_id       # Run on specific device
```

### `./scripts/build.sh`

Builds the Flutter app

```bash
./scripts/build.sh                  # Build for all platforms
./scripts/build.sh -p android       # Build for Android only
./scripts/build.sh -p ios           # Build for iOS only
./scripts/build.sh -t debug         # Build debug version
```

### `./scripts/clean.sh`

Cleans the Flutter project

- Removes build files
- Cleans dependencies
- Reinstalls pods (iOS)

### `./scripts/deploy.sh`

Builds for deployment

```bash
./scripts/deploy.sh -p android      # Build Android for deployment
./scripts/deploy.sh -p ios          # Build iOS for deployment
./scripts/deploy.sh -e production   # Build for production
```

## Usage

1. First time setup:

```bash
./scripts/setup.sh
```

2. Start development:

```bash
./scripts/dev.sh
```

3. Build for release:

```bash
./scripts/build.sh
```

4. Clean project (if needed):

```bash
./scripts/clean.sh
```
