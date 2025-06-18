#!/bin/bash
# ARM64 build script for SPTracker using Docker

set -e  # Exit on any error

echo "=== SPTracker ARM64 Build Script ==="
echo "Starting ARM64 build in Docker..."

# Activate virtual environment
source env/arm64/bin/activate

# Build stracker for ARM64
echo "Building stracker for ARM64..."
cd stracker

# Clean previous builds
rm -rf dist build

# Build with PyInstaller
pyinstaller --name stracker \
    --clean -y --onefile \
    --exclude-module http_templates \
    --hidden-import cherrypy.wsgiserver.wsgiserver3 \
    --hidden-import psycopg2 \
    --path .. \
    --path externals \
    stracker.py

# Generate default config
if [ -f "stracker-default.ini" ]; then
    rm stracker-default.ini
fi

# Run stracker to generate default config (will fail but create config)
echo "Generating default configuration..."
./dist/stracker --stracker_ini stracker-default.ini > /dev/null 2>&1 || true

# Create tarball
echo "Creating ARM64 distribution tarball..."
tar -czf stracker_linux_arm64.tgz -C dist stracker

echo "ARM64 build completed successfully!"
echo "Generated: stracker/stracker_linux_arm64.tgz"

# Copy results to host
cp stracker_linux_arm64.tgz /app/versions/

cd ..
