#!/bin/bash
# Script para compilación Linux nativa en WSL (sin Docker)
# ========================================================
#
# Este script compila sptracker para Linux x64/x86 usando WSL nativo
# con Python + PyInstaller directamente, sin Docker.
#
# Requisitos:
# - WSL (Debian/Ubuntu) configurado
# - Python 3.11+ instalado en WSL
# - Dependencias del proyecto instaladas

set -e

echo ""
echo "============================================================="
echo "🐧 COMPILACION LINUX NATIVA EN WSL (SIN DOCKER) 🐧"
echo "============================================================="
echo ""

# Verificar que estamos en WSL
if [ ! -f /proc/version ] || ! grep -q Microsoft /proc/version 2>/dev/null; then
    echo "❌ Error: Este script debe ejecutarse dentro de WSL"
    echo "   Usa: wsl -d Debian -- bash build_linux_wsl_native.sh"
    exit 1
fi

echo "✅ Ejecutándose en WSL"

# Verificar Python
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Error: Python3 no está instalado"
    echo "   Instala con: sudo apt update && sudo apt install python3 python3-pip python3-venv"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo "✅ Python disponible: $PYTHON_VERSION"

# Verificar directorio del proyecto
PROJECT_DIR="/mnt/e/vscode-workspace/sptracker-ra"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Directorio del proyecto no encontrado: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"
echo "✅ Directorio del proyecto: $PROJECT_DIR"

# Verificar create_release.py
if [ ! -f "create_release.py" ]; then
    echo "❌ Error: create_release.py no encontrado"
    exit 1
fi

echo "✅ Scripts de compilación encontrados"

# Solicitar versión
read -p "🔢 Introduce la versión a compilar (ej: 3.5.2): " VERSION
if [ -z "$VERSION" ]; then
    echo "❌ Error: Versión requerida"
    exit 1
fi

echo ""
echo "📋 RESUMEN DE COMPILACION LINUX"
echo "--------------------------------"
echo "🎯 Versión: $VERSION"
echo "🐧 Entorno: WSL nativo (sin Docker)"
echo "🏗️  Arquitecturas: Linux x64 + x86"
echo "⏱️  Tiempo estimado: 2-3 minutos"
echo "📁 Método: Python + PyInstaller directo"
echo ""

read -p "✅ ¿Continuar? (S/n): " CONFIRM
if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then
    echo "❌ Compilación cancelada"
    exit 0
fi

echo ""
echo "🚀 INICIANDO COMPILACION LINUX..."
echo "================================="

# Verificar/crear entorno virtual Linux
LINUX_ENV="env/linux"
if [ ! -d "$LINUX_ENV" ]; then
    echo "⚙️  Creando entorno virtual Linux..."
    python3 -m venv "$LINUX_ENV"
    if [ $? -ne 0 ]; then
        echo "❌ Error creando entorno virtual"
        exit 1
    fi
fi

echo "✅ Entorno virtual Linux disponible"

# Activar entorno virtual
source "$LINUX_ENV/bin/activate"
echo "✅ Entorno virtual activado"

# Actualizar pip
echo "⚙️  Actualizando pip y herramientas..."
pip install --upgrade pip setuptools wheel

# Instalar dependencias si no están
echo "⚙️  Verificando dependencias..."
pip install \
    bottle \
    cherrypy \
    python-dateutil \
    simplejson \
    apsw \
    psycopg2-binary \
    wsgi-request-logger \
    pyinstaller

echo "✅ Dependencias verificadas"

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
rm -rf stracker/dist/stracker_linux* 2>/dev/null || true
rm -rf versions/stracker_linux* 2>/dev/null || true

# Ejecutar compilación Linux
echo ""
echo "⏳ Compilando Linux x64..."
python create_release.py --linux_only --test_release_process "$VERSION"

COMPILE_RESULT=$?

if [ $COMPILE_RESULT -eq 0 ]; then
    echo ""
    echo "============================================================="
    echo "✅ COMPILACION LINUX COMPLETADA"
    echo "============================================================="
    echo ""
    
    # Mostrar archivos generados
    echo "📦 Archivos generados:"
    if [ -d "versions" ]; then
        ls -la versions/stracker_linux*.tgz 2>/dev/null || echo "   (No se encontraron archivos Linux)"
    fi
    
    if [ -d "stracker/dist" ]; then
        ls -la stracker/dist/stracker_linux* 2>/dev/null || echo "   (No hay archivos en stracker/dist)"
    fi
    
    echo ""
    echo "🏁 Compilación Linux completada usando WSL nativo"
    echo "⚙️  Método: Python + PyInstaller directo (sin Docker)"
    echo "📍 Archivos: versions/stracker_linux*.tgz"
    echo "⚡ Ventaja: Compilación nativa más rápida que Docker"
    echo ""
else
    echo ""
    echo "❌ ERROR EN COMPILACION LINUX"
    echo "Código de salida: $COMPILE_RESULT"
    echo ""
    echo "🔍 Verifica:"
    echo "   - Dependencias instaladas correctamente"
    echo "   - Entorno virtual activado"
    echo "   - Permisos del sistema"
    echo ""
    exit $COMPILE_RESULT
fi

# Desactivar entorno virtual
deactivate

echo "✅ Script completado"
