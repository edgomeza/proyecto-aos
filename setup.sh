#!/bin/bash

# =========================================
# ALICATADOS PLASENCIA - SETUP COMPLETO
# =========================================
echo ""
echo "========================================="
echo "ALICATADOS PLASENCIA - SETUP COMPLETO"
echo "========================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Verificar Docker
echo -n "Verificando Docker..."
if ! command -v docker &> /dev/null; then
    echo -e " ${RED}ERROR${NC}"
    echo -e "${RED}ERROR: Docker no esta instalado${NC}"
    echo -e "${YELLOW}Instala Docker desde: https://www.docker.com/products/docker-desktop${NC}"
    read -p "Presiona Enter para salir"
    exit 1
fi
echo -e " ${GREEN}OK${NC}"

# Verificar que Docker está ejecutándose
echo -n "Verificando que Docker este ejecutandose..."
if ! docker info > /dev/null 2>&1; then
    echo -e " ${RED}ERROR${NC}"
    echo -e "${RED}ERROR: Docker no esta ejecutandose${NC}"
    echo -e "${YELLOW}Por favor, inicia Docker Desktop o el servicio de Docker${NC}"
    read -p "Presiona Enter para salir"
    exit 1
fi
echo -e " ${GREEN}OK${NC}"

echo ""
echo -e "${YELLOW}[1/3] Deteniendo contenedores antiguos...${NC}"
docker-compose down -v 2> /dev/null

echo ""
echo -e "${YELLOW}[2/3] Construyendo imagenes Docker...${NC}"
echo -e "${GRAY}Esto puede tardar varios minutos la primera vez...${NC}"
docker-compose build

if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}ERROR: Fallo la construccion de imagenes${NC}"
    read -p "Presiona Enter para salir"
    exit 1
fi

echo ""
echo -e "${YELLOW}[3/3] Iniciando todos los servicios...${NC}"
docker-compose up -d --build

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}SISTEMA INICIADO CORRECTAMENTE${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${GRAY}Esperando a que los servicios esten listos...${NC}"
sleep 30

echo ""
echo -e "${CYAN}URLs disponibles:${NC}"
echo "  - Eureka Dashboard: http://localhost:8761"
echo "  - Gateway API:      http://localhost:8080/api"
echo "  - Containers API:   http://localhost:8101/swagger-ui.html"
echo "  - Logistics API:    http://localhost:8111/swagger-ui.html"
echo "  - Accounting API:   http://localhost:8121/swagger-ui.html"
echo "  - Users API:        http://localhost:8131/swagger-ui.html"
echo ""
echo -e "${YELLOW}Comandos utiles:${NC}"
echo "  Ver logs:           docker-compose logs -f"
echo "  Ver estado:         docker-compose ps"
echo "  Detener sistema:    docker-compose down"
echo ""
echo -e "${CYAN}=========================================${NC}"
read -p "Presiona Enter para salir"
