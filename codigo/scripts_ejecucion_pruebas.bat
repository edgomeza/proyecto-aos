@echo off
setlocal enabledelayedexpansion

set BASE_URL=http://localhost:8080/api

echo =========================================
echo PRUEBAS SISTEMA ALICATADOS PLASENCIA
echo =========================================

REM Verificar que curl está instalado
where curl >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: curl no esta instalado en este sistema
    echo Por favor instala curl o usa PowerShell para ejecutar el script .ps1
    pause
    exit /b 1
)

REM Prueba 1: Listar tipos de contenedores
echo.
echo 1. Listar tipos de contenedores disponibles
curl -X GET "%BASE_URL%/containers/types"
echo.

REM Prueba 2: Crear nuevo alquiler de contenedor
echo.
echo 2. Crear alquiler de contenedor
curl -X POST "%BASE_URL%/containers/rentals" ^
  -H "Content-Type: application/json" ^
  -d "{\"containerId\": 1, \"customerId\": 10, \"startDate\": \"2025-11-20\", \"expectedEndDate\": \"2025-12-05\", \"deliveryAddress\": \"Calle Mayor 25, Plasencia\", \"deliveryCity\": \"Plasencia\", \"deliveryPostalCode\": \"10600\"}"
echo.

REM Prueba 3: Consultar rutas del día
echo.
echo 3. Consultar rutas planificadas
curl -X GET "%BASE_URL%/logistics/routes?date=2025-11-20"
echo.

REM Prueba 4: Generar nóminas del mes
echo.
echo 4. Generar nominas de noviembre 2025
curl -X POST "%BASE_URL%/accounting/payrolls/generate" ^
  -H "Content-Type: application/json" ^
  -d "{\"periodMonth\": 11, \"periodYear\": 2025}"
echo.

REM Prueba 5: Estadísticas financieras
echo.
echo 5. Consultar estadisticas financieras del mes
curl -X GET "%BASE_URL%/accounting/statistics?month=11&year=2025"
echo.

REM Prueba 6: Login de usuario
echo.
echo 6. Autenticacion de usuario
curl -X POST "%BASE_URL%/users/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\": \"admin\", \"password\": \"admin123\"}"
echo.

echo.
echo =========================================
echo PRUEBAS COMPLETADAS
echo =========================================
echo.
echo NOTA: Para ver los resultados formateados, instala jq o usa el script PowerShell
pause
