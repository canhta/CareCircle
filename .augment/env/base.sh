#!/bin/bash

# CareCircle Base Environment Setup Script
set -e

echo "🚀 Setting up CareCircle base environment..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update

# Install essential tools for git and documentation work
echo "�️ Installing essential tools..."
sudo apt-get install -y git curl

# Configure Git (if not already configured)
echo "� Configuring Git..."
if [ -z "$(git config --global user.name)" ]; then
    echo "⚠️  Git user.name not configured. Please run:"
    echo "   git config --global user.name 'Your Name'"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo "⚠️  Git user.email not configured. Please run:"
    echo "   git config --global user.email 'your.email@example.com'"
fi

# Navigate to workspace
echo "� Navigating to workspace..."
cd /mnt/persist/workspace

echo "✅ Base environment setup complete!"
echo ""
echo "� Available tools:"
echo "  • git - Version control"
echo "  • curl - File downloading and API requests"
echo ""
echo "📋 Next steps:"
echo "  1. Configure Git if needed (see warnings above)"
echo "  2. Use specific setup scripts for backend or mobile development"
echo "  3. Review project documentation in docs/ directory"
echo ""
echo "💡 This base setup provides essential tools for documentation and git operations."
