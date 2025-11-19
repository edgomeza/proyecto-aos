#!/bin/bash

# =========================================
# PRUEBAS SISTEMA ALICATADOS PLASENCIA
# Script de pruebas automatizadas para todos los microservicios
# =========================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
NC='\033[0m' # No Color

# Variables de conteo
PASSED=0
FAILED=0

# Generar timestamp único para datos de prueba
TIMESTAMP=$(date +%H%M%S%N | cut -b1-10)

# Funciones para output
print_test_header() {
    echo ""
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
}

print_test_result() {
    if [ "$2" = "true" ]; then
        echo -e "   ${GREEN}[OK]${NC} $1"
        ((PASSED++))
    else
        echo -e "   ${RED}[FALLO]${NC} $1"
        ((FAILED++))
    fi
}

print_use_case() {
    echo ""
    echo -e "   ${MAGENTA}[Caso de Uso]${NC} $1"
    echo ""
}

# Banner inicial
echo ""
echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}PRUEBAS SISTEMA ALICATADOS PLASENCIA${NC}"
echo -e "${YELLOW}=========================================${NC}"
echo ""
echo ""
echo -e "${CYAN}Este script prueba el sistema completo de gestion de alquiler de contenedores:${NC}"
echo -e "${GRAY}  1. Infraestructura y servicios base${NC}"
echo -e "${GRAY}  2. Gestion de tipos y contenedores fisicos${NC}"
echo -e "${GRAY}  3. Tarifas y contratos de alquiler${NC}"
echo -e "${GRAY}  4. Inspecciones post-devolucion${NC}"
echo -e "${GRAY}  5. Rutas de transporte logistico${NC}"
echo -e "${GRAY}  6. Facturacion de servicios${NC}"
echo -e "${GRAY}  7. Gestion de usuarios del sistema${NC}"
echo -e "${GRAY}  8. Enrutamiento a traves del API Gateway${NC}"
echo -e "${GRAY}  9. Descubrimiento de servicios con Eureka${NC}"
echo ""
echo -e "${YELLOW}NOTA: Para mejores resultados, ejecute con base de datos limpia${NC}"
echo -e "${YELLOW}      o reinicie los servicios antes de la primera ejecucion.${NC}"
echo ""

# Verificar que Docker está ejecutándose
echo -n "Verificando que Docker este ejecutandose..."
if ! docker ps > /dev/null 2>&1; then
    echo -e " ${RED}ERROR${NC}"
    echo -e "${RED}Docker no esta ejecutandose. Por favor, inicie Docker Desktop.${NC}"
    exit 1
fi
echo -e " ${GREEN}OK${NC}"

# =========================================
# 1. INFRAESTRUCTURA (7 pruebas)
# =========================================
print_test_header "1. INFRAESTRUCTURA (7 pruebas)"
print_use_case "Verificar que todos los servicios de infraestructura (Eureka, Config Server, Gateway) y microservicios de negocio esten disponibles y respondiendo correctamente"

# Eureka Server - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8761/actuator/health 2>/dev/null || curl -s -o /dev/null -w "%{http_code}" http://localhost:8761 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Eureka Server" "true"
else
    print_test_result "Eureka Server" "false"
fi

# Config Server - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8888/actuator/health 2>/dev/null || curl -s -o /dev/null -w "%{http_code}" http://localhost:8888 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Config Server" "true"
else
    print_test_result "Config Server" "false"
fi

# Gateway Service - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Gateway Service" "true"
else
    print_test_result "Gateway Service" "false"
fi

# Containers Service - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/actuator/health 2>/dev/null || curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/types 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Containers Service" "true"
else
    print_test_result "Containers Service" "false"
fi

# Logistics Service - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8111/actuator/health 2>/dev/null || curl -s -o /dev/null -w "%{http_code}" http://localhost:8111/routes 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Logistics Service" "true"
else
    print_test_result "Logistics Service" "false"
fi

# Accounting Service - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/actuator/health 2>/dev/null || curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Accounting Service" "true"
else
    print_test_result "Accounting Service" "false"
fi

# Users Service - Health check
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/actuator/health 2>/dev/null || curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/users 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Users Service" "true"
else
    print_test_result "Users Service" "false"
fi

# =========================================
# 2. CONTAINERS SERVICE - Tipos (3 pruebas)
# =========================================
print_test_header "2. CONTAINERS SERVICE - Tipos (3 pruebas)"
print_use_case "Gestionar catalogo de tipos de contenedores disponibles (5m3, 10m3, etc.). Consultar todos los tipos, filtrar solo activos, y crear nuevos tipos para el sistema"

