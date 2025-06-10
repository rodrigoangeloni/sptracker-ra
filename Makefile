# Makefile para sptracker - Entorno de Desarrollo Estandarizado
# =============================================================
#
# Este Makefile automatiza las tareas comunes de desarrollo para
# el entorno Windows + WSL + Docker Desktop.
#
# USO:
#   make setup           # Configurar entorno completo
#   make build           # Compilar todas las arquitecturas
#   make build-windows   # Solo Windows
#   make build-linux     # Solo Linux
#   make build-arm       # Solo ARM (32+64)
#   make test            # Ejecutar tests
#   make clean           # Limpiar archivos temporales
#   make help            # Mostrar ayuda
#

# =============================================================
# CONFIGURACIÓN
# =============================================================

SHELL := /bin/bash
.DEFAULT_GOAL := help

# Variables del proyecto
PROJECT_NAME := sptracker
VERSION := 3.5.2
BUILD_DIR := build
DIST_DIR := dist
VERSIONS_DIR := versions
TEMP_DIR := temp

# Variables de Docker
DOCKER_COMPOSE := docker-compose
DOCKER_BUILDX := docker buildx
DOCKER_REGISTRY := 

# Variables de Python
PYTHON := python
PYTHON3 := python3
PIP := pip
VENV_WINDOWS := env/windows
VENV_LINUX := env/linux
VENV_DOCKER := env/docker

# Variables de compilación
BUILD_FLAGS := --test_release_process
INTERACTIVE_BUILDER := interactive_builder.py
CREATE_RELEASE := create_release.py

# Colores para output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m

# =============================================================
# TARGETS PRINCIPALES
# =============================================================

.PHONY: help
help: ## 📚 Mostrar esta ayuda
	@echo -e "$(PURPLE)sptracker - Makefile de Desarrollo$(NC)"
	@echo -e "$(PURPLE)==================================$(NC)"
	@echo ""
	@echo -e "$(CYAN)Entorno: Windows + WSL + Docker Desktop$(NC)"
	@echo ""
	@echo -e "$(YELLOW)COMANDOS PRINCIPALES:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo -e "$(YELLOW)EJEMPLOS:$(NC)"
	@echo "  make setup                    # Configurar entorno completo"
	@echo "  make build VERSION=3.5.3     # Compilar versión específica"
	@echo "  make build-arm                # Solo ARM32 + ARM64"
	@echo "  make test-interactive         # Testing interactivo"

.PHONY: setup
setup: setup-windows setup-wsl validate ## 🔧 Configurar entorno completo de desarrollo
	@echo -e "$(GREEN)✅ Entorno de desarrollo configurado completamente$(NC)"

.PHONY: build
build: build-windows build-linux build-arm ## 🏗️ Compilar todas las arquitecturas
	@echo -e "$(GREEN)✅ Compilación completa terminada$(NC)"
	@make show-results

.PHONY: test
test: test-syntax test-interactive test-docker ## 🧪 Ejecutar todas las pruebas
	@echo -e "$(GREEN)✅ Todas las pruebas completadas$(NC)"

.PHONY: clean
clean: clean-builds clean-temp clean-cache ## 🧹 Limpiar todos los archivos temporales
	@echo -e "$(GREEN)✅ Limpieza completada$(NC)"

# =============================================================
# CONFIGURACIÓN DEL ENTORNO
# =============================================================

.PHONY: setup-windows
setup-windows: ## 🪟 Configurar entorno Windows (requiere Admin)
	@echo -e "$(BLUE)🔧 Configurando entorno Windows...$(NC)"
	@if [ -f "setup-dev-environment.ps1" ]; then \
		powershell -ExecutionPolicy Bypass -File setup-dev-environment.ps1; \
	else \
		echo -e "$(RED)❌ setup-dev-environment.ps1 no encontrado$(NC)"; \
		exit 1; \
	fi

.PHONY: setup-wsl
setup-wsl: ## 🐧 Configurar entorno WSL
	@echo -e "$(BLUE)🔧 Configurando entorno WSL...$(NC)"
	@if [ -f "setup-dev-environment.sh" ]; then \
		chmod +x setup-dev-environment.sh; \
		./setup-dev-environment.sh; \
	else \
		echo -e "$(RED)❌ setup-dev-environment.sh no encontrado$(NC)"; \
		exit 1; \
	fi

