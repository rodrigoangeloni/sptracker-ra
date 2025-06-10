#!/bin/bash
# Linux build script for SPTracker using WSL

set -e  # Exit on any error

echo "=== SPTracker Linux Build Script ==="
echo "Starting Linux build in WSL..."

# Install dependencies if needed
if ! command -v python3 &> /dev/null; then
    echo "Installing Python3..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
fi

# Create virtual environment for Linux
if [ ! -d "env/linux" ]; then
    echo "Creating Linux virtual environment..."
    python3 -m venv env/linux
fi

# Activate virtual environment
. env/linux/bin/activate

# Install/upgrade packages
echo "Installing Python packages..."
pip install --upgrade pip
pip install --upgrade bottle
pip install --upgrade cherrypy
pip install --upgrade python-dateutil
pip install --upgrade wsgi-request-logger
pip install --upgrade simplejson
pip install --upgrade pyinstaller

# Install psycopg2 (PostgreSQL adapter)
pip install --upgrade psycopg2-binary

# Install APSW (SQLite wrapper)
pip install --upgrade apsw

# Build stracker for Linux
echo "Building stracker for Linux..."
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
echo "Creating Linux distribution tarball..."
tar -czf stracker_linux_x86.tgz -C dist stracker

echo "Linux build completed successfully!"
echo "Generated: stracker/stracker_linux_x86.tgz"

cd ..
