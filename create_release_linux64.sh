#!/bin/bash
# Script de compilación Linux 64-bit para sptracker
# =================================================

set -e

# Get version parameter
VERSION=${1:-"dev"}
echo "=== SPTracker Linux 64-bit Build Script ==="
echo "Starting Linux 64-bit build..."
echo "Version: $VERSION"

# Mostrar información del sistema
echo "=== INFORMACIÓN DEL SISTEMA ==="
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME)"
echo "GLIBC: $(ldd --version | head -1)"
echo "Python: $(python --version)"
echo "PyInstaller: $(env/linux64/bin/pyinstaller --version)"

# Activate virtual environment
source env/linux64/bin/activate

# Navigate to stracker directory
cd stracker

# Clean any previous build artifacts
echo "=== Limpiando artefactos previos ==="
rm -rf dist build
rm -f stracker.spec

# Build with PyInstaller
echo "=== Compilando stracker Linux 64-bit ==="
../env/linux64/bin/pyinstaller --name stracker \
    --clean -y --onedir \
    --exclude-module http_templates \
    --hidden-import cherrypy.wsgiserver.wsgiserver3 \
    --hidden-import psycopg2 \
    --path .. \
    --path externals \
    stracker.py

# Generate default config (optional)
echo "=== Generando configuración por defecto ==="
if [ -f "stracker-default.ini" ]; then
    rm stracker-default.ini
fi

# Try to generate config, but don't fail if it doesn't work (expected in Docker without AC server)
echo "⚠️  Attempting to generate default config (may fail without AC server config - this is normal)..."
set +e  # Temporarily disable exit on error
timeout 10 dist/stracker/stracker --stracker_ini stracker-default.ini >/dev/null 2>&1
config_result=$?
set -e  # Re-enable exit on error

if [ $config_result -eq 0 ]; then
    echo "✅ Config generation successful"
elif [ $config_result -eq 124 ]; then
    echo "⚠️  Config generation timed out (expected in Docker environment)"
else
    echo "⚠️  Config generation failed (expected in Docker environment without AC server)"
fi

# Create a basic default config if none was generated
if [ ! -f "stracker-default.ini" ]; then
    echo "📝 Creating basic stracker-default.ini template..."
    cat > stracker-default.ini << 'EOF'
# stracker default configuration
# Generated during build process
# This is a template - modify according to your AC server setup

[STRACKER_CONFIG]
ac_server_cfg_ini = 
listening_port = 50041
server_name = Default Server
log_file = stracker.log
tee_to_stdout = False
log_level = info

[HTTP_CONFIG]
enabled = True
listen_port = 50042
listen_addr = 

[DATABASE]
database_type = sqlite3
database_file = stracker.db
EOF
    echo "✅ Basic default config created"
fi

echo "✅ Config generation step completed"

# Check if build was successful (onedir mode creates a directory)
if [ ! -d "dist/stracker" ]; then
    echo "❌ Error: Build directory not found at dist/stracker"
    exit 1
fi

if [ ! -f "dist/stracker/stracker" ]; then
    echo "❌ Error: Binary not found at dist/stracker/stracker"
    exit 1
fi

echo "✅ Build successful: stracker_linux_x86 (onedir mode)"

# Show binary information
echo "=== INFORMACIÓN DEL BINARIO ==="
file dist/stracker/stracker
ldd dist/stracker/stracker | head -5

# Create distribution package
echo "=== Creando archivo de distribución ==="

# Create target dist directory if it doesn't exist
mkdir -p ../dist

# The PyInstaller should have created a directory with all dependencies
# Check if we have a directory build (onedir mode) or just a file (onefile mode)
if [ -d "dist/stracker" ]; then
    # onedir mode - copy and rename the directory structure
    echo "✅ Found onedir build - copying complete directory structure"
    cp -r dist/stracker ../dist/stracker_linux_x86
else
    # onefile mode - need to create directory structure manually
    echo "⚠️  Found onefile build - creating directory structure"
    mkdir -p ../dist/stracker_linux_x86
    cp dist/stracker ../dist/stracker_linux_x86/stracker
fi

# Add default config if it exists
if [ -f "stracker-default.ini" ]; then
    cp stracker-default.ini ../dist/stracker_linux_x86/
    echo "✅ Copied stracker-default.ini"
fi

# Resolve symbolic links to avoid issues when extracting on Windows
echo "=== Resolviendo enlaces simbólicos para compatibilidad con Windows ==="
cd ../dist
if [ -d "stracker_linux_x86" ]; then
    # Create a temporary directory to resolve symlinks
    mkdir -p stracker_linux_x86_resolved
    
    # Copy the directory structure, following symlinks (dereference them)
    cp -rL stracker_linux_x86/* stracker_linux_x86_resolved/
    
    # Replace the original directory with the resolved one
    rm -rf stracker_linux_x86
    mv stracker_linux_x86_resolved stracker_linux_x86
    
    echo "✅ Enlaces simbólicos resueltos"
fi

# Create tarball
tar -czf stracker_linux_x86.tgz stracker_linux_x86/
echo "✅ Created: stracker_linux_x86.tgz"

# Clean up temporary directory
rm -rf stracker_linux_x86

# Copy to versions directory
versions_dir="../versions"
if [ ! -d "$versions_dir" ]; then
    mkdir -p "$versions_dir"
fi

# Copy with versioned filename
if [ -n "$VERSION" ]; then
    cp stracker_linux_x86.tgz "$versions_dir/stracker-v${VERSION}-linux64.tgz"
    echo "✅ Created: $versions_dir/stracker-v${VERSION}-linux64.tgz"
    ls -la "$versions_dir/stracker-v${VERSION}-linux64.tgz"
    
    # Also copy to workspace/versions if it exists (Docker integration)
    if [ -d "/workspace/versions" ]; then
        cp stracker_linux_x86.tgz "/workspace/versions/stracker-v${VERSION}-linux64.tgz"
        echo "✅ Copied to Docker workspace: /workspace/versions/stracker-v${VERSION}-linux64.tgz"
    fi
else
    cp stracker_linux_x86.tgz "$versions_dir/"
    echo "✅ Copied to versions directory"
    
    # Also copy to workspace/versions if it exists (Docker integration)
    if [ -d "/workspace/versions" ]; then
        cp stracker_linux_x86.tgz "/workspace/versions/"
        echo "✅ Copied to Docker workspace: /workspace/versions/"
    fi
fi

echo "=== Build completed successfully ==="
