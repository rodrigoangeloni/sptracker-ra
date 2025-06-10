@echo off
setlocal EnableDelayedExpansion
REM Cambiar la página de códigos a UTF-8 para correcta visualización de caracteres
chcp 65001 >nul

REM Script para compilación ARM usando Docker Desktop en Windows
REM ============================================================
REM 
REM Este script compila sptracker para ARM32/ARM64 usando Docker Desktop
REM con emulación QEMU directamente desde Windows (no WSL).
REM
REM Requisitos:
REM - Docker Desktop en Windows con emulación habilitada
REM - QEMU para emulación ARM

echo.
echo ===============================================================
REM Usar PowerShell para el título principal para mejor manejo de UTF-8 en consolas PowerShell
powershell -Command "Write-Host '🤖 COMPILACION ARM USANDO DOCKER DESKTOP EN WINDOWS 🤖'"
echo ===============================================================
echo.

REM Verificar Docker Desktop
echo 📋 Verificando Docker Desktop...
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Docker Desktop no está disponible
    echo    Asegúrate de que Docker Desktop esté ejecutándose
    pause
    exit /b 1
)

echo ✅ Docker Desktop disponible

REM Verificar emulación ARM
echo 📋 Verificando soporte de emulación ARM...
docker buildx ls | findstr "linux/arm" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Configurando emulación ARM...
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    if errorlevel 1 (
        echo ❌ Error configurando emulación ARM
        pause
        exit /b 1
    )
)

echo ✅ Emulación ARM disponible

REM Limpiar builds anteriores
echo 📋 Limpiando builds anteriores...
docker system prune -f >nul 2>&1

REM Verificar contexto y tamaño
echo 📋 Verificando contexto de build...
if not exist .dockerignore (
    echo ❌ Error: .dockerignore no encontrado
    echo    El contexto podría ser muy grande
    pause
    exit /b 1
)

echo ✅ .dockerignore encontrado

REM Mostrar versión a compilar
set /p VERSION="🔢 Introduce la versión a compilar (ej: 3.5.2): "
if "%VERSION%"=="" (
    echo ❌ Error: Versión requerida
    pause
    exit /b 1
)

echo.
echo 📋 RESUMEN DE COMPILACION ARM
echo --------------------------------
echo 🎯 Versión: %VERSION%
echo 🐳 Entorno: Docker Desktop Windows + QEMU
echo 🏗️  Arquitecturas: ARM32 + ARM64
echo ⏱️  Tiempo estimado: 15-20 minutos
echo.

set /p CONFIRM="✅ ¿Continuar? (S/n): "
if /i "%CONFIRM%"=="n" (
    echo ❌ Compilación cancelada
    pause
    exit /b 0
)

echo.
echo 🚀 INICIANDO COMPILACION ARM32...
echo ==================================

REM Build ARM32
echo ⏳ Compilando ARM32...
docker build ^
    -f Dockerfile.arm32 ^
    -t sptracker-arm32:%VERSION% ^
    --platform linux/arm/v7 ^
    --progress=plain ^
    --build-arg VERSION=%VERSION% ^
    . 2>&1

if errorlevel 1 (
    echo ❌ Error en compilación ARM32
    pause
    exit /b 1
)

echo ✅ ARM32 compilado exitosamente

REM Extraer archivos ARM32
echo 📦 Extrayendo archivos ARM32...
REM Crear un directorio de versiones en el host si no existe
if not exist "%CD%\versions" mkdir "%CD%\versions"

REM Ejecutar el contenedor para que el ENTRYPOINT compile y coloque los archivos en /app/versions
REM Le damos un nombre para poder usar docker cp luego.
set ARM32_CONTAINER_NAME=sptracker-arm32-builder-%VERSION%
docker run --name %ARM32_CONTAINER_NAME% ^
    sptracker-arm32:%VERSION%

REM Verificar si el contenedor se ejecutó correctamente (esto es opcional, docker cp fallará si no)
if errorlevel 1 (
    echo ❌ Error ejecutando el contenedor de compilación ARM32.
    docker rm %ARM32_CONTAINER_NAME% >nul 2>&1
    pause
    exit /b 1
)

REM Copiar los artefactos desde /app/versions/ del contenedor al directorio versions del host
echo 📤 Copiando artefactos desde el contenedor %ARM32_CONTAINER_NAME%:/app/versions/...
docker cp %ARM32_CONTAINER_NAME%:/app/versions/. "%CD%\versions"

if errorlevel 1 (
    echo ❌ Error copiando artefactos desde el contenedor ARM32.
    echo    Verifica que los archivos existen en /app/versions/ dentro del contenedor.
    docker rm %ARM32_CONTAINER_NAME% >nul 2>&1
    pause
    exit /b 1
) else (
    echo ✅ Artefactos ARM32 copiados a "%CD%\versions\"
)

REM Limpiar el contenedor nombrado
docker rm %ARM32_CONTAINER_NAME% >nul 2>&1

echo.
echo 🚀 INICIANDO COMPILACION ARM64...
echo ==================================
echo ⏳ Compilando ARM64...
docker buildx build --platform linux/arm64 -t sptracker-arm64:%VERSION% -f Dockerfile.arm64 . --load

