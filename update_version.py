#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para actualizar versiones de sptracker

Este script ayuda a actualizar las versiones en todos los archivos relevantes
del proyecto de manera consistente.

Uso:
    python update_version.py 5.1.0
    python update_version.py --increment patch  # Incrementa automáticamente
    python update_version.py --increment minor
    python update_version.py --increment major
"""

import sys
import os
import re
import argparse
from version_config import VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH, get_next_version

def update_version_in_file(filepath, new_version, pattern=None):
    """
    Actualiza la versión en un archivo específico
    
    Args:
        filepath (str): Ruta del archivo
        new_version (str): Nueva versión
        pattern (str): Patrón regex personalizado (opcional)
    """
    if not os.path.exists(filepath):
        print(f"⚠️  Archivo no encontrado: {filepath}")
        return False
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Patrones por defecto según el tipo de archivo
        if pattern is None:
            if filepath.endswith('.py'):
                pattern = r"version\s*=\s*['\"][^'\"]*['\"]"
                replacement = f"version = '{new_version}'"
            elif filepath.endswith('.md'):
                # Para README.md, actualizar ejemplos de versiones
                pattern = r"python create_release\.py (\d+\.\d+\.\d+)"
                replacement = f"python create_release.py {new_version}"
            else:
                print(f"⚠️  Tipo de archivo no soportado: {filepath}")
                return False
        else:
            replacement = pattern.replace("{version}", new_version)
        
        # Aplicar la actualización
        new_content = re.sub(pattern, replacement, content)
        
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"✅ Actualizado: {filepath}")
            return True
        else:
            print(f"ℹ️  Sin cambios: {filepath}")
            return False
            
    except Exception as e:
        print(f"❌ Error actualizando {filepath}: {e}")
        return False

def update_all_versions(new_version):
    """Actualiza la versión en todos los archivos relevantes"""
    
    files_to_update = [
        "ptracker_lib/__init__.py",
        "stracker/stracker_lib/__init__.py",
        "version_config.py"
    ]
    
    print(f"🔄 Actualizando versión a {new_version}...")
    
    updated_count = 0
    for filepath in files_to_update:
        if update_version_in_file(filepath, new_version):
            updated_count += 1
    
    # Actualizar version_config.py con los componentes de versión
    try:
        parts = new_version.split('.')
        if len(parts) == 3:
            major, minor, patch = map(int, parts)
            
            # Leer y actualizar version_config.py
            with open("version_config.py", 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Actualizar cada componente
            content = re.sub(r'VERSION_MAJOR\s*=\s*\d+', f'VERSION_MAJOR = {major}', content)
            content = re.sub(r'VERSION_MINOR\s*=\s*\d+', f'VERSION_MINOR = {minor}', content)
            content = re.sub(r'VERSION_PATCH\s*=\s*\d+', f'VERSION_PATCH = {patch}', content)
            content = re.sub(r'BASE_VERSION\s*=\s*"[^"]*"', f'BASE_VERSION = "{new_version}"', content)
            
            with open("version_config.py", 'w', encoding='utf-8') as f:
                f.write(content)
                
            print("✅ Actualizado version_config.py con componentes de versión")
            
    except Exception as e:
        print(f"⚠️  No se pudieron actualizar los componentes de versión: {e}")
    
    print(f"\n🎉 Actualizados {updated_count} archivos con la versión {new_version}")
    print("\n📝 Próximos pasos:")
    print("1. Revisar los cambios con: git diff")
    print("2. Crear el release con: python create_release.py", new_version)
    print("3. Hacer commit de los cambios")

def main():
    parser = argparse.ArgumentParser(description='Actualizar versiones de sptracker')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('version', nargs='?', help='Nueva versión (ej: 5.1.0)')
    group.add_argument('--increment', choices=['major', 'minor', 'patch'], 
                      help='Incrementar automáticamente la versión')
    
    args = parser.parse_args()
    
    if args.increment:
        new_version = get_next_version(args.increment)
        print(f"📈 Incrementando versión ({args.increment}): {new_version}")
    else:
        new_version = args.version
        
        # Validar formato de versión
        if not re.match(r'^\d+\.\d+\.\d+$', new_version):
            print("❌ Error: La versión debe tener el formato X.Y.Z (ej: 5.1.0)")
            sys.exit(1)
        
        # Verificar que sea 5.0.0 o superior
        parts = list(map(int, new_version.split('.')))
        if parts[0] < 5:
            print("❌ Error: La versión debe ser 5.0.0 o superior")
            sys.exit(1)
    
    update_all_versions(new_version)

if __name__ == "__main__":
    main()