.PHONY: setup-venv
setup-venv: ## 🐍 Crear entornos virtuales Python
	@echo -e "$(BLUE)🔧 Configurando entornos virtuales Python...$(NC)"
	
	# Windows venv
	@if [ ! -d "$(VENV_WINDOWS)" ]; then \
		echo "  Creando entorno virtual Windows..."; \
		$(PYTHON) -m virtualenv $(VENV_WINDOWS); \
	fi
	
	# Linux venv (si estamos en WSL)
	@if [ -n "$$WSL_DISTRO_NAME" ] && [ ! -d "$(VENV_LINUX)" ]; then \
		echo "  Creando entorno virtual Linux..."; \
		$(PYTHON3) -m venv $(VENV_LINUX); \
		$(VENV_LINUX)/bin/pip install --upgrade pip; \
		$(VENV_LINUX)/bin/pip install bottle cherrypy python-dateutil wsgi-request-logger simplejson pyinstaller psycopg2-binary apsw; \
	fi
	
	@echo -e "$(GREEN)✅ Entornos virtuales configurados$(NC)"

.PHONY: setup-docker
setup-docker: ## 🐳 Configurar Docker para compilación multiplataforma
	@echo -e "$(BLUE)🔧 Configurando Docker...$(NC)"
	
	# Verificar Docker
	@if ! command -v docker >/dev/null 2>&1; then \
		echo -e "$(RED)❌ Docker no está instalado$(NC)"; \
		exit 1; \
	fi
	
	# Configurar buildx
	@echo "  Configurando Docker Buildx..."
	@$(DOCKER_BUILDX) create --name multiplatform --driver docker-container --use 2>/dev/null || true
	@$(DOCKER_BUILDX) inspect --bootstrap multiplatform 2>/dev/null || true
	
	# Habilitar emulación QEMU
	@echo "  Habilitando emulación QEMU..."
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes 2>/dev/null || true
	
	@echo -e "$(GREEN)✅ Docker configurado$(NC)"

# =============================================================
# COMPILACIÓN POR PLATAFORMA
# =============================================================

.PHONY: build-windows
build-windows: ## 🪟 Compilar solo para Windows (x64 + x86)
	@echo -e "$(BLUE)🔧 Compilando para Windows...$(NC)"
	@$(PYTHON) $(CREATE_RELEASE) $(BUILD_FLAGS) --windows_only $(VERSION)
	@echo -e "$(GREEN)✅ Compilación Windows completada$(NC)"

.PHONY: build-linux
build-linux: ## 🐧 Compilar solo para Linux (usando WSL)
	@echo -e "$(BLUE)🔧 Compilando para Linux en WSL...$(NC)"
	@if [ -n "$$WSL_DISTRO_NAME" ]; then \
		echo "  Ejecutando en WSL nativo..."; \
		source $(VENV_LINUX)/bin/activate && $(PYTHON) $(CREATE_RELEASE) $(BUILD_FLAGS) --linux_only $(VERSION); \
	else \
		echo "  Ejecutando desde Windows hacia WSL..."; \
		wsl source $(VENV_LINUX)/bin/activate '&&' python $(CREATE_RELEASE) $(BUILD_FLAGS) --linux_only $(VERSION); \
	fi
	@echo -e "$(GREEN)✅ Compilación Linux completada$(NC)"

.PHONY: build-arm
build-arm: build-arm32 build-arm64 ## 🤖 Compilar para ARM (32 + 64 bits)
	@echo -e "$(GREEN)✅ Compilación ARM completada$(NC)"

.PHONY: build-arm32
build-arm32: ## 🤖 Compilar solo ARM32 (usando Docker)
	@echo -e "$(BLUE)🔧 Compilando para ARM32...$(NC)"
	@$(DOCKER_COMPOSE) up --build build-arm32
	@echo -e "$(GREEN)✅ Compilación ARM32 completada$(NC)"

.PHONY: build-arm64
build-arm64: ## 🦾 Compilar solo ARM64 (usando Docker)
	@echo -e "$(BLUE)🔧 Compilando para ARM64...$(NC)"
	@$(DOCKER_COMPOSE) up --build build-arm64
	@echo -e "$(GREEN)✅ Compilación ARM64 completada$(NC)"

.PHONY: build-ptracker
build-ptracker: ## 🏎️ Compilar solo ptracker
	@echo -e "$(BLUE)🔧 Compilando solo ptracker...$(NC)"
	@$(PYTHON) $(CREATE_RELEASE) $(BUILD_FLAGS) --ptracker_only $(VERSION)
	@echo -e "$(GREEN)✅ ptracker compilado$(NC)"

.PHONY: build-stracker
build-stracker: ## 🖥️ Compilar solo stracker
	@echo -e "$(BLUE)🔧 Compilando solo stracker...$(NC)"
	@$(PYTHON) $(CREATE_RELEASE) $(BUILD_FLAGS) --stracker_only $(VERSION)
	@echo -e "$(GREEN)✅ stracker compilado$(NC)"

.PHONY: build-packager
build-packager: ## 📦 Compilar solo stracker-packager
	@echo -e "$(BLUE)🔧 Compilando solo stracker-packager...$(NC)"
	@$(PYTHON) $(CREATE_RELEASE) $(BUILD_FLAGS) --stracker_packager_only $(VERSION)
	@echo -e "$(GREEN)✅ stracker-packager compilado$(NC)"