if errorlevel 1 (
    echo ❌ Error en compilación ARM64
    pause
    exit /b 1
)

echo ✅ ARM64 compilado exitosamente

REM Extraer archivos ARM64
echo 📦 Extrayendo archivos ARM64...
REM Crear un directorio de versiones en el host si no existe (aunque ya debería existir por ARM32)
if not exist "%CD%\\versions" mkdir "%CD%\\versions"

REM Ejecutar el contenedor para que el ENTRYPOINT compile y coloque los archivos en /app/versions
REM Le damos un nombre para poder usar docker cp luego.
set ARM64_CONTAINER_NAME=sptracker-arm64-builder-%VERSION%
echo  запускаю контейнер %ARM64_CONTAINER_NAME% из образа sptracker-arm64:%VERSION%
REM docker run --name %ARM64_CONTAINER_NAME% ^
REM     sptracker-arm64:%VERSION%

REM Ejecutar en modo interactivo para depuración si falla la copia
docker run -d --name %ARM64_CONTAINER_NAME% sptracker-arm64:%VERSION% sleep infinity

REM Dar tiempo al contenedor para que inicie y posiblemente falle si el entrypoint es el problema
timeout /t 5 >nul

REM Intentar ejecutar el script de compilación manualmente si existe
echo ⏳ Intentando ejecutar el script de compilación dentro del contenedor...
docker exec %ARM64_CONTAINER_NAME% sh -c "if [ -x /app/create_release_arm64.sh ]; then /app/create_release_arm64.sh %VERSION%; elif [ -x /app/create_release.sh ]; then /app/create_release.sh --arm64_only %VERSION%; else echo 'No se encontró script de compilación arm64.'; exit 1; fi"

if errorlevel 1 (
    echo ❌ Error ejecutando el script de compilación dentro del contenedor ARM64.
    echo    Mostrando logs del contenedor %ARM64_CONTAINER_NAME%:
    docker logs %ARM64_CONTAINER_NAME%
    echo    Contenido de /app/ en el contenedor %ARM64_CONTAINER_NAME%:
    docker exec %ARM64_CONTAINER_NAME% ls -la /app
    docker rm -f %ARM64_CONTAINER_NAME% >nul 2>&1
    pause
    exit /b 1
)

REM Copiar los artefactos desde /app/versions/ del contenedor al directorio versions del host
echo 📤 Copiando artefactos desde el contenedor %ARM64_CONTAINER_NAME%:/app/versions/...
docker cp %ARM64_CONTAINER_NAME%:/app/versions/. "%CD%\\versions"

if errorlevel 1 (
    echo ❌ Error copiando artefactos desde el contenedor ARM64.
    echo    Verifica que los archivos existen en /app/versions/ dentro del contenedor.
    echo    Mostrando logs del contenedor %ARM64_CONTAINER_NAME%:
    docker logs %ARM64_CONTAINER_NAME%
    echo    Contenido de /app/ en el contenedor %ARM64_CONTAINER_NAME%:
    docker exec %ARM64_CONTAINER_NAME% ls -la /app
    echo    Contenido de /app/versions/ en el contenedor %ARM64_CONTAINER_NAME%:
    docker exec %ARM64_CONTAINER_NAME% ls -la /app/versions
    docker rm %ARM64_CONTAINER_NAME% >nul 2>&1
    pause
    exit /b 1
) else (
    echo ✅ Artefactos ARM64 copiados a "%CD%\\versions\\"
)

REM Limpiar el contenedor nombrado
docker rm %ARM64_CONTAINER_NAME% >nul 2>&1

echo.
echo 🎉 COMPILACION ARM64 COMPLETADA 🎉
goto arm_build_success

:end_error
echo.
echo ===============================================================
echo ❌ ERROR EN LA COMPILACION ARM
echo ===============================================================
echo.
echo 📦 Archivos generados en versions/:
if exist versions\ (
    dir versions\*.tgz /b 2>nul | findstr arm
    if errorlevel 1 (
        echo    (No se encontraron archivos ARM)
    )
) else (
    echo    (Directorio versions/ no existe)
)

echo.
echo 🏁 Compilación ARM completada usando Docker Desktop Windows
echo ⚙️  Emulación: QEMU en Docker Desktop
echo 📍 Archivos: versions\stracker_linux_arm*.tgz
echo.

pause
exit /b 0

:arm_build_success
echo.
echo ===============================================================
echo ✅ COMPILACION ARM COMPLETADA
echo ===============================================================
echo.
echo 📦 Archivos generados en versions/:
if exist versions\ (
    dir versions\*.tgz /b 2>nul | findstr arm
    if errorlevel 1 (
        echo    (No se encontraron archivos ARM)
    )
) else (
    echo    (Directorio versions/ no existe)
)

echo.
echo 🏁 Compilación ARM completada usando Docker Desktop Windows
echo ⚙️  Emulación: QEMU en Docker Desktop
echo 📍 Archivos: versions\stracker_linux_arm*.tgz
echo.

pause
