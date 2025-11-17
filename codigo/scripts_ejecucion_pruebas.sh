#!/bin/bash

BASE_URL="http://localhost:8080/api"

echo "========================================="
echo "PRUEBAS SISTEMA ALICATADOS PLASENCIA"
echo "========================================="

# Prueba 1: Listar tipos de contenedores
echo ""
echo "1. Listar tipos de contenedores disponibles"
curl -X GET "${BASE_URL}/containers/types" | jq

# Prueba 2: Crear nuevo alquiler de contenedor
echo ""
echo "2. Crear alquiler de contenedor"
curl -X POST "${BASE_URL}/containers/rentals" \
  -H "Content-Type: application/json" \
  -d '{
    "containerId": 1,
    "customerId": 10,
    "startDate": "2025-11-20",
    "expectedEndDate": "2025-12-05",
    "deliveryAddress": "Calle Mayor 25, Plasencia",
    "deliveryCity": "Plasencia",
    "deliveryPostalCode": "10600"
  }' | jq

# Prueba 3: Consultar rutas del día
echo ""
echo "3. Consultar rutas planificadas"
curl -X GET "${BASE_URL}/logistics/routes?date=2025-11-20" | jq

# Prueba 4: Generar nóminas del mes
echo ""
echo "4. Generar nóminas de noviembre 2025"
curl -X POST "${BASE_URL}/accounting/payrolls/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "periodMonth": 11,
    "periodYear": 2025
  }' | jq

# Prueba 5: Estadísticas financieras
echo ""
echo "5. Consultar estadísticas financieras del mes"
curl -X GET "${BASE_URL}/accounting/statistics?month=11&year=2025" | jq

# Prueba 6: Login de usuario
echo ""
echo "6. Autenticación de usuario"
curl -X POST "${BASE_URL}/users/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }' | jq

echo ""
echo "========================================="
echo "PRUEBAS COMPLETADAS"
echo "========================================="
