# 📝 Nomenclatura de Binarios - sptracker

## 🎯 Objetivo
Establecer un sistema de nombres claro y consistente para todos los binarios generados que permita identificar fácilmente:
- **Componente**: qué parte del sistema es (ptracker, stracker, stracker-packager)
- **Versión**: número de versión específico
- **Arquitectura**: plataforma y arquitectura de destino
- **Tipo**: si es instalador, standalone, paquete completo

## 📋 Estándar de Nomenclatura

### Formato General
```
componente-v[VERSION]-[ARQUITECTURA]-[TIPO].extensión
```

### Ejemplos Completos
```
ptracker-v3.5.3-win64-installer.exe
stracker-v3.5.3-win64-standalone.exe
stracker-v3.5.3-linux64.tgz
stracker-v3.5.3-arm32.tgz
stracker-packager-v3.5.3-win64-installer.exe
```

## 🗂️ Componentes

### ptracker
- **Descripción**: Aplicación cliente para usuarios finales
- **Plataformas**: Solo Windows
- **Arquitecturas**: win64
- **Tipos**: installer, standalone

### stracker  
- **Descripción**: Servidor de seguimiento principal
- **Plataformas**: Windows, Linux, ARM
- **Arquitecturas**: win32, win64, linux32, linux64, arm32, arm64
- **Tipos**: installer, standalone, complete (para Windows)

### stracker-packager
- **Descripción**: Herramienta de empaquetado para administradores
- **Plataformas**: Solo Windows  
- **Arquitecturas**: win64
- **Tipos**: installer, standalone

## 🏗️ Arquitecturas

| Código | Descripción | Plataforma |
|--------|-------------|------------|
| win32 | Windows 32-bit | Windows |
| win64 | Windows 64-bit | Windows |
| linux32 | Linux 32-bit (x86) | Linux |
| linux64 | Linux 64-bit (x64) | Linux |
| arm32 | ARM 32-bit | ARM Linux |
| arm64 | ARM 64-bit | ARM Linux |

## 📦 Tipos de Binarios

| Tipo | Descripción | Extensión |
|------|-------------|-----------|
| installer | Instalador con setup completo | .exe |
| standalone | Ejecutable independiente | .exe |
| complete | Paquete completo con todas las arquitecturas | .zip |
| (sin tipo) | Binario compilado para Linux/ARM | .tgz |

## 📁 Estructura de Directorios

### Directorio versions/
Todos los binarios finales se almacenan en `versions/` con la nomenclatura estándar:

```
versions/
├── ptracker-v3.5.3-win64-installer.exe
├── ptracker-v3.5.3-win64-standalone.exe
├── stracker-v3.5.3-win64-installer.exe
├── stracker-v3.5.3-win64-standalone.exe
├── stracker-v3.5.3-win32-standalone.exe
├── stracker-v3.5.3-win-complete.zip
├── stracker-v3.5.3-linux64.tgz
├── stracker-v3.5.3-linux32.tgz
├── stracker-v3.5.3-arm64.tgz
├── stracker-v3.5.3-arm32.tgz
├── stracker-packager-v3.5.3-win64-installer.exe
└── stracker-packager-v3.5.3-win64-standalone.exe
```

## 🎯 Distribución Recomendada

### Para Usuarios Finales
- **ptracker-v[VERSION]-win64-installer.exe**: Instalador principal para usuarios
- **stracker-v[VERSION]-win-complete.zip**: Paquete completo con todas las arquitecturas Windows

### Para Servidores
- **stracker-v[VERSION]-linux64.tgz**: Para servidores Linux modernos
- **stracker-v[VERSION]-arm64.tgz**: Para servidores ARM (Raspberry Pi 4, etc.)

### Para Administradores
- **stracker-packager-v[VERSION]-win64-installer.exe**: Herramienta de empaquetado

### Para Desarrollo/Testing
- **Archivos standalone**: Para testing rápido sin instalación

## 🔄 Migración de Nomenclatura Antigua

El script `build_complete.cmd` incluye lógica de migración que convierte automáticamente:

```bash
# Formato antiguo → Formato nuevo
ptracker-V3.5.3.exe → ptracker-v3.5.3-win64-installer.exe
stracker-V3.5.3.zip → stracker-v3.5.3-win-complete.zip
stracker_linux_x64.tgz → stracker-v3.5.3-linux64.tgz
stracker_linux_arm32.tgz → stracker-v3.5.3-arm32.tgz
```

## ⚙️ Implementación

### En build_complete.cmd
El Paso 7 del script se encarga de:
1. Buscar archivos con nomenclatura antigua o inconsistente
2. Renombrarlos al estándar nuevo
3. Organizarlos en el directorio `versions/`
4. Evitar duplicados y conflictos

### Beneficios
- ✅ **Claridad**: Fácil identificación de versión y arquitectura
- ✅ **Consistencia**: Mismo formato para todos los componentes
- ✅ **Automatización**: Script maneja la conversión automáticamente
- ✅ **Distribución**: Nombres claros para usuarios finales
- ✅ **Desarrollo**: Fácil identificación durante testing

## 🚀 Ejemplo de Uso

Después de ejecutar `build_complete.cmd 3.5.3`, obtienes:

```bash
📦 RESUMEN DE ARCHIVOS GENERADOS (nomenclatura estandarizada):

🪟 WINDOWS (ptracker + stracker + stracker-packager):
   📦 INSTALADORES:
      ✅ ptracker-v3.5.3-win64-installer.exe
      ✅ stracker-v3.5.3-win-complete.zip
      ✅ stracker-packager-v3.5.3-win64-installer.exe
   🔧 BINARIOS STANDALONE:  
      ✅ ptracker-v3.5.3-win64-standalone.exe
      ✅ stracker-v3.5.3-win64-standalone.exe
      ✅ stracker-v3.5.3-win32-standalone.exe
      ✅ stracker-packager-v3.5.3-win64-standalone.exe

🐧 LINUX (solo stracker):
      ✅ stracker-v3.5.3-linux64.tgz
      ✅ stracker-v3.5.3-linux32.tgz

🤖 ARM (solo stracker):
      ✅ stracker-v3.5.3-arm64.tgz  
      ✅ stracker-v3.5.3-arm32.tgz
```

---

**Versión**: 3.5.3  
**Fecha**: Diciembre 2024  
**Estado**: Implementado en build_complete.cmd v7+
