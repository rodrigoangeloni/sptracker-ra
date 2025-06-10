#!/bin/bash
# ARM32 build script for SPTracker using Docker

set -e  # Exit on any error

echo "=== SPTracker ARM32 Build Script ==="
echo "Starting ARM32 build in Docker..."

# Verificar que estamos en el directorio correcto
echo "Current directory: $(pwd)"
echo "Python version: $(python3 --version)"
echo "Architecture: $(uname -m)"

# NO activar env local - Docker ya tiene el entorno configurado
# El entorno virtual se maneja en el Dockerfile

# Build stracker for ARM32
echo "Building stracker for ARM32..."
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
./dist/stracker --stracker_ini stracker-default.ini || true

# Create tarball
echo "Creating ARM32 distribution tarball..."
tar -czf stracker_linux_arm32.tgz -C dist stracker

echo "ARM32 build completed successfully!"
echo "Generated: stracker/stracker_linux_arm32.tgz"

# Copy results to host
echo "Copying stracker_linux_arm32.tgz to /app/versions/"
cp stracker_linux_arm32.tgz /app/versions/
echo "Files in /app/versions/:"
ls -la /app/versions/

cd ..