# =============================================================
# TESTING Y VALIDACIÓN
# =============================================================

.PHONY: test-syntax
test-syntax: ## ✅ Verificar sintaxis de Python
	@echo -e "$(BLUE)🔧 Verificando sintaxis Python...$(NC)"
	@$(PYTHON) -m py_compile $(CREATE_RELEASE)
	@$(PYTHON) -m py_compile $(INTERACTIVE_BUILDER)
	@$(PYTHON) -m py_compile ptracker.py
	@echo -e "$(GREEN)✅ Sintaxis Python válida$(NC)"

.PHONY: test-interactive
test-interactive: ## 🎮 Ejecutar compilación interactiva
	@echo -e "$(BLUE)🔧 Ejecutando compilación interactiva...$(NC)"
	@$(PYTHON) $(INTERACTIVE_BUILDER)

.PHONY: test-docker
test-docker: ## 🐳 Probar compilación Docker
	@echo -e "$(BLUE)🔧 Probando compilación Docker...$(NC)"
	@$(DOCKER_COMPOSE) up test-multiarch
	@$(DOCKER_COMPOSE) up --build dev-environment

.PHONY: validate
validate: ## ✅ Validar entorno completo
	@echo -e "$(BLUE)🔧 Validando entorno...$(NC)"
	@if [ -f "setup-dev-environment.ps1" ]; then \
		powershell -ExecutionPolicy Bypass -File setup-dev-environment.ps1 -Validate; \
	fi
	@if [ -f "setup-dev-environment.sh" ]; then \
		./setup-dev-environment.sh --validate; \
	fi

# =============================================================
# LIMPIEZA
# =============================================================

.PHONY: clean-builds
clean-builds: ## 🧹 Limpiar archivos de compilación
	@echo -e "$(BLUE)🧹 Limpiando builds...$(NC)"
	@rm -rf $(BUILD_DIR)/ $(DIST_DIR)/ stracker/build/ stracker/dist/
	@rm -f nsis_temp_files* ptracker-server-dist.py ptracker.nsh
	@echo -e "$(GREEN)✅ Builds limpiados$(NC)"

