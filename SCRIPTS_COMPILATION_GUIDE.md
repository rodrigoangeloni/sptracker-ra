# 🚀 Scripts de Compilación - Guía Rápida

## 📋 ¿Qué Script Usar?

### Para Compilación Completa Automatizada
```cmd
build_complete.cmd 3.5.4
```
**Cuándo usar**: Cuando quieres compilar TODAS las arquitecturas de una vez
- ✅ Windows 32/64 + Linux 32/64 + ARM 32/64
- ✅ Progreso paso a paso detallado
- ✅ Nomenclatura automática estandarizada
- ✅ Manejo robusto de errores

### Para Compilación Selectiva/Modular
```cmd
compile_all.cmd 3.5.4
```
**Cuándo usar**: Cuando quieres elegir qué compilar
- ✅ Menú interactivo de opciones
- ✅ Solo Windows, solo Linux, solo ARM, o todo
- ✅ Llama a scripts especializados
- ✅ Más rápido para testing

### Para Compilación Rápida con Verificaciones
```cmd
compile.cmd 3.5.4
```
**Cuándo usar**: Para compilación rápida con validaciones automáticas
- ✅ Verifica prerrequisitos (Python, Docker, WSL)
- ✅ Wrapper que llama a `build_complete.cmd`
- ✅ Ideal para uso diario

## 🗂️ Nomenclatura de Archivos

Todos los scripts generan archivos con nomenclatura estandarizada:
```
componente-v[VERSION]-[ARQUITECTURA]-[TIPO].extensión
```

**Ejemplos**:
- `ptracker-v3.5.4-win64-installer.exe`
- `stracker-v3.5.4-linux64.tgz`
- `stracker-v3.5.4-arm32.tgz`

Ver [`NOMENCLATURA_BINARIOS.md`](NOMENCLATURA_BINARIOS.md) para detalles completos.

## 📦 Archivos Generados

Todos en `versions/` con nombres claros:
```
versions/
├── ptracker-v3.5.4-win64-installer.exe
├── stracker-v3.5.4-win64-standalone.exe
├── stracker-v3.5.4-linux64.tgz
└── stracker-v3.5.4-arm64.tgz
```

## ⚡ Quick Start

1. **Primera vez** (compilación completa):
   ```cmd
   build_complete.cmd 3.5.4
   ```

2. **Desarrollo diario** (solo Windows):
   ```cmd
   compile_all.cmd 3.5.4
   # Elegir opción 2 (Solo Windows)
   ```

3. **Release final** (todo + verificaciones):
   ```cmd
   compile.cmd 3.5.4
   ```

## 📚 Documentación Completa

- [`COMPILATION_COMPLETE_GUIDE.md`](COMPILATION_COMPLETE_GUIDE.md) - Guía detallada
- [`NOMENCLATURA_BINARIOS.md`](NOMENCLATURA_BINARIOS.md) - Estándar de nombres
- [`COMPILATION_STRATEGY.md`](COMPILATION_STRATEGY.md) - Estrategia técnica

---
**Última actualización**: Diciembre 2024 - Sistema de nomenclatura estandarizada v7
