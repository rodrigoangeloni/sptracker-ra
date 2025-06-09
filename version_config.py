# -*- coding: utf-8 -*-
"""
Configuración de versiones para sptracker

Este archivo centraliza la configuración de versiones del proyecto.
A partir de la versión 5.0.0, el proyecto sigue Semantic Versioning.
"""

# Versión base del proyecto (para próximos releases)
BASE_VERSION = "3.5.1"

# Componentes de versión actual (continuando desde DocWilco)
VERSION_MAJOR = 3
VERSION_MINOR = 5
VERSION_PATCH = 2

# Versión completa
CURRENT_VERSION = f"{VERSION_MAJOR}.{VERSION_MINOR}.{VERSION_PATCH}"

# Información de versión para metadatos
VERSION_INFO = {
    "major": VERSION_MAJOR,
    "minor": VERSION_MINOR,
    "patch": VERSION_PATCH,
    "version": CURRENT_VERSION,
    "base_version": BASE_VERSION,
    "description": "sptracker - Suite de aplicaciones para Assetto Corsa"
}

def get_version():
    """Retorna la versión actual del proyecto"""
    return CURRENT_VERSION

def get_next_version(increment_type="patch"):
    """
    Genera la siguiente versión según el tipo de incremento
    
    Args:
        increment_type (str): "major", "minor", o "patch"
    
    Returns:
        str: La siguiente versión
    """
    major, minor, patch = VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH
    
    if increment_type == "major":
        major += 1
        minor = 0
        patch = 0
    elif increment_type == "minor":
        minor += 1
        patch = 0
    elif increment_type == "patch":
        patch += 1
    else:
        raise ValueError("increment_type debe ser 'major', 'minor' o 'patch'")
    
    return f"{major}.{minor}.{patch}"

if __name__ == "__main__":
    print(f"Versión actual: {get_version()}")
    print(f"Próxima versión patch: {get_next_version('patch')}")
    print(f"Próxima versión minor: {get_next_version('minor')}")
    print(f"Próxima versión major: {get_next_version('major')}")
