@echo off
setlocal enabledelayedexpansion

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

echo [1/7] Eureka Server (puerto 8761)...
curl -s http://localhost:8761/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Eureka Server funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Eureka Server no responde
    set /a FAILED+=1
)

echo [2/7] Config Server (puerto 8888)...
curl -s http://localhost:8888/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Config Server funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Config Server no responde
    set /a FAILED+=1
)

echo [3/7] Gateway Service (puerto 8080)...
curl -s http://localhost:8080/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway Service no responde
    set /a FAILED+=1
)

echo [4/7] Containers Service (puerto 8101)...
curl -s http://localhost:8101/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Containers Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Containers Service no responde
    set /a FAILED+=1
)

echo [5/7] Logistics Service (puerto 8111)...
curl -s http://localhost:8111/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Logistics Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Logistics Service no responde
    set /a FAILED+=1
)

echo [6/7] Accounting Service (puerto 8121)...
curl -s http://localhost:8121/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Accounting Service funcionando
    set /a PASSED+=1
) else (
    echo    [FALLO] Accounting Service no responde
    set /a FAILED+=1
)

echo [7/7] Users Service (puerto 8131)...
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
echo 2. API CONTAINERS SERVICE - TIPOS
echo =========================================
echo.

echo [1/3] GET /types - Listar todos los tipos
curl -s -w "%%{http_code}" http://localhost:8101/types -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /types
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /types
    set /a FAILED+=1
)

echo [2/3] GET /types/active - Listar tipos activos
curl -s -w "%%{http_code}" http://localhost:8101/types/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /types/active
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /types/active
    set /a FAILED+=1
)

echo [3/3] POST /types - Crear tipo (simulado)
curl -s -w "%%{http_code}" -X POST http://localhost:8101/types -H "Content-Type: application/json" -d "{\"name\":\"Test\"}" -o nul | find "201" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] POST /types
    set /a PASSED+=1
) else (
    echo    [FALLO] POST /types - puede fallar si faltan campos requeridos
    set /a FAILED+=1
)
echo.

echo =========================================
echo 3. API CONTAINERS SERVICE - CONTENEDORES
echo =========================================
echo.

echo [1/3] GET /containers - Listar todos los contenedores
curl -s -w "%%{http_code}" http://localhost:8101/containers -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /containers
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /containers
    set /a FAILED+=1
)

echo [2/3] GET /containers/available - Listar disponibles
curl -s -w "%%{http_code}" http://localhost:8101/containers/available -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /containers/available
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /containers/available
    set /a FAILED+=1
)

echo [3/3] GET /containers/status/AVAILABLE - Por estado
curl -s -w "%%{http_code}" http://localhost:8101/containers/status/AVAILABLE -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /containers/status/AVAILABLE
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /containers/status/AVAILABLE
    set /a FAILED+=1
)
echo.

echo =========================================
echo 4. API CONTAINERS SERVICE - TARIFAS
echo =========================================
echo.

echo [1/2] GET /rates - Listar todas las tarifas
curl -s -w "%%{http_code}" http://localhost:8101/rates -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /rates
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /rates
    set /a FAILED+=1
)

echo [2/2] GET /rates/active - Listar tarifas activas
curl -s -w "%%{http_code}" http://localhost:8101/rates/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /rates/active
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /rates/active
    set /a FAILED+=1
)
echo.

echo =========================================
echo 5. API CONTAINERS SERVICE - ALQUILERES
echo =========================================
echo.

echo [1/3] GET /rentals - Listar todos los alquileres
curl -s -w "%%{http_code}" http://localhost:8101/rentals -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /rentals
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /rentals
    set /a FAILED+=1
)

echo [2/3] GET /rentals/active - Alquileres activos
curl -s -w "%%{http_code}" http://localhost:8101/rentals/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /rentals/active
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /rentals/active
    set /a FAILED+=1
)

echo [3/3] GET /rentals/pending - Alquileres pendientes
curl -s -w "%%{http_code}" http://localhost:8101/rentals/pending -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /rentals/pending
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /rentals/pending
    set /a FAILED+=1
)
echo.

echo =========================================
echo 6. API CONTAINERS SERVICE - INSPECCIONES
echo =========================================
echo.

