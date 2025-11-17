#!/bin/bash

echo "========================================="
echo "COMPILANDO MICROSERVICIOS - ALICATADOS PLASENCIA"
echo "========================================="

# Servicios de infraestructura
echo "1. Compilando eureka-server..."
cd ../eureka-server && mvn clean package -DskipTests
cd ../codigo

echo "2. Compilando config-server..."
cd ../config-server && mvn clean package -DskipTests
cd ../codigo

echo "3. Compilando gateway-service..."
cd ../gateway-service && mvn clean package -DskipTests
cd ../codigo

# Microservicios base
echo "4. Compilando containers-service..."
cd ../containers-service && mvn clean package -DskipTests
cd ../codigo

echo "5. Compilando logistics-service..."
cd ../logistics-service && mvn clean package -DskipTests
cd ../codigo

echo "6. Compilando accounting-service..."
cd ../accounting-service && mvn clean package -DskipTests
cd ../codigo

echo "7. Compilando users-service..."
cd ../users-service && mvn clean package -DskipTests
cd ../codigo

echo "========================================="
echo "COMPILACIÓN COMPLETADA"
echo "========================================="
