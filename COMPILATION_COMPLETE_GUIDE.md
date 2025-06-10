# 🚀 Scripts de Compilación Completa - sptracker

## 📋 Resumen

Este proyecto incluye scripts para compilar **TODOS** los binarios necesarios para distribución completa de sptracker en todas las arquitecturas soportadas.

## 🎯 Archivos Generados

### Windows (ptracker + stracker + stracker-packager)
- ✅ **Windows 32-bit**: `ptracker.exe`, `stracker.exe`, `stracker-packager.exe`
- ✅ **Windows 64-bit**: `ptracker.exe`, `stracker.exe`, `stracker-packager.exe`

### Linux (solo stracker)
- ✅ **Linux 32-bit**: `stracker` (en `.tgz`)
- ✅ **Linux 64-bit**: `stracker` (en `.tgz`)

### ARM (solo stracker)
- ✅ **ARM 32-bit**: `stracker` (en `.tgz`)
- ✅ **ARM 64-bit**: `stracker` (en `.tgz`)

## 🚀 Scripts Disponibles

### 1. `compile.cmd` - Script Principal (RECOMENDADO)
```cmd
# Uso simple con verificaciones automáticas
compile.cmd

# Uso con versión específica
compile.cmd 3.5.3
```

**Características**:
- ✅ Verificaciones automáticas de prerrequisitos
- ✅ Interfaz simplificada
- ✅ Llamada automática a `build_complete.cmd`

### 2. `build_complete.cmd` - Script Completo
```cmd
# Compilación completa paso a paso
build_complete.cmd 3.5.3
```

**Características**:
- ✅ Compilación secuencial de todas las arquitecturas
- ✅ Progreso detallado paso a paso
- ✅ Resumen completo de archivos generados
- ✅ Manejo robusto de errores

## 🛠️ Prerrequisitos

### Windows Host
- ✅ **Windows 10/11** con PowerShell
- ✅ **Python 3.8+** instalado y en PATH
- ✅ **Git** para control de versiones

### WSL (para Linux)
- ✅ **WSL2** habilitado
- ✅ **Debian** instalado en WSL
- ✅ Herramientas de desarrollo en Debian

### Docker Desktop (para ARM)
- ✅ **Docker Desktop for Windows** instalado
- ✅ Docker ejecutándose y accesible
- ✅ Emulación QEMU habilitada para ARM

## 📊 Estrategia de Compilación

| Arquitectura | Método | Herramienta | Tiempo Est. |
|--------------|---------|-------------|-------------|
| Windows 32/64 | Nativo | `create_release.py` | 5-8 min |
| Linux 32/64 | WSL Nativo | `build_linux_wsl_native.sh` | 3-5 min |
| ARM 32/64 | Docker + QEMU | `Dockerfile.arm32/64` | 15-20 min |

**Tiempo total estimado**: 30-45 minutos

## 🔄 Proceso de Compilación

### Paso 1: Windows 64-bit
```cmd
python create_release.py --test_release_process [version]
```
- Genera: `ptracker.exe`, `stracker.exe`, `stracker-packager.exe` para Win64

### Paso 2: Windows 32-bit  
```cmd
python create_release.py --windows32_only --test_release_process [version]
```
- Genera: `ptracker.exe`, `stracker.exe`, `stracker-packager.exe` para Win32

### Paso 3: Linux 64-bit
```cmd
wsl -d Debian -- ./build_linux_wsl_native.sh [version]
```
- Genera: `stracker_linux_x64-V[version].tgz`

### Paso 4: Linux 32-bit
```cmd
python create_release.py --linux32_only --test_release_process [version]
```
- Genera: `stracker_linux_x86-V[version].tgz`

### Paso 5: ARM 64-bit
```cmd
docker build -f Dockerfile.arm64 -t sptracker-arm64:[version] .
docker run --rm -v "versions:/app/versions" sptracker-arm64:[version] [version]
```
- Genera: `stracker_linux_arm64-V[version].tgz`

