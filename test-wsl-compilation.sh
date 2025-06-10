#!/bin/bash
# Script de prueba rápida para compilación WSL nativa
# ================================================

echo "🐧 Probando compilación Linux en WSL nativo..."

# Verificar que estamos en WSL
if [ -z "$WSL_DISTRO_NAME" ]; then
    echo "❌ Este script debe ejecutarse desde WSL"
    exit 1
fi

# Verificar Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 no está instalado en WSL"
    exit 1
fi

echo "✅ WSL detectado: $WSL_DISTRO_NAME"
echo "✅ Python: $(python3 --version)"

# Crear entorno virtual si no existe
if [ ! -d "env/linux" ]; then
    echo "🔧 Creando entorno virtual Linux..."
    python3 -m venv env/linux
    source env/linux/bin/activate
    pip install --upgrade pip
    pip install bottle cherrypy python-dateutil wsgi-request-logger simplejson pyinstaller psycopg2-binary apsw
else
    echo "✅ Entorno virtual Linux ya existe"
    source env/linux/bin/activate
fi

# Verificar PyInstaller
if ! command -v pyinstaller &> /dev/null; then
    echo "❌ PyInstaller no está disponible"
    exit 1
fi

echo "✅ PyInstaller: $(pyinstaller --version)"

# Probar compilación rápida (solo test)
echo "🔧 Probando compilación de prueba..."
python create_release.py --test_release_process --stracker_only --linux_only 3.5.2

echo "🎉 Prueba WSL completada exitosamente!"
