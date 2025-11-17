@echo off
setlocal enabledelayedexpansion

set BASE_URL=http://localhost:8080/api

echo =========================================
echo PRUEBAS SISTEMA ALICATADOS PLASENCIA
echo =========================================
echo.

REM Verificar que curl está disponible
where curl >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: curl no esta instalado
    echo curl viene incluido en Windows 10/11
    pause
    exit /b 1
)

echo Verificando que el Gateway este activo...
curl -s http://localhost:8080/actuator/health >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: El Gateway no esta respondiendo
    echo Ejecuta 'setup.bat' primero para iniciar el sistema
    pause
    exit /b 1
)

echo OK - Gateway activo
echo.

echo =========================================
echo EJECUTANDO PRUEBAS
echo =========================================
echo.

echo [1/6] Verificar Eureka Server...
curl -s http://localhost:8761/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo OK - Eureka Server funcionando
) else (
    echo FALLO - Eureka Server no responde
)
echo.

echo [2/6] Verificar Config Server...
curl -s http://localhost:8888/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo OK - Config Server funcionando
) else (
    echo FALLO - Config Server no responde
)
echo.

echo [3/6] Verificar Gateway Service...
curl -s http://localhost:8080/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo OK - Gateway Service funcionando
) else (
    echo FALLO - Gateway Service no responde
)
echo.

echo [4/6] Verificar Containers Service...
curl -s http://localhost:8101/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo OK - Containers Service funcionando
) else (
    echo FALLO - Containers Service no responde
)
echo.

echo [5/6] Verificar Logistics Service...
curl -s http://localhost:8111/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo OK - Logistics Service funcionando
) else (
    echo FALLO - Logistics Service no responde
)
echo.

echo [6/6] Verificar Accounting Service...
curl -s http://localhost:8121/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo OK - Accounting Service funcionando
) else (
    echo FALLO - Accounting Service no responde
)
echo.

echo =========================================
echo PRUEBAS API
echo =========================================
echo.

echo Probando API de Containers Service...
echo Listando tipos de contenedores:
curl -s http://localhost:8101/types
echo.
echo.

echo =========================================
echo RESUMEN
echo =========================================
echo.
echo Todas las pruebas completadas
echo.
echo Para ver mas detalles:
echo   - Eureka Dashboard: http://localhost:8761
echo   - Containers Swagger: http://localhost:8101/swagger-ui.html
echo.
pause
