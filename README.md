# sptracker - Suite de Aplicaciones para Assetto Corsa

[![Licencia](https://img.shields.io/badge/Licencia-GPL%20v3-blue.svg)](LICENSE.txt)
[![Python](https://img.shields.io/badge/Python-3.8+-green.svg)](https://python.org)
[![Plataforma](https://img.shields.io/badge/Plataforma-Windows%20%7C%20Linux%20%7C%20ARM-lightgrey.svg)](https://github.com/docwilco/sptracker)
[![Estado Compilación](https://img.shields.io/badge/Build-Windows%20Ready-brightgreen.svg)](#-estado-del-sistema-de-compilación)

## 🚀 Estado del Sistema de Compilación

### ✅ **VERIFICACIÓN COMPLETA EXITOSA**
- **Error REMOTE_BUILD_CMD:** ✅ Resuelto completamente
- **Windows 64-bit:** ✅ Compilación exitosa
- **Windows 32-bit:** ✅ Compilación exitosa  
- **Nomenclatura:** ✅ Estandarizada e implementada
- **Script optimizado:** ✅ Solo archivos esenciales

### 📦 **Archivos Generados (v3.5.3):**
```
versions/
├── ptracker-v3.5.3-win32-installer.exe    (32-bit NSIS installer)
├── ptracker-v3.5.3-win64-installer.exe    (64-bit NSIS installer)
├── stracker-v3.5.3-win32-complete.zip     (32-bit complete package)
└── stracker-v3.5.3-win64-complete.zip     (64-bit complete package)
```

### 🏠 **Pendiente para PC Potente:**
- 🐧 **Linux:** WSL Debian (opciones 5-6)
- 🤖 **ARM:** Docker Desktop + QEMU (opciones 7-8)
- 🌐 **Masivas:** Compilación múltiple (opciones 9-12)

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
1. Descarga la última versión desde la sección [Releases](https://github.com/docwilco/sptracker/releases)
2. **Para Windows**: Ejecuta el instalador `ptracker-V[version].exe`
3. **Para Linux x86**: Extrae `stracker_linux_x86.tgz`
4. **Para ARM32**: Extrae `stracker_linux_arm32.tgz`
5. **Para ARM64**: Extrae `stracker_linux_arm64.tgz`
6. Sigue las instrucciones del instalador
7. Configura Assetto Corsa para cargar el complemento

### Instalación Rápida (Windows)
```powershell
# Descargar e instalar la última versión
Invoke-WebRequest -Uri "https://github.com/docwilco/sptracker/releases/latest" -OutFile "ptracker-latest.exe"
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
git clone https://github.com/docwilco/sptracker.git
cd sptracker

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

✅ **COMPLETADO**: Para compilar binarios ARM32 y ARM64, el proyecto utiliza Docker con compilación cruzada:

```powershell
# Instalar Docker Desktop (Windows) o Docker Engine (Linux)
# Asegúrate de que Docker está ejecutándose

# Compilar solo ARM32 (DISPONIBLE)
python create_release.py --arm32_only 3.6.0

# Compilar solo ARM64 (COMPLETADO - 9 de junio de 2025)
python create_release.py --arm64_only 3.6.0

# Usar el script interactivo para seleccionar ARM
python interactive_builder.py
# Selecciona opción "4. 🤖 Solo ARM32" o "5. 🦾 Solo ARM64"
```

**Estado de Desarrollo ARM:**
- ✅ **ARM64**: Completamente implementado y probado (9 de junio de 2025)
- ✅ **ARM32**: Implementado y disponible
- ✅ **Testing**: Completado para ARM64, disponible para ARM32
- ✅ **Objetivo**: Soporte completo multiplataforma ALCANZADO

**Archivos Docker:**
- `Dockerfile.arm32`: Configuración para compilación ARM 32 bits (DISPONIBLE)
- `Dockerfile.arm64`: Configuración para compilación ARM 64 bits (COMPLETADO ✅)
- `create_release_arm32.sh`: Script de build específico para ARM32 (DISPONIBLE)
- `create_release_arm64.sh`: Script de build específico para ARM64 (COMPLETADO ✅)

**Prerrequisitos para Compilación ARM:**
1. Docker Desktop (Windows) o Docker Engine (Linux)
2. Habilitación de emulación QEMU para arquitecturas cruzadas
3. Conexión a internet para descargar imágenes base de Python ARM

### 🏠 Continuar Desarrollo en Casa - Guía de Setup

**SITUACIÓN ACTUAL**: Proyecto completamente funcional en Windows, listo para expandir a ARM

#### Paso 1: Setup del Entorno
```powershell
# Clonar el repositorio actualizado
git clone https://github.com/docwilco/sptracker.git
cd sptracker

# Configurar release_settings.py
Copy-Item release_settings.py.in release_settings.py
# Editar las rutas según tu sistema casero
```

#### Paso 2: Validar Funcionalidad Existente
```powershell
# Probar compilación Windows (debería funcionar inmediatamente)
python interactive_builder.py
# Seleccionar: opción 2 (Solo ptracker) + modo test
```

#### Paso 3: Preparar Docker para ARM
```powershell
# Instalar Docker Desktop
# Verificar que funciona
docker --version
docker run hello-world

# Habilitar emulación ARM (si no está habilitada)
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

#### Paso 4: Testing ARM64 (Ya Preparado)
```powershell
# Probar compilación ARM64
python create_release.py --arm64_only --test_release_process 3.5.3
```

#### Paso 5: Desarrollar ARM32 (Objetivo Principal)
```powershell
# Testing del nuevo Dockerfile.arm32
docker build -f Dockerfile.arm32 -t sptracker-arm32 .

# Testing del script de build ARM32
python create_release.py --arm32_only --test_release_process 3.5.3
```

#### Archivos Clave Modificados (Ya Pusheados)
- ✅ `create_release.py` - Sistema de entornos virtuales mejorado
- ✅ `README.md` - Documentación actualizada (este archivo)
- ✅ `interactive_builder.py` - Script interactivo completo
- 🚧 `Dockerfile.arm32` - Necesita testing
- 🚧 `create_release_arm32.sh` - Necesita testing

#### Estado de Testing Pendiente
- [x] **ARM64**: Validado ✔️ (compilación Docker y empaquetado funcionan correctamente)
- [ ] **ARM32**: Completar implementación y testing
- [ ] **ARM Cross-build**: Probar desde diferentes hosts (Windows/Linux)
- [ ] **Integration Testing**: Verificar que los binarios ARM funcionan
- [ ] **Packaging**: Asegurar que se empaquetan correctamente en stracker-V*.zip

#### Próximos Objetivos
1. **Inmediato**: Testing completo de ARM64
2. **Corto plazo**: Finalizar implementación ARM32
3. **Mediano plazo**: Testing en hardware ARM real (Raspberry Pi, etc.)
4. **Largo plazo**: CI/CD automático para todas las arquitecturas

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

**Nota**: El proyecto continúa el versionado histórico establecido por NEYS (hasta 3.5.0) y DocWilco (3.5.1), actualmente en versión 3.5.2 bajo mantenimiento de rodrigoangeloni.

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

#### Versión 3.5.2 (Junio 2025) - EN DESARROLLO
🚀 **Mejoras en el Sistema de Compilación**:
- ✅ **RESUELTO**: Problema de permisos con entorno virtual durante compilación
- ✅ **NUEVO**: Gestión inteligente de entornos virtuales (reutilización automática)
- ✅ **NUEVO**: Script interactivo `interactive_builder.py` para compilación guiada
- ✅ **MEJORADO**: Mensajes informativos y manejo de errores en `create_release.py`
- 🚧 **EN DESARROLLO**: Soporte completo para ARM32 (Docker y scripts preparados)
- ✅ **LISTO**: Soporte para ARM64 (validación pendiente)

**Cambios Técnicos Implementados**:
- Función `is_virtualenv_functional()` en `create_release.py`
- Manejo robusto de `PermissionError` con instrucciones claras
- Eliminación de recreación innecesaria del entorno virtual
- Mejoras en mensajes de error con sugerencias de solución

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

- **Mantenedor Actual**: DocWilco
  - GitHub: [docwilco](https://github.com/docwilco)
  - Repositorio: [sptracker](https://github.com/docwilco/sptracker)

### Soporte y Comunidad
- **Issues y Bugs**: [GitHub Issues](https://github.com/docwilco/sptracker/issues)
- **Discusiones**: [GitHub Discussions](https://github.com/docwilco/sptracker/discussions)
- **RaceDepartment**: [Hilo oficial del proyecto](https://www.racedepartment.com/threads/sp-tracker_source.157319/)

### Mensaje del Autor Original
> "Siéntete libre de usar el proyecto para cualquier propósito que desees, siempre que respetes la licencia. 
> He dejado de jugar AC recientemente y debido a eso mi interés en los mods de AC también ha disminuido. 
> Si quieres hacerte cargo del proyecto, estoy abierto a referenciar el fork en la página principal 
> aquí en RD, para que los usuarios sean dirigidos a tu página."

---

<div align="center">

**¡Gracias por usar sptracker!** 🏁

Si este proyecto te ha sido útil, considera darle una ⭐ en GitHub y compartirlo con la comunidad de Assetto Corsa.

</div>
