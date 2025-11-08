#!/bin/bash

echo "=========================================="
echo "  Verificación de Angular 20"
echo "=========================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 está disponible"
        return 0
    else
        echo -e "${RED}✗${NC} $1 no está disponible"
        return 1
    fi
}

# 1. Verificar Node.js
echo "1. Verificando versión de Node.js..."
NODE_VERSION=$(node -v 2>/dev/null)
if [ $? -eq 0 ]; then
    MAJOR_VERSION=$(echo $NODE_VERSION | sed 's/v\([0-9]*\).*/\1/')
    if [ "$MAJOR_VERSION" -ge 20 ]; then
        echo -e "${GREEN}✓${NC} Node.js $NODE_VERSION (mínimo v20.11.1 requerido)"
    else
        echo -e "${RED}✗${NC} Node.js $NODE_VERSION es muy antiguo. Se requiere v20.11.1 o superior"
        echo -e "${YELLOW}!${NC} Por favor actualiza Node.js desde https://nodejs.org/"
    fi
else
    echo -e "${RED}✗${NC} Node.js no está instalado"
fi
echo ""

# 2. Verificar package.json
echo "2. Verificando package.json..."
ANGULAR_VERSION=$(grep '"@angular/core"' package.json | grep -o '"[^"]*"' | tail -1 | tr -d '"')
TYPESCRIPT_VERSION=$(grep '"typescript"' package.json | grep -o '"[^"]*"' | tail -1 | tr -d '"')
ZONE_VERSION=$(grep '"zone.js"' package.json | grep -o '"[^"]*"' | tail -1 | tr -d '"')

echo -e "${GREEN}✓${NC} @angular/core: $ANGULAR_VERSION"
echo -e "${GREEN}✓${NC} typescript: $TYPESCRIPT_VERSION"
echo -e "${GREEN}✓${NC} zone.js: $ZONE_VERSION"
echo ""

# 3. Verificar si node_modules existe
echo "3. Verificando instalación de dependencias..."
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} node_modules existe"

    # Verificar versión instalada de Angular
    if [ -f "node_modules/@angular/core/package.json" ]; then
        INSTALLED_VERSION=$(grep '"version"' node_modules/@angular/core/package.json | head -1 | grep -o '"[^"]*"' | tail -1 | tr -d '"')
        MAJOR=$(echo $INSTALLED_VERSION | cut -d. -f1)

        if [ "$MAJOR" = "20" ]; then
            echo -e "${GREEN}✓${NC} Angular Core instalado: v$INSTALLED_VERSION"
        else
            echo -e "${YELLOW}!${NC} Angular Core instalado: v$INSTALLED_VERSION (se esperaba v20.x.x)"
            echo -e "${YELLOW}!${NC} Ejecuta: npm install"
        fi
    else
        echo -e "${YELLOW}!${NC} @angular/core no encontrado en node_modules"
        echo -e "${YELLOW}!${NC} Ejecuta: npm install"
    fi

    # Verificar Angular CLI
    if [ -f "node_modules/@angular/cli/package.json" ]; then
        CLI_VERSION=$(grep '"version"' node_modules/@angular/cli/package.json | head -1 | grep -o '"[^"]*"' | tail -1 | tr -d '"')
        CLI_MAJOR=$(echo $CLI_VERSION | cut -d. -f1)

        if [ "$CLI_MAJOR" = "20" ]; then
            echo -e "${GREEN}✓${NC} Angular CLI instalado: v$CLI_VERSION"
        else
            echo -e "${YELLOW}!${NC} Angular CLI instalado: v$CLI_VERSION (se esperaba v20.x.x)"
        fi
    fi

    # Verificar TypeScript
    if [ -f "node_modules/typescript/package.json" ]; then
        TS_VERSION=$(grep '"version"' node_modules/typescript/package.json | head -1 | grep -o '"[^"]*"' | tail -1 | tr -d '"')
        TS_MAJOR=$(echo $TS_VERSION | cut -d. -f1)
        TS_MINOR=$(echo $TS_VERSION | cut -d. -f2)

        if [ "$TS_MAJOR" = "5" ] && [ "$TS_MINOR" -ge 6 ]; then
            echo -e "${GREEN}✓${NC} TypeScript instalado: v$TS_VERSION"
        else
            echo -e "${YELLOW}!${NC} TypeScript instalado: v$TS_VERSION (se recomienda v5.6.x)"
        fi
    fi
else
    echo -e "${YELLOW}!${NC} node_modules no existe"
    echo -e "${YELLOW}!${NC} Ejecuta: npm install"
fi
echo ""

# 4. Verificar Angular CLI (si está instalado)
echo "4. Verificando Angular CLI..."
if [ -x "node_modules/.bin/ng" ]; then
    NG_VERSION=$(./node_modules/.bin/ng version 2>/dev/null | grep "Angular CLI" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    if [ ! -z "$NG_VERSION" ]; then
        echo -e "${GREEN}✓${NC} ng version: $NG_VERSION"
    fi
else
    echo -e "${YELLOW}!${NC} Angular CLI no está instalado localmente"
    echo -e "${YELLOW}!${NC} Ejecuta: npm install"
fi
echo ""

# 5. Verificar archivos de migración
echo "5. Verificando documentación..."
if [ -f "ANGULAR_20_MIGRATION.md" ]; then
    echo -e "${GREEN}✓${NC} ANGULAR_20_MIGRATION.md existe"
else
    echo -e "${RED}✗${NC} ANGULAR_20_MIGRATION.md no encontrado"
fi
echo ""

# 6. Verificar Git
echo "6. Verificando estado de Git..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    LAST_COMMIT=$(git log -1 --oneline | head -1)
    echo -e "${GREEN}✓${NC} Último commit: $LAST_COMMIT"

    if echo "$LAST_COMMIT" | grep -q "Angular.*20"; then
        echo -e "${GREEN}✓${NC} El commit de migración está presente"
    fi
else
    echo -e "${RED}✗${NC} No es un repositorio Git"
fi
echo ""

# Resumen
echo "=========================================="
echo "  Resumen"
echo "=========================================="
echo ""
echo "Para completar la verificación:"
echo "1. Asegúrate de tener Node.js 20.11.1 o superior"
echo "2. Ejecuta: npm install"
echo "3. Ejecuta: npm start (para verificar que compila)"
echo "4. Ejecuta: npm run build (para verificar producción)"
echo ""
echo "Si todo funciona correctamente, la migración a Angular 20 está completa ✓"
echo ""
