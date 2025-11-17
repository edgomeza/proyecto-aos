@echo off
setlocal enabledelayedexpansion

set BASE_URL=http://localhost:8080/api
set PASSED=0
set FAILED=0

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

echo Verificando que Docker este ejecutandose...
docker ps >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Docker no esta ejecutandose
    echo Inicia Docker Desktop primero
    pause
    exit /b 1
)
echo OK - Docker ejecutandose
echo.

echo =========================================
echo 1. VERIFICACION DE INFRAESTRUCTURA
echo =========================================
echo.

echo [1/7] Eureka Server...
curl -s http://localhost:8761/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Eureka Server funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Eureka Server no responde
    set /a FAILED+=1
)

echo [2/7] Config Server...
curl -s http://localhost:8888/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Config Server funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Config Server no responde
    set /a FAILED+=1
)

echo [3/7] Gateway Service...
curl -s http://localhost:8080/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway Service no responde
    set /a FAILED+=1
)

echo [4/7] Containers Service...
curl -s http://localhost:8101/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Containers Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Containers Service no responde
    set /a FAILED+=1
)

echo [5/7] Logistics Service...
curl -s http://localhost:8111/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Logistics Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Logistics Service no responde
    set /a FAILED+=1
)

echo [6/7] Accounting Service...
curl -s http://localhost:8121/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Accounting Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Accounting Service no responde
    set /a FAILED+=1
)

echo [7/7] Users Service...
curl -s http://localhost:8131/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Users Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Users Service no responde
    set /a FAILED+=1
)
echo.

echo =========================================
echo 2. PRUEBAS DE ENDPOINTS - CONTAINERS SERVICE
echo =========================================
echo.

echo [1/10] GET /types - Listar tipos de contenedores
curl -s http://localhost:8101/types -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /types responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /types no responde
    set /a FAILED+=1
)

echo [2/10] GET /types/active - Listar tipos activos
curl -s http://localhost:8101/types/active -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /types/active responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /types/active no responde
    set /a FAILED+=1
)

echo [3/10] GET /containers - Listar contenedores
curl -s http://localhost:8101/containers -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /containers responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /containers no responde
    set /a FAILED+=1
)

echo [4/10] GET /containers/available - Listar contenedores disponibles
curl -s http://localhost:8101/containers/available -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /containers/available responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /containers/available no responde
    set /a FAILED+=1
)

echo [5/10] GET /rates - Listar tarifas de alquiler
curl -s http://localhost:8101/rates -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /rates responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /rates no responde
    set /a FAILED+=1
)

echo [6/10] GET /rates/active - Listar tarifas activas
curl -s http://localhost:8101/rates/active -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /rates/active responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /rates/active no responde
    set /a FAILED+=1
)

echo [7/10] GET /rentals - Listar alquileres
curl -s http://localhost:8101/rentals -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /rentals responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /rentals no responde
    set /a FAILED+=1
)

echo [8/10] GET /rentals/active - Listar alquileres activos
curl -s http://localhost:8101/rentals/active -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /rentals/active responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /rentals/active no responde
    set /a FAILED+=1
)

echo [9/10] GET /rentals/pending - Listar alquileres pendientes
curl -s http://localhost:8101/rentals/pending -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /rentals/pending responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /rentals/pending no responde
    set /a FAILED+=1
)

echo [10/10] GET /inspections - Listar inspecciones
curl -s http://localhost:8101/inspections -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Endpoint /inspections responde correctamente
    set /a PASSED+=1
) else (
    echo    [FALLO] Endpoint /inspections no responde
    set /a FAILED+=1
)
echo.

echo =========================================
echo 3. PRUEBAS A TRAVES DEL GATEWAY
echo =========================================
echo.

echo [1/4] GET /api/containers/types - A traves del Gateway
curl -s http://localhost:8080/api/containers/types -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta correctamente a Containers Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta correctamente
    set /a FAILED+=1
)

echo [2/4] GET /api/logistics/actuator/health - A traves del Gateway
curl -s http://localhost:8080/api/logistics/actuator/health -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta correctamente a Logistics Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta correctamente
    set /a FAILED+=1
)

echo [3/4] GET /api/accounting/actuator/health - A traves del Gateway
curl -s http://localhost:8080/api/accounting/actuator/health -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta correctamente a Accounting Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta correctamente
    set /a FAILED+=1
)

echo [4/4] GET /api/users/actuator/health - A traves del Gateway
curl -s http://localhost:8080/api/users/actuator/health -w "\n%%{http_code}" | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta correctamente a Users Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta correctamente
    set /a FAILED+=1
)
echo.

echo =========================================
echo 4. VERIFICACION DE REGISTRO EN EUREKA
echo =========================================
echo.

echo Verificando servicios registrados en Eureka...
curl -s http://localhost:8761/eureka/apps | find "CONTAINERS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Containers Service registrado en Eureka
    set /a PASSED+=1
) else (
    echo    [FALLO] Containers Service NO registrado en Eureka
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "LOGISTICS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Logistics Service registrado en Eureka
    set /a PASSED+=1
) else (
    echo    [FALLO] Logistics Service NO registrado en Eureka
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "ACCOUNTING-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Accounting Service registrado en Eureka
    set /a PASSED+=1
) else (
    echo    [FALLO] Accounting Service NO registrado en Eureka
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "USERS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Users Service registrado en Eureka
    set /a PASSED+=1
) else (
    echo    [FALLO] Users Service NO registrado en Eureka
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "GATEWAY-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway Service registrado en Eureka
    set /a PASSED+=1
    ) else (
    echo    [FALLO] Gateway Service NO registrado en Eureka
    set /a FAILED+=1
)
echo.

echo =========================================
echo RESUMEN FINAL
echo =========================================
echo.
echo Total de pruebas ejecutadas: !PASSED! + !FAILED! = %PASSED%%FAILED%
echo Pruebas exitosas: !PASSED!
echo Pruebas fallidas:  !FAILED!
echo.

if !FAILED! equ 0 (
    echo [EXITO] Todas las pruebas pasaron correctamente!
    echo.
    echo Sistema completamente operativo:
    echo   - Infraestructura: 7/7 servicios funcionando
    echo   - API Containers: 10/10 endpoints funcionando
    echo   - Gateway: 4/4 rutas funcionando
    echo   - Eureka: 5/5 servicios registrados
) else (
    echo [ATENCION] Algunas pruebas fallaron
    echo.
    echo Revisa los logs de los servicios con:
    echo   docker-compose logs -f [nombre-servicio]
    echo.
    echo O ejecuta 'setup.bat' para reiniciar el sistema
)
echo.

echo =========================================
echo RECURSOS UTILES
echo =========================================
echo.
echo Dashboards:
echo   - Eureka Dashboard:     http://localhost:8761
echo   - Config Server:        http://localhost:8888
echo.
echo Documentacion API (Swagger):
echo   - Containers Service:   http://localhost:8101/swagger-ui.html
echo   - Logistics Service:    http://localhost:8111/swagger-ui.html
echo   - Accounting Service:   http://localhost:8121/swagger-ui.html
echo   - Users Service:        http://localhost:8131/swagger-ui.html
echo.
echo Endpoints Gateway:
echo   - Containers API:       http://localhost:8080/api/containers
echo   - Logistics API:        http://localhost:8080/api/logistics
echo   - Accounting API:       http://localhost:8080/api/accounting
echo   - Users API:            http://localhost:8080/api/users
echo.
pause
