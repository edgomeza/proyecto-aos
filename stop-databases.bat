@echo off
echo =========================================
echo DETENIENDO BASES DE DATOS - Docker Compose
echo =========================================

docker-compose stop

echo.
echo Bases de datos detenidas.
echo Los datos se mantienen en los volumenes Docker.
echo.
echo Para reiniciar: start-databases.bat
echo Para eliminar TODO (incluidos datos): docker-compose down -v
echo =========================================
echo.
pause
