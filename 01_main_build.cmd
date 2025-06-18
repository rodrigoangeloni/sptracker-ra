@echo off
chcp 65001 >nul 2>&1
REM =============================================================================
REM Script Maestro de Compilación Completa - sptracker
REM =============================================================================
REM
REM Este script compila TODOS los binarios necesarios para distribución completa:
REM 
REM WINDOWS (ptracker + stracker + stracker-packager):
REM   - Windows 32-bit: ptracker.exe, stracker.exe, stracker-packager.exe
REM   - Windows 64-bit: ptracker.exe, stracker.exe, stracker-packager.exe
REM
REM LINUX (solo stracker):
REM   - Linux 32-bit: stracker
REM   - Linux 64-bit: stracker
REM
REM ARM (solo stracker):
REM   - ARM 32-bit: stracker
REM   - ARM 64-bit: stracker
REM
REM Uso: build_complete.cmd [version]
REM Ejemplo: build_complete.cmd 3.5.2
REM =============================================================================

setlocal enabledelayedexpansion

REM Configuración
set SCRIPT_NAME=🚀 BUILD COMPLETE SPTRACKER 🚀
set TOTAL_STEPS=7
set CURRENT_STEP=0

REM Variables de control de compilación
set COMPILED_PTRACKER=0
set COMPILED_STRACKER_64=0
set COMPILED_STRACKER_32=0
set COMPILED_PACKAGER=0

REM Variables para diferenciar arquitecturas de compilación
set COMPILED_PTRACKER_32=0
set COMPILED_PTRACKER_64=0
set COMPILED_PACKAGER_32=0
set COMPILED_PACKAGER_64=0

echo.
echo =============================================================================
echo %SCRIPT_NAME%
echo =============================================================================
echo.
echo 📋 COMPILACION COMPLETA MULTIPLATAFORMA Y MULTI-ARQUITECTURA
echo.
echo 🎯 OBJETIVO: Generar todos los binarios para distribución^:
echo    📦 Windows 32/64: TODOS los ejecutables (opción 1-2)
echo    🖥️  Solo stracker: servidor únicamente (opción 3-8)
echo    🐧 Linux 32/64: solo stracker
echo    🤖 ARM 32/64: solo stracker
echo.
echo ⚙️  ESTRATEGIA^:
echo    🪟 Windows: Compilación nativa (create_release.py)
echo    🐧 Linux: Docker Desktop (Dockerfiles Linux32/64)  
echo    🤖 ARM: Docker Desktop + QEMU (Dockerfiles ARM32/64)
echo.
echo ⏱️  TIEMPO ESTIMADO: 30-45 minutos
echo.

REM Obtener versión
if "%1"=="" (
    set /p VERSION="🔢 Introduce la versión a compilar (ej: 3.5.2): "
) else (
    set VERSION=%1
)

if "%VERSION%"=="" (
    echo ❌ Error: Versión requerida
    pause
    exit /b 1
)

echo ✅ Versión a compilar: %VERSION%
echo.

REM Menú de opciones de compilación
echo 📋 OPCIONES DE COMPILACIÓN^:
echo =============================
echo.
echo 🪟 WINDOWS COMPLETO (ptracker + stracker + stracker-packager)^:
echo    1. Windows 64-bit: TODOS los ejecutables
echo    2. Windows 32-bit: TODOS los ejecutables
echo.
echo 🖥️ SOLO STRACKER (servidor únicamente)^:
echo    3. Solo stracker Windows 64-bit
echo    4. Solo stracker Windows 32-bit
echo    5. Solo stracker Linux 64-bit (Docker)
echo    6. Solo stracker Linux 32-bit (Docker)
echo    7. Solo stracker ARM 32-bit (Docker)
echo    8. Solo stracker ARM 64-bit (Docker)
echo.
echo 🚀 COMPILACIÓN MASIVA^:
echo    9. TODOS - Windows (64-bit y 32-bit)
echo    10. TODOS - Linux (64-bit y 32-bit vía Docker)
echo    11. TODOS - ARM (ARM32 y ARM64 vía Docker)
echo    12. COMPLETO - TODOS los binarios (Windows + Linux + ARM)
echo.

