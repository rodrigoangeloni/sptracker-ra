@echo off
REM Script maestro de compilación multiplataforma para sptracker
REM ==========================================================
REM
REM Este script coordina las compilaciones según la estrategia optimizada:
REM - Windows: Compilación nativa
REM - Linux: WSL nativo (sin Docker)  
REM - ARM: Docker Desktop con emulación QEMU
REM
REM Uso: compile_all.cmd [version]

setlocal enabledelayedexpansion

echo.
echo ===============================================================
echo 🚀 COMPILACION MULTIPLATAFORMA SPTRACKER 🚀
echo ===============================================================
echo.
echo Estrategia optimizada:
echo   🪟 Windows: Compilación nativa
echo   🐧 Linux: WSL nativo (sin Docker)
echo   🤖 ARM: Docker Desktop + QEMU emulación
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

REM Menú de opciones
echo.
echo 📋 OPCIONES DE COMPILACION:
echo ----------------------------
echo 1. 🌐 Compilación completa (Windows + Linux + ARM)
echo 2. 🪟 Solo Windows (nativo)
echo 3. 🐧 Solo Linux (WSL nativo)
echo 4. 🤖 Solo ARM (Docker Desktop)
echo 5. 📦 Usar interactive_builder.py (interfaz completa)
echo.

set /p CHOICE="Elige una opción (1-5): "

if "%CHOICE%"=="1" goto COMPILE_ALL
if "%CHOICE%"=="2" goto COMPILE_WINDOWS
if "%CHOICE%"=="3" goto COMPILE_LINUX
if "%CHOICE%"=="4" goto COMPILE_ARM
if "%CHOICE%"=="5" goto INTERACTIVE
echo ❌ Opción no válida
pause
exit /b 1

:COMPILE_ALL
echo.
echo 🌐 COMPILACION COMPLETA
echo =======================
echo ⏱️  Tiempo estimado total: 20-25 minutos
echo.

set /p CONFIRM="✅ ¿Continuar con compilación completa? (S/n): "
if /i "%CONFIRM%"=="n" goto END

echo.
echo 🪟 Compilando Windows...
call :COMPILE_WINDOWS_INTERNAL
if errorlevel 1 goto ERROR

echo.
echo 🐧 Compilando Linux...
call :COMPILE_LINUX_INTERNAL
if errorlevel 1 goto ERROR

echo.
echo 🤖 Compilando ARM...
call :COMPILE_ARM_INTERNAL
if errorlevel 1 goto ERROR

goto SUCCESS_ALL

:COMPILE_WINDOWS
echo.
echo 🪟 COMPILACION WINDOWS NATIVA
echo =============================
call :COMPILE_WINDOWS_INTERNAL
if errorlevel 1 goto ERROR
goto SUCCESS

:COMPILE_LINUX
echo.
echo 🐧 COMPILACION LINUX WSL NATIVO
echo ===============================
call :COMPILE_LINUX_INTERNAL
if errorlevel 1 goto ERROR
goto SUCCESS

:COMPILE_ARM
echo.
echo 🤖 COMPILACION ARM DOCKER DESKTOP
echo =================================
call :COMPILE_ARM_INTERNAL
if errorlevel 1 goto ERROR
goto SUCCESS

:INTERACTIVE
echo.
echo 📦 Ejecutando interactive_builder.py...
python interactive_builder.py
goto END

REM Funciones internas
:COMPILE_WINDOWS_INTERNAL
echo ⏳ Compilando Windows usando create_release.py...
python create_release.py --windows_only --test_release_process %VERSION%
exit /b %ERRORLEVEL%

:COMPILE_LINUX_INTERNAL
echo ⏳ Compilando Linux usando WSL nativo...
wsl -d Debian -- bash -c "cd /mnt/e/vscode-workspace/sptracker-ra && chmod +x build_linux_wsl_native.sh && echo '%VERSION%' | ./build_linux_wsl_native.sh"
exit /b %ERRORLEVEL%

:COMPILE_ARM_INTERNAL
echo ⏳ Compilando ARM usando Docker Desktop...
call build_arm_docker_windows.cmd
exit /b %ERRORLEVEL%

:SUCCESS_ALL
echo.
echo ===============================================================
echo ✅ COMPILACION COMPLETA EXITOSA
echo ===============================================================
echo.
echo 📦 Archivos generados en versions/:
if exist versions\ (
    echo.
    echo 🪟 Windows:
    dir versions\*.exe /b 2>nul | findstr -v "stracker-packager"
    dir versions\*.zip /b 2>nul
    echo.
    echo 🐧 Linux:
    dir versions\*linux*.tgz /b 2>nul | findstr -v arm
    echo.
    echo 🤖 ARM:
    dir versions\*arm*.tgz /b 2>nul
) else (
    echo    (Directorio versions/ no existe)
)
echo.
echo 🏁 Todas las plataformas compiladas exitosamente
echo ⚙️  Estrategia utilizada: Windows nativo + WSL nativo + Docker ARM
echo.
goto END

:SUCCESS
echo.
echo ✅ Compilación completada exitosamente
echo 📍 Revisa el directorio versions/ para los archivos generados
echo.
goto END

:ERROR
echo.
echo ❌ Error durante la compilación
echo 🔍 Revisa los mensajes anteriores para más detalles
echo.
pause
exit /b 1

:END
echo 👋 Script completado
pause
