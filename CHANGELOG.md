# Changelog - sptracker

Registro completo de cambios del proyecto **sptracker** - Suite de aplicaciones para Assetto Corsa.

## Formato

Este changelog sigue las convenciones de [Keep a Changelog](https://keepachangelog.com/es/1.0.0/) y utiliza [Semantic Versioning](https://semver.org/lang/es/) continuando desde la versión 3.5.2.

**Tipos de cambios:**
- `Added` - Nuevas funcionalidades
- `Changed` - Cambios en funcionalidades existentes
- `Deprecated` - Funcionalidades que serán eliminadas
- `Removed` - Funcionalidades eliminadas
- `Fixed` - Correcciones de errores
- `Security` - Mejoras de seguridad

---

## [3.5.2] - 2025-06-10 (EN DESARROLLO) - rodrigoangeloni

### Added
- 🚀 **Gestión inteligente de entornos virtuales**: Reutilización automática de entornos existentes funcionales
- 📋 **Script interactivo de compilación**: `interactive_builder.py` para construcción guiada paso a paso
- 🔧 **Soporte ARM32/ARM64**: Dockerfiles y scripts de compilación para arquitecturas ARM
- 📖 **Documentación completa ARM**: Guías detalladas para desarrollo en ARM32 y ARM64
- ⚡ **Función `is_virtualenv_functional()`**: Verificación inteligente del estado del entorno virtual
- 🎯 **Adopción de herramientas modernas**: Scripts `update_version.py` y `version_config.py`
- 📚 **Sistema de documentación mejorado**: README.md completamente reescrito y expandido
- 🏗️ **Entorno estandarizado Windows + WSL**: Configuración reproducible para desarrollo
- 📋 **Makefile avanzado**: Automatización completa del proceso de compilación
- 🐧 **Compilación WSL nativa**: Linux se compila directamente en WSL (sin Docker)
- 📊 **Estrategia de compilación optimizada**: WSL 6-7x más rápido que Docker para Linux

### Changed
- 🛠️ **Sistema de compilación mejorado**: Manejo robusto de `PermissionError` con instrucciones claras
- 📝 **Mensajes de error mejorados**: Instrucciones claras para resolver problemas de permisos
- 🔄 **Eliminación de recreación innecesaria**: No se recrea el entorno virtual si ya es funcional
- 📋 **Guía de versionado**: Archivo `VERSIONING.md` con convenciones y procesos
- 🐳 **Docker solo para ARM**: Docker reservado únicamente para arquitecturas ARM (32/64)

### Fixed
- ✅ **Problema de permisos**: Resuelto error "Acceso denegado" al eliminar entorno virtual en Windows
- 🔒 **Conflictos con IDEs**: Gestión de archivos bloqueados por VS Code y otros editores
- 🔧 **Compilación multiplataforma**: Estrategia optimizada Windows nativo + WSL nativo + Docker ARM
- 📋 **Versionado correcto**: Corregida documentación para usar versión 3.5.2 en lugar de 5.x.x incorrecta

### Technical Details
- **Archivos modificados**: `create_release.py`, `README.md`, `ptracker_lib/__init__.py`, `stracker/stracker_lib/__init__.py`
- **Archivos nuevos**: `Makefile`, `COMPILATION_STRATEGY.md`, `test-wsl-compilation.sh`, `docker-compose.yml`
- **Entorno probado**: ✅ Windows + WSL Debian + PyInstaller 6.14.1
- **Próximo objetivo**: Testing completo ARM64 + desarrollo ARM32  
- **Target**: Soporte completo Windows + Linux + ARM32 + ARM64
- **Mantenedor**: rodrigoangeloni (continuando el trabajo de DocWilco y NEYS)

---

## Historial (Autor Original: NEYS)

### [3.5.1] - 2021-05-17 (DocWilco)

#### Added
- 🗺️ **Líneas de división de sectores**: Visualización de sectores en mapas de circuito
- 📊 **Gráficos mejorados**: Integración con Highcharts para mejor rendimiento
- 🔄 **Zoom sincronizado**: Funcionalidad de zoom con rueda del ratón en mapas

#### Changed
- 📈 **Reemplazo de PyGal**: Migración a Highcharts para mejor rendimiento de gráficos
- 🚀 **Velocidad de compilación**: Optimizaciones en scripts de construcción
- 🎯 **Detección de instalación AC**: Mejor detección del directorio de instalación de Assetto Corsa

#### Fixed
- 🔧 **stracker-packager**: Correcciones en el empaquetador
- 🎮 **Detección AC**: Mejor detección de instalación de Assetto Corsa en NSIS

### [3.5.0] - 2018-05-19 (NEYS)

#### Added
- 🔒 **Anonimización GDPR**: Cumplimiento con GDPR mediante anonimización de Steam IDs
- 💬 **Historial de chat**: Tabla ChatHistory en base de datos (esquema v24)
- 🚫 **Comando de anonimización**: Los usuarios pueden anonimizar sus datos personales
- 🛡️ **Blacklist automática**: Opción para añadir jugadores anónimos a la blacklist

#### Changed
- 🆔 **Steam IDs hasheados**: Reemplazo de Steam IDs por valores hash anónimos (DB schema v24)
- 📝 **Actualización README**: Mención del dilema GDPR y responsabilidades del administrador

#### Removed
- 💰 **Enlaces de donación**: Eliminación de opciones de PayPal y Flattr
- 📋 **Sincronización blacklist**: Eliminado soporte para sincronización de archivos blacklist

#### Fixed
- 📊 **Orden de drivers**: Corrección en ordenamiento de conductores para bases de datos PostgreSQL

### [3.4.0] - 2018-05-10 (NEYS)

#### Added
- 🏆 **API Minorating**: Nueva API para obtener calificaciones MR
- 🎨 **Iconos MR diferenciados**: MR-A (verde claro) y MR-B (verde oscuro)
- 🔗 **Protocolo mejorado**: No depende más del nombre de jugador para identificación

#### Changed
- 👤 **Identificación de conductores**: Protocolo cliente-servidor mejorado para mejor identificación
- 🔧 **Compatibilidad**: Solución para problemas con nombres de caracteres especiales

### [3.3.x Series] - 2017-2018 (NEYS)

#### 3.3.7 - Added
- 🎮 **Información ESC**: Guardado correcto de pulsaciones de tecla ESC
- ✅ **Validación de vueltas**: Primera vuelta de jugadores sin ptracker se invalida

#### 3.3.6 - Fixed
- 🔧 **Compatibilidad AC 1.13**: Corrección para intercambio/guardado automático de setups

#### 3.3.5 - Added
- ⏱️ **Soporte carreras por tiempo**: Compatibilidad con carreras cronometradas
- 🏅 **Calificaciones Minorating**: Opción para mostrar calificaciones MR (configurable)
- 📏 **Delta mejorado**: Muestra "1 L" cuando se está a más de una vuelta
- 🎨 **Iconos de ayudas actualizados**: Integración de iconos mejorados por @Laurent81
- 🏎️ **API de neumáticos**: Uso de nueva API para consultar compuesto de neumáticos

#### 3.3.4 - Fixed
- 🏁 **Soporte carreras cronometradas**: Añadido soporte para carreras por tiempo en stracker
- 🗺️ **Visualización de circuitos**: Corrección en visualización de circuitos en detalles de sesión

#### 3.3.3 - Fixed
- 🎮 **Gestión de sesiones**: Restauración de gestión de sesiones (rota en 3.3.0-3.3.2)
- 🏆 **Mensajes de victoria**: Corrección de mensajes "<jugador> ganó la carrera"
- 🏅 **Consultas MR**: Limpieza de código para consultas de calificación MR
- 🐛 **Correcciones championship**: Posible corrección de errores en correcciones de sesiones de campeonato

#### 3.3.2 - Added
- 🔧 **Cache MR**: Sistema de caché para calificaciones Minorating (DB schema v23)
- 📡 **Transferencia MR**: Envío de calificaciones MR a instancias ptracker conectadas
- ⏱️ **Carreras cronometradas**: Funcionalidad de carreras por tiempo

#### 3.3.1 - Fixed
- 🔧 **Intercambio de setups**: Corrección de intercambio de setups (roto en 3.3.0)

#### 3.3.0 - Added
- 🆔 **GUIDs por nombre**: Opción para crear GUIDs basados en nombres de conductor
- ⚠️ **Nota**: Solo para escenarios especiales (ej: internet café)

### [3.2.x Series] - 2016-2017 (NEYS)

#### 3.2.10 - Fixed
- ✅ **Compatibilidad AC 1.7**: Corrección de compatibilidad con Assetto Corsa 1.7

#### 3.2.9 - Fixed
- 💬 **Mensajes de chat**: Corrección de errores al enviar mensajes a jugadores desconectados
- 📝 **Corrección typo**: Error tipográfico "unknwon"

#### 3.2.8 - Fixed
- 🖥️ **Dreamweaver**: Corrección de problemas cuando Dreamweaver está instalado en Windows

#### 3.2.7 - Added
- ⛽ **Comunicación de combustible**: Protocolo stracker/ptracker actualizado para carga de combustible
- 🚗 **Mensaje de entrada**: Muestra el coche del jugador al entrar (sesiones multi-coche)
- 📊 **Visualización combustible**: Mostrar combustible en sesiones ya finalizadas

#### 3.2.6 - Fixed
- 🏎️ **Display (C)orvette**: Corrección de problemas de visualización de marcas (mín. 3 caracteres)
- 🎨 **Templates editables**: Posibilidad de modificar templates HTTP
- 🔧 **Comparación de vueltas**: Corrección de selección de vueltas para sesiones multi-coche
- 💾 **Uso de memoria**: Reducción de uso de memoria (mapas y badges bajo demanda)
- 🌐 **Soporte in-game browser**: Cambios en templates para navegador integrado
- 📊 **Gráficos optimizados**: Actualización a pygal 2.1.1 y reducción de tamaño

#### 3.2.5 - Added/Fixed
- 🔄 **Protocolo compatible**: Compatibilidad con ptracker 3.1.x (incompatible con 3.2.0-3.2.4)
- 💾 **Compresión DB**: Corrección de errores de compresión y compresión inmediata al inicio
- 🔚 **Salida mejorada**: Corrección de posibles colgadas al salir
- 🐘 **PostgreSQL**: Mejor mensaje de error para migración a BD no vacía

#### 3.2.4 - Fixed
- 🎨 **Badges y mapas**: Posible corrección para desaparición de badges y mapas
- 📊 **Gráficos**: Actualización a pygal 2.1.1 y reducción de tamaño de comparaciones

#### 3.2.3 - Added
- 🌡️ **Unidades de velocidad**: Configuración de unidades (kmh/mph) en stracker.ini
- 🔧 **Columna vmax**: Columna opcional vmax en página de estadísticas de vueltas

#### 3.2.2 - Fixed
- 🚫 **Blacklist**: Corrección de "incapacidad de iniciar" cuando blacklist_file está configurado

#### 3.2.1 - Added/Fixed
- 📡 **Protocolo stats**: Cambio en protocolo stracker/ptracker para nueva visualización stats
- 💾 **Compresión DB**: Corrección de error al comprimir base de datos
- 🔧 **Comparación de vueltas**: Corrección de selección de vueltas para sesiones multi-coche

#### 3.2.0 - Major Update
- 🔧 **Configuración stracker.ini**: Múltiples nuevas opciones de configuración
- 🆔 **DB Schema v22**: 
  - Columna MessagesDisabled en tabla Players
  - Columna ballast en tabla Lap
  - Separación de HistoryInfo para mejor rendimiento
  - Tabla ChatHistory
- 🏎️ **Soporte A2B**: Soporte para circuitos punto a punto con manejo especial para Nordschleife
- 🤬 **Filtro de palabrotas**: Filtro configurable con acciones de kick/ban
- 👤 **Mensajes configurables**: Los jugadores sin ptracker pueden deshabilitar mensajes
- ⏰ **Timestamps consistentes**: Corrección de timestamps con respeto de zona horaria
- 📊 **Filtrado de estadísticas**: Corrección de filtrado de tiempo en estadísticas de vueltas
- 🏁 **Clasificación qualify**: Corrección para coincidir con estilo AC
- 🚀 **PyInstaller**: Cambio de py2exe a pyinstaller en sistemas Windows

### [3.1.x Series] - 2016 (NEYS)

#### 3.1.x - Added
- 🔧 **Debugging mejorado**: Mejores posibilidades de depuración para ptracker-server.py
- 🔄 **Reemplazo pysqlite3**: Migración a apsw (cambio importante)
- 🎨 **Imágenes de neumáticos**: Nuevas imágenes con mejores colores visuales
- 🏎️ **División por cero A→B**: Corrección para circuitos punto a punto
- 💾 **Detección setup**: Carga y guardado de setups detectado nuevamente
- 📊 **Ranking combo**: Reporte de ranking combo para mejores personales/del servidor
- 🎮 **Gestión de sesiones**: Función de gestión de sesiones añadida
- 🔒 **Keep alive**: Conexiones TCP con keep_alive para evitar desconexiones inesperadas

### [3.0.x Series] - 2015-2016 (NEYS)

#### 3.0.x - Major Update
- 🆕 **DB Version 20**: Nueva versión de base de datos
- 🔌 **Nueva API AC**: Migración a nueva API del servidor AC (acplugins4python)
- 🚀 **Optimizaciones protocolo**: Optimizaciones stracker/ptracker - problemas de ancho de banda resueltos
- 🔄 **Reinicio independiente**: Servidores AC pueden reiniciarse independientemente de stracker
- 🔗 **Reconexión automática**: Reconexión automática de ptrackers tras reinicio de stracker
- ✅ **Validación server-side**: Cálculo del flag valid en servidor (requiere penalizaciones)
- 📈 **SQLite 3.08.11.1**: Actualización para mejor rendimiento
- 🏆 **Ranking de vueltas**: Incluir ranking de vuelta en mensajes de mejor vuelta
- 💥 **Invalidación por colisiones**: Opcionalmente invalidar vueltas con colisiones

### [2.8.x Series] - 2015 (NEYS)

#### 2.8.x - Added
- 🆕 **DB Version 19**: Nueva tabla Teams y columnas para Tracks/Cars
- 👥 **Teams → Drivers**: Renombrado "Players" a "Drivers" en salida HTTP
- 🎛️ **Configuraciones avanzadas**: Múltiples nuevas opciones de configuración
- 🏁 **Clasificaciones de equipos**: Gestión de equipos para campeonatos
- 📊 **Página de estadísticas**: Nueva página de estadísticas HTTP
- 🎨 **Banner configurable**: Imagen de banner configurable (por defecto logo AC)
- 🔧 **Datos UI AC**: Soporte para envío de datos UI de AC desde clientes admin
- 🏎️ **Visualización mejorada**: Mejores displays para circuitos y coches

### [2.6.x Series] - 2014-2015 (NEYS)

#### 2.6.x - Added
- 🏆 **Gestión de campeonatos**: Introducción de gestión de campeonatos HTTP
- 🔄 **Redirecciones HTTP**: Redirección HTTP tras modificar BD
- 🔍 **SEO**: Prevención de acceso de motores de búsqueda a páginas de estadísticas
- 💾 **Backup manual**: Opción de backup manual de BD a archivo db3
- 📋 **Generación entry_list**: Posibilidad de generar entry_list.ini desde área admin
- 🔧 **Configuraciones de circuitos**: Soporte para configuraciones de circuitos
- 🐧 **Soporte Linux**: Soporte nativo para Linux (experimental)
- ✅ **Checksums requeridos**: Soporte para checksums requeridos

### Versiones Anteriores (2.0.x - 2.5.x)

Las versiones anteriores incluían desarrollo fundamental de:
- Sistema básico de base de datos (schemas 1-16)
- Funcionalidades core de ptracker y stracker  
- Sistema HTTP básico
- Integración con Assetto Corsa
- Sistema de vueltas y telemetría
- Funcionalidades de chat y administración

---

## Información de Database Schemas

### Schema Versions Evolution
- **v24**: Anonimización Steam IDs (GDPR)
- **v23**: Cache Minorating
- **v22**: ChatHistory, ballast, separación HistoryInfo
- **v21**: Información combo en sesión, vista live con mapa/ranking
- **v20**: Cuts, colisiones, grip level, whitelist
- **v19**: Datos UI para tracks/cars, teams
- **v18**: Tabla Teams
- **v17**: Renombrado vallelunga tracks
- **v16**: Índices únicos para championship point schemas
- **v15**: Columnas championship adicionales
- **v14**: Championship management (CSSeasons, CSEvent, etc.)
- **v13**: Vista BlacklistedPlayers
- **v12**: Grupos de jugadores, depósito de setups
- **v11**: Aids en tabla Lap
- **v10**: Timestamps, columna IsOnline
- **v9**: Vista BestLapsByLapCount
- **v8**: Session aids, temperaturas
- **v7**: TyreCompounds en vista LapTimes  
- **v6**: Validación plausibilidad
- **v5**: SectorsAreSoftSplits
- **v4**: Separación Tracks/Cars de Combos
- **v3**: Nueva estructura session/playerinsession
- **v2**: Columnas adicionales en Combos/Hotlaps
- **v1**: Schema inicial

---

## Mantenedores

### Histórico
- **NEYS (Original)**: Desarrollo principal hasta versión 3.5.0
- **DocWilco (2021)**: Mantenimiento y mejoras (versión 3.5.1)
- **rodrigoangeloni (2025-actual)**: Mantenimiento actual continuando desde 3.5.2

### Contribuciones Especiales
- **@Laurent81**: Iconos de ayudas actualizados
- **@maxator**: Soporte HTTPS y actualización CherryPy
- **Minolin**: Permiso y soporte para integración Minorating

---

## Licencia

GNU General Public License v3.0 - Ver [LICENSE.txt](LICENSE.txt) para más detalles.

---

*Este changelog ha sido reconstruido a partir del análisis del código fuente, documentación HTML, historial de commits y estructura del proyecto. Algunas fechas y detalles menores pueden ser aproximados basándose en la información disponible.*
