#!/usr/bin/env pwsh
#Requires -Version 7.0
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Configurador del Entorno de Desarrollo para sptracker
    
.DESCRIPTION
    Script de configuración automática para establecer el entorno de desarrollo
    estándar de sptracker en Windows + WSL + Docker Desktop.
    
    Este script debe ejecutarse como Administrador en PowerShell 7+
    
.PARAMETER SkipWSL
    Omite la configuración de WSL si ya está configurado
    
.PARAMETER SkipDocker
    Omite la instalación/configuración de Docker Desktop
    
.PARAMETER SkipPython
    Omite la instalación de Python
    
.EXAMPLE
    .\setup-dev-environment.ps1
    
.EXAMPLE
    .\setup-dev-environment.ps1 -SkipWSL -SkipDocker
#>

param(
    [switch]$SkipWSL,
    [switch]$SkipDocker,
    [switch]$SkipPython,
    [switch]$Validate
)

# ==========================================================
# CONFIGURACIÓN INICIAL
# ==========================================================

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Colores para output
$ColorError = "Red"
$ColorWarning = "Yellow" 
$ColorSuccess = "Green"
$ColorInfo = "Cyan"
$ColorHeader = "Magenta"

# Configuración de versiones requeridas
$PythonMinVersion = [version]"3.8.0"
$DockerMinVersion = [version]"20.10.0"

# ==========================================================
# FUNCIONES DE UTILIDAD
# ==========================================================

function Write-Header {
    param([string]$Message)
    Write-Host "`n$('=' * 60)" -ForegroundColor $ColorHeader
    Write-Host " $Message" -ForegroundColor $ColorHeader
    Write-Host "$('=' * 60)" -ForegroundColor $ColorHeader
}