### Paso 6: ARM 32-bit
```cmd
docker build -f Dockerfile.arm32 -t sptracker-arm32:[version] .
docker run --rm -v "versions:/app/versions" sptracker-arm32:[version] [version]
```
- Genera: `stracker_linux_arm32-V[version].tgz`

## 📦 Archivos de Salida

Todos los archivos se generan en el directorio `versions/` con nomenclatura estandarizada:

```
versions/
├── ptracker-v[version]-win64-installer.exe        # Instalador Windows ptracker
├── ptracker-v[version]-win64-standalone.exe       # Binario standalone ptracker
├── stracker-v[version]-win64-installer.exe        # Instalador Windows stracker
├── stracker-v[version]-win64-standalone.exe       # Binario standalone stracker Win64
├── stracker-v[version]-win32-standalone.exe       # Binario standalone stracker Win32
├── stracker-v[version]-win-complete.zip           # Paquete completo stracker (todas arch)
├── stracker-v[version]-linux64.tgz                # Linux 64-bit
├── stracker-v[version]-linux32.tgz                # Linux 32-bit
├── stracker-v[version]-arm64.tgz                  # ARM 64-bit
├── stracker-v[version]-arm32.tgz                  # ARM 32-bit
├── stracker-packager-v[version]-win64-installer.exe   # Instalador empaquetador
└── stracker-packager-v[version]-win64-standalone.exe  # Empaquetador standalone
```

**Nomenclatura**: `componente-v[VERSION]-[ARQUITECTURA]-[TIPO].extensión`

Consulta [`NOMENCLATURA_BINARIOS.md`](NOMENCLATURA_BINARIOS.md) para detalles completos.

## 🎯 Distribución Recomendada

### Para Usuarios Finales
- **Cliente ptracker**: `ptracker-v[version]-win64-installer.exe`

### Para Administradores de Servidor
- **Servidor completo**: `stracker-v[version]-win-complete.zip` (contiene todas las arquitecturas Windows)
- **Solo empaquetador**: `stracker-packager-v[version]-win64-installer.exe`

### Para Distribución Específica por Arquitectura
- **Windows**: Usar archivos `-standalone.exe` para testing rápido
- **Linux**: Usar archivos `.tgz` específicos por arquitectura
- **ARM**: Usar archivos `stracker-v[version]-arm*.tgz`

## 🐛 Solución de Problemas

### Error: Python no encontrado
```cmd
# Verificar instalación
python --version

# Instalar si es necesario
winget install Python.Python.3.12
```

### Error: Docker no está ejecutándose
```cmd
# Verificar estado
docker --version

# Iniciar Docker Desktop manualmente
```

### Error: WSL no configurado
```cmd
# Instalar WSL y Debian
wsl --install -d Debian

# Verificar distribuciones
wsl --list --verbose
```

### Error de permisos en compilación
```cmd
# Ejecutar como administrador si es necesario
# O verificar permisos en directorio versions/
```

## 📝 Logs y Depuración

- Los errores se muestran en tiempo real durante la compilación
- Cada paso muestra su progreso individual
- En caso de error, el script se detiene y muestra información de depuración

## 🔄 Automatización

Para automatizar completamente:

```cmd
# Script automatizado sin intervención
build_complete.cmd 3.5.3

# O con verificaciones
compile.cmd 3.5.3
```

## 📊 Métricas de Rendimiento

| Componente | Arch | Método | Tiempo | Tamaño aprox |
|------------|------|---------|---------|--------------|
| ptracker | Win64 | Nativo | 3-4 min | 180 MB |
| stracker | Win64 | Nativo | 2-3 min | 15 MB |
| stracker | Linux64 | WSL | 3-4 min | 10 MB |
| stracker | ARM64 | Docker | 10-15 min | 8 MB |

---

## 🎉 Resultado Final

Después de ejecutar `compile.cmd [version]`, tendrás una distribución completa de sptracker lista para todas las plataformas y arquitecturas soportadas, optimizada para máximo rendimiento en cada entorno.
