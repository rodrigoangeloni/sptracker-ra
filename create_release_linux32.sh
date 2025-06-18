#!/bin/bash
set -e

# Get version parameter
VERSION=${1:-$(python3 -c "import sys; sys.path.append('..'); from version_config import BASE_VERSION; print(BASE_VERSION)")}
echo "=== SPTracker Linux 32-bit Build Script ==="
echo "Starting Linux 32-bit build..."
echo "Building version: $VERSION"

# Activate virtual environment
source env/linux32/bin/activate

# Build stracker for Linux 32-bit
echo "Building stracker for Linux 32-bit..."
cd stracker

# Clean previous builds
rm -rf dist build

# Build with PyInstaller (usando --onedir como Linux 64-bit)
pyinstaller --name stracker \
    --clean -y --onedir \
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

# Try to generate config, but don't fail if it doesn't work
echo "⚠️  Attempting to generate default config (may fail without AC server config - this is normal)..."
set +e  # Temporarily disable exit on error
timeout 10 dist/stracker/stracker --stracker_ini stracker-default.ini >/dev/null 2>&1
config_result=$?
set -e  # Re-enable exit on error

# Create a basic default config if none was generated
if [ ! -f "stracker-default.ini" ]; then
    echo "📝 Creating basic stracker-default.ini template..."
    cat > stracker-default.ini << 'EOF'
# stracker default configuration for Linux 32-bit
# Generated during build process

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

# Check if build was successful
if [ ! -d "dist/stracker" ]; then
    echo "❌ Error: Build directory not found at dist/stracker"
    exit 1
fi

if [ ! -f "dist/stracker/stracker" ]; then
    echo "❌ Error: Binary not found at dist/stracker/stracker"
    exit 1
fi

echo "✅ Build successful: stracker_linux_x86 (onedir mode)"

# Create distribution package
echo "=== Creando archivo de distribución ==="

# Create target dist directory if it doesn't exist
mkdir -p ../dist

# Copy and rename the directory structure
echo "✅ Found onedir build - copying complete directory structure"
cp -r dist/stracker ../dist/stracker_linux_x86

# Add default config
if [ -f "stracker-default.ini" ]; then
    cp stracker-default.ini ../dist/stracker_linux_x86/
    echo "✅ Copied stracker-default.ini"
fi

# Resolve symbolic links for Windows compatibility
echo "=== Resolviendo enlaces simbólicos para compatibilidad con Windows ==="
cd ../dist
if [ -d "stracker_linux_x86" ]; then
    mkdir -p stracker_linux_x86_resolved
    cp -rL stracker_linux_x86/* stracker_linux_x86_resolved/
    rm -rf stracker_linux_x86
    mv stracker_linux_x86_resolved stracker_linux_x86
    echo "✅ Enlaces simbólicos resueltos"
fi

# Create tarball with standard nomenclature
FILENAME="stracker-v${VERSION}-linux32.tgz"
echo "Creating Linux 32-bit distribution tarball: $FILENAME"
tar -czf "$FILENAME" stracker_linux_x86/
echo "✅ Created: $FILENAME"

# Clean up temporary directory
rm -rf stracker_linux_x86

echo "Linux 32-bit build completed successfully!"
echo "Generated: stracker/$FILENAME"

# Copy results to host (for Docker)
cp "$FILENAME" /app/versions/ || true

cd ..
