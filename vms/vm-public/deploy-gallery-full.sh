#!/usr/bin/env bash
set -euo pipefail

# Full deployment script - copies entire dist/ folder including processed photos
# Usage: ./deploy-gallery-full.sh [VM_IP_OR_HOSTNAME]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GALLERY_DIR="${SCRIPT_DIR}/../../../photo-gallery"
VM_HOST="${1:-vm-public}"
REMOTE_DIR="/var/www/cmg.akrivka.com/fotky"

echo "Photo Gallery Full Deployment"
echo "=============================="
echo "Gallery source: ${GALLERY_DIR}/dist"
echo "Target host: ${VM_HOST}"
echo "Target directory: ${REMOTE_DIR}"
echo ""

# Create remote directory if it doesn't exist
echo "Creating remote directory..."
ssh "${VM_HOST}" "sudo mkdir -p ${REMOTE_DIR} && sudo chown caddy:caddy ${REMOTE_DIR}"

# Copy the entire dist directory content to the VM
echo "Copying all gallery files (including photos)..."
echo "This may take a while for large photo collections..."
rsync -avz --progress --delete \
    --exclude '.cache.json' \
    "${GALLERY_DIR}/dist/" \
    "${VM_HOST}:${REMOTE_DIR}/"

# Fix permissions on the VM
echo "Setting permissions..."
ssh "${VM_HOST}" "sudo chown -R caddy:caddy ${REMOTE_DIR}"

echo ""
echo "Full deployment complete!"
echo "Gallery is now available at: https://cmg.akrivka.com/fotky"