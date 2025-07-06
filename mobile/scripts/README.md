# Flutter Scripts

Optimized Flutter development scripts for iOS and Android with advanced build and performance features.

## Available Scripts

### `./setup.sh`

Sets up the Flutter development environment with platform-specific optimizations.

```bash
./setup.sh                         # Setup all platforms
./setup.sh -p ios                  # Setup iOS only
./setup.sh -p android              # Setup Android only
./setup.sh -u                      # Upgrade dependencies
./setup.sh -c                      # Check performance issues
```

**Options:**

- `-p, --platform` - Platform to setup (android, ios, all)
- `-v, --verbose` - Enable verbose output
- `-u, --upgrade` - Upgrade dependencies
- `-s, --skip-flutter-upgrade` - Skip Flutter SDK upgrade
- `-f, --force` - Force reinstallation of components
- `-c, --check-performance` - Check setup performance issues

### `./dev.sh`

Starts Flutter development server with enhanced debugging and device options.

```bash
./dev.sh                           # Run with interactive device selection
./dev.sh -d device_id              # Run on specific device
./dev.sh -p                        # Run with performance overlay
./dev.sh -r                        # Run in profile mode
```

**Options:**

- `-d, --device` - Device to run on (device_id or 'menu' for interactive)
- `-p, --performance` - Run with performance overlay
- `-n, --network-debug` - Enable network debugging
- `-w, --web-port` - Web server port (default: 8080)
- `-r, --profile` - Run in profile mode
- `-l, --log-level` - Log level (verbose|debug|info|warning|error)
- `-f, --fast` - Fast start (skip dependency checks)
- `-s, --skip-build-runner` - Skip build_runner generation

### `./build.sh`

Builds the Flutter app with optimizations for different environments.

```bash
./build.sh                         # Build all platforms in release mode
./build.sh -p android              # Build Android only
./build.sh -p ios                  # Build iOS only
./build.sh -t profile              # Build profile version
./build.sh -f staging              # Build staging flavor
./build.sh -p ios --simulator      # Build iOS for simulator
```

**Options:**

- `-p, --platform` - Platform to build (android, ios, all)
- `-t, --type` - Build type (debug, profile, release)
- `-f, --flavor` - Build flavor (dev, staging, production)
- `-n, --build-number` - Specify build number
- `-c, --clean` - Perform clean build
- `-v, --verbose` - Enable verbose output
- `-o, --obfuscate` - Obfuscate code (release builds only, must be used with -s)
- `-s, --split-debug-info` - Path to split debug info
- `--simulator` - Build for iOS simulator instead of device

### `./clean.sh`

Cleans the Flutter project with selective cleaning options.

```bash
./clean.sh                         # Clean all platforms
./clean.sh -p android              # Clean Android only
./clean.sh -p ios                  # Clean iOS only
./clean.sh -d                      # Deep clean
./clean.sh -a                      # Analyze unused dependencies
```

**Options:**

- `-p, --platform` - Platform to clean (android, ios, all)
- `-d, --deep` - Perform a deeper clean
- `-c, --preserve-cache` - Preserve pub and gradle caches
- `-n, --no-reinstall` - Skip dependency reinstallation
- `-a, --analyze-deps` - Analyze and report unused dependencies
- `-v, --verbose` - Enable verbose output

## Features

### Build Optimizations

- **Multiple build flavors** - dev, staging, production
- **Code obfuscation** - for release builds
- **Tree-shaking** - reduces app size
- **Split debug info** - for easier crash analysis
- **Build variants** - debug, profile, release modes

### Performance Features

- **Performance overlays** - visual performance tracking
- **Network debugging** - monitor API requests and responses
- **Hardware acceleration detection** - ensure optimal emulator performance
- **Gradle optimizations** - parallel builds and caching
- **Profile mode** - accurate performance metrics

### iOS-Specific Features

- **Swift optimizations** - for faster release builds
- **M1/M2/M3 Mac support** - architecture detection
- **IPA archiving** - automated app packaging
- **Auto code signing** - simplified release process

### Android-Specific Features

- **App Bundle generation** - for Play Store submissions
- **Multi-dex support** - for large apps
- **Gradle memory optimizations** - faster builds
- **Custom build variants** - flavor support

## Usage

1. First time setup:

```bash
./setup.sh
```

2. Start development:

```bash
./dev.sh
```

3. Build for different environments:

```bash
# Debug build
./build.sh -t debug

# Production release
./build.sh -f production -c -o
```

4. Clean when needed:

```bash
./clean.sh -p android -d  # Deep clean Android
```