set /p CHOICE="🔢 Elige una opción (1-12): "

if "%CHOICE%"=="1" goto WINDOWS_64_FULL
if "%CHOICE%"=="2" goto WINDOWS_32_FULL
if "%CHOICE%"=="3" goto STRACKER_WIN64_ONLY
if "%CHOICE%"=="4" goto STRACKER_WIN32_ONLY
if "%CHOICE%"=="5" goto STRACKER_LINUX64_ONLY
if "%CHOICE%"=="6" goto STRACKER_LINUX32_ONLY
if "%CHOICE%"=="7" goto STRACKER_ARM32_ONLY
if "%CHOICE%"=="8" goto STRACKER_ARM64_ONLY
if "%CHOICE%"=="9" goto BUILD_ALL_WINDOWS
if "%CHOICE%"=="10" goto BUILD_ALL_LINUX
if "%CHOICE%"=="11" goto BUILD_ALL_ARM
if "%CHOICE%"=="12" goto BUILD_ALL_COMPLETE

echo ❌ Opción no válida
goto END

REM =============================================================================
REM FUNCIONES ESPECÍFICAS POR OPCIÓN
REM =============================================================================

:WINDOWS_64_FULL
echo.
echo 🪟 COMPILANDO WINDOWS 64-BIT COMPLETO (TODOS los ejecutables)
echo ============================================================
call :COMPILE_WINDOWS_64_FULL
goto SUCCESS_COMPLETE

:WINDOWS_32_FULL
echo.
echo 🪟 COMPILANDO WINDOWS 32-BIT COMPLETO (TODOS los ejecutables)
echo ============================================================
call :COMPILE_WINDOWS_32_FULL
goto SUCCESS_COMPLETE

:STRACKER_WIN64_ONLY
echo.
echo 🖥️ COMPILANDO SOLO STRACKER WINDOWS 64-BIT
echo ==========================================
call :COMPILE_STRACKER_WIN64_ONLY
goto SUCCESS_COMPLETE

:STRACKER_WIN32_ONLY
echo.
echo 🖥️ COMPILANDO SOLO STRACKER WINDOWS 32-BIT
echo ==========================================
call :COMPILE_STRACKER_WIN32_ONLY
goto SUCCESS_COMPLETE

:STRACKER_LINUX64_ONLY
echo.
echo 🐧 COMPILANDO SOLO STRACKER LINUX 64-BIT (Docker)
echo ===============================================
call :COMPILE_STRACKER_LINUX64_ONLY
goto SUCCESS_COMPLETE

:STRACKER_LINUX32_ONLY
echo.
echo 🐧 COMPILANDO SOLO STRACKER LINUX 32-BIT (Docker)
echo ===============================================
call :COMPILE_STRACKER_LINUX32_ONLY
goto SUCCESS_COMPLETE

:STRACKER_ARM32_ONLY
echo.
echo 🤖 COMPILANDO SOLO STRACKER ARM 32-BIT (Docker Desktop)
echo ======================================================
call :COMPILE_STRACKER_ARM32_ONLY
goto SUCCESS_COMPLETE

:STRACKER_ARM64_ONLY
echo.
echo 🤖 COMPILANDO SOLO STRACKER ARM 64-BIT (Docker Desktop)
echo ======================================================
call :COMPILE_STRACKER_ARM64_ONLY
goto SUCCESS_COMPLETE

REM =============================================================================
REM IMPLEMENTACIONES DE COMPILACIÓN
REM =============================================================================

:COMPILE_WINDOWS_64_FULL
echo ⏳ Compilando Windows 64-bit COMPLETO (ptracker + stracker + stracker-packager)...
python create_release.py --windows_only --test_release_process %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación Windows 64-bit completo
    goto ERROR
)
set COMPILED_PTRACKER_64=1
set COMPILED_STRACKER_64=1
set COMPILED_PACKAGER_64=1
echo ✅ Windows 64-bit COMPLETO terminado
exit /b 0

