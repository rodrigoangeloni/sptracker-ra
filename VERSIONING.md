# Guía de Versionado para sptracker

## Introducción
A partir de la versión 5.0.0, sptracker adopta un esquema de versionado semántico consistente para facilitar el desarrollo y la distribución.

## Estructura de Versiones

### Formato: MAJOR.MINOR.PATCH (ej: 5.2.1)

- **MAJOR** (5.x.x): Cambios que rompen compatibilidad
  - Cambios en protocolos de red
  - Modificaciones en API públicas
  - Reestructuración significativa del código
  
- **MINOR** (x.2.x): Nuevas funcionalidades compatibles
  - Nuevas características para usuarios
  - Mejoras en la interfaz
  - Nuevas opciones de configuración
  
- **PATCH** (x.x.1): Correcciones y mejoras menores
  - Corrección de bugs
  - Optimizaciones de rendimiento
  - Mejoras en documentación

## Proceso de Release

### 1. Planificación
- Decidir tipo de incremento (major/minor/patch)
- Revisar issues y pull requests pendientes
- Actualizar documentación si es necesario

### 2. Actualización de Versión
```powershell
# Opción A: Incremento automático
python update_version.py --increment patch

# Opción B: Versión específica
python update_version.py 5.1.0
```

### 3. Verificación
```powershell
# Verificar que todos los archivos tienen la nueva versión
git diff

# Verificar que la construcción funciona
python create_release.py --test_release_process 5.1.0
```

### 4. Construcción del Release
```powershell
# Construcción completa
python create_release.py 5.1.0

# Solo componentes específicos si es necesario
python create_release.py --ptracker_only 5.1.0
python create_release.py --stracker_only 5.1.0
```

### 5. Publicación
```powershell
# Commit de los cambios de versión
git add .
git commit -m "Release version 5.1.0"
git tag v5.1.0
git push origin main --tags

# Subir artefactos a GitHub Releases
```

## Archivos que Contienen Versiones

### Archivos de Código
- `ptracker_lib/__init__.py`: Versión de ptracker
- `stracker/stracker_lib/__init__.py`: Versión de stracker  
- `version_config.py`: Configuración centralizada

### Archivos de Documentación
- `README.md`: Ejemplos de uso con versiones

### Archivos Generados Automáticamente
- `dist/ptracker.exe`: Contiene versión embebida
- `versions/ptracker-V[version].exe`: Instalador con versión
- `versions/stracker-V[version].zip`: Paquete con versión

## Herramientas de Versionado

### update_version.py
Script principal para actualizar versiones en todo el proyecto.

**Características:**
- Actualización automática en todos los archivos relevantes
- Validación de formato de versión
- Incremento automático (patch/minor/major)
- Verificación de que la versión sea ≥ 5.0.0

### version_config.py
Configuración centralizada de versiones.

**Funciones útiles:**
- `get_version()`: Obtiene la versión actual
- `get_next_version(type)`: Calcula la siguiente versión
- `VERSION_INFO`: Diccionario con metadatos de versión

## Convenciones de Commit

### Mensajes de Commit Sugeridos
```
# Para releases
Release version 5.1.0

# Para preparación de releases
Prepare release 5.1.0

# Para incrementos de versión
Bump version to 5.1.0

# Para desarrollo
feat: add new dashboard widget
fix: resolve connection timeout issue
docs: update installation guide
```

### Tags de Git
```powershell
# Crear tag para release
git tag -a v5.1.0 -m "Release version 5.1.0"

# Listar tags
git tag --list "v5.*"

# Push tags
git push origin --tags
```

## Consideraciones Especiales

### Compatibilidad
- Las versiones MINOR y PATCH deben mantener compatibilidad hacia atrás
- Los cambios MAJOR pueden requerir migración de configuraciones
- Siempre documentar cambios incompatibles en el changelog

### Testing
- Probar construcción en Windows y Linux
- Verificar funcionamiento de ptracker y stracker
- Validar instaladores antes de publicar

### Distribución
- GitHub Releases para distribución principal
- Mantener enlaces estables para última versión
- Archivar versiones anteriores pero mantenerlas accesibles

## Troubleshooting

### Problemas Comunes

**Error: "Versión debe ser 5.0.0 o superior"**
- Solución: Usar solo versiones 5.x.x o superiores

**Error: "Formato de versión inválido"**
- Solución: Usar formato X.Y.Z (ej: 5.1.0)

**Error: "Archivo no encontrado"**
- Solución: Ejecutar desde el directorio raíz del proyecto

**Error en construcción después de cambio de versión**
- Solución: Limpiar directorios build/ y dist/ antes de reconstruir
