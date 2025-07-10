#!/bin/bash

# CareCircle Mobile Development Environment Setup Script
set -e

echo "🚀 Setting up CareCircle mobile development environment..."

# Update system packages
sudo apt-get update

# Install Flutter dependencies
echo "📱 Installing Flutter dependencies..."
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Download and install Flutter 3.32.5
echo "📱 Installing Flutter 3.32.5..."
cd $HOME
if [ ! -d "flutter" ]; then
    wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.5-stable.tar.xz
    tar xf flutter_linux_3.32.5-stable.tar.xz
    rm flutter_linux_3.32.5-stable.tar.xz
fi

# Add Flutter to PATH in .profile
if ! grep -q "export PATH=\"\$HOME/flutter/bin:\$PATH\"" $HOME/.profile; then
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> $HOME/.profile
fi

# Source the profile to make Flutter available immediately
export PATH="$HOME/flutter/bin:$PATH"

# Install Git
echo "📝 Installing Git..."
sudo apt-get install -y git

# Navigate to workspace
cd /mnt/persist/workspace

# Install mobile dependencies
echo "📱 Installing mobile dependencies..."
cd mobile
flutter pub get

# Run Flutter doctor to check setup
echo "🔍 Running Flutter doctor..."
flutter doctor

# Go back to workspace root
cd ..

echo "✅ Mobile development environment setup complete!"
echo ""
echo "🔧 Available commands:"
echo "  Mobile: cd mobile && flutter run --flavor development"
echo ""
echo "📋 Next steps:"
echo "  1. Start mobile app: cd mobile && flutter run --flavor development"
echo "  2. For iOS development, ensure Xcode is installed and configured"
echo "  3. For Android development, ensure Android Studio and SDK are configured"
echo ""
echo "💡 Note: Run 'flutter doctor' to check for any additional setup requirements."