:COMPILE_WINDOWS_32_FULL
echo ⏳ Compilando Windows 32-bit COMPLETO (ptracker + stracker + stracker-packager)...
python create_release.py --windows32_only --test_release_process %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación Windows 32-bit completo
    goto ERROR
)
set COMPILED_PTRACKER_32=1
set COMPILED_STRACKER_32=1
set COMPILED_PACKAGER_32=1
echo ✅ Windows 32-bit COMPLETO terminado
exit /b 0

:COMPILE_STRACKER_WIN64_ONLY
echo ⏳ Compilando solo stracker Windows 64-bit...
python create_release.py --stracker_only --windows_only %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación stracker Windows 64-bit
    goto ERROR
)
set COMPILED_STRACKER_64=1
echo ✅ Solo stracker Windows 64-bit terminado
exit /b 0

:COMPILE_STRACKER_WIN32_ONLY
echo ⏳ Compilando solo stracker Windows 32-bit...
python create_release.py --stracker_only --windows32_only %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación stracker Windows 32-bit
    goto ERROR
)
set COMPILED_STRACKER_32=1
echo ✅ Solo stracker Windows 32-bit terminado
exit /b 0

:COMPILE_STRACKER_LINUX64_ONLY
echo ⏳ Compilando solo stracker Linux 64-bit usando Docker Desktop...
echo 🐳 Verificando Docker Desktop...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Docker Desktop no está instalado o no se puede ejecutar
    echo 💡 Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop/
    goto ERROR
)
echo ✅ Docker Desktop disponible
echo 🔨 Construyendo imagen Docker Linux 64-bit (si es necesario)...
docker build -f Dockerfile.linux64 -t sptracker-linux64 .
if errorlevel 1 (
    echo ❌ Error en construcción de imagen Docker Linux 64-bit
    goto ERROR
)
echo � Ejecutando compilación Linux 64-bit en contenedor...
docker run --rm -v "%cd%\versions":/workspace/versions sptracker-linux64 %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación stracker Linux 64-bit
    goto ERROR
)
echo ✅ Solo stracker Linux 64-bit terminado
exit /b 0

:COMPILE_STRACKER_LINUX32_ONLY
echo ⏳ Compilando solo stracker Linux 32-bit usando Docker Desktop...
echo 🐳 Verificando Docker Desktop...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Docker Desktop no está instalado o no se puede ejecutar
    echo 💡 Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop/
    goto ERROR
)
echo ✅ Docker Desktop disponible
echo 🔨 Construyendo imagen Docker Linux 32-bit (si es necesario)...
docker build -f Dockerfile.linux32 -t sptracker-linux32 .
if errorlevel 1 (
    echo ❌ Error en construcción de imagen Docker Linux 32-bit
    goto ERROR
)
echo � Ejecutando compilación Linux 32-bit en contenedor...
docker run --rm -v "%cd%\versions":/app/versions sptracker-linux32 ./create_release_linux32.sh %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación stracker Linux 32-bit
    goto ERROR
)
echo ✅ Solo stracker Linux 32-bit terminado
exit /b 0

:COMPILE_STRACKER_ARM32_ONLY
echo ⏳ Compilando solo stracker ARM 32-bit usando Docker Desktop...
REM OPTIMIZACIÓN: Reutilizar imágenes Docker existentes para ahorrar tiempo
REM Las imágenes solo contienen el entorno (OS + Python + PyInstaller)
REM El código fuente se monta como volumen en tiempo de ejecución
echo 🐳 Verificando Docker Desktop...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error - Docker Desktop no está disponible
    echo 💡 Instala Docker Desktop y asegúrate de que esté ejecutándose
    goto ERROR
)

echo 🔍 Verificando imágenes Docker ARM32 disponibles...
set IMAGE_TAG=sptracker-arm32
set IMAGE_VERSION=%VERSION%

REM Primero buscar imagen latest (más eficiente)
docker images "!IMAGE_TAG!:latest" -q >nul 2>&1
if not errorlevel 1 (
    echo    ✅ Imagen !IMAGE_TAG!:latest encontrada - REUTILIZANDO
    echo    💡 Las imágenes Docker solo contienen el entorno, tu código se monta dinámicamente
    set "FINAL_IMAGE=!IMAGE_TAG!:latest"
    goto RUN_ARM32_CONTAINER
)

