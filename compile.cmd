@echo off
REM =============================================================================
REM Script de Compilación Rápida - sptracker
REM =============================================================================
REM 
REM Script simplificado que ejecuta build_complete.cmd con validaciones
REM 
REM Uso: 
REM   compile.cmd           (pregunta por versión)
REM   compile.cmd 3.5.3     (usa versión específica)
REM =============================================================================

echo.
echo 🚀 COMPILACION RAPIDA SPTRACKER 🚀
echo.

REM Verificar prerrequisitos básicos
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Python no encontrado
    echo 💡 Instala Python y añádelo al PATH
    pause
    exit /b 1
)

docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Docker Desktop no encontrado
    echo 💡 Instala Docker Desktop y asegúrate de que esté ejecutándose
    pause
    exit /b 1
)

wsl --list >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: WSL no encontrado
    echo 💡 Instala WSL con Debian
    pause
    exit /b 1
)

echo ✅ Prerrequisitos verificados
echo.

REM Ejecutar script completo
call build_complete.cmd %1

exit /b %ERRORLEVEL%
