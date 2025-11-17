#!/bin/bash

echo "========================================="
echo "DETENIENDO BASES DE DATOS - Docker Compose"
echo "========================================="

docker-compose stop

echo ""
echo "Bases de datos detenidas."
echo "Los datos se mantienen en los volúmenes Docker."
echo ""
echo "Para reiniciar: ./start-databases.sh"
echo "Para eliminar TODO (incluidos datos): docker-compose down -v"
echo "========================================="
