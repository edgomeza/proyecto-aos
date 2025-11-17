@echo off
echo =========================================
echo INICIANDO BASES DE DATOS - Docker Compose
echo =========================================

REM Verificar si Docker está instalado
where docker >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Docker no esta instalado.
    echo Instala Docker desde: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Iniciando contenedores MySQL...
docker-compose up -d

echo.
echo Esperando a que las bases de datos esten listas...
timeout /t 10 /nobreak

echo.
echo =========================================
echo BASES DE DATOS INICIADAS
echo =========================================
echo.
echo Estado de los contenedores:
docker-compose ps
echo.
echo Bases de datos disponibles:
echo   - Containers DB:  localhost:3306 (containers_db)
echo   - Logistics DB:   localhost:3307 (logistics_db)
echo   - Accounting DB:  localhost:3308 (accounting_db)
echo   - Users DB:       localhost:3309 (users_db)
echo.
echo phpMyAdmin: http://localhost:8090
echo   Usuario: root
echo   Password: root
echo.
echo Para ver logs: docker-compose logs -f
echo Para detener: docker-compose stop
echo =========================================
echo.
pause
