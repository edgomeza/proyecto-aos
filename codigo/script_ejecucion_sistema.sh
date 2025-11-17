#!/bin/bash

echo "========================================="
echo "INICIANDO SISTEMA - ALICATADOS PLASENCIA"
echo "========================================="

# 1. Eureka Server
echo "Iniciando Eureka Server (8761)..."
cd ../eureka-server
mvn spring-boot:run &
EUREKA_PID=$!
cd ../codigo
sleep 15

# 2. Config Server
echo "Iniciando Config Server (8888)..."
cd ../config-server
mvn spring-boot:run &
CONFIG_PID=$!
cd ../codigo
sleep 10

# 3. Gateway Service
echo "Iniciando Gateway Service (8080)..."
cd ../gateway-service
mvn spring-boot:run &
GATEWAY_PID=$!
cd ../codigo
sleep 10

# 4. Containers Service (2 instancias)
echo "Iniciando Containers Service instancia 1 (8101)..."
cd ../containers-service
mvn spring-boot:run &
CONTAINERS1_PID=$!
cd ../codigo
sleep 5

echo "Iniciando Containers Service instancia 2 (8102)..."
cd ../containers-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8102 &
CONTAINERS2_PID=$!
cd ../codigo
sleep 5

# 5. Logistics Service (2 instancias)
echo "Iniciando Logistics Service instancia 1 (8111)..."
cd ../logistics-service
mvn spring-boot:run &
LOGISTICS1_PID=$!
cd ../codigo
sleep 5

echo "Iniciando Logistics Service instancia 2 (8112)..."
cd ../logistics-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8112 &
LOGISTICS2_PID=$!
cd ../codigo
sleep 5

# 6. Accounting Service (2 instancias)
echo "Iniciando Accounting Service instancia 1 (8121)..."
cd ../accounting-service
mvn spring-boot:run &
ACCOUNTING1_PID=$!
cd ../codigo
sleep 5

echo "Iniciando Accounting Service instancia 2 (8122)..."
cd ../accounting-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8122 &
ACCOUNTING2_PID=$!
cd ../codigo
sleep 5

# 7. Users Service (2 instancias)
echo "Iniciando Users Service instancia 1 (8131)..."
cd ../users-service
mvn spring-boot:run &
USERS1_PID=$!
cd ../codigo
sleep 5

echo "Iniciando Users Service instancia 2 (8132)..."
cd ../users-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8132 &
USERS2_PID=$!
cd ../codigo

echo "========================================="
echo "SISTEMA INICIADO COMPLETAMENTE"
echo "========================================="
echo "Eureka: http://localhost:8761"
echo "Gateway: http://localhost:8080"
echo "Containers: http://localhost:8101, http://localhost:8102"
echo "Logistics: http://localhost:8111, http://localhost:8112"
echo "Accounting: http://localhost:8121, http://localhost:8122"
echo "Users: http://localhost:8131, http://localhost:8132"
echo "========================================="

# Esperar para que el usuario detenga los servicios
read -p "Presiona ENTER para detener todos los servicios..."

# Detener todos los procesos
kill $EUREKA_PID $CONFIG_PID $GATEWAY_PID \
     $CONTAINERS1_PID $CONTAINERS2_PID \
     $LOGISTICS1_PID $LOGISTICS2_PID \
     $ACCOUNTING1_PID $ACCOUNTING2_PID \
     $USERS1_PID $USERS2_PID

echo "Todos los servicios han sido detenidos."
