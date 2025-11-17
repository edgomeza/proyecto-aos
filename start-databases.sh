#!/bin/bash

echo "========================================="
echo "INICIANDO BASES DE DATOS - Docker Compose"
echo "========================================="

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker no está instalado."
    echo "Instala Docker desde: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Verificar si Docker está ejecutándose
if ! docker info &> /dev/null; then
    echo "ERROR: Docker no está ejecutándose."
    echo "Por favor, inicia Docker Desktop."
    exit 1
fi

echo "Iniciando contenedores MySQL..."
docker-compose up -d

echo ""
echo "Esperando a que las bases de datos estén listas..."
sleep 10

echo ""
echo "========================================="
echo "BASES DE DATOS INICIADAS"
echo "========================================="
echo ""
echo "Estado de los contenedores:"
docker-compose ps
echo ""
echo "Bases de datos disponibles:"
echo "  - Containers DB:  localhost:3306 (containers_db)"
echo "  - Logistics DB:   localhost:3307 (logistics_db)"
echo "  - Accounting DB:  localhost:3308 (accounting_db)"
echo "  - Users DB:       localhost:3309 (users_db)"
echo ""
echo "phpMyAdmin: http://localhost:8090"
echo "  Usuario: root"
echo "  Password: root"
echo ""
echo "Para ver logs: docker-compose logs -f"
echo "Para detener: docker-compose stop"
echo "========================================="