.PHONY: clean-temp
clean-temp: ## 🧹 Limpiar archivos temporales
	@echo -e "$(BLUE)🧹 Limpiando temporales...$(NC)"
	@rm -rf $(TEMP_DIR)/ .cache/ logs/
	@rm -rf __pycache__/ */__pycache__/ */*/__pycache__/
	@rm -f *.pyc */*.pyc */*/*.pyc
	@echo -e "$(GREEN)✅ Temporales limpiados$(NC)"

.PHONY: clean-cache
clean-cache: ## 🧹 Limpiar cache de pip y Docker
	@echo -e "$(BLUE)🧹 Limpiando cache...$(NC)"
	@$(PIP) cache purge 2>/dev/null || true
	@docker system prune -f 2>/dev/null || true
	@echo -e "$(GREEN)✅ Cache limpiado$(NC)"

.PHONY: clean-venv
clean-venv: ## 🧹 Limpiar entornos virtuales (CUIDADO)
	@echo -e "$(YELLOW)⚠️  Esto eliminará todos los entornos virtuales$(NC)"
	@read -p "¿Continuar? (s/N): " -n 1 -r && echo; \
	if [[ $$REPLY =~ ^[Ss]$$ ]]; then \
		rm -rf env/; \
		echo -e "$(GREEN)✅ Entornos virtuales eliminados$(NC)"; \
	else \
		echo -e "$(YELLOW)❌ Operación cancelada$(NC)"; \
	fi

# =============================================================
# INFORMACIÓN Y MONITOREO
# =============================================================

.PHONY: show-results
show-results: ## 📊 Mostrar archivos generados
	@echo -e "$(BLUE)📊 Archivos generados:$(NC)"
	@echo ""
	@if [ -d "$(VERSIONS_DIR)" ]; then \
		echo -e "$(CYAN)📁 $(VERSIONS_DIR)/:$(NC)"; \
		ls -la $(VERSIONS_DIR)/ 2>/dev/null || echo "  (vacío)"; \
	fi
	@echo ""
	@if [ -d "$(DIST_DIR)" ]; then \
		echo -e "$(CYAN)📁 $(DIST_DIR)/:$(NC)"; \
		ls -la $(DIST_DIR)/ 2>/dev/null || echo "  (vacío)"; \
	fi
	@echo ""
	@if [ -d "stracker/dist" ]; then \
		echo -e "$(CYAN)📁 stracker/dist/:$(NC)"; \
		ls -la stracker/dist/ 2>/dev/null || echo "  (vacío)"; \
	fi

.PHONY: show-env
show-env: ## 🔍 Mostrar información del entorno
	@echo -e "$(BLUE)🔍 Información del entorno:$(NC)"
	@echo ""
	@echo -e "$(CYAN)Sistema:$(NC)"
	@echo "  OS: $$(uname -s 2>/dev/null || echo 'Windows')"
	@echo "  Arquitectura: $$(uname -m 2>/dev/null || echo 'x86_64')"
	@if [ -n "$$WSL_DISTRO_NAME" ]; then echo "  WSL: $$WSL_DISTRO_NAME"; fi
	@echo ""
	@echo -e "$(CYAN)Python:$(NC)"
	@$(PYTHON) --version 2>/dev/null || echo "  Python no disponible"
	@echo ""
	@echo -e "$(CYAN)Docker:$(NC)"
	@docker --version 2>/dev/null || echo "  Docker no disponible"
	@echo ""
	@echo -e "$(CYAN)Git:$(NC)"
	@git --version 2>/dev/null || echo "  Git no disponible"

.PHONY: monitor
monitor: ## 📈 Iniciar monitor de builds (puerto 8080)
	@echo -e "$(BLUE)📈 Iniciando monitor de builds...$(NC)"
	@echo -e "$(CYAN)URL: http://localhost:8080$(NC)"
	@$(DOCKER_COMPOSE) up -d build-monitor
	@echo -e "$(GREEN)✅ Monitor iniciado$(NC)"

.PHONY: stop-monitor
stop-monitor: ## 📈 Detener monitor de builds
	@echo -e "$(BLUE)📈 Deteniendo monitor...$(NC)"
	@$(DOCKER_COMPOSE) down build-monitor
	@echo -e "$(GREEN)✅ Monitor detenido$(NC)"

# =============================================================
# DESARROLLO RÁPIDO
# =============================================================

.PHONY: dev
dev: ## 🚀 Modo desarrollo rápido (solo ptracker Windows)
	@echo -e "$(BLUE)🚀 Modo desarrollo rápido...$(NC)"
	@$(PYTHON) $(CREATE_RELEASE) $(BUILD_FLAGS) --ptracker_only $(VERSION)
	@echo -e "$(GREEN)✅ Build rápido completado$(NC)"

.PHONY: dev-interactive
dev-interactive: ## 🎮 Desarrollo interactivo
	@echo -e "$(BLUE)🎮 Modo desarrollo interactivo...$(NC)"
	@$(PYTHON) $(INTERACTIVE_BUILDER)

.PHONY: dev-shell
dev-shell: ## 🐚 Shell de desarrollo en Docker
	@echo -e "$(BLUE)🐚 Iniciando shell de desarrollo...$(NC)"
	@$(DOCKER_COMPOSE) run --rm dev-environment bash

# =============================================================
# UTILIDADES
# =============================================================

.PHONY: update-version
update-version: ## 🔄 Actualizar versión del proyecto
	@if [ -z "$(NEW_VERSION)" ]; then \
		echo -e "$(RED)❌ Especifica NEW_VERSION=x.y.z$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(BLUE)🔄 Actualizando versión a $(NEW_VERSION)...$(NC)"
	@if [ -f "update_version.py" ]; then \
		$(PYTHON) update_version.py $(NEW_VERSION); \
	else \
		echo -e "$(YELLOW)⚠️  update_version.py no encontrado, actualización manual$(NC)"; \
	fi

.PHONY: release
release: clean build test ## 🚀 Crear release completo
	@echo -e "$(GREEN)🚀 Release $(VERSION) creado exitosamente$(NC)"
	@make show-results

# =============================================================
# INFORMACIÓN ADICIONAL
# =============================================================

.PHONY: requirements
requirements: ## 📋 Mostrar requisitos del sistema
	@echo -e "$(BLUE)📋 Requisitos del Sistema:$(NC)"
	@echo ""
	@echo -e "$(CYAN)Windows + WSL + Docker Desktop:$(NC)"
	@echo "  • Windows 10/11 con WSL2 habilitado"
	@echo "  • Docker Desktop con integración WSL"
	@echo "  • Python 3.8+ en Windows y WSL"
	@echo "  • PowerShell 7+ (para scripts de setup)"
	@echo "  • Git para control de versiones"
	@echo ""
	@echo -e "$(CYAN)Opcional:$(NC)"
	@echo "  • VS Code con extensiones WSL y Docker"
	@echo "  • Make (para este Makefile)"
	@echo "  • NSIS para crear instaladores Windows"

# Verificar que estamos en el directorio correcto
.validate-project:
	@if [ ! -f "$(CREATE_RELEASE)" ]; then \
		echo -e "$(RED)❌ No se encontró $(CREATE_RELEASE)$(NC)"; \
		echo -e "$(YELLOW)Ejecuta make desde el directorio raíz del proyecto$(NC)"; \
		exit 1; \
	fi