echo [1/1] GET /inspections - Listar inspecciones
curl -s -w "%%{http_code}" http://localhost:8101/inspections -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] GET /inspections
    set /a PASSED+=1
) else (
    echo    [FALLO] GET /inspections
    set /a FAILED+=1
)
echo.

echo =========================================
echo 7. ENRUTAMIENTO DEL GATEWAY
echo =========================================
echo.

echo [1/4] Gateway -^> Containers Service (/api/containers/types)
curl -s -w "%%{http_code}" http://localhost:8080/api/containers/types -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta a Containers Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta a Containers Service
    set /a FAILED+=1
)

echo [2/4] Gateway -^> Logistics Service (/api/logistics/actuator/health)
curl -s -w "%%{http_code}" http://localhost:8080/api/logistics/actuator/health -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta a Logistics Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta a Logistics Service
    set /a FAILED+=1
)

echo [3/4] Gateway -^> Accounting Service (/api/accounting/actuator/health)
curl -s -w "%%{http_code}" http://localhost:8080/api/accounting/actuator/health -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta a Accounting Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta a Accounting Service
    set /a FAILED+=1
)

echo [4/4] Gateway -^> Users Service (/api/users/actuator/health)
curl -s -w "%%{http_code}" http://localhost:8080/api/users/actuator/health -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway enruta a Users Service
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway no enruta a Users Service
    set /a FAILED+=1
)
echo.

echo =========================================
echo 8. REGISTRO EN EUREKA
echo =========================================
echo.

echo Verificando servicios registrados en Eureka...

curl -s http://localhost:8761/eureka/apps | find "CONTAINERS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Containers Service registrado
    set /a PASSED+=1
) else (
    echo    [FALLO] Containers Service NO registrado
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "LOGISTICS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Logistics Service registrado
    set /a PASSED+=1
) else (
    echo    [FALLO] Logistics Service NO registrado
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "ACCOUNTING-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Accounting Service registrado
    set /a PASSED+=1
) else (
    echo    [FALLO] Accounting Service NO registrado
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "USERS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Users Service registrado
    set /a PASSED+=1
) else (
    echo    [FALLO] Users Service NO registrado
    set /a FAILED+=1
)

curl -s http://localhost:8761/eureka/apps | find "GATEWAY-SERVICE" >nul
if %ERRORLEVEL% equ 0 (
    echo    [OK] Gateway Service registrado
    set /a PASSED+=1
) else (
    echo    [FALLO] Gateway Service NO registrado
    set /a FAILED+=1
)
echo.

echo =========================================
echo RESUMEN FINAL
echo =========================================
echo.
set /a TOTAL=!PASSED!+!FAILED!
echo Total de pruebas ejecutadas: !TOTAL!
echo Pruebas exitosas:            !PASSED!
echo Pruebas fallidas:            !FAILED!
echo.

if !FAILED! equ 0 (
    echo ================================================
    echo [EXITO] TODAS LAS PRUEBAS PASARON CORRECTAMENTE
    echo ================================================
    echo.
    echo Sistema completamente operativo:
    echo   - Infraestructura:      7/7 servicios
    echo   - Containers API:       13/13 endpoints
    echo   - Gateway:              4/4 rutas
    echo   - Eureka:               5/5 servicios registrados
    echo.
    echo TOTAL: !PASSED! pruebas exitosas
) else (
    echo ================================================
    echo [ATENCION] ALGUNAS PRUEBAS FALLARON
    echo ================================================
    echo.
    echo Acciones recomendadas:
    echo   1. Revisar logs: docker-compose logs -f [servicio]
    echo   2. Verificar Eureka: http://localhost:8761
    echo   3. Reiniciar sistema: setup.bat
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
echo API Gateway (acceso unificado):
echo   - Containers:           http://localhost:8080/api/containers
echo   - Logistics:            http://localhost:8080/api/logistics
echo   - Accounting:           http://localhost:8080/api/accounting
echo   - Users:                http://localhost:8080/api/users
echo.
echo Acceso directo a servicios:
echo   - Containers:           http://localhost:8101
echo   - Logistics:            http://localhost:8111
echo   - Accounting:           http://localhost:8121
echo   - Users:                http://localhost:8131
echo.
pause
