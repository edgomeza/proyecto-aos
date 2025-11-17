@echo off
echo =========================================
echo ALICATADOS PLASENCIA - SETUP COMPLETO
echo =========================================
echo.

REM Verificar Docker
where docker >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Docker no esta instalado
    echo Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Verificar que Docker está ejecutándose
docker info >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Docker no esta ejecutandose
    echo Por favor, inicia Docker Desktop
    pause
    exit /b 1
)

echo [1/3] Deteniendo contenedores antiguos...
docker-compose down -v 2>nul

echo.
echo [2/3] Construyendo imagenes Docker...
echo Esto puede tardar varios minutos la primera vez...
docker-compose build

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Fallo la construccion de imagenes
    pause
    exit /b 1
)

echo.
echo [3/3] Iniciando todos los servicios...
docker-compose up -d --build

echo.
echo =========================================
echo SISTEMA INICIADO CORRECTAMENTE
echo =========================================
echo.
echo Esperando a que los servicios esten listos...
timeout /t 30 /nobreak >nul

echo.
echo URLs disponibles:
echo   - Eureka Dashboard: http://localhost:8761
echo   - Gateway API:      http://localhost:8080/api
echo   - Containers API:   http://localhost:8101/swagger-ui.html
echo   - Logistics API:    http://localhost:8111/swagger-ui.html
echo   - Accounting API:   http://localhost:8121/swagger-ui.html
echo   - Users API:        http://localhost:8131/swagger-ui.html
echo.
echo Ver logs:           docker-compose logs -f
echo Ver estado:         docker-compose ps
echo Detener sistema:    docker-compose down
echo.
echo =========================================
pause
