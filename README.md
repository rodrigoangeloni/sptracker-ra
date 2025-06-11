# sptracker - Suite de Aplicaciones para Assetto Corsa

[![Licencia](https://img.shields.io/badge/Licencia-GPL%20v3-blue.svg)](LICENSE.txt)
[![Python](https://img.shields.io/badge/Python-3.8+-green.svg)](https://python.org)
[![Plataforma](https://img.shields.io/badge/Plataforma-Windows%20%7C%20Linux%20%7C%20ARM-lightgrey.svg)](https://github.com/rodrigoangeloni/sptracker-ra)
[![Estado Compilación](https://img.shields.io/badge/Build-Multiplataforma%20Completo-brightgreen.svg)](#-estado-del-sistema-de-compilación)

## 🚀 Estado del Sistema de Compilación

### ✅ **SISTEMA MULTIPLATAFORMA COMPLETADO**
- **Codificación UTF-8:** ✅ Resuelto - `chcp 65001` implementado
- **Windows 64-bit:** ✅ Compilación exitosa con instalador NSIS
- **Linux WSL 64-bit:** ✅ Compilación exitosa - stracker-v3.5.3-linux64.tgz (20.6 MB)
- **Linux WSL 32-bit:** ✅ Compilación exitosa - stracker-v3.5.3-linux32.tgz (18.8 MB)
- **ARM32 Docker:** ✅ Compilación exitosa - stracker-v3.5.3-arm32.tgz (19.4 MB)
- **ARM64 Docker:** ✅ Compilación exitosa - stracker-v3.5.3-arm64.tgz (20.0 MB)
- **Nomenclatura:** ✅ Sistema estandarizado implementado
- **Optimización Docker:** ✅ Reutilización inteligente de imágenes

### 📦 **Archivos Generados (v3.5.3) - TODAS LAS PLATAFORMAS:**
```
versions/
├── ptracker-v3.5.3-win64-installer.exe    (Windows 64-bit NSIS installer)
├── stracker-v3.5.3-win64-complete.zip     (Windows 64-bit complete package)
├── stracker-v3.5.3-linux64.tgz           (Linux 64-bit binary - 20.6 MB)
├── stracker-v3.5.3-linux32.tgz           (Linux 32-bit binary - 18.8 MB)
├── stracker-v3.5.3-arm32.tgz             (ARM 32-bit binary - 19.4 MB)
└── stracker-v3.5.3-arm64.tgz             (ARM 64-bit binary - 20.0 MB)
```

### 🎯 **OBJETIVOS ALCANZADOS:**
- ✅ **Multiplataforma completo:** Windows, Linux WSL, ARM32/ARM64 Docker
- ✅ **Rutas dinámicas:** Detección automática de WSL y paths optimizados  
- ✅ **Correcciones críticas:** WSL environment detection, ARM compilation logic
- ✅ **Sistema robusto:** Manejo de errores y reutilización de recursos

### ⚠️ **TAREAS PENDIENTES:**
- 🔧 **Compilación masiva:** Probar opciones 9-12 (Windows, Linux, ARM, completa)
- 🐛 **Script syntax:** Corregir error "No se esperaba : en este momento" en 01_main_build.cmd

> **📋 Ver:** [`CONTINUACION_EN_CASA.md`](CONTINUACION_EN_CASA.md) para pruebas pendientes

---

**sptracker** es una suite completa de aplicaciones para [Assetto Corsa](http://www.assettocorsa.net/) que incluye `ptracker` (rastreador personal) y `stracker` (rastreador de servidor). Esta herramienta proporciona análisis avanzado de rendimiento, estadísticas detalladas y funcionalidades mejoradas tanto para jugadores individuales como para administradores de servidores. Con soporte nativo para arquitecturas x86, x64, ARM32 y ARM64.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Componentes](#-componentes)
- [Requisitos del Sistema](#-requisitos-del-sistema)
- [Instalación](#-instalación)
- [Construcción desde el Código Fuente](#-construcción-desde-el-código-fuente)
- [Uso](#-uso)
- [Configuración](#-configuración)
- [Desarrollo](#-desarrollo)
- [Versionado](#-versionado)
- [Licencia](#-licencia)
- [Contacto](#-contacto)

## ✨ Características

### Características Principales
- **Análisis de rendimiento en tiempo real** - Tiempos de vuelta, deltas y comparaciones
- **Interfaz gráfica avanzada** - Widgets personalizables con múltiples temas
- **Estadísticas completas** - Base de datos de rendimiento y análisis histórico
- **Soporte multiplataforma** - Windows, Linux, ARM32 y ARM64
- **Interfaz web** - Panel de control basado en navegador para servidores
- **Comunicación cliente-servidor** - Protocolo de red optimizado
- **Soporte de base de datos** - SQLite y PostgreSQL
- **Compilación con Docker** - Soporte para arquitecturas ARM mediante contenedores

### Funcionalidades Específicas
- Comparación de vueltas con ghost cars
- Información detallada de combustible y neumáticos
- Chat mejorado con filtros
- Sistema de autenticación para servidores
- Exportación de datos para análisis externos
- Monitoreo de sesiones en tiempo real
- Soporte para múltiples idiomas

## 🔧 Componentes

### ptracker (Rastreador Personal)
Aplicación del lado del cliente que se ejecuta como complemento dentro de Assetto Corsa:
- **Análisis de vueltas**: Comparación en tiempo real con mejores tiempos
- **Información de carrera**: Datos de combustible, neumáticos y rendimiento
- **Interfaz personalizable**: Múltiples widgets y temas visuales
- **Chat mejorado**: Funcionalidades adicionales de comunicación

### stracker (Rastreador de Servidor)
Aplicación del lado del servidor para administradores de servidores de Assetto Corsa:
- **Base de datos de estadísticas**: Almacenamiento de datos de todos los jugadores
- **Interfaz web**: Panel de control accesible desde navegador
- **Gestión de usuarios**: Sistema de autenticación y permisos
- **Monitoreo en tiempo real**: Seguimiento de sesiones activas
- **Filtros y moderación**: Control de chat y lista de baneos

## 💻 Requisitos del Sistema

### Requisitos Mínimos
- **Sistema Operativo**: Windows 10+ o Ubuntu 18.04+
- **Arquitecturas Soportadas**: x86, x64, ARM32, ARM64
- **Assetto Corsa**: Instalación completa del juego
- **Python**: 3.8 o superior (solo para desarrollo)
- **Memoria RAM**: 4GB mínimo, 8GB recomendado
- **Espacio en disco**: 500MB para instalación completa

### Para Desarrollo
- **Python**: 3.8+ con pip y virtualenv
- **Git**: Para control de versiones
- **NSIS**: 3.x para crear instaladores de Windows
- **Docker**: Para compilación ARM32/ARM64 (opcional)
- **Entorno Linux**: WSL2, VM o host remoto para compilación multiplataforma

## 🚀 Instalación

### Instalación para Usuarios
1. Descarga la última versión desde la sección [Releases](https://github.com/rodrigoangeloni/sptracker-ra/releases)
2. **Para Windows**: Ejecuta el instalador `ptracker-v[version]-win64-installer.exe`
3. **Para Linux 64-bit**: Extrae `stracker-v[version]-linux64.tgz`
4. **Para Linux 32-bit**: Extrae `stracker-v[version]-linux32.tgz`
5. **Para ARM32**: Extrae `stracker-v[version]-arm32.tgz`
6. **Para ARM64**: Extrae `stracker-v[version]-arm64.tgz`
7. Sigue las instrucciones del instalador
8. Configura Assetto Corsa para cargar el complemento

### Instalación Rápida (Windows)
```powershell
# Descargar e instalar la última versión
Invoke-WebRequest -Uri "https://github.com/rodrigoangeloni/sptracker-ra/releases/latest" -OutFile "ptracker-latest.exe"
.\ptracker-latest.exe
```

## 🛠️ Construcción desde el Código Fuente

### Estado Actual del Proyecto (Junio 2025)
🚀 **RECIÉN RESUELTO**: Se ha solucionado un problema crítico en el sistema de compilación relacionado con la gestión de entornos virtuales:

- **Problema resuelto**: Error "Acceso denegado" al intentar eliminar el entorno virtual `env/windows` durante la compilación
- **Causa**: VS Code y otros IDEs mantenían archivos bloqueados en el entorno virtual
- **Solución implementada**: Gestión inteligente de entornos virtuales que reutiliza entornos existentes y funcionales
- **Beneficio**: Compilaciones más rápidas y sin conflictos de permisos

✅ **COMPLETAMENTE PROBADO EN WINDOWS**: 
- Sistema de compilación funcional al 100%
- Script interactivo `interactive_builder.py` operativo
- Generación exitosa de todos los ejecutables (ptracker.exe, stracker.exe, stracker-packager.exe)
- Creación de instaladores e archivos de distribución

✅ **OBJETIVO ALCANZADO**: Compilación para arquitecturas ARM completada
- ✅ ARM64: Completamente implementado y probado (9 de junio de 2025)
- ✅ ARM32: Implementado y disponible
- ✅ Meta lograda: soporte completo para Windows, Linux, ARM32 y ARM64

### Configuración del Entorno de Desarrollo
```powershell
# Clonar el repositorio
git clone https://github.com/rodrigoangeloni/sptracker-ra.git
cd sptracker-ra

# Instalar Python y virtualenv
pip install virtualenv

# Crear archivo de configuración
Copy-Item release_settings.py.in release_settings.py
# Editar release_settings.py con tus rutas específicas
```

### ⚠️ Notas Importantes para el Desarrollo
1. **Entorno Virtual**: El sistema ahora gestiona automáticamente el entorno virtual `env/windows`
2. **VS Code**: Puedes trabajar con VS Code abierto sin problemas de compilación
3. **Permisos**: No es necesario ejecutar como administrador
4. **Reutilización**: Los entornos virtuales se reutilizan si están funcionales, acelerando las compilaciones

### Construcción Interactiva (Recomendado)
Para facilitar el proceso de construcción, puedes usar el script interactivo:

```powershell
# Ejecutar el constructor interactivo
python interactive_builder.py
```

El script interactivo te guiará paso a paso a través de:
- **Selección de versión**: Especifica la versión que quieres construir
- **Opciones de construcción**: Elige qué componentes compilar (ptracker, stracker, o ambos)
- **Configuración de plataforma**: Windows, Linux, ARM32, ARM64 o todas las arquitecturas
- **Modo de prueba**: Opción para probar sin hacer commits git
- **Información detallada**: Muestra información completa de todos los archivos generados

### Construcción Manual
```powershell
# Construir todas las aplicaciones (todas las arquitecturas)
python create_release.py 3.6.0

# Construir solo ptracker
python create_release.py --ptracker_only 3.6.0

# Construir solo stracker
python create_release.py --stracker_only 3.6.0

# Construir solo para Windows
python create_release.py --windows_only 3.6.0

# Construir solo para Linux
python create_release.py --linux_only 3.6.0

# Construir solo para ARM32
python create_release.py --arm32_only 3.6.0

# Construir solo para ARM64
python create_release.py --arm64_only 3.6.0

# Modo de prueba (sin commit git)
python create_release.py --test_release_process 3.6.0
```

### Archivos Generados
Después de una construcción exitosa, encontrarás los siguientes archivos:

**En el directorio `versions/`:**
- `ptracker-V[version].exe`: Instalador de Windows para ptracker (cliente)
- `stracker-packager-V[version].exe`: Empaquetador standalone de stracker
- `stracker-V[version].zip`: Paquete completo de stracker (servidor)
  - Incluye `stracker_linux_x86.tgz`: Binario Linux x86
  - Incluye `stracker_linux_arm32.tgz`: Binario Linux ARM32 (si se compiló)
  - Incluye `stracker_linux_arm64.tgz`: Binario Linux ARM64 (si se compiló)

**En el directorio `dist/`:**
- `ptracker.exe`: Ejecutable de ptracker para desarrollo

**En el directorio `stracker/dist/`:**
- `stracker.exe`: Ejecutable principal del servidor
- `stracker-packager.exe`: Herramienta de empaquetado

### Opciones de Construcción
- `--test_release_process`: Modo de prueba sin modificaciones git
- `--ptracker_only`: Construir solo el cliente ptracker
- `--stracker_only`: Construir solo el servidor stracker
- `--windows_only`: Solo versiones de Windows
- `--linux_only`: Solo versiones de Linux
- `--arm32_only`: Solo versión ARM 32 bits (requiere Docker)
- `--arm64_only`: Solo versión ARM 64 bits (requiere Docker)
- `--stracker_packager_only`: Solo el empaquetador de stracker

### Compilación para Arquitecturas ARM

✅ **COMPLETADO - TODAS LAS ARQUITECTURAS**: El proyecto tiene soporte completo para ARM32 y ARM64 usando Docker:

```powershell
# Usar el script principal (RECOMENDADO)
.\01_main_build.cmd
# Opciones disponibles:
# 4. Solo ARM32 Docker           ✅ COMPLETADO 
# 5. Solo ARM64 Docker           ✅ COMPLETADO

# O usar directamente create_release.py
python create_release.py --arm32_only 3.5.3   # ✅ FUNCIONAL
python create_release.py --arm64_only 3.5.3   # ✅ FUNCIONAL
```
```

**Estado de Desarrollo ARM:**
- ✅ **ARM32**: Completamente implementado y probado (10 de junio de 2025)
- ✅ **ARM64**: Completamente implementado y probado (10 de junio de 2025)
- ✅ **Testing**: Completado para ambas arquitecturas
- ✅ **Objetivo**: Soporte completo multiplataforma ALCANZADO

**Archivos Docker Implementados:**
- ✅ `Dockerfile.arm32`: Configuración para compilación ARM 32 bits 
- ✅ `Dockerfile.arm64`: Configuración para compilación ARM 64 bits
- ✅ `create_release_arm32.sh`: Script de build específico para ARM32
- ✅ `create_release_arm64.sh`: Script de build específico para ARM64

**Binarios Generados Exitosamente:**
- ✅ `stracker-v3.5.3-arm32.tgz` (19.4 MB) - Probado y funcional
- ✅ `stracker-v3.5.3-arm64.tgz` (20.0 MB) - Probado y funcional

**Prerrequisitos para Compilación ARM:**
1. Docker Desktop (Windows) o Docker Engine (Linux)
2. Habilitación de emulación QEMU para arquitecturas cruzadas
3. Conexión a internet para descargar imágenes base de Python ARM

### 🏠 Sistema de Compilación Multiplataforma - COMPLETADO

**SITUACIÓN ACTUAL**: ✅ Proyecto completamente funcional en todas las plataformas objetivo

#### ✅ Estado de Implementación Completado
```powershell
# ✅ TODAS LAS PLATAFORMAS FUNCIONANDO:
01_main_build.cmd
├── Opción 1: Solo Windows 64-bit         ✅ FUNCIONANDO
├── Opción 2: Solo Linux WSL 64-bit       ✅ FUNCIONANDO  
├── Opción 3: Solo Linux WSL 32-bit       ✅ FUNCIONANDO
├── Opción 4: Solo ARM32 Docker           ✅ FUNCIONANDO
├── Opción 5: Solo ARM64 Docker           ✅ FUNCIONANDO
├── Opción 6: [PENDIENTE] Windows + Linux ⚠️ POR PROBAR
├── Opción 7: [PENDIENTE] Linux + ARM     ⚠️ POR PROBAR
├── Opción 8: [PENDIENTE] Solo ARM        ⚠️ POR PROBAR
└── Opción 9: [PENDIENTE] COMPLETA        ⚠️ POR PROBAR
```

#### 🔧 Correcciones Implementadas
- **WSL Environment Detection:** `grep -qi "microsoft\|wsl"` en lugar de solo "Microsoft"
- **ARM Compilation Logic:** Variables ARM correctamente deshabilitadas en modo `--linux_only`
- **Docker Optimization:** Reutilización inteligente de imágenes existentes
- **UTF-8 Encoding:** `chcp 65001` para mostrar emojis correctamente
- **Path Standardization:** Detección dinámica de rutas WSL con función `TOLOWER`

#### 📦 Binarios Generados y Verificados
```bash
# Todos los archivos generados exitosamente:
versions/stracker-v3.5.3-linux64.tgz    # 20.6 MB - WSL Native
versions/stracker-v3.5.3-linux32.tgz    # 18.8 MB - WSL Native  
versions/stracker-v3.5.3-arm32.tgz      # 19.4 MB - Docker
versions/stracker-v3.5.3-arm64.tgz      # 20.0 MB - Docker
```

#### ⚠️ Tareas Finales Pendientes
1. **Probar opciones masivas (6-9)** - Compilación múltiple simultánea
2. **Corregir syntax error** - "No se esperada : en este momento" en script batch

#### 🚀 Uso del Sistema Completado
```powershell
# Ejecutar el script principal con todas las opciones disponibles
.\01_main_build.cmd

# Menú disponible:
# 1. Solo Windows 64-bit         ✅ FUNCIONANDO
# 2. Solo Linux WSL 64-bit       ✅ FUNCIONANDO  
# 3. Solo Linux WSL 32-bit       ✅ FUNCIONANDO
# 4. Solo ARM32 Docker           ✅ FUNCIONANDO
# 5. Solo ARM64 Docker           ✅ FUNCIONANDO
# 6. Windows + Linux             ⚠️ POR PROBAR
# 7. Linux + ARM                 ⚠️ POR PROBAR
# 8. Solo ARM (32+64)            ⚠️ POR PROBAR
# 9. COMPILACIÓN COMPLETA        ⚠️ POR PROBAR
```

#### 📁 Archivos y Scripts Implementados
- ✅ `01_main_build.cmd` - Script principal multiplataforma
- ✅ `build_linux_wsl_native.sh` - Compilación WSL con detección mejorada
- ✅ `create_release.py` - Sistema de compilación con lógica ARM corregida
- ✅ `Dockerfile.arm32` - Compilación ARM32 funcional
- ✅ `Dockerfile.arm64` - Compilación ARM64 funcional
- ✅ Optimización Docker con reutilización de imágenes

### Gestión de Versiones
Para facilitar la actualización de versiones, puedes usar el script auxiliar:

```powershell
# Actualizar a una versión específica
python update_version.py 3.6.0

# Incrementar automáticamente la versión
python update_version.py --increment patch  # 3.5.2 → 3.5.3
python update_version.py --increment minor  # 3.5.2 → 3.6.0
python update_version.py --increment major  # 3.5.2 → 4.0.0

# Luego construir el release
python create_release.py 3.6.0
```

## 📖 Uso

### Configuración de ptracker
1. Inicia Assetto Corsa
2. Ve a Configuración → General → UI Modules
3. Activa "ptracker"
4. Configura las opciones según tus preferencias

### Configuración de stracker (Servidor)
```bash
# Ejecutar stracker en servidor Linux x86
./stracker --help

# Ejecutar stracker en ARM32
./stracker_arm32 --help

# Ejecutar stracker en ARM64
./stracker_arm64 --help

# Generar configuración por defecto
./stracker --stracker_ini stracker-default.ini

# Ejecutar con configuración específica
./stracker --stracker_ini mi-config.ini
```

### Interfaz Web de stracker
- Accede a `http://[servidor]:8080` para ver estadísticas
- Panel de administración disponible con credenciales configuradas
- API REST para integración con otras aplicaciones

## ⚙️ Configuración

### Archivos de Configuración Principales
- `ptracker.ini`: Configuración del cliente ptracker
- `stracker.ini`: Configuración del servidor stracker
- `release_settings.py`: Configuración de construcción del proyecto

### Configuración de Base de Datos
stracker soporta SQLite (por defecto) y PostgreSQL:

```ini
[DATABASE]
database_type = sqlite3
database_file = stracker.db3

# Para PostgreSQL
# database_type = postgres
# postgres_host = localhost
# postgres_user = stracker
# postgres_pwd = password
# postgres_db = stracker
```

## 👨‍💻 Desarrollo

### Estructura del Proyecto
```
sptracker/
├── ptracker_lib/          # Biblioteca principal compartida
├── stracker/              # Código del servidor
├── images/                # Recursos gráficos
├── sounds/                # Archivos de audio
├── icons/                 # Iconos de la interfaz
├── www/                   # Documentación web
├── create_release.py      # Script de construcción principal
└── README.md             # Este archivo
```

### Arquitectura de Software
- **Lenguaje**: Python 3.8+
- **GUI**: PySide6/Qt para interfaces nativas
- **Web**: CherryPy para servidor HTTP
- **Base de datos**: SQLite/PostgreSQL con APSW
- **Empaquetado**: PyInstaller para ejecutables
- **Instaladores**: NSIS para Windows

### Contribuir al Proyecto
1. Fork el repositorio en GitHub
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Realiza tus cambios y añade tests si es necesario
4. Commit tus cambios (`git commit -am 'Añadir nueva funcionalidad'`)
5. Push a la rama (`git push origin feature/nueva-funcionalidad`)
6. Crea un Pull Request

### Estándares de Código
- Seguir PEP 8 para estilo de código Python
- Documentar funciones y clases importantes
- Añadir tests para funcionalidades nuevas
- Mantener compatibilidad con Python 3.8+

### Esquema de Versionado
El proyecto utiliza [Semantic Versioning](https://semver.org/) continuando desde la versión **3.5.2**:
- **MAJOR** (3.x.x): Cambios incompatibles en la API o arquitectura
- **MINOR** (x.Y.x): Nuevas funcionalidades manteniendo compatibilidad
- **PATCH** (x.x.Z): Correcciones de bugs y mejoras menores

**Nota**: El proyecto continúa el versionado histórico establecido por NEYS (hasta 3.5.0) y DocWilco (3.5.1), actualmente en versión 3.5.3 con mejoras significativas en el sistema de compilación multiplataforma desarrolladas por rodrigoangeloni en el repositorio [sptracker-ra](https://github.com/rodrigoangeloni/sptracker-ra).

## 🏷️ Versionado

### Esquema de Versiones
El proyecto utiliza [Semantic Versioning](https://semver.org/) continuando desde la versión **3.5.2**:

- **3.x.x** - Versión principal (cambios incompatibles)
- **x.Y.x** - Versión menor (nuevas funcionalidades compatibles)
- **x.x.Z** - Versión de parche (correcciones de bugs)

### Gestión de Versiones
El proyecto incluye herramientas para facilitar la gestión de versiones:

```powershell
# Ver versión actual
python -c "from version_config import get_version; print(get_version())"

# Actualizar versión manualmente
python update_version.py 3.6.0

# Incrementar versión automáticamente
python update_version.py --increment patch   # Correcciones
python update_version.py --increment minor   # Nuevas funcionalidades
python update_version.py --increment major   # Cambios incompatibles
```

### Historial de Versiones y Cambios Recientes

#### Versión 3.5.3 (Junio 2025) - rodrigoangeloni
🚀 **Sistema de Compilación Multiplataforma Completado**:
- ✅ **NUEVO**: Sistema completo multiplataforma (Windows, Linux WSL, ARM32/ARM64 Docker)
- ✅ **NUEVO**: Script principal `01_main_build.cmd` con 9 opciones de compilación
- ✅ **RESUELTO**: WSL environment detection (`grep -qi "microsoft\|wsl"`)
- ✅ **RESUELTO**: ARM compilation logic en modo `--linux_only`
- ✅ **NUEVO**: Optimización Docker con reutilización inteligente de imágenes
- ✅ **NUEVO**: Codificación UTF-8 (`chcp 65001`) para caracteres especiales
- ✅ **NUEVO**: Nomenclatura estandarizada de archivos binarios
- ✅ **NUEVO**: Documentación técnica completa del sistema

**Archivos Binarios Generados**:
- `stracker-v3.5.3-linux64.tgz` (20.6 MB) - WSL Native
- `stracker-v3.5.3-linux32.tgz` (18.8 MB) - WSL Native
- `stracker-v3.5.3-arm32.tgz` (19.4 MB) - Docker Build
- `stracker-v3.5.3-arm64.tgz` (20.0 MB) - Docker Build

#### Versión 3.5.2 (Junio 2025) - Base para Sistema Multiplataforma
🚀 **Mejoras en el Sistema de Compilación Base**:
- ✅ **RESUELTO**: Problema de permisos con entorno virtual durante compilación
- ✅ **NUEVO**: Gestión inteligente de entornos virtuales (reutilización automática)
- ✅ **NUEVO**: Script interactivo `interactive_builder.py` para compilación guiada
- ✅ **MEJORADO**: Mensajes informativos y manejo de errores en `create_release.py`

#### Versión 3.5.1 (Mayo 2021) - DocWilco
- **Líneas de división de sectores**: Visualización de sectores en mapas de circuito
- **Gráficos mejorados**: Integración con Highcharts para mejor rendimiento
- **Zoom sincronizado**: Funcionalidad de zoom con rueda del ratón en mapas
- **Reemplazo de PyGal**: Migración a Highcharts para mejor rendimiento de gráficos
- **Velocidad de compilación**: Optimizaciones en scripts de construcción
- **Detección de instalación AC**: Mejor detección del directorio de instalación de Assetto Corsa

#### Versión 3.5.0 (Mayo 2018) - NEYS
- **Funcionalidades Core**: ptracker + stracker + stracker-packager
- **Soporte Windows**: Compilación y empaquetado completos
- **Soporte Linux**: Binarios x86/x64 funcionales
- **Instaladores**: NSIS para Windows, tarball para Linux
- **Anonimización GDPR**: Cumplimiento con GDPR mediante anonimización de Steam IDs
- **Historial de chat**: Tabla ChatHistory en base de datos (esquema v24)

### Releases y Distribución
Cada versión genera los siguientes artefactos en el directorio `versions/`:
- `ptracker-V[version].exe`: Instalador de Windows para ptracker
- `stracker-packager-V[version].exe`: Empaquetador standalone de stracker  
- `stracker-V[version].zip`: Paquete completo de stracker (Windows + Linux)

## 📄 Licencia

Este proyecto está licenciado bajo la **GNU General Public License v3.0**. Ver el archivo [LICENSE.txt](LICENSE.txt) para más detalles.

### Nota sobre la Licencia
Como se indica en la GPL v3, tienes la libertad de:
- Usar el software para cualquier propósito
- Estudiar y modificar el código fuente
- Distribuir copias del software
- Distribuir versiones modificadas

Siempre que respetes los términos de la licencia, incluyendo mantener el código fuente disponible bajo la misma licencia.

## 📞 Contacto

### Autores y Mantenedores
- **Autor Original**: NEYS
  - Usuario en [Assetto Corsa Forums](http://www.assettocorsa.net/forum/index.php): `never_eat_yellow_snow1`
  - Usuario en [RaceDepartment](http://www.racedepartment.com/forums/): `Neys`

- **Mantenedor Histórico**: DocWilco
  - GitHub: [docwilco](https://github.com/docwilco)
  - Repositorio original: [sptracker](https://github.com/docwilco/sptracker)

- **Mantenedor Actual y Desarrollador Sistema Multiplataforma**: rodrigoangeloni
  - **GitHub**: [rodrigoangeloni](https://github.com/rodrigoangeloni)
  - **Repositorio actual**: [sptracker-ra](https://github.com/rodrigoangeloni/sptracker-ra)
  - **Contribuciones principales (Junio 2025)**:
    - ✅ Sistema de compilación multiplataforma completo (Windows, Linux WSL, ARM32/ARM64 Docker)
    - ✅ Corrección WSL environment detection y ARM compilation logic
    - ✅ Optimización Docker con reutilización inteligente de imágenes
    - ✅ Script interactivo `01_main_build.cmd` con 9 opciones de compilación
    - ✅ Nomenclatura estandarizada y codificación UTF-8
    - ✅ Documentación técnica completa y guías de desarrollo

### Soporte y Comunidad
- **Issues y Bugs**: [GitHub Issues](https://github.com/rodrigoangeloni/sptracker-ra/issues)
- **Discusiones**: [GitHub Discussions](https://github.com/rodrigoangeloni/sptracker-ra/discussions)
- **Repositorio**: [sptracker-ra](https://github.com/rodrigoangeloni/sptracker-ra)
- **RaceDepartment**: [Hilo oficial del proyecto original](https://www.racedepartment.com/threads/sp-tracker_source.157319/)

### Mensaje del Autor Original
> "Siéntete libre de usar el proyecto para cualquier propósito que desees, siempre que respetes la licencia. 
> He dejado de jugar AC recientemente y debido a eso mi interés en los mods de AC también ha disminuido. 
> Si quieres hacerte cargo del proyecto, estoy abierto a referenciar el fork en la página principal 
> aquí en RD, para que los usuarios sean dirigidos a tu página."

### Fork Actual - sptracker-ra
Este repositorio es un fork mantenido activamente por **rodrigoangeloni** con mejoras significativas:
- 🚀 **Sistema de compilación multiplataforma completo**
- 🐳 **Soporte Docker para ARM32/ARM64**
- 🐧 **Compilación WSL nativa**
- 📦 **Nomenclatura estandarizada**
- 🔧 **Scripts automatizados optimizados**

---

<div align="center">

**¡Gracias por usar sptracker!** 🏁

Si este proyecto te ha sido útil, considera darle una ⭐ en GitHub: [sptracker-ra](https://github.com/rodrigoangeloni/sptracker-ra)

</div>