REM Si no hay latest, buscar versión específica
docker images "!IMAGE_TAG!:!IMAGE_VERSION!" -q >nul 2>&1
if not errorlevel 1 (
    echo    ✅ Imagen !IMAGE_TAG!:!IMAGE_VERSION! encontrada - REUTILIZANDO
    set "FINAL_IMAGE=!IMAGE_TAG!:!IMAGE_VERSION!"
    goto RUN_ARM32_CONTAINER
)

REM Si no hay ninguna imagen, construir latest
echo    ❌ No se encontró ninguna imagen ARM32, construyendo nueva...
set "FINAL_IMAGE=!IMAGE_TAG!:latest"

echo 📋 Información de debug:
echo    🎯 Dockerfile: Dockerfile.arm32
echo    🏷️  Tag objetivo: !FINAL_IMAGE!
echo    🔧 Builder: multiarch (con soporte ARM)
echo    🔧 Comando: docker buildx build --builder multiarch --platform linux/arm/v7 -f Dockerfile.arm32 -t !FINAL_IMAGE! . --load
echo.

docker buildx build --builder multiarch --platform linux/arm/v7 -f Dockerfile.arm32 -t "!FINAL_IMAGE!" . --load
if errorlevel 1 (
    echo ❌ Error en construcción de imagen Docker ARM32
    goto ERROR
)

:RUN_ARM32_CONTAINER
echo 🚀 Ejecutando compilación ARM32...
docker run --rm -v "%CD%\versions:/app/versions" "!FINAL_IMAGE!" %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación ARM32
    goto ERROR
)
echo ✅ Solo stracker ARM 32-bit terminado
exit /b 0

:COMPILE_STRACKER_ARM64_ONLY
echo ⏳ Compilando solo stracker ARM 64-bit usando Docker Desktop...
REM OPTIMIZACIÓN: Reutilizar imágenes Docker existentes para ahorrar tiempo
REM Las imágenes solo contienen el entorno (OS + Python + PyInstaller)
REM El código fuente se monta como volumen en tiempo de ejecución
echo 🐳 Verificando Docker Desktop...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error - Docker Desktop no está disponible
    echo 💡 Instala Docker Desktop y asegúrate de que esté ejecutándose
    goto ERROR
)

echo 🔍 Verificando imágenes Docker ARM64 disponibles...
set IMAGE_TAG=sptracker-arm64
set IMAGE_VERSION=%VERSION%

REM Primero buscar imagen latest (más eficiente)
docker images "!IMAGE_TAG!:latest" -q >nul 2>&1
if not errorlevel 1 (
    echo    ✅ Imagen !IMAGE_TAG!:latest encontrada - REUTILIZANDO
    echo    💡 Las imágenes Docker solo contienen el entorno, tu código se monta dinámicamente
    set "FINAL_IMAGE=!IMAGE_TAG!:latest"
    goto RUN_ARM64_CONTAINER
)

REM Si no hay latest, buscar versión específica
docker images "!IMAGE_TAG!:!IMAGE_VERSION!" -q >nul 2>&1
if not errorlevel 1 (
    echo    ✅ Imagen !IMAGE_TAG!:!IMAGE_VERSION! encontrada - REUTILIZANDO
    set "FINAL_IMAGE=!IMAGE_TAG!:!IMAGE_VERSION!"
    goto RUN_ARM64_CONTAINER
)

REM Si no hay ninguna imagen, construir latest
echo    ❌ No se encontró ninguna imagen ARM64, construyendo nueva...
set "FINAL_IMAGE=!IMAGE_TAG!:latest"

echo 📋 Información de debug:
echo    🎯 Dockerfile: Dockerfile.arm64
echo    🏷️  Tag objetivo: !FINAL_IMAGE!
echo    🔧 Builder: multiarch (con soporte ARM)
echo    🔧 Comando: docker buildx build --builder multiarch --platform linux/arm64 -f Dockerfile.arm64 -t !FINAL_IMAGE! . --load
echo.