function Write-Step {
    param([string]$Message)
    Write-Host "`n🔧 $Message" -ForegroundColor $ColorInfo
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $ColorSuccess
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $ColorWarning
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $ColorError
}

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-WSLInstalled {
    try {
        $wslVersion = wsl --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Test-DockerInstalled {
    try {
        $dockerVersion = docker --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Test-PythonVersion {
    param([string]$MinVersion)
    try {
        $pythonOutput = python --version 2>$null
        if ($pythonOutput -match "Python (\d+\.\d+\.\d+)") {
            $currentVersion = [version]$Matches[1]
            return $currentVersion -ge [version]$MinVersion
        }
        return $false
    }
    catch {
        return $false
    }
}

# ==========================================================
# FUNCIONES DE INSTALACIÓN
# ==========================================================

function Install-WindowsFeatures {
    Write-Step "Habilitando características de Windows necesarias..."
    
    # WSL y Hyper-V
    $features = @(
        "Microsoft-Windows-Subsystem-Linux",
        "VirtualMachinePlatform",
        "Microsoft-Hyper-V-All"
    )
    
    foreach ($feature in $features) {
        Write-Host "  Habilitando $feature..."
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart -All
            Write-Success "  $feature habilitado"
        }
        catch {
            Write-Warning "  No se pudo habilitar $feature (posible que ya esté habilitado)"
        }
    }
}

function Install-WSL {
    if ($SkipWSL) {
        Write-Warning "Omitiendo configuración de WSL (--SkipWSL especificado)"
        return
    }
    
    Write-Step "Configurando WSL (Windows Subsystem for Linux)..."
    
    if (Test-WSLInstalled) {
        Write-Success "WSL ya está instalado"
        
        # Verificar que esté en versión 2
        Write-Host "  Configurando WSL versión 2 como predeterminada..."
        wsl --set-default-version 2
        
        # Verificar distribuciones instaladas
        Write-Host "  Distribuciones WSL instaladas:"
        wsl --list --verbose
    }
    else {
        Write-Host "  Instalando WSL..."
        wsl --install
        Write-Success "WSL instalado. Será necesario reiniciar el sistema."
        
        # Programar configuración post-reinicio
        Write-Warning "Después del reinicio, ejecute este script nuevamente para continuar."
    }
}

function Install-Docker {
    if ($SkipDocker) {
        Write-Warning "Omitiendo instalación de Docker (--SkipDocker especificado)"
        return
    }
    
    Write-Step "Configurando Docker Desktop..."
    
    if (Test-DockerInstalled) {
        Write-Success "Docker ya está instalado"
        
        # Verificar versión
        $dockerVersion = docker --version
        Write-Host "  Versión: $dockerVersion"
        
        # Verificar que Docker Desktop esté ejecutándose
        try {
            docker info > $null 2>&1
            Write-Success "  Docker Desktop está ejecutándose"
        }
        catch {
            Write-Warning "  Docker Desktop no está ejecutándose. Inicie Docker Desktop manualmente."
        }
    }
    else {
        Write-Host "  Docker Desktop no está instalado."
        Write-Host "  Descargando Docker Desktop..."
        
        $dockerInstallerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
        $dockerInstallerPath = "$env:TEMP\DockerDesktopInstaller.exe"
        
        try {
            Invoke-WebRequest -Uri $dockerInstallerUrl -OutFile $dockerInstallerPath
            Write-Host "  Ejecutando instalador de Docker Desktop..."
            Start-Process -FilePath $dockerInstallerPath -ArgumentList "install --quiet" -Wait
            Write-Success "Docker Desktop instalado"
        }
        catch {
            Write-Error "Error descargando o instalando Docker Desktop: $_"
            Write-Host "  Descarga manual desde: https://www.docker.com/products/docker-desktop/"
        }
    }
}

function Install-Python {
    if ($SkipPython) {
        Write-Warning "Omitiendo instalación de Python (--SkipPython especificado)"
        return
    }
    
    Write-Step "Configurando Python..."
    
    if (Test-PythonVersion -MinVersion "3.8.0") {
        $pythonVersion = python --version
        Write-Success "Python está instalado: $pythonVersion"
    }
    else {
        Write-Host "  Python 3.8+ no está disponible."
        
        # Verificar si winget está disponible
        try {
            winget --version > $null 2>&1
            Write-Host "  Instalando Python usando winget..."
            winget install Python.Python.3.11
            Write-Success "Python 3.11 instalado"
        }
        catch {
            Write-Warning "  winget no está disponible."
            Write-Host "  Descarga manual desde: https://www.python.org/downloads/"
        }
    }
    
    # Instalar pip packages globales necesarios
    Write-Host "  Instalando paquetes Python globales..."
    $globalPackages = @("virtualenv", "pip", "setuptools", "wheel")
    
    foreach ($package in $globalPackages) {
        try {
            python -m pip install --upgrade $package
            Write-Success "  $package instalado/actualizado"
        }
        catch {
            Write-Warning "  Error instalando $package: $_"
        }
    }
}

function Setup-ProjectEnvironment {
    Write-Step "Configurando entorno del proyecto..."
    
    $projectRoot = Get-Location
    Write-Host "  Directorio del proyecto: $projectRoot"
    
    # Crear directorios necesarios
    $directories = @("env", "temp", "versions", ".cache")
    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force
            Write-Success "  Directorio creado: $dir"
        }
    }
    
    # Configurar release_settings.py si no existe
    if (-not (Test-Path "release_settings.py") -and (Test-Path "release_settings.py.in")) {
        Copy-Item "release_settings.py.in" "release_settings.py"
        Write-Success "  release_settings.py creado desde template"
        Write-Warning "  Edita release_settings.py con tus rutas específicas"
    }
    
    # Crear entorno virtual Windows
    if (-not (Test-Path "env/windows")) {
        Write-Host "  Creando entorno virtual Windows..."
        python -m virtualenv env/windows
        Write-Success "  Entorno virtual Windows creado"
    }
}

function Install-VSCodeExtensions {
    Write-Step "Configurando VS Code (opcional)..."
    
    try {
        code --version > $null 2>&1
        
        $extensions = @(
            "ms-python.python",
            "ms-vscode-remote.remote-wsl", 
            "ms-vscode-remote.remote-containers",
            "ms-python.autopep8",
            "ms-python.pylint"
        )
        
        foreach ($ext in $extensions) {
            Write-Host "  Instalando extensión: $ext"
            code --install-extension $ext --force
        }
        
        Write-Success "Extensiones de VS Code instaladas"
    }
    catch {
        Write-Warning "VS Code no está instalado o no está en PATH. Saltando configuración de extensiones."
    }
}

# ==========================================================
# FUNCIÓN DE VALIDACIÓN
# ==========================================================

function Validate-Environment {
    Write-Header "VALIDANDO ENTORNO DE DESARROLLO"
    
    $issues = @()
    
    # Verificar WSL
    if (Test-WSLInstalled) {
        Write-Success "WSL está instalado"
        try {
            $wslDistros = wsl --list --quiet
            Write-Host "  Distribuciones: $($wslDistros -join ', ')"
        }
        catch {
            $issues += "WSL no responde correctamente"
        }
    }
    else {
        $issues += "WSL no está instalado"
    }
    
    # Verificar Docker
    if (Test-DockerInstalled) {
        Write-Success "Docker está instalado"
        try {
            docker info > $null 2>&1
            Write-Success "  Docker está ejecutándose"
        }
        catch {
            $issues += "Docker no está ejecutándose"
        }
    }
    else {
        $issues += "Docker no está instalado"
    }
    
    # Verificar Python
    if (Test-PythonVersion -MinVersion "3.8.0") {
        $pythonVersion = python --version
        Write-Success "Python: $pythonVersion"
    }
    else {
        $issues += "Python 3.8+ no está disponible"
    }
    
    # Verificar estructura de proyecto
    $requiredFiles = @("create_release.py", "interactive_builder.py", "ptracker.py")
    foreach ($file in $requiredFiles) {
        if (Test-Path $file) {
            Write-Success "Archivo encontrado: $file"
        }
        else {
            $issues += "Archivo faltante: $file"
        }
    }
    
    # Resultado final
    if ($issues.Count -eq 0) {
        Write-Header "✅ ENTORNO VÁLIDO - LISTO PARA DESARROLLO"
        Write-Host "Puedes ejecutar:" -ForegroundColor $ColorSuccess
        Write-Host "  python interactive_builder.py" -ForegroundColor $ColorInfo
        Write-Host "  python create_release.py --test_release_process 3.5.2" -ForegroundColor $ColorInfo
    }
    else {
        Write-Header "❌ PROBLEMAS ENCONTRADOS"
        foreach ($issue in $issues) {
            Write-Error $issue
        }
        Write-Host "`nEjecuta el script de setup nuevamente para resolver los problemas." -ForegroundColor $ColorWarning
    }
}

# ==========================================================
# FUNCIÓN PRINCIPAL
# ==========================================================

function Main {
    Write-Header "CONFIGURADOR DEL ENTORNO DE DESARROLLO - SPTRACKER"
    Write-Host "Entorno objetivo: Windows + WSL + Docker Desktop" -ForegroundColor $ColorInfo
    
    # Verificar permisos de administrador
    if (-not (Test-AdminRights)) {
        Write-Error "Este script debe ejecutarse como Administrador"
        Write-Host "Ejecuta PowerShell como Administrador y vuelve a intentar." -ForegroundColor $ColorWarning
        exit 1
    }
    
    if ($Validate) {
        Validate-Environment
        return
    }
    
    Write-Host "`nEste script configurará automáticamente:" -ForegroundColor $ColorInfo
    Write-Host "  • WSL (Windows Subsystem for Linux)" -ForegroundColor $ColorInfo
    Write-Host "  • Docker Desktop" -ForegroundColor $ColorInfo  
    Write-Host "  • Python 3.8+" -ForegroundColor $ColorInfo
    Write-Host "  • Entorno virtual del proyecto" -ForegroundColor $ColorInfo
    Write-Host "  • Extensiones de VS Code (opcional)" -ForegroundColor $ColorInfo
    
    $confirm = Read-Host "`n¿Continuar con la configuración? (S/n)"
    if ($confirm -match '^[Nn]') {
        Write-Warning "Configuración cancelada por el usuario"
        exit 0
    }
    
    try {
        Install-WindowsFeatures
        Install-WSL
        Install-Docker
        Install-Python
        Setup-ProjectEnvironment
        Install-VSCodeExtensions
        
        Write-Header "🎉 CONFIGURACIÓN COMPLETADA EXITOSAMENTE"
        Write-Host "El entorno de desarrollo está listo." -ForegroundColor $ColorSuccess
        Write-Host "`nPróximos pasos:" -ForegroundColor $ColorInfo
        Write-Host "  1. Reinicia el sistema si se instaló WSL" -ForegroundColor $ColorInfo
        Write-Host "  2. Edita release_settings.py con tus rutas específicas" -ForegroundColor $ColorInfo
        Write-Host "  3. Ejecuta: .\setup-dev-environment.ps1 -Validate" -ForegroundColor $ColorInfo
        Write-Host "  4. Ejecuta el script WSL: wsl ./setup-dev-environment.sh" -ForegroundColor $ColorInfo
        Write-Host "  5. Prueba la compilación: python interactive_builder.py" -ForegroundColor $ColorInfo
        
        # Ejecutar validación automáticamente
        Write-Host "`nEjecutando validación final..." -ForegroundColor $ColorInfo
        Start-Sleep 2
        Validate-Environment
    }
    catch {
        Write-Error "Error durante la configuración: $_"
        Write-Host "Revisa los errores anteriores y ejecuta el script nuevamente." -ForegroundColor $ColorWarning
        exit 1
    }
}

# ==========================================================
# EJECUCIÓN
# ==========================================================

# Verificar que estamos en el directorio correcto del proyecto
if (-not (Test-Path "create_release.py")) {
    Write-Error "Este script debe ejecutarse desde el directorio raíz del proyecto sptracker"
    Write-Host "Navegue al directorio que contiene create_release.py y ejecute el script nuevamente." -ForegroundColor $ColorWarning
    exit 1
}

Main
