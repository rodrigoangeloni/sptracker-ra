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
if [ ! -f /proc/version ] || ! grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then
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
PROJECT_DIR=$(pwd)
echo "📁 Detectando directorio del proyecto automáticamente..."
echo "✅ Directorio del proyecto: $PROJECT_DIR"

# Verificar que estamos en el directorio correcto
if [ ! -f "create_release.py" ]; then
    echo "❌ Error: No se encontró create_release.py en $PROJECT_DIR"
    echo "   Asegúrate de ejecutar este script desde el directorio raíz de sptracker"
    exit 1
fi

echo "✅ Scripts de compilación encontrados"

# Solicitar versión (aceptar como parámetro o desde stdin)
ARCH_MODE="linux64"  # Default to 64-bit

if [ $# -eq 1 ]; then
    # Check if the parameter is an architecture or version
    if [ "$1" = "linux32" ] || [ "$1" = "linux64" ]; then
        ARCH_MODE="$1"
        # Read version from stdin
        if [ ! -t 0 ]; then
            read VERSION
            echo "🔢 Versión recibida desde stdin: $VERSION"
        else
            read -p "🔢 Introduce la versión a compilar (ej: 3.5.2): " VERSION
        fi
    else
        VERSION="$1"
        echo "🔢 Versión recibida como parámetro: $VERSION"
    fi
elif [ $# -eq 2 ]; then
    VERSION="$1"
    ARCH_MODE="$2"
    echo "🔢 Versión: $VERSION, Arquitectura: $ARCH_MODE"
elif [ ! -t 0 ]; then
    # Si stdin no es un terminal (viene de pipe), leer desde stdin
    read VERSION
    echo "🔢 Versión recibida desde stdin: $VERSION"
else
    # Si es interactivo, solicitar versión
    read -p "🔢 Introduce la versión a compilar (ej: 3.5.2): " VERSION
fi

if [ -z "$VERSION" ]; then
    echo "❌ Error: Versión requerida"
    exit 1
fi

echo ""
echo "📋 RESUMEN DE COMPILACION LINUX"
echo "--------------------------------"
echo "🎯 Versión: $VERSION"
echo "🏗️  Arquitectura: $ARCH_MODE"
echo "🐧 Entorno: WSL nativo (sin Docker)"
echo "⏱️  Tiempo estimado: 2-3 minutos"
echo "📁 Método: Python + PyInstaller directo"
echo ""

# Solo solicitar confirmación si es interactivo
if [ -t 0 ]; then
    read -p "✅ ¿Continuar? (S/n): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then
        echo "❌ Compilación cancelada"
        exit 0
    fi
else
    echo "✅ Continuando automáticamente (modo no interactivo)"
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
if [ "$ARCH_MODE" = "linux32" ]; then
    echo "⏳ Compilando Linux x86 (32-bit)..."
    python create_release.py --stracker_only --linux32_only --test_release_process "$VERSION"
else
    echo "⏳ Compilando Linux x64 (64-bit)..."
    python create_release.py --stracker_only --linux_only --test_release_process "$VERSION"
fi

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
        if [ "$ARCH_MODE" = "linux32" ]; then
            ls -la versions/stracker_linux*32*.tgz 2>/dev/null || echo "   (No se encontraron archivos Linux 32-bit)"
        else
            ls -la versions/stracker_linux*.tgz 2>/dev/null || echo "   (No se encontraron archivos Linux 64-bit)"
        fi
    fi
    
    if [ -d "stracker/dist" ]; then
        if [ "$ARCH_MODE" = "linux32" ]; then
            ls -la stracker/dist/stracker_linux*32* 2>/dev/null || echo "   (No hay archivos Linux 32-bit en stracker/dist)"
        else
            ls -la stracker/dist/stracker_linux* 2>/dev/null || echo "   (No hay archivos Linux 64-bit en stracker/dist)"
        fi
    fi
    
    echo ""
    echo "🏁 Compilación Linux ($ARCH_MODE) completada usando WSL nativo"
    echo "⚙️  Método: Python + PyInstaller directo (sin Docker)"
    if [ "$ARCH_MODE" = "linux32" ]; then
        echo "📍 Archivos: versions/stracker_linux*32*.tgz"
    else
        echo "📍 Archivos: versions/stracker_linux*.tgz"
    fi
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