docker buildx build --builder multiarch --platform linux/arm64 -f Dockerfile.arm64 -t "!FINAL_IMAGE!" . --load
if errorlevel 1 (
    echo ❌ Error en construcción de imagen Docker ARM64
    goto ERROR
)

:RUN_ARM64_CONTAINER
echo 🚀 Ejecutando compilación ARM64...
docker run --rm -v "%CD%\versions:/app/versions" "!FINAL_IMAGE!" %VERSION%
if errorlevel 1 (
    echo ❌ Error en compilación ARM64
    goto ERROR
)
echo ✅ Solo stracker ARM 64-bit terminado
exit /b 0

REM =============================================================================
REM LIMPIAR Y ORGANIZAR NOMENCLATURA
REM =============================================================================
:SUCCESS_COMPLETE
echo.
echo 🗂️ ORGANIZANDO ARCHIVOS CON NOMENCLATURA ESTANDARIZADA...
echo ===========================================================

REM Crear directorio final si no existe
if not exist "versions" mkdir versions

echo 📋 APLICANDO NOMENCLATURA ESTÁNDAR^:
echo    Windows^: componente-v%VERSION%-win32/win64.exe
echo    Linux^:   componente-v%VERSION%-linux32/linux64.tgz  
echo    ARM^:     componente-v%VERSION%-arm32/arm64.tgz
echo.

REM =============================================================================
REM VERIFICAR ARCHIVOS PRINCIPALES GENERADOS
REM =============================================================================
echo 📦 Verificando archivos principales Windows...

REM Verificar instalador ptracker (ya con nomenclatura correcta)
if %COMPILED_PTRACKER_64%==1 (
    if exist "versions\ptracker-v%VERSION%-win64-installer.exe" (
        echo    ✅ ptracker-v%VERSION%-win64-installer.exe
    )
) else if %COMPILED_PTRACKER_32%==1 (
    if exist "versions\ptracker-v%VERSION%-win32-installer.exe" (
        echo    ✅ ptracker-v%VERSION%-win32-installer.exe
    )
) else (
    if exist "versions\ptracker-v%VERSION%-installer.exe" (
        echo    ✅ ptracker-v%VERSION%-installer.exe
    )
)

REM Verificar archivos stracker (ya tienen nomenclatura correcta)
if exist "versions\stracker-v%VERSION%-win32-complete.zip" (
    echo    ✅ stracker-v%VERSION%-win32-complete.zip
)
if exist "versions\stracker-v%VERSION%-win64-complete.zip" (
    echo    ✅ stracker-v%VERSION%-win64-complete.zip
)

REM Solo renombrar stracker antiguo si no existe ningún archivo nuevo
if exist "versions\stracker-V%VERSION%.zip" (
    if not exist "versions\stracker-v%VERSION%-win64-complete.zip" (
        if not exist "versions\stracker-v%VERSION%-win32-complete.zip" (
            move "versions\stracker-V%VERSION%.zip" "versions\stracker-v%VERSION%-complete.zip" >nul 2>&1
            echo    ✅ stracker-v%VERSION%-complete.zip (renombrado por compatibilidad)
        )
    )
)

REM =============================================================================
REM LINUX BINARIOS
REM =============================================================================
echo 🐧 Organizando binarios Linux...

REM Buscar y renombrar archivos Linux con diferentes nombres posibles
for %%f in (
    "versions\stracker_linux_x64.tgz"
    "versions\stracker_linux_x86.tgz" 
    "versions\stracker-linux-x64.tgz"
    "versions\stracker-linux64.tgz"
    "stracker\stracker_linux_x64.tgz"
    "stracker\stracker_linux_x86.tgz"
    "stracker\stracker-linux-x64.tgz"
    "stracker\stracker-linux64.tgz"
) do (
    if exist "%%f" (
        if not exist "versions\stracker-v%VERSION%-linux64.tgz" (
            move "%%f" "versions\stracker-v%VERSION%-linux64.tgz" >nul 2>&1
            echo    ✅ stracker-v%VERSION%-linux64.tgz
        )
    )
)

