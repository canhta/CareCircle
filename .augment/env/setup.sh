#!/bin/bash

# CareCircle Development Environment Setup Script
set -e

echo "🚀 Setting up CareCircle development environment..."

# Update system packages
sudo apt-get update

# Install Node.js 18+ and npm
echo "📦 Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Node.js installation
node --version
npm --version

# Install Flutter dependencies
echo "📱 Installing Flutter dependencies..."
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Download and install Flutter 3.8+
echo "📱 Installing Flutter 3.8..."
cd $HOME
if [ ! -d "flutter" ]; then
    wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
    tar xf flutter_linux_3.24.5-stable.tar.xz
    rm flutter_linux_3.24.5-stable.tar.xz
fi

# Add Flutter to PATH in .profile
if ! grep -q "export PATH=\"\$HOME/flutter/bin:\$PATH\"" $HOME/.profile; then
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> $HOME/.profile
fi

# Source the profile to make Flutter available immediately
export PATH="$HOME/flutter/bin:$PATH"

# Install Python 3.10+ and pip
echo "🐍 Installing Python 3.10..."
sudo apt-get install -y python3.10 python3.10-venv python3-pip

# Install Docker and Docker Compose
echo "🐳 Installing Docker..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Install Git
echo "📝 Installing Git..."
sudo apt-get install -y git

# Navigate to workspace
cd /mnt/persist/workspace

# Install root project dependencies
echo "📦 Installing root project dependencies..."
npm install

# Install backend dependencies
echo "🔧 Installing backend dependencies..."
cd backend
npm install

# Generate Prisma client
echo "🗄️ Generating Prisma client..."
npx prisma generate

# Go back to workspace root
cd ..

# Install mobile dependencies
echo "📱 Installing mobile dependencies..."
cd mobile
flutter pub get

# Run Flutter doctor to check setup
echo "🔍 Running Flutter doctor..."
flutter doctor

# Go back to workspace root
cd ..

# Install Python dependencies for data crawler
echo "🐍 Installing Python crawler dependencies..."
cd data/crawler
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Add Python virtual environment activation to .profile
if ! grep -q "source /mnt/persist/workspace/data/crawler/venv/bin/activate" $HOME/.profile; then
    echo 'source /mnt/persist/workspace/data/crawler/venv/bin/activate' >> $HOME/.profile
fi

# Go back to workspace root
cd ../..

echo "✅ Development environment setup complete!"
echo ""
echo "🔧 Available commands:"
echo "  Backend: cd backend && npm run start:dev"
echo "  Mobile: cd mobile && flutter run --flavor development"
echo "  Docker: npm run docker:dev"
echo "  Crawler: cd data/crawler && python src/main.py"
echo ""
echo "📋 Next steps:"
echo "  1. Start Docker services: npm run docker:dev"
echo "  2. Run database migrations: cd backend && npm run db:migrate"
echo "  3. Start backend: cd backend && npm run start:dev"
echo "  4. Start mobile app: cd mobile && flutter run --flavor development"