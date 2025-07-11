#!/bin/bash

# CareCircle GCP Setup - Minimal production setup for Vietnam market
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}$1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Get project ID
if [ -z "$PROJECT_ID" ]; then
    PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
    if [ -z "$PROJECT_ID" ]; then
        echo "❌ No project ID set. Run: gcloud config set project YOUR_PROJECT_ID"
        exit 1
    fi
fi
log_info "Using project: $PROJECT_ID"

# Setup function
setup_gcp() {
    log_info "Setting up GCP resources..."

    # Enable APIs
    gcloud services enable run.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com --quiet

    # Create service account
    if ! gcloud iam service-accounts describe github-actions@$PROJECT_ID.iam.gserviceaccount.com &>/dev/null; then
        gcloud iam service-accounts create github-actions --display-name="GitHub Actions"
    fi

    # Grant permissions
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
        --role="roles/run.admin" --quiet

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
        --role="roles/secretmanager.secretAccessor" --quiet

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
        --role="roles/artifactregistry.writer" --quiet

    log_success "GCP setup completed"
}

# Create secrets
create_secrets() {
    log_info "Creating secrets..."

    for secret in database-url vector-db-url openai-api-key firebase-credentials; do
        if ! gcloud secrets describe $secret &>/dev/null; then
            echo "placeholder-update-me" | gcloud secrets create $secret --data-file=-
        fi
    done

    log_warning "Update all secrets with actual values!"
}

# Generate GitHub key
generate_github_key() {
    log_info "Generating GitHub Actions key..."

    gcloud iam service-accounts keys create github-actions-key.json \
        --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com

    log_success "Key saved to: github-actions-key.json"
}

# Main execution
echo "🚀 CareCircle GCP Setup"
echo "======================"

setup_gcp
create_secrets
generate_github_key

echo ""
log_success "Setup completed!"
echo ""
echo "📋 Next Steps:"
echo "1. Add GitHub Secrets:"
echo "   - GCP_PROJECT_ID: $PROJECT_ID"
echo "   - GCP_SA_KEY: (content of github-actions-key.json)"
echo ""
echo "2. Update secrets:"
echo "   echo 'your-db-url' | gcloud secrets versions add database-url --data-file=-"
echo "   echo 'your-vector-db-url' | gcloud secrets versions add vector-db-url --data-file=-"
echo "   echo 'your-openai-key' | gcloud secrets versions add openai-api-key --data-file=-"
echo "   gcloud secrets versions add firebase-credentials --data-file=firebase-key.json"
echo ""
echo "3. Deploy: git push origin main"