for %%f in (
    "versions\stracker_linux_x86_32.tgz"
    "versions\stracker_linux_i386.tgz"
    "versions\stracker-linux-x86.tgz"
    "versions\stracker-linux32.tgz"
    "stracker\stracker_linux_x86_32.tgz"
    "stracker\stracker_linux_i386.tgz"
    "stracker\stracker-linux-x86.tgz"
    "stracker\stracker-linux32.tgz"
) do (
    if exist "%%f" (
        if not exist "versions\stracker-v%VERSION%-linux32.tgz" (
            move "%%f" "versions\stracker-v%VERSION%-linux32.tgz" >nul 2>&1
            echo    ✅ stracker-v%VERSION%-linux32.tgz
        )
    )
)

REM =============================================================================
REM ARM BINARIOS
REM =============================================================================
echo 🤖 Organizando binarios ARM...

for %%f in (
    "versions\stracker_linux_arm64.tgz"
    "versions\stracker-arm64.tgz"
    "versions\stracker_arm64.tgz"
) do (
    if exist "%%f" (
        if not exist "versions\stracker-v%VERSION%-arm64.tgz" (
            move "%%f" "versions\stracker-v%VERSION%-arm64.tgz" >nul 2>&1
            echo    ✅ stracker-v%VERSION%-arm64.tgz
        )
    )
)

for %%f in (
    "versions\stracker_linux_arm32.tgz"
    "versions\stracker-arm32.tgz"
    "versions\stracker_arm32.tgz"
) do (
    if exist "%%f" (
        if not exist "versions\stracker-v%VERSION%-arm32.tgz" (
            move "%%f" "versions\stracker-v%VERSION%-arm32.tgz" >nul 2>&1
            echo    ✅ stracker-v%VERSION%-arm32.tgz
        )
    )
)

echo.
echo ✅ Nomenclatura estandarizada completada
echo    📁 Todos los archivos en: versions\
echo    📝 Formato: componente-v[VERSION]-[ARQUITECTURA]-[TIPO].ext
echo.
echo.
echo =============================================================================
echo ✅ 🎉 COMPILACION COMPLETA EXITOSA 🎉 ✅
echo =============================================================================
echo.
echo 📦 RESUMEN DE ARCHIVOS GENERADOS (nomenclatura estandarizada):
echo.

if exist versions\ (
    echo 🪟 WINDOWS^:
    echo    📦 INSTALADORES Y PAQUETES^:
    for %%f in (versions\ptracker-v%VERSION%-installer.exe) do echo       ✅ %%~nxf
    for %%f in (versions\stracker-v%VERSION%-win*-complete.zip) do echo       ✅ %%~nxf
    for %%f in (versions\stracker-v%VERSION%-complete.zip) do echo       ✅ %%~nxf
    echo.
    
    echo 🐧 LINUX ^(solo stracker^)^:
    for %%f in (versions\stracker-v%VERSION%-linux*.tgz) do echo       ✅ %%~nxf
    echo.
    
    echo 🤖 ARM ^(solo stracker^)^:
    for %%f in (versions\stracker-v%VERSION%-arm*.tgz) do echo       ✅ %%~nxf
    echo.
    
) else (
    echo ❌ Directorio versions/ no existe o está vacío
)

echo.
echo 🎯 DISTRIBUCIÓN RECOMENDADA^:
echo    🏎️  Usuarios finales^: ptracker-v%VERSION%-installer.exe
echo    🖥️  Servidores Windows^: stracker-v%VERSION%-win*-complete.zip
echo    🐧 Servidores Linux^: stracker-v%VERSION%-linux*.tgz
echo    🤖 Servidores ARM^: stracker-v%VERSION%-arm*.tgz
echo.
echo ⚙️  COMPONENTES INCLUIDOS^:
echo    📦 ptracker-installer.exe^: App completa para Assetto Corsa (instalador NSIS)
echo    📦 stracker-complete.zip^: Servidor + packager + documentación + scripts
echo.
echo 📝 NOMENCLATURA SIMPLIFICADA^:
echo    📌 ptracker-v[VERSION]-[ARCH]-installer.exe (instalador completo)
echo    📌 stracker-v[VERSION]-[ARCH]-complete.zip (paquete servidor)
echo    📌 stracker-v[VERSION]-[ARCH].tgz (Linux/ARM)
echo.
echo 🎉 ¡COMPILACION SIMPLIFICADA - SOLO ARCHIVOS NECESARIOS!
echo.
goto END

