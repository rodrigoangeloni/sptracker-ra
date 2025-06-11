#!/bin/bash
set -e

echo "=== SPTracker Linux 32-bit Build Script ==="
echo "Starting Linux 32-bit build..."

# Activate virtual environment
source env/linux32/bin/activate

# Build stracker for Linux 32-bit
echo "Building stracker for Linux 32-bit..."
cd stracker

# Clean previous builds
rm -rf dist build

# Build with PyInstaller
pyinstaller --name stracker_linux32 \
    --clean -y --onefile \
    --exclude-module http_templates \
    --hidden-import cherrypy.wsgiserver.wsgiserver3 \
    --hidden-import psycopg2 \
    --path .. \
    --path externals \
    stracker.py

# Generate default config
if [ -f "stracker-default-linux32.ini" ]; then
    rm stracker-default-linux32.ini
fi

# Run stracker to generate default config (will fail but create config)
./dist/stracker_linux32 --stracker_ini stracker-default-linux32.ini || true

# Create tarball
echo "Creating Linux 32-bit distribution tarball..."
tar -czf stracker_linux_x86_32.tgz -C dist stracker_linux32

echo "Linux 32-bit build completed successfully!"
echo "Generated: stracker/stracker_linux_x86_32.tgz"

# Copy results to host
cp stracker_linux_x86_32.tgz /app/versions/ || true

cd ..