# Variable para almacenar el ID del tipo creado
createdTypeId=""

# GET /types
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/types 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /types" "true"
else
    print_test_result "GET /types" "false"
fi

# GET /types/active
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/types/active 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /types/active" "true"
else
    print_test_result "GET /types/active" "false"
fi

# POST /types
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8101/types \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"Test Container 5m3 $TIMESTAMP\",\"capacityM3\":5.0,\"active\":true}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | sed '$d')

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /types" "true"
    createdTypeId=$(echo "$response_body" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    echo -e "     ${DARKGRAY}[INFO] Tipo creado con ID: $createdTypeId${NC}"
else
    print_test_result "POST /types" "false"
fi

# =========================================
# 3. CONTAINERS SERVICE - Contenedores (4 pruebas)
# =========================================
print_test_header "3. CONTAINERS SERVICE - Contenedores (4 pruebas)"
print_use_case "Gestionar inventario de contenedores fisicos. Consultar todos los contenedores, filtrar por disponibilidad, consultar por estado especifico, y registrar nuevos contenedores en el sistema"

# Variable para almacenar el ID del contenedor creado
createdContainerId=""

# GET /containers
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/containers 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /containers" "true"
else
    print_test_result "GET /containers" "false"
fi

# GET /containers/available
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/containers/available 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /containers/available" "true"
else
    print_test_result "GET /containers/available" "false"
fi

# GET /containers/status/AVAILABLE
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/containers/status/AVAILABLE 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /containers/status/AVAILABLE" "true"
else
    print_test_result "GET /containers/status/AVAILABLE" "false"
fi

# POST /containers
typeIdToUse=${createdTypeId:-1}
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8101/containers \
    -H "Content-Type: application/json" \
    -d "{\"containerCode\":\"TEST-$TIMESTAMP\",\"containerType\":{\"id\":$typeIdToUse},\"status\":\"AVAILABLE\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | sed '$d')

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /containers" "true"
    createdContainerId=$(echo "$response_body" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    echo -e "     ${DARKGRAY}[INFO] Contenedor creado con ID: $createdContainerId (usando tipo ID: $typeIdToUse)${NC}"
else
    print_test_result "POST /containers" "false"
fi

# =========================================
# 4. CONTAINERS SERVICE - Tarifas (3 pruebas)
# =========================================
print_test_header "4. CONTAINERS SERVICE - Tarifas (3 pruebas)"
print_use_case "Gestionar tarifas de alquiler por tipo de contenedor. Consultar todas las tarifas, filtrar solo activas, y crear nuevas tarifas con precios base diarios"

# GET /rates
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/rates 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /rates" "true"
else
    print_test_result "GET /rates" "false"
fi

# GET /rates/active
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/rates/active 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /rates/active" "true"
else
    print_test_result "GET /rates/active" "false"
fi

# POST /rates
typeIdToUse=${createdTypeId:-1}
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8101/rates \
    -H "Content-Type: application/json" \
    -d "{\"containerType\":{\"id\":$typeIdToUse},\"periodType\":\"DAILY\",\"basePrice\":25.0,\"active\":true}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /rates" "true"
    echo -e "     ${DARKGRAY}[INFO] Tarifa creada para tipo ID: $typeIdToUse${NC}"
else
    print_test_result "POST /rates" "false"
fi

# =========================================
# 5. CONTAINERS SERVICE - Alquileres (4 pruebas)
# =========================================
print_test_header "5. CONTAINERS SERVICE - Alquileres (4 pruebas)"
print_use_case "Gestionar contratos de alquiler de contenedores. Consultar todos los alquileres, filtrar por estado (activos/pendientes), y crear nuevos contratos asociando contenedor con cliente"

# Variable para almacenar el ID del alquiler creado
createdRentalId=""

# GET /rentals
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/rentals 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /rentals" "true"
else
    print_test_result "GET /rentals" "false"
fi

# GET /rentals/active
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/rentals/active 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /rentals/active" "true"
else
    print_test_result "GET /rentals/active" "false"
fi

# GET /rentals/pending
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/rentals/pending 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /rentals/pending" "true"
else
    print_test_result "GET /rentals/pending" "false"
fi

# POST /rentals
containerIdToUse=${createdContainerId:-1}
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8101/rentals \
    -H "Content-Type: application/json; charset=utf-8" \
    -d "{\"rentalNumber\":\"RNT-$TIMESTAMP\",\"container\":{\"id\":$containerIdToUse},\"customerId\":1,\"startDate\":\"2025-11-17\",\"expectedEndDate\":\"2025-11-24\",\"deliveryAddress\":\"Test Address 123\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | sed '$d')

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /rentals" "true"
    createdRentalId=$(echo "$response_body" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    echo -e "     ${DARKGRAY}[INFO] Alquiler creado con ID: $createdRentalId (usando contenedor ID: $containerIdToUse)${NC}"
else
    print_test_result "POST /rentals" "false"
    if [ "$status_code" = "400" ] || [ "$status_code" = "404" ]; then
        echo -e "     ${DARKGRAY}[INFO] Error al crear alquiler - verifica que el contenedor existe y esta disponible${NC}"
    fi
fi

# =========================================
# 6. CONTAINERS SERVICE - Inspecciones (2 pruebas)
# =========================================
print_test_header "6. CONTAINERS SERVICE - Inspecciones (2 pruebas)"
print_use_case "Registrar inspecciones de contenedores al finalizar alquileres. Consultar historial de inspecciones y crear nuevas evaluaciones del estado del contenedor tras su devolucion"

# GET /inspections
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8101/inspections 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /inspections" "true"
else
    print_test_result "GET /inspections" "false"
fi

# POST /inspections
rentalIdToUse=${createdRentalId:-1}
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8101/inspections \
    -H "Content-Type: application/json; charset=utf-8" \
    -d "{\"rental\":{\"id\":$rentalIdToUse},\"conditionStatus\":\"GOOD\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | sed '$d')

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /inspections" "true"
    inspectionId=$(echo "$response_body" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
    echo -e "     ${DARKGRAY}[INFO] Inspeccion creada con ID: $inspectionId (usando alquiler ID: $rentalIdToUse)${NC}"
else
    print_test_result "POST /inspections" "false"
    if [ "$status_code" = "400" ] || [ "$status_code" = "404" ]; then
        echo -e "     ${DARKGRAY}[INFO] Error al crear inspeccion - verifica que el alquiler existe${NC}"
    fi
fi

# =========================================
# 7. LOGISTICS SERVICE - Rutas (7 pruebas)
# =========================================
print_test_header "7. LOGISTICS SERVICE - Rutas (7 pruebas)"
print_use_case "Gestionar rutas de transporte de contenedores. Consultar rutas, filtrar por estado (planificadas/activas), buscar por fecha, crear nuevas rutas y actualizar informacion de rutas existentes"

# GET /routes
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8111/routes 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /routes" "true"
else
    print_test_result "GET /routes" "false"
fi

# GET /routes/status/PLANNED
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8111/routes/status/PLANNED 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /routes/status/PLANNED" "true"
else
    print_test_result "GET /routes/status/PLANNED" "false"
fi

# GET /routes/active
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8111/routes/active 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /routes/active" "true"
else
    print_test_result "GET /routes/active" "false"
fi

# GET /routes/planned
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8111/routes/planned 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /routes/planned" "true"
else
    print_test_result "GET /routes/planned" "false"
fi

# GET /routes/date/{date}
today=$(date +%Y-%m-%d)
status_code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8111/routes/date/$today" 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /routes/date/{date}" "true"
else
    print_test_result "GET /routes/date/{date}" "false"
fi

# POST /routes
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8111/routes \
    -H "Content-Type: application/json" \
    -d "{\"routeCode\":\"RT-TEST-$TIMESTAMP\",\"origin\":\"Plasencia\",\"destination\":\"Caceres\",\"scheduleDate\":\"2025-11-20\",\"status\":\"PLANNED\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /routes" "true"
else
    print_test_result "POST /routes" "false"
fi

# PUT /routes/{id}
response=$(curl -s -w "\n%{http_code}" -X PUT http://localhost:8111/routes/1 \
    -H "Content-Type: application/json" \
    -d "{\"routeCode\":\"RT-001\",\"origin\":\"Plasencia\",\"destination\":\"Madrid\",\"scheduleDate\":\"2025-11-18\",\"status\":\"PLANNED\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "PUT /routes/{id}" "true"
else
    print_test_result "PUT /routes/{id}" "false"
fi

# =========================================
# 8. ACCOUNTING SERVICE - Facturas (8 pruebas)
# =========================================
print_test_header "8. ACCOUNTING SERVICE - Facturas (8 pruebas)"
print_use_case "Gestionar facturacion de servicios. Consultar facturas, filtrar por estado (pendientes/pagadas/vencidas), buscar por cliente, crear nuevas facturas y actualizar estado de pago"

# GET /invoices
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /invoices" "true"
else
    print_test_result "GET /invoices" "false"
fi

# GET /invoices/status/PENDING
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices/status/PENDING 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /invoices/status/PENDING" "true"
else
    print_test_result "GET /invoices/status/PENDING" "false"
fi

# GET /invoices/pending
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices/pending 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /invoices/pending" "true"
else
    print_test_result "GET /invoices/pending" "false"
fi

# GET /invoices/paid
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices/paid 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /invoices/paid" "true"
else
    print_test_result "GET /invoices/paid" "false"
fi

# GET /invoices/overdue
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices/overdue 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /invoices/overdue" "true"
else
    print_test_result "GET /invoices/overdue" "false"
fi

# GET /invoices/customer/{id}
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8121/invoices/customer/1 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /invoices/customer/{id}" "true"
else
    print_test_result "GET /invoices/customer/{id}" "false"
fi

# POST /invoices
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8121/invoices \
    -H "Content-Type: application/json" \
    -d "{\"invoiceNumber\":\"INV-TEST-$TIMESTAMP\",\"customerId\":1,\"invoiceDate\":\"2025-11-17\",\"subtotal\":100.0,\"totalAmount\":121.0,\"status\":\"PENDING\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /invoices" "true"
else
    print_test_result "POST /invoices" "false"
fi

# PUT /invoices/{id}
response=$(curl -s -w "\n%{http_code}" -X PUT http://localhost:8121/invoices/1 \
    -H "Content-Type: application/json" \
    -d "{\"invoiceNumber\":\"INV-001\",\"customerId\":1,\"invoiceDate\":\"2025-11-17\",\"subtotal\":150.0,\"totalAmount\":181.5,\"status\":\"PAID\"}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "PUT /invoices/{id}" "true"
else
    print_test_result "PUT /invoices/{id}" "false"
fi

# =========================================
# 9. USERS SERVICE - Usuarios (8 pruebas)
# =========================================
print_test_header "9. USERS SERVICE - Usuarios (8 pruebas)"
print_use_case "Gestionar usuarios del sistema. Consultar usuarios, filtrar por rol (clientes/administradores) y estado (activos/inactivos), crear nuevos usuarios, actualizar informacion y eliminar usuarios"

# GET /users
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/users 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /users" "true"
else
    print_test_result "GET /users" "false"
fi

# GET /users/role/CUSTOMER
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/users/role/CUSTOMER 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /users/role/CUSTOMER" "true"
else
    print_test_result "GET /users/role/CUSTOMER" "false"
fi

# GET /users/role/ADMIN
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/users/role/ADMIN 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /users/role/ADMIN" "true"
else
    print_test_result "GET /users/role/ADMIN" "false"
fi

# GET /users/active
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/users/active 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /users/active" "true"
else
    print_test_result "GET /users/active" "false"
fi

# GET /users/inactive
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8131/users/inactive 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "GET /users/inactive" "true"
else
    print_test_result "GET /users/inactive" "false"
fi

# POST /users
response=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8131/users \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"testuser$TIMESTAMP\",\"email\":\"test$TIMESTAMP@example.com\",\"password\":\"Test123456\",\"role\":\"CUSTOMER\",\"active\":true}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "POST /users" "true"
else
    print_test_result "POST /users" "false"
fi

# PUT /users/{id}
response=$(curl -s -w "\n%{http_code}" -X PUT http://localhost:8131/users/1 \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"admin\",\"email\":\"admin@example.com\",\"password\":\"Admin123456\",\"role\":\"ADMIN\",\"active\":true}" 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "PUT /users/{id}" "true"
else
    print_test_result "PUT /users/{id}" "false"
fi

# DELETE /users/{id}
response=$(curl -s -w "\n%{http_code}" -X DELETE http://localhost:8131/users/999 2>/dev/null)
status_code=$(echo "$response" | tail -n1)

if [[ "$status_code" =~ ^2 ]]; then
    print_test_result "DELETE /users/{id}" "true"
else
    print_test_result "DELETE /users/{id}" "false"
fi

# =========================================
# 10. GATEWAY - Enrutamiento (4 pruebas)
# =========================================
print_test_header "10. GATEWAY - Enrutamiento (4 pruebas)"
print_use_case "Verificar que el API Gateway enruta correctamente las peticiones a cada microservicio. Prueba acceso unificado a todos los servicios a traves del puerto 8080"

# Gateway -> Containers
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/containers/types 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Gateway -> Containers" "true"
else
    print_test_result "Gateway -> Containers" "false"
fi

# Gateway -> Logistics
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/logistics/routes 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Gateway -> Logistics" "true"
else
    print_test_result "Gateway -> Logistics" "false"
fi

# Gateway -> Accounting
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/accounting/invoices 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Gateway -> Accounting" "true"
else
    print_test_result "Gateway -> Accounting" "false"
fi

# Gateway -> Users
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/users/users 2>/dev/null)
if [ "$status_code" = "200" ]; then
    print_test_result "Gateway -> Users" "true"
else
    print_test_result "Gateway -> Users" "false"
fi

# =========================================
# 11. EUREKA - Registro (5 pruebas)
# =========================================
print_test_header "11. EUREKA - Registro (5 pruebas)"
print_use_case "Verificar que todos los microservicios se han registrado correctamente en Eureka para descubrimiento de servicios. Confirma que el sistema puede localizar dinamicamente cada microservicio"

# Containers registrado
response=$(curl -s http://localhost:8761/eureka/apps 2>/dev/null)
if [[ "$response" == *"CONTAINERS-SERVICE"* ]]; then
    print_test_result "Containers registrado" "true"
else
    print_test_result "Containers NO registrado" "false"
fi

# Logistics registrado
if [[ "$response" == *"LOGISTICS-SERVICE"* ]]; then
    print_test_result "Logistics registrado" "true"
else
    print_test_result "Logistics NO registrado" "false"
fi

# Accounting registrado
if [[ "$response" == *"ACCOUNTING-SERVICE"* ]]; then
    print_test_result "Accounting registrado" "true"
else
    print_test_result "Accounting NO registrado" "false"
fi

# Users registrado
if [[ "$response" == *"USERS-SERVICE"* ]]; then
    print_test_result "Users registrado" "true"
else
    print_test_result "Users NO registrado" "false"
fi

# Gateway registrado
if [[ "$response" == *"GATEWAY-SERVICE"* ]]; then
    print_test_result "Gateway registrado" "true"
else
    print_test_result "Gateway NO registrado" "false"
fi

# =========================================
# RESUMEN FINAL
# =========================================
echo ""
echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}RESUMEN FINAL${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""

TOTAL=$((PASSED + FAILED))
echo "Total de pruebas: $TOTAL"
echo -n "Exitosas:         "
echo -e "${GREEN}$PASSED${NC}"
echo -n "Fallidas:         "
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}$FAILED${NC}"
else
    echo -e "${RED}$FAILED${NC}"
fi
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}[EXITO] TODAS LAS PRUEBAS PASARON${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo -e "${GREEN}Sistema 100% operativo:${NC}"
    echo "  - Infraestructura:     7/7"
    echo "  - Containers Service:  16/16 endpoints"
    echo "  - Logistics Service:   7/7 endpoints"
    echo "  - Accounting Service:  8/8 endpoints"
    echo "  - Users Service:       8/8 endpoints"
    echo "  - Gateway:             4/4 rutas"
    echo "  - Eureka:              5/5 servicios"
    echo ""
    echo -e "${GREEN}TOTAL: $PASSED pruebas exitosas${NC}"
else
    echo -e "${RED}================================================${NC}"
    echo -e "${RED}[ATENCION] HAY PRUEBAS FALLIDAS${NC}"
    echo -e "${RED}================================================${NC}"
    echo ""
    echo -e "${YELLOW}Para diagnosticar:${NC}"
    echo "  docker-compose logs -f [servicio]"
    echo "  http://localhost:8761"
    echo ""
    echo -e "${YELLOW}Para reiniciar:${NC}"
    echo "  ./setup.sh  (Linux/Mac)"
    echo "  docker-compose down && docker-compose up -d  (Manual)"
fi
echo ""

# =========================================
# RECURSOS
# =========================================
echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}RECURSOS${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo -e "${YELLOW}Dashboards:${NC}"
echo "  Eureka:     http://localhost:8761"
echo "  Config:     http://localhost:8888"
echo ""
echo -e "${YELLOW}Swagger (Documentacion API):${NC}"
echo "  Containers: http://localhost:8101/swagger-ui.html"
echo "  Logistics:  http://localhost:8111/swagger-ui.html"
echo "  Accounting: http://localhost:8121/swagger-ui.html"
echo "  Users:      http://localhost:8131/swagger-ui.html"
echo ""
echo -e "${YELLOW}Gateway (Acceso unificado):${NC}"
echo "  Containers: http://localhost:8080/api/containers"
echo "  Logistics:  http://localhost:8080/api/logistics"
echo "  Accounting: http://localhost:8080/api/accounting"
echo "  Users:      http://localhost:8080/api/users"
echo ""

# Salir con código de error si hay fallos
if [ $FAILED -gt 0 ]; then
    exit 1
fi
exit 0