REM =============================================================================
REM FUNCIONES DE COMPILACIÓN MASIVA
REM =============================================================================

:BUILD_ALL_WINDOWS
echo.
echo 🪟 COMPILACIÓN MASIVA - TODOS LOS BINARIOS WINDOWS (64-bit y 32-bit)
echo =================================================================
echo.
echo 📋 Secuencia de compilación:
echo    1. Windows 64-bit completo
echo    2. Windows 32-bit completo
echo.
echo ⏱️ Tiempo estimado: 10-15 minutos
echo.
echo 🚀 Iniciando compilación en secuencia...
echo.

call :PRINT_STEP "Windows 64-bit completo" "ptracker + stracker + packager (64-bit)"
call :COMPILE_WINDOWS_64_FULL
if errorlevel 1 goto ERROR

call :PRINT_STEP "Windows 32-bit completo" "ptracker + stracker + packager (32-bit)"
call :COMPILE_WINDOWS_32_FULL
if errorlevel 1 goto ERROR

echo.
echo ✅ COMPILACIÓN MASIVA WINDOWS COMPLETADA
goto SUCCESS_COMPLETE

:BUILD_ALL_LINUX
echo.
echo 🐧 COMPILACIÓN MASIVA - TODOS LOS BINARIOS LINUX (64-bit y 32-bit)
echo ===============================================================
echo.
echo 📋 Secuencia de compilación:
echo    1. Linux 64-bit (Docker)
echo    2. Linux 32-bit (Docker)
echo.
echo ⏱️ Tiempo estimado: 15-25 minutos
echo.
echo 🚀 Iniciando compilación en secuencia...
echo.

call :PRINT_STEP "Linux 64-bit (Docker)" "stracker (64-bit)"
call :COMPILE_STRACKER_LINUX64_ONLY
if errorlevel 1 goto ERROR

call :PRINT_STEP "Linux 32-bit (Docker)" "stracker (32-bit)"
call :COMPILE_STRACKER_LINUX32_ONLY
if errorlevel 1 goto ERROR

echo.
echo ✅ COMPILACIÓN MASIVA LINUX COMPLETADA
goto SUCCESS_COMPLETE

:BUILD_ALL_ARM
echo.
echo 🤖 COMPILACIÓN MASIVA - TODOS LOS BINARIOS ARM (32-bit y 64-bit)
echo ==============================================================
echo.
echo 📋 Secuencia de compilación:
echo    1. ARM 32-bit (Docker)
echo    2. ARM 64-bit (Docker)
echo.
echo ⏱️ Tiempo estimado: 10-15 minutos
echo.
echo 🚀 Iniciando compilación en secuencia...
echo.

call :PRINT_STEP "ARM 32-bit (Docker)" "stracker (arm32)"
call :COMPILE_STRACKER_ARM32_ONLY
if errorlevel 1 goto ERROR

call :PRINT_STEP "ARM 64-bit (Docker)" "stracker (arm64)"
call :COMPILE_STRACKER_ARM64_ONLY
if errorlevel 1 goto ERROR

echo.
echo ✅ COMPILACIÓN MASIVA ARM COMPLETADA
goto SUCCESS_COMPLETE

:BUILD_ALL_COMPLETE
echo.
echo 🌟 COMPILACIÓN COMPLETA - TODOS LOS BINARIOS (Windows + Linux + ARM)
echo =================================================================
echo.
echo 📋 Secuencia de compilación:
echo    1. Windows 64-bit completo
echo    2. Windows 32-bit completo
echo    3. Linux 64-bit (WSL)
echo    4. Linux 32-bit (WSL)
echo    5. ARM 32-bit (Docker)
echo    6. ARM 64-bit (Docker)
echo.
echo ⏱️ Tiempo estimado: 30-45 minutos
echo.
echo 🚀 Iniciando compilación en secuencia...
echo.

