#!/bin/bash
# ==========================================================
# Configurador del Entorno WSL para sptracker
# ==========================================================
#
# Este script configura el entorno de desarrollo en WSL para
# compilar sptracker nativamente en Linux.
#
# PREREQUISITOS:
# - WSL2 configurado y ejecutándose
# - Docker Desktop (solo para ARM32/ARM64)
# - Acceso al directorio del proyecto desde WSL
#
# COMPILACIÓN:
# - WSL: Compilación nativa Linux x64/x86 
# - Docker: Solo para ARM32/ARM64 (emulación)
#
# USO:
#   chmod +x setup-dev-environment.sh
#   ./setup-dev-environment.sh
#

set -e  # Exit on any error

# ==========================================================
# CONFIGURACIÓN INICIAL
# ==========================================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuración de versiones
PYTHON_MIN_VERSION="3.8"
DOCKER_MIN_VERSION="20.10"
NODE_MIN_VERSION="16.0"

# ==========================================================
# FUNCIONES DE UTILIDAD
# ==========================================================

print_header() {
    echo -e "\n${PURPLE}========================================${NC}"
    echo -e "${PURPLE} $1${NC}"
    echo -e "${PURPLE}========================================${NC}"
}

print_step() {
    echo -e "\n${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

version_gte() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

check_python_version() {
    if check_command python3; then
        local version=$(python3 --version 2>&1 | cut -d' ' -f2)
        if version_gte "$version" "$PYTHON_MIN_VERSION"; then
            return 0
        fi
    fi
    return 1
}

check_docker_access() {
    if docker info >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# ==========================================================
# FUNCIONES DE INSTALACIÓN
# ==========================================================

update_system() {
    print_step "Actualizando sistema Ubuntu..."
    
    sudo apt update
    sudo apt upgrade -y
    
    print_success "Sistema actualizado"
}

install_essential_packages() {
    print_step "Instalando paquetes esenciales..."
    
    local packages=(
        "curl"
        "wget" 
        "git"
        "build-essential"
        "software-properties-common"
        "apt-transport-https"
        "ca-certificates"
        "gnupg"
        "lsb-release"
        "zip"
        "unzip"
        "tree"
        "htop"
        "nano"
        "vim"
    )
    
    for package in "${packages[@]}"; do
        echo "  Instalando $package..."
        sudo apt install -y "$package"
    done
    
    print_success "Paquetes esenciales instalados"
}

install_python() {
    print_step "Configurando Python..."
    
    if check_python_version; then
        local version=$(python3 --version 2>&1 | cut -d' ' -f2)
        print_success "Python ya está instalado: $version"
    else
        echo "  Instalando Python 3.11..."
        
        # Agregar PPA para Python 3.11 si es necesario
        sudo add-apt-repository ppa:deadsnakes/ppa -y
        sudo apt update
        
        # Instalar Python y herramientas
        sudo apt install -y python3.11 python3.11-dev python3.11-venv python3-pip
        
        # Crear enlace simbólico si no existe
        if ! check_command python3; then
            sudo ln -sf /usr/bin/python3.11 /usr/bin/python3
        fi
        
        print_success "Python 3.11 instalado"
    fi
    
    # Instalar pip packages globales
    echo "  Instalando paquetes Python globales..."
    local pip_packages=(
        "virtualenv"
        "pip"
        "setuptools"
        "wheel" 
        "build"
        "twine"
    )
    
    for package in "${pip_packages[@]}"; do
        python3 -m pip install --user --upgrade "$package" 2>/dev/null || true
    done
    
    print_success "Paquetes Python configurados"
}

configure_docker() {
    print_step "Configurando Docker en WSL..."
    
    if check_docker_access; then
        print_success "Docker ya está configurado y accesible"
        local docker_version=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
        echo "  Versión: $docker_version"
        
        # Verificar Docker Compose
        if check_command docker-compose; then
            local compose_version=$(docker-compose --version | cut -d' ' -f3 | cut -d',' -f1)
            echo "  Docker Compose: $compose_version"
        fi
    else
        print_warning "Docker no está accesible desde WSL"
        echo "  Posibles soluciones:"
        echo "    1. Asegúrate de que Docker Desktop esté ejecutándose en Windows"
        echo "    2. Habilita la integración WSL en Docker Desktop settings"
        echo "    3. Agrega tu usuario al grupo docker:"
        echo "       sudo usermod -aG docker \$USER"
        echo "       newgrp docker"
        
        # Intentar agregar usuario al grupo docker
        if getent group docker >/dev/null; then
            echo "  Agregando usuario al grupo docker..."
            sudo usermod -aG docker "$USER"
            print_warning "Cierra y abre WSL nuevamente para aplicar cambios de grupo"
        fi
    fi
}

setup_docker_buildx() {
    print_step "Configurando Docker Buildx para compilación multiplataforma..."
    
    if check_docker_access; then
        # Crear builder para multiplataforma
        echo "  Configurando builder multiplataforma..."
        docker buildx create --name multiplatform --driver docker-container --use 2>/dev/null || true
        docker buildx inspect --bootstrap multiplatform 2>/dev/null || true
        
        # Habilitar emulación QEMU
        echo "  Habilitando emulación QEMU..."
        docker run --rm --privileged multiarch/qemu-user-static --reset -p yes 2>/dev/null || true
        
        # Verificar plataformas disponibles
        echo "  Plataformas disponibles:"
        docker buildx ls | grep multiplatform || true
        
        print_success "Docker Buildx configurado"
    else
        print_warning "Docker no accesible, saltando configuración de Buildx"
    fi
}

setup_project_environment() {
    print_step "Configurando entorno del proyecto..."
    
    local project_root=$(pwd)
    echo "  Directorio del proyecto: $project_root"
    
    # Verificar que estamos en el directorio correcto
    if [[ ! -f "create_release.py" ]]; then
        print_error "No se encontró create_release.py. Ejecuta este script desde el directorio raíz del proyecto."
        exit 1
    fi
    
    # Crear directorios necesarios
    local directories=("env" "temp" "versions" ".cache" "logs")
    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            print_success "  Directorio creado: $dir"
        fi
    done
    
    # Crear entorno virtual Linux
    if [[ ! -d "env/linux" ]]; then
        echo "  Creando entorno virtual Linux..."
        python3 -m venv env/linux
        print_success "  Entorno virtual Linux creado"
    fi
    
    # Activar entorno virtual e instalar dependencias
    echo "  Instalando dependencias en entorno virtual..."
    source env/linux/bin/activate
    
    local python_packages=(
        "bottle"
        "cherrypy"
        "python-dateutil" 
        "wsgi-request-logger"
        "simplejson"
        "pyinstaller"
        "psycopg2-binary"
        "apsw"
    )
    
    for package in "${python_packages[@]}"; do
        pip install --upgrade "$package" 2>/dev/null || print_warning "  Error instalando $package"
    done
    
    deactivate
    print_success "Entorno virtual configurado"
}

create_docker_images() {
    print_step "Preparando imágenes Docker para compilación..."
    
    if check_docker_access; then
        # Verificar que los Dockerfiles existen
        local dockerfiles=("Dockerfile.arm32" "Dockerfile.arm64")
        for dockerfile in "${dockerfiles[@]}"; do
            if [[ -f "$dockerfile" ]]; then
                print_success "  Encontrado: $dockerfile"
            else
                print_warning "  Faltante: $dockerfile"
            fi
        done
        
        # Pre-pull imágenes base para acelerar builds futuros
        echo "  Descargando imágenes base..."
        docker pull arm32v7/python:3.11-slim 2>/dev/null || print_warning "  No se pudo descargar imagen ARM32"
        docker pull arm64v8/python:3.11-slim 2>/dev/null || print_warning "  No se pudo descargar imagen ARM64"
        docker pull python:3.11-slim 2>/dev/null || print_warning "  No se pudo descargar imagen x86_64"
        
        print_success "Imágenes Docker preparadas"
    else
        print_warning "Docker no accesible, saltando preparación de imágenes"
    fi
}

configure_git() {
    print_step "Configurando Git..."
    
    # Verificar configuración existente
    local git_name=$(git config --global user.name 2>/dev/null || echo "")
    local git_email=$(git config --global user.email 2>/dev/null || echo "")
    
    if [[ -z "$git_name" ]]; then
        echo "  Configurando nombre de usuario Git..."
        echo -n "    Introduce tu nombre: "
        read -r git_name
        git config --global user.name "$git_name"
    fi
    
    if [[ -z "$git_email" ]]; then
        echo "  Configurando email Git..."
        echo -n "    Introduce tu email: "
        read -r git_email  
        git config --global user.email "$git_email"
    fi
    
    # Configuración adicional recomendada
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf input
    
    print_success "Git configurado: $git_name <$git_email>"
}

create_development_scripts() {
    print_step "Creando scripts de desarrollo WSL..."
    
    # Script para compilación Linux rápida
    cat > dev-build-linux.sh << 'EOF'
#!/bin/bash
# Script de compilación Linux rápida para desarrollo

set -e

echo "🏁 Compilación Linux - Modo Desarrollo"
echo "======================================"

# Activar entorno virtual
source env/linux/bin/activate

# Compilación rápida solo stracker para Linux
python create_release.py --test_release_process --stracker_only --linux_only 3.5.2-dev

echo ""
echo "✅ Compilación completada"
echo "📁 Archivo generado: stracker/stracker_linux_x86.tgz"
EOF

    chmod +x dev-build-linux.sh
    
    # Script para testing Docker
    cat > dev-test-docker.sh << 'EOF'
#!/bin/bash
# Script de testing Docker para ARM

set -e

echo "🔧 Testing Docker - Compilación ARM"
echo "=================================="

# Verificar Docker
echo "Verificando Docker..."
docker info

# Test ARM64
echo ""
echo "Testing ARM64..."
python create_release.py --test_release_process --stracker_only --arm64_only 3.5.2-dev

echo ""
echo "✅ Testing completado"
EOF

    chmod +x dev-test-docker.sh
    
    # Script de limpieza
    cat > dev-clean.sh << 'EOF'
#!/bin/bash
# Script de limpieza del entorno de desarrollo

echo "🧹 Limpiando entorno de desarrollo..."

# Limpiar builds anteriores
rm -rf build/ dist/ temp/ .cache/
rm -rf stracker/build/ stracker/dist/
rm -f nsis_temp_files* ptracker-server-dist.py ptracker.nsh

# Limpiar entornos virtuales (opcional)
read -p "¿Limpiar entornos virtuales? (s/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    rm -rf env/
    echo "  Entornos virtuales eliminados"
fi

echo "✅ Limpieza completada"
EOF

    chmod +x dev-clean.sh
    
    print_success "Scripts de desarrollo creados"
}

# ==========================================================
# FUNCIÓN DE VALIDACIÓN
# ==========================================================

validate_environment() {
    print_header "VALIDANDO ENTORNO WSL"
    
    local issues=()
    
    # Verificar WSL
    echo "🐧 Verificando WSL..."
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
        print_success "WSL activo: $WSL_DISTRO_NAME"
    else
        issues+=("No parece estar ejecutándose en WSL")
    fi
    
    # Verificar Python
    echo "🐍 Verificando Python..."
    if check_python_version; then
        local version=$(python3 --version 2>&1 | cut -d' ' -f2)
        print_success "Python: $version"
    else
        issues+=("Python 3.8+ no disponible")
    fi
    
    # Verificar Docker
    echo "🐳 Verificando Docker..."
    if check_docker_access; then
        local docker_version=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
        print_success "Docker: $docker_version"
        
        # Verificar plataformas Docker
        echo "  Plataformas soportadas:"
        docker buildx ls | grep -E "(linux/amd64|linux/arm64|linux/arm/v7)" || true
    else
        issues+=("Docker no accesible desde WSL")
    fi
    
    # Verificar estructura del proyecto
    echo "📁 Verificando estructura del proyecto..."
    local required_files=("create_release.py" "interactive_builder.py" "Dockerfile.arm64")
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            print_success "  $file"
        else
            issues+=("Archivo faltante: $file")
        fi
    done
    
    # Verificar entorno virtual
    echo "🔧 Verificando entorno virtual..."
    if [[ -d "env/linux" ]]; then
        print_success "  env/linux existe"
        if [[ -f "env/linux/bin/python" ]]; then
            print_success "  Python virtual disponible"
        else
            issues+=("Entorno virtual Linux dañado")
        fi
    else
        issues+=("Entorno virtual Linux no existe")
    fi
    
    # Resultado final
    echo ""
    if [[ ${#issues[@]} -eq 0 ]]; then
        print_header "✅ ENTORNO WSL VÁLIDO - LISTO PARA DESARROLLO"
        echo -e "${GREEN}Puedes ejecutar:${NC}"
        echo -e "${CYAN}  ./dev-build-linux.sh${NC}      # Compilación Linux rápida"
        echo -e "${CYAN}  ./dev-test-docker.sh${NC}      # Testing Docker ARM"  
        echo -e "${CYAN}  python interactive_builder.py${NC} # Compilación interactiva"
    else
        print_header "❌ PROBLEMAS ENCONTRADOS"
        for issue in "${issues[@]}"; do
            print_error "$issue"
        done
        echo ""
        print_warning "Ejecuta el script de setup nuevamente para resolver problemas."
    fi
}

# ==========================================================
# FUNCIÓN PRINCIPAL
# ==========================================================

main() {
    print_header "CONFIGURADOR DEL ENTORNO WSL - SPTRACKER"
    echo -e "${CYAN}Configurando WSL para desarrollo multiplataforma${NC}"
    
    # Verificar que estamos en WSL
    if [[ -z "$WSL_DISTRO_NAME" ]]; then
        print_warning "No parece que estés ejecutando este script en WSL"
        echo "Este script está diseñado para configurar el entorno WSL específicamente."
        echo ""
        read -p "¿Continuar de todas formas? (s/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            echo "Script cancelado"
            exit 0
        fi
    fi
    
    # Verificar directorio del proyecto
    if [[ ! -f "create_release.py" ]]; then
        print_error "Este script debe ejecutarse desde el directorio raíz del proyecto sptracker"
        echo "Navega al directorio que contiene create_release.py y ejecuta el script nuevamente."
        exit 1
    fi
    
    echo ""
    echo -e "${CYAN}Este script configurará:${NC}"
    echo "  • Python 3.11 y entorno virtual"
    echo "  • Docker con soporte multiplataforma" 
    echo "  • Herramientas de desarrollo"
    echo "  • Scripts de compilación"
    echo ""
    
    read -p "¿Continuar con la configuración? (S/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_warning "Configuración cancelada"
        exit 0
    fi
    
    # Ejecutar configuración
    update_system
    install_essential_packages  
    install_python
    configure_docker
    setup_docker_buildx
    setup_project_environment
    configure_git
    create_development_scripts
    
    print_header "🎉 CONFIGURACIÓN WSL COMPLETADA"
    print_success "El entorno WSL está listo para desarrollo"
    
    echo ""
    echo -e "${CYAN}Próximos pasos:${NC}"
    echo "  1. Ejecuta validación: ./setup-dev-environment.sh --validate"
    echo "  2. Prueba compilación Linux: ./dev-build-linux.sh"
    echo "  3. Prueba compilación ARM: ./dev-test-docker.sh"
    echo "  4. Desarrollo interactivo: python interactive_builder.py"
    
    # Ejecutar validación automática
    echo ""
    echo -e "${CYAN}Ejecutando validación final...${NC}"
    sleep 2
    validate_environment
}

# ==========================================================
# EJECUCIÓN
# ==========================================================

# Manejar argumentos de línea de comandos
case "${1:-}" in
    --validate)
        validate_environment
        exit 0
        ;;
    --help|-h)
        echo "Uso: $0 [--validate|--help]"
        echo ""
        echo "Opciones:"
        echo "  --validate    Validar entorno sin instalar"
        echo "  --help        Mostrar esta ayuda"
        exit 0
        ;;
    *)
        main
        ;;
esac
