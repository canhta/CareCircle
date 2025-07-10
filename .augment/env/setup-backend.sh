#!/bin/bash

# CareCircle Backend Development Environment Setup Script
set -e

echo "🚀 Setting up CareCircle backend development environment..."

# Update system packages
sudo apt-get update

# Install Node.js 22+ and npm
echo "📦 Installing Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Node.js installation
node --version
npm --version

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

echo "✅ Backend development environment setup complete!"
echo ""
echo "🔧 Available commands:"
echo "  Backend: cd backend && npm run start:dev"
echo "  Docker: npm run docker:dev"
echo ""
echo "📋 Next steps:"
echo "  1. Start Docker services: npm run docker:dev"
echo "  2. Run database migrations: cd backend && npm run db:migrate"
echo "  3. Start backend: cd backend && npm run start:dev"
echo ""
echo "💡 Note: You may need to log out and back in for Docker group changes to take effect."
