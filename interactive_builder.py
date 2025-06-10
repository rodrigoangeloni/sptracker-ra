#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script Interactivo de Compilación para sptracker
================================================

Este script proporciona una interfaz fácil de usar para compilar sptracker
usando el script create_release.py existente con diferentes opciones.

Uso: python interactive_builder.py
"""

import subprocess
import sys
import os
import shutil
from pathlib import Path

def print_banner():
    """Muestra el banner del script."""
    print("=" * 60)
    print(" 🏁 COMPILADOR INTERACTIVO DE SPTRACKER 🏁")
    print("=" * 60)
    print("Este script te ayudará a compilar sptracker de forma fácil")
    print("con las opciones que necesites.")
    print()

def get_yes_no_input(prompt_text, default=None):
    """Obtiene una respuesta sí/no del usuario."""
    if default is not None:
        suffix = " (S/n): " if default else " (s/N): "
    else:
        suffix = " (s/n): "
    
    while True:
        try:
            response = input(prompt_text + suffix).strip().lower()
            if not response and default is not None:
                return default
            if response in ['s', 'si', 'sí', 'yes', 'y']:
                return True
            elif response in ['n', 'no']:
                return False
            else:
                print("❌ Respuesta no válida. Por favor, introduce 's' para sí o 'n' para no.")
        except KeyboardInterrupt:
            print("\n\n👋 Saliendo del script...")
            sys.exit(0)

def get_version_input():
    """Obtiene el número de versión del usuario."""
    print("📋 INFORMACIÓN DE VERSIÓN")
    print("-" * 25)
    print("Formatos válidos: X.Y.Z (ejemplo: 3.5.3)")
    print()
    
    while True:
        try:
            version = input("🔢 Introduce el número de versión: ").strip()
            if not version:
                print("❌ El número de versión no puede estar vacío.")
                continue
            
            # Validación básica del formato de versión
            parts = version.split('.')
            if len(parts) == 3 and all(part.isdigit() for part in parts):
                return version
            else:
                print("❌ Formato incorrecto. Usa el formato X.Y.Z (ejemplo: 3.5.3)")
        except KeyboardInterrupt:
            print("\n\n👋 Saliendo del script...")
            sys.exit(0)

def get_component_choice():
    """Obtiene la elección de componentes a compilar."""
    print("\n🔨 COMPONENTES A COMPILAR")
    print("-" * 25)
    print("1. 🎯 Todo (ptracker + stracker + stracker-packager)")
    print("2. 🏎️  Solo ptracker (aplicación cliente)")
    print("3. 🖥️  Solo stracker (aplicación servidor)")
    print("4. 📦 Solo stracker-packager (empaquetador)")
    print()
    
    while True:
        try:
            choice = input("Elige una opción (1-4): ").strip()
            if choice in ["1", "2", "3", "4"]:
                return choice
            else:
                print("❌ Opción no válida. Elige entre 1 y 4.")
        except KeyboardInterrupt:
            print("\n\n👋 Saliendo del script...")
            sys.exit(0)

def get_os_filter_choice(component_choice):
    """Obtiene el filtro de sistema operativo si es relevante."""
    # Solo preguntar si es relevante
    if component_choice not in ["1", "3"]:  # Solo para "Todo" o "Solo stracker"
        return "1"  # Por defecto
    
    print("\n💻 FILTRO DE SISTEMA OPERATIVO Y ARQUITECTURA")
    print("-" * 45)
    print("1. 🌐 Por defecto (Windows 64-bit + Linux 64-bit + ARM donde aplique)")
    print("2. 🪟 Solo Windows 64-bit (nativo)")
    print("3. 🪟 Solo Windows 32-bit (nativo, experimental)")
    print("4. 🐧 Solo Linux 64-bit (WSL nativo)")
    print("5. 🐧 Solo Linux 32-bit (WSL nativo, experimental)")
    print("6. 🤖 Solo ARM32 (Docker Desktop + QEMU)")
    print("7. 🦾 Solo ARM64 (Docker Desktop + QEMU)")
    print("8. 🔧 Compilación completa (todas las arquitecturas)")
    print()
    
    if component_choice == "1":
        print("ℹ️  Estrategia de compilación optimizada:")
        print("   🪟 Windows: Compilación nativa")
        print("   🐧 Linux: WSL nativo (sin Docker)")
        print("   🤖 ARM: Docker Desktop con emulación QEMU")
        print("⚠️  Las opciones de 32-bit son experimentales")
    
    while True:
        try:
            choice = input("Elige una opción de SO/arquitectura (1-8): ").strip()
            if choice in ["1", "2", "3", "4", "5", "6", "7", "8"]:
                return choice
            else:
                print("❌ Opción no válida. Elige entre 1 y 8.")
        except KeyboardInterrupt:
            print("\n\n👋 Saliendo del script...")
            sys.exit(0)

def check_prerequisites():
    """Verifica que los archivos necesarios existan."""
    script_dir = Path(__file__).parent
    create_release_path = script_dir / "create_release.py"
    
    if not create_release_path.exists():
        print("❌ Error: No se encontró 'create_release.py' en el directorio actual.")
        print(f"   Directorio actual: {script_dir}")
        return False
    
    # Verificar que Python esté disponible
    try:
        result = subprocess.run(["python", "--version"], capture_output=True, text=True)
        if result.returncode != 0:
            print("❌ Error: Python no está disponible o no está en el PATH.")
            return False
    except FileNotFoundError:
        print("❌ Error: Python no está instalado o no está en el PATH.")
        return False
    
    return True

def build_command_args(version, component_choice, os_filter_choice, is_test_release):
    """Construye los argumentos para el comando create_release.py."""
    args = ["python", "create_release.py"]
    
    # Agregar flag de test si se seleccionó
    if is_test_release:
        args.append("--test_release_process")
    
    # Agregar flags específicos de componentes
    component_flags = {
        "2": "--ptracker_only",
        "3": "--stracker_only", 
        "4": "--stracker_packager_only"
    }
    
    if component_choice in component_flags:
        args.append(component_flags[component_choice])
    
    # Agregar filtros de OS y arquitectura
    if os_filter_choice == "2":
        args.append("--windows_only")
    elif os_filter_choice == "3":
        args.append("--windows32_only")
    elif os_filter_choice == "4":
        args.append("--linux_only")
    elif os_filter_choice == "5":
        args.append("--linux32_only")
    elif os_filter_choice == "6":
        args.append("--arm32_only")
    elif os_filter_choice == "7":
        args.append("--arm64_only")
    elif os_filter_choice == "8":
        args.append("--all_architectures")
    
    # Agregar versión al final
    args.append(version)
    
    return args

def show_compilation_summary(args, component_choice, os_filter_choice):
    """Muestra un resumen de lo que se va a compilar."""
    print("\n📋 RESUMEN DE COMPILACIÓN")
    print("-" * 25)
    
    # Mostrar componentes
    component_names = {
        "1": "Todo (ptracker + stracker + stracker-packager)",
        "2": "Solo ptracker", 
        "3": "Solo stracker",
        "4": "Solo stracker-packager"
    }
    print(f"🔨 Componentes: {component_names[component_choice]}")
    
    # Mostrar OS
    os_names = {
        "1": "Windows 64-bit + Linux 64-bit + ARM (donde aplique)",
        "2": "Solo Windows 64-bit",
        "3": "Solo Windows 32-bit (experimental)",
        "4": "Solo Linux 64-bit",
        "5": "Solo Linux 32-bit (experimental)",
        "6": "Solo ARM32",
        "7": "Solo ARM64",
        "8": "Todas las arquitecturas"
    }
    print(f"💻 Sistema: {os_names[os_filter_choice]}")
    
    # Mostrar modo de test si aplica
    if "--test_release_process" in args:
        print("🧪 Modo: Compilación de prueba (sin commits a Git)")
    else:
        print("🚀 Modo: Compilación de producción")
    
    print(f"\n💻 Comando a ejecutar:")
    print(f"   {' '.join(args)}")
    print()

def run_compilation(args):
    """Ejecuta la compilación y muestra el progreso."""
    print("🚀 INICIANDO COMPILACIÓN...")
    print("-" * 25)
    print("⏳ Esto puede tomar varios minutos dependiendo de los componentes seleccionados.")
    print()
    
    script_dir = Path(__file__).parent
    
    # Extraer la versión de los argumentos (siempre es el último argumento)
    version = args[-1] if args else None
    
    try:
        # Ejecutar el comando
        process = subprocess.Popen(
            args, 
            cwd=script_dir, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.STDOUT,  # Combinar stderr con stdout
            text=True, 
            bufsize=1,
            universal_newlines=True
        )
        
        # Mostrar salida en tiempo real
        output_lines = []
        for line in iter(process.stdout.readline, ''):
            if line:
                print(line, end='')
                output_lines.append(line)
        process.stdout.close()
        return_code = process.wait()
        print("\n" + "=" * 60)
        if return_code == 0:
            print("✅ ¡COMPILACIÓN COMPLETADA EXITOSAMENTE!")
            
            # Copiar stracker-packager.exe al directorio versions/ si existe
            if version:
                copy_packager_to_versions(script_dir, version)
            
            show_generated_files_info(script_dir)
        else:
            print("❌ ERROR DURANTE LA COMPILACIÓN")
            print(f"   Código de salida: {return_code}")
            print("\n🔍 Revisa la salida anterior para más detalles.")
        
        return return_code == 0
        
    except FileNotFoundError:
        print("❌ Error: No se pudo ejecutar Python o encontrar create_release.py")
        return False
    except Exception as e:
        print(f"❌ Error inesperado durante la compilación: {e}")
        return False

def copy_packager_to_versions(script_dir, version):
    """Copia stracker-packager.exe al directorio versions/ con el número de versión."""
    try:
        stracker_dist_dir = script_dir / "stracker" / "dist"
        packager_source = stracker_dist_dir / "stracker-packager.exe"
        versions_dir = script_dir / "versions"
        
        if packager_source.exists():
            # Crear el directorio versions si no existe
            versions_dir.mkdir(exist_ok=True)
            
            # Nombre con versión
            packager_dest = versions_dir / f"stracker-packager-V{version}.exe"
            
            # Copiar el archivo
            shutil.copy2(packager_source, packager_dest)
            print(f"📦 Copiado: stracker-packager-V{version}.exe al directorio versions/")
            return True
        else:
            print(f"⚠️  Warning: No se encontró stracker-packager.exe en {packager_source}")
            return False
    except Exception as e:
        print(f"❌ Error copiando stracker-packager.exe: {e}")
        return False

def show_generated_files_info(script_dir):
    """Muestra información detallada sobre los archivos generados."""
    print("\n📦 ARCHIVOS GENERADOS")
    print("=" * 60)
    
    # Verificar archivos en versions/
    versions_dir = script_dir / "versions"
    dist_dir = script_dir / "dist"
    stracker_dist_dir = script_dir / "stracker" / "dist"
    
    # Archivos de distribución final
    print("\n🎯 ARCHIVOS DE DISTRIBUCIÓN FINAL:")
    print("-" * 40)
    if versions_dir.exists():
        for file_path in sorted(versions_dir.glob("*")):
            if file_path.is_file():
                size_mb = file_path.stat().st_size / (1024 * 1024)
                if file_path.suffix == ".exe":
                    if file_path.name.startswith("ptracker-V"):
                        print(f"🏎️  {file_path.name} ({size_mb:.1f} MB)")
                        print(f"   📁 Ubicación: {file_path}")
                        print(f"   🎯 Propósito: Instalador completo del cliente ptracker")
                        print(f"   👥 Para: Usuarios finales que quieren instalar ptracker")
                        print(f"   📝 Uso: Ejecutar para instalar en el sistema")
                        print()
                    elif file_path.name.startswith("stracker-packager-V"):
                        print(f"📦 {file_path.name} ({size_mb:.1f} MB)")
                        print(f"   📁 Ubicación: {file_path}")
                        print(f"   🎯 Propósito: Empaquetador de coches y pistas")
                        print(f"   👥 Para: Administradores que gestionan contenido")
                        print(f"   📝 Uso: Subir información de nuevos coches/pistas al servidor")
                        print()
                elif file_path.suffix == ".zip":
                    print(f"🖥️  {file_path.name} ({size_mb:.1f} MB)")
                    print(f"   📁 Ubicación: {file_path}")
                    print(f"   🎯 Propósito: Servidor stracker completo")
                    print(f"   👥 Para: Administradores de servidores")
                    print(f"   📝 Uso: Descomprimir y ejecutar stracker.exe en el servidor")
                    print()
                elif file_path.suffix in [".tgz", ".tar.gz"]:
                    arch_info = ""
                    if "arm32" in file_path.name:
                        arch_info = " (ARM 32-bit)"
                    elif "arm64" in file_path.name:
                        arch_info = " (ARM 64-bit)"
                    elif "x86" in file_path.name:
                        arch_info = " (Linux x86)"
                    
                    print(f"🐧 {file_path.name} ({size_mb:.1f} MB){arch_info}")
                    print(f"   📁 Ubicación: {file_path}")
                    print(f"   🎯 Propósito: Binario stracker para Linux")
                    print(f"   👥 Para: Administradores de servidores Linux")
                    print(f"   📝 Uso: Extraer y ejecutar ./stracker")
                    print()
    
    # Ejecutables individuales
    print("🔧 EJECUTABLES INDIVIDUALES:")
    print("-" * 40)
    
    # ptracker.exe en dist/
    if dist_dir.exists():
        ptracker_exe = dist_dir / "ptracker.exe"
        if ptracker_exe.exists():
            size_mb = ptracker_exe.stat().st_size / (1024 * 1024)
            print(f"🏎️  ptracker.exe ({size_mb:.1f} MB)")
            print(f"   📁 Ubicación: {ptracker_exe}")
            print(f"   🎯 Propósito: Cliente ptracker standalone")
            print(f"   👥 Para: Desarrollo/testing o ejecución directa")
            print(f"   📝 Uso: Ejecutar directamente sin instalación")
            print()
    
    # Ejecutables del servidor
    if stracker_dist_dir.exists():
        stracker_exe = stracker_dist_dir / "stracker.exe"
        packager_exe = stracker_dist_dir / "stracker-packager.exe"
        
        if stracker_exe.exists():
            size_mb = stracker_exe.stat().st_size / (1024 * 1024)
            print(f"🖥️  stracker.exe ({size_mb:.1f} MB)")
            print(f"   📁 Ubicación: {stracker_exe}")
            print(f"   🎯 Propósito: Servidor principal de sptracker")
            print(f"   👥 Para: Administradores de servidores")
            print(f"   📝 Uso: Ejecutar en el servidor para recopilar datos de AC")
            print()
        
        if packager_exe.exists():
            size_mb = packager_exe.stat().st_size / (1024 * 1024)
            print(f"📦 stracker-packager.exe ({size_mb:.1f} MB)")
            print(f"   📁 Ubicación: {packager_exe}")
            print(f"   🎯 Propósito: Empaquetador de coches y pistas")
            print(f"   👥 Para: Administradores que gestionan contenido")
            print(f"   📝 Uso: Subir información de nuevos coches/pistas al servidor")
            print()
    
    # Guía de uso
    print("📚 GUÍA DE USO:")
    print("-" * 40)
    print("🎮 Para usuarios finales:")
    print("   → Usa el instalador ptracker-V*.exe del directorio versions/")
    print()
    print("🖥️  Para administradores de servidor:")
    print("   → Usa stracker-V*.zip (servidor completo) del directorio versions/")
    print("   → O usa stracker-packager-V*.exe (solo empaquetador)")
    print()
    print("🔧 Para desarrollo/testing:")
    print("   → Usa los ejecutables individuales en dist/ y stracker/dist/")
    print()
    print("📋 ARCHIVOS PRINCIPALES EN VERSIONS/:")
    print("   🏎️  ptracker-V*.exe - Cliente para Assetto Corsa")
    print("   🖥️  stracker-V*.zip - Servidor completo")
    print("   📦 stracker-packager-V*.exe - Empaquetador standalone")
    print("   🐧 stracker_linux_*.tgz - Binarios Linux específicos")
    print()

def main():
    """Función principal del script."""
    print_banner()
    
    # Verificar prerrequisitos
    if not check_prerequisites():
        print("\n❌ No se pueden cumplir los prerrequisitos. Saliendo...")
        sys.exit(1)
    
    try:
        # Obtener información del usuario
        version = get_version_input()
        
        # Preguntar sobre modo de test
        is_test_release = get_yes_no_input(
            "\n🧪 ¿Es esta una compilación de prueba?", 
            default=False
        )
        
        component_choice = get_component_choice()
        os_filter_choice = get_os_filter_choice(component_choice)
        
        # Construir argumentos del comando
        args = build_command_args(version, component_choice, os_filter_choice, is_test_release)
        
        # Mostrar resumen
        show_compilation_summary(args, component_choice, os_filter_choice)
        
        # Confirmar antes de proceder
        if get_yes_no_input("✅ ¿Continuar con la compilación?", default=True):
            success = run_compilation(args)
            
            if success:
                # Copiar stracker-packager.exe a versions/ si es necesario
                if component_choice == "4" or (component_choice == "1" and os_filter_choice in ["1", "8"]):
                    copy_packager_to_versions(Path(__file__).parent, version)
                
                print("\n🎉 ¡Proceso completado exitosamente!")
            else:
                print("\n💔 La compilación falló. Revisa los errores mostrados arriba.")
                sys.exit(1)
        else:
            print("\n❌ Compilación cancelada por el usuario.")
            
    except KeyboardInterrupt:
        print("\n\n👋 Script interrumpido por el usuario. ¡Hasta luego!")
        sys.exit(0)

if __name__ == "__main__":
    main()