call :PRINT_STEP "Windows 64-bit completo" "ptracker + stracker + packager (64-bit)"
call :COMPILE_WINDOWS_64_FULL
if errorlevel 1 goto ERROR

call :PRINT_STEP "Windows 32-bit completo" "ptracker + stracker + packager (32-bit)"
call :COMPILE_WINDOWS_32_FULL
if errorlevel 1 goto ERROR

call :PRINT_STEP "Linux 64-bit (WSL)" "stracker (64-bit)"
call :COMPILE_STRACKER_LINUX64_ONLY
if errorlevel 1 goto ERROR

call :PRINT_STEP "Linux 32-bit (WSL)" "stracker (32-bit)"
call :COMPILE_STRACKER_LINUX32_ONLY
if errorlevel 1 goto ERROR

call :PRINT_STEP "ARM 32-bit (Docker)" "stracker (arm32)"
call :COMPILE_STRACKER_ARM32_ONLY
if errorlevel 1 goto ERROR

call :PRINT_STEP "ARM 64-bit (Docker)" "stracker (arm64)"
call :COMPILE_STRACKER_ARM64_ONLY
if errorlevel 1 goto ERROR

echo.
echo ✅ COMPILACIÓN COMPLETA FINALIZADA - TODOS LOS BINARIOS GENERADOS
goto SUCCESS_COMPLETE

:SUCCESS_COMPLETE
echo.
echo =============================================================================
echo ✅ COMPILACIÓN EXITOSA
echo =============================================================================
echo.
goto RENAME_GENERATED_FILES

:RENAME_GENERATED_FILES
echo.
echo =============================================================================
echo 🏷️ ESTANDARIZANDO NOMENCLATURA DE ARCHIVOS GENERADOS
echo =============================================================================
echo.

:ERROR
echo.
echo =============================================================================
echo ❌ ERROR DURANTE LA COMPILACION
echo =============================================================================
echo.
echo 🔍 Revisa los mensajes anteriores para más detalles sobre el error.
echo.
echo 💡 SOLUCIONES COMUNES^:
echo    🐍 Verificar que Python esté instalado y en PATH
echo    🔧 Verificar que WSL Debian esté configurado
echo    🐳 Verificar que Docker Desktop esté ejecutándose
echo    📂 Verificar permisos de escritura en directorio versions/
echo    🌐 Verificar conexión a internet para Docker
echo.
echo 🔄 Para reintentar^:
echo    "%~nx0" %VERSION%
echo.
pause
exit /b 1

REM =============================================================================
REM FUNCIONES AUXILIARES
REM =============================================================================

:TOLOWER
set %2=%1
if "%1"=="A" set %2=a
if "%1"=="B" set %2=b
if "%1"=="C" set %2=c
if "%1"=="D" set %2=d
if "%1"=="E" set %2=e
if "%1"=="F" set %2=f
if "%1"=="G" set %2=g
if "%1"=="H" set %2=h
if "%1"=="I" set %2=i
if "%1"=="J" set %2=j
if "%1"=="K" set %2=k
if "%1"=="L" set %2=l
if "%1"=="M" set %2=m
if "%1"=="N" set %2=n
if "%1"=="O" set %2=o
if "%1"=="P" set %2=p
if "%1"=="Q" set %2=q
if "%1"=="R" set %2=r
if "%1"=="S" set %2=s
if "%1"=="T" set %2=t
if "%1"=="U" set %2=u
if "%1"=="V" set %2=v
if "%1"=="W" set %2=w
if "%1"=="X" set %2=x
if "%1"=="Y" set %2=y
if "%1"=="Z" set %2=z
exit /b 0

:PRINT_STEP
set /a CURRENT_STEP+=1
echo.
echo =============================================================================
echo 📍 PASO %CURRENT_STEP%/%TOTAL_STEPS%: %~1
echo =============================================================================
echo 🎯 Compilando: %~2
echo ⏱️  Progreso: %CURRENT_STEP% de %TOTAL_STEPS% pasos completados
exit /b 0

:END
echo.
echo 👋 Script completado
echo 📅 %DATE% %TIME%
exit /b 0
