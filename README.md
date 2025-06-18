# sptracker - Suite de Aplicaciones para Assetto Corsa

[![Licencia](https://img.shields.io/badge/Licencia-GPL%20v3-blue.svg)](LICENSE.txt)
[![Python](https://img.shields.io/badge/Python-3.8+-green.svg)](https://python.org)
[![Plataforma](https://img.shields.io/badge/Plataforma-Windows%20%7C%20Linux%20%7C%20ARM-lightgrey.svg)](https://github.com/rodrigoangeloni/sptracker-ra)
[![Estado Compilación](https://img.shields.io/badge/Build-Completo-brightgreen.svg)](#compilación)

**sptracker** es una suite completa de aplicaciones para [Assetto Corsa](http://www.assettocorsa.net/) que incluye `ptracker` (rastreador personal) y `stracker` (rastreador de servidor). Proporciona análisis avanzado de rendimiento, estadísticas detalladas y funcionalidades mejoradas tanto para jugadores individuales como para administradores de servidores.

## 🚀 Estado Actual - v3.5.2

✅ **Sistema de compilación multiplataforma completado**  
✅ **Nomenclatura de archivos estandarizada**  
✅ **8 plataformas soportadas:** Windows 32/64, Linux 32/64, ARM32/ARM64  
✅ **Errores críticos resueltos**  
✅ **Sistema de build optimizado**  

### 🆕 Lo Nuevo en v3.5.2
- **Nomenclatura estandarizada**: Todos los archivos siguen el patrón `componente-v[VERSION]-[ARQUITECTURA]-[TIPO].ext`
- **Sistema multiplataforma**: Soporte completo para 8 arquitecturas diferentes
- **Build optimizado**: Script principal con opciones claras y Docker multiarch
- **Crash crítico resuelto**: Fixed `NameError: traceback` que causaba fallos del servidor

## ✨ Características

- **Análisis de rendimiento en tiempo real** - Tiempos de vuelta, deltas y comparaciones
- **Interfaz gráfica avanzada** - Widgets personalizables con múltiples temas
- **Estadísticas completas** - Base de datos de rendimiento y análisis histórico
- **Soporte multiplataforma** - Windows, Linux, ARM32 y ARM64
- **Interfaz web** - Panel de control basado en navegador para servidores

## 🔧 Componentes

### ptracker (Cliente)
Aplicación que se ejecuta como complemento dentro de Assetto Corsa:
- Análisis de vueltas en tiempo real
- Información de carrera (combustible, neumáticos)
- Interfaz personalizable

### stracker (Servidor)
Aplicación para administradores de servidores:
- Base de datos de estadísticas de jugadores
- Interfaz web de administración
- Monitoreo en tiempo real

## 💻 Requisitos

- **Sistema Operativo**: Windows 10+ o Ubuntu 18.04+
- **Assetto Corsa**: Instalación completa del juego
- **Para compilación**: Docker Desktop (Linux/ARM) o Python 3.8+ (Windows)

## 🚀 Instalación

### Para Usuarios
1. Descarga la versión apropiada para tu sistema:

#### Windows (Usuarios Finales)
```
ptracker-v3.5.2-win32-installer.exe    (Windows 32-bit - Instalador completo)
ptracker-v3.5.2-win64-installer.exe    (Windows 64-bit - Instalador completo)
```

#### Servidores Windows
```
stracker-v3.5.2-win32-complete.zip     (Windows 32-bit - Solo servidor)
stracker-v3.5.2-win64-complete.zip     (Windows 64-bit - Solo servidor)
```

#### Servidores Linux/ARM
```
stracker-v3.5.2-linux32.tgz           (Linux 32-bit)
stracker-v3.5.2-linux64.tgz           (Linux 64-bit)
stracker-v3.5.2-arm32.tgz             (ARM 32-bit)
stracker-v3.5.2-arm64.tgz             (ARM 64-bit)
```

2. **Windows**: Ejecuta el instalador `.exe`
3. **Linux/ARM**: Extrae el archivo `.tgz` y ejecuta `./stracker`

## 🛠️ Compilación

### Sistema de Build Simplificado
```powershell
# Ejecutar el script principal interactivo
.\01_main_build.cmd

# Con versión específica (recomendado)
.\01_main_build.cmd 3.5.2
```

### Opciones de Compilación
1. **Windows 64-bit completo** - Todos los componentes
2. **Windows 32-bit completo** - Todos los componentes
3. **Solo stracker Windows 64-bit** - Servidor únicamente
4. **Solo stracker Windows 32-bit** - Servidor únicamente
5. **Solo stracker Linux 64-bit** - Docker
6. **Solo stracker Linux 32-bit** - Docker
7. **Solo stracker ARM 32-bit** - Docker + QEMU
8. **Solo stracker ARM 64-bit** - Docker + QEMU

### Nomenclatura de Archivos
Todos los archivos generados siguen el patrón estándar:
- **Instaladores**: `ptracker-v[VERSION]-[ARCH]-installer.exe`
- **Paquetes Windows**: `stracker-v[VERSION]-[ARCH]-complete.zip`
- **Paquetes Linux/ARM**: `stracker-v[VERSION]-[ARCH].tgz`

## 📖 Uso Rápido

### ptracker (Cliente)
1. Instala usando el instalador de Windows
2. Inicia Assetto Corsa
3. Ve a Configuración → General → UI Modules
4. Activa "ptracker"

### stracker (Servidor)
```bash
# Ejecutar servidor
./stracker

# Generar configuración por defecto
./stracker --stracker_ini stracker-default.ini

# Interfaz web (puerto por defecto)
http://localhost:50042
```

## 🏷️ Historial de Versiones

### v3.5.2 (Junio 2025) - rodrigoangeloni
- **ESTANDARIZACIÓN**: Nomenclatura unificada para todos los binarios
- **CRÍTICO**: Resuelto crash `NameError: traceback` en stracker.py
- **Sistema multiplataforma completo**: 8 plataformas soportadas
- **Build system simplificado**: Script principal optimizado con Docker multiarch
- **Verificación de calidad**: Todos los binarios probados y validados

### v3.5.1 (Mayo 2021) - DocWilco
- Líneas de división de sectores en mapas e integración con Highcharts

### v3.5.0 (Mayo 2018) - NEYS  
- Versión base con funcionalidades core

## 📄 Licencia

Este proyecto está licenciado bajo la **GNU General Public License v3.0**. Ver [LICENSE.txt](LICENSE.txt) para más detalles.

## 📞 Contacto

### Mantenimiento Actual
- **Mantenedor**: rodrigoangeloni - [sptracker-ra](https://github.com/rodrigoangeloni/sptracker-ra)
- **Issues y Bugs**: [GitHub Issues](https://github.com/rodrigoangeloni/sptracker-ra/issues)

---

<div align="center">

**¡Gracias por usar sptracker!** 🏁

Si este proyecto te ha sido útil, considera darle una ⭐ en GitHub

</div>
