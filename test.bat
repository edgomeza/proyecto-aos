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
    pause
    exit /b 1
)

echo Verificando que Docker este ejecutandose...
docker ps >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: Docker no esta ejecutandose
    pause
    exit /b 1
)
echo OK - Docker ejecutandose
echo.

echo =========================================
echo 1. INFRAESTRUCTURA (7 pruebas)
echo =========================================
echo.

curl -s http://localhost:8761/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Eureka Server & set /a PASSED+=1) else (echo    [FALLO] Eureka Server & set /a FAILED+=1)

curl -s http://localhost:8888/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Config Server & set /a PASSED+=1) else (echo    [FALLO] Config Server & set /a FAILED+=1)

curl -s http://localhost:8080/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Gateway Service & set /a PASSED+=1) else (echo    [FALLO] Gateway Service & set /a FAILED+=1)

curl -s http://localhost:8101/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Containers Service & set /a PASSED+=1) else (echo    [FALLO] Containers Service & set /a FAILED+=1)

curl -s http://localhost:8111/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Logistics Service & set /a PASSED+=1) else (echo    [FALLO] Logistics Service & set /a FAILED+=1)

curl -s http://localhost:8121/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Accounting Service & set /a PASSED+=1) else (echo    [FALLO] Accounting Service & set /a FAILED+=1)

curl -s http://localhost:8131/actuator/health | find "UP" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Users Service & set /a PASSED+=1) else (echo    [FALLO] Users Service & set /a FAILED+=1)
echo.

echo =========================================
echo 2. CONTAINERS SERVICE - Tipos (3 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8101/types -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /types & set /a PASSED+=1) else (echo    [FALLO] GET /types & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8101/types/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /types/active & set /a PASSED+=1) else (echo    [FALLO] GET /types/active & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8101/types -H "Content-Type: application/json" -d "{\"name\":\"Test Container 5m3\",\"capacityM3\":5.0,\"active\":true}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /types & set /a PASSED+=1) else (echo    [FALLO] POST /types & set /a FAILED+=1)
echo.

echo =========================================
echo 3. CONTAINERS SERVICE - Contenedores (4 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8101/containers -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /containers & set /a PASSED+=1) else (echo    [FALLO] GET /containers & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8101/containers/available -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /containers/available & set /a PASSED+=1) else (echo    [FALLO] GET /containers/available & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8101/containers/status/AVAILABLE -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /containers/status/AVAILABLE & set /a PASSED+=1) else (echo    [FALLO] GET /containers/status/AVAILABLE & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8101/containers -H "Content-Type: application/json" -d "{\"containerCode\":\"TEST-001\",\"containerType\":{\"id\":1},\"status\":\"AVAILABLE\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /containers & set /a PASSED+=1) else (echo    [FALLO] POST /containers & set /a FAILED+=1)
echo.

echo =========================================
echo 4. CONTAINERS SERVICE - Tarifas (3 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8101/rates -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /rates & set /a PASSED+=1) else (echo    [FALLO] GET /rates & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8101/rates/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /rates/active & set /a PASSED+=1) else (echo    [FALLO] GET /rates/active & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8101/rates -H "Content-Type: application/json" -d "{\"containerType\":{\"id\":1},\"periodType\":\"DAILY\",\"basePrice\":25.0,\"active\":true}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /rates & set /a PASSED+=1) else (echo    [FALLO] POST /rates & set /a FAILED+=1)
echo.

echo =========================================
echo 5. CONTAINERS SERVICE - Alquileres (4 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8101/rentals -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /rentals & set /a PASSED+=1) else (echo    [FALLO] GET /rentals & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8101/rentals/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /rentals/active & set /a PASSED+=1) else (echo    [FALLO] GET /rentals/active & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8101/rentals/pending -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /rentals/pending & set /a PASSED+=1) else (echo    [FALLO] GET /rentals/pending & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8101/rentals -H "Content-Type: application/json" -d "{\"rentalNumber\":\"RENT-TEST-001\",\"container\":{\"id\":1},\"customerId\":1,\"startDate\":\"2025-11-17\",\"expectedEndDate\":\"2025-11-24\",\"deliveryAddress\":\"Test Address 123\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /rentals & set /a PASSED+=1) else (echo    [FALLO] POST /rentals & set /a FAILED+=1)
echo.

echo =========================================
echo 6. CONTAINERS SERVICE - Inspecciones (2 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8101/inspections -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /inspections & set /a PASSED+=1) else (echo    [FALLO] GET /inspections & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8101/inspections -H "Content-Type: application/json" -d "{\"rental\":{\"id\":1},\"conditionStatus\":\"GOOD\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /inspections & set /a PASSED+=1) else (echo    [FALLO] POST /inspections & set /a FAILED+=1)
echo.

echo =========================================
echo 7. LOGISTICS SERVICE - Rutas (7 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8111/routes -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /routes & set /a PASSED+=1) else (echo    [FALLO] GET /routes & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8111/routes/status/PLANNED -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /routes/status/PLANNED & set /a PASSED+=1) else (echo    [FALLO] GET /routes/status/PLANNED & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8111/routes/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /routes/active & set /a PASSED+=1) else (echo    [FALLO] GET /routes/active & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8111/routes/planned -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /routes/planned & set /a PASSED+=1) else (echo    [FALLO] GET /routes/planned & set /a FAILED+=1)

for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set TODAY=%%c-%%b-%%a)
curl -s -w "%%{http_code}" http://localhost:8111/routes/date/%TODAY% -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /routes/date/{date} & set /a PASSED+=1) else (echo    [FALLO] GET /routes/date/{date} & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8111/routes -H "Content-Type: application/json" -d "{\"routeCode\":\"RT-TEST-001\",\"origin\":\"Plasencia\",\"destination\":\"Caceres\",\"scheduleDate\":\"2025-11-20\",\"status\":\"PLANNED\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /routes & set /a PASSED+=1) else (echo    [FALLO] POST /routes & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X PUT http://localhost:8111/routes/1 -H "Content-Type: application/json" -d "{\"routeCode\":\"RT-001\",\"origin\":\"Plasencia\",\"destination\":\"Madrid\",\"scheduleDate\":\"2025-11-18\",\"status\":\"PLANNED\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] PUT /routes/{id} & set /a PASSED+=1) else (echo    [FALLO] PUT /routes/{id} & set /a FAILED+=1)
echo.

echo =========================================
echo 8. ACCOUNTING SERVICE - Facturas (8 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8121/invoices -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /invoices & set /a PASSED+=1) else (echo    [FALLO] GET /invoices & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8121/invoices/status/PENDING -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /invoices/status/PENDING & set /a PASSED+=1) else (echo    [FALLO] GET /invoices/status/PENDING & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8121/invoices/pending -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /invoices/pending & set /a PASSED+=1) else (echo    [FALLO] GET /invoices/pending & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8121/invoices/paid -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /invoices/paid & set /a PASSED+=1) else (echo    [FALLO] GET /invoices/paid & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8121/invoices/overdue -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /invoices/overdue & set /a PASSED+=1) else (echo    [FALLO] GET /invoices/overdue & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8121/invoices/customer/1 -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /invoices/customer/{id} & set /a PASSED+=1) else (echo    [FALLO] GET /invoices/customer/{id} & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8121/invoices -H "Content-Type: application/json" -d "{\"invoiceNumber\":\"INV-TEST-001\",\"customerId\":1,\"invoiceDate\":\"2025-11-17\",\"subtotal\":100.0,\"totalAmount\":121.0,\"status\":\"PENDING\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /invoices & set /a PASSED+=1) else (echo    [FALLO] POST /invoices & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X PUT http://localhost:8121/invoices/1 -H "Content-Type: application/json" -d "{\"invoiceNumber\":\"INV-001\",\"customerId\":1,\"invoiceDate\":\"2025-11-17\",\"subtotal\":150.0,\"totalAmount\":181.5,\"status\":\"PAID\"}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] PUT /invoices/{id} & set /a PASSED+=1) else (echo    [FALLO] PUT /invoices/{id} & set /a FAILED+=1)
echo.

echo =========================================
echo 9. USERS SERVICE - Usuarios (8 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8131/users -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /users & set /a PASSED+=1) else (echo    [FALLO] GET /users & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8131/users/role/CUSTOMER -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /users/role/CUSTOMER & set /a PASSED+=1) else (echo    [FALLO] GET /users/role/CUSTOMER & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8131/users/role/ADMIN -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /users/role/ADMIN & set /a PASSED+=1) else (echo    [FALLO] GET /users/role/ADMIN & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8131/users/active -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /users/active & set /a PASSED+=1) else (echo    [FALLO] GET /users/active & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8131/users/inactive -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] GET /users/inactive & set /a PASSED+=1) else (echo    [FALLO] GET /users/inactive & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X POST http://localhost:8131/users -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"Test123456\",\"role\":\"CUSTOMER\",\"active\":true}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] POST /users & set /a PASSED+=1) else (echo    [FALLO] POST /users & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X PUT http://localhost:8131/users/1 -H "Content-Type: application/json" -d "{\"username\":\"admin\",\"email\":\"admin@example.com\",\"password\":\"Admin123456\",\"role\":\"ADMIN\",\"active\":true}" -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] PUT /users/{id} & set /a PASSED+=1) else (echo    [FALLO] PUT /users/{id} & set /a FAILED+=1)

curl -s -w "%%{http_code}" -X DELETE http://localhost:8131/users/999 -o nul | find /I "20" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] DELETE /users/{id} & set /a PASSED+=1) else (echo    [FALLO] DELETE /users/{id} & set /a FAILED+=1)
echo.

echo =========================================
echo 10. GATEWAY - Enrutamiento (4 pruebas)
echo =========================================
echo.

curl -s -w "%%{http_code}" http://localhost:8080/api/containers/types -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Gateway -^> Containers & set /a PASSED+=1) else (echo    [FALLO] Gateway -^> Containers & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8080/api/logistics/routes -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Gateway -^> Logistics & set /a PASSED+=1) else (echo    [FALLO] Gateway -^> Logistics & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8080/api/accounting/invoices -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Gateway -^> Accounting & set /a PASSED+=1) else (echo    [FALLO] Gateway -^> Accounting & set /a FAILED+=1)

curl -s -w "%%{http_code}" http://localhost:8080/api/users/users -o nul | find "200" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Gateway -^> Users & set /a PASSED+=1) else (echo    [FALLO] Gateway -^> Users & set /a FAILED+=1)
echo.

echo =========================================
echo 11. EUREKA - Registro (5 pruebas)
echo =========================================
echo.

curl -s http://localhost:8761/eureka/apps | find "CONTAINERS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Containers registrado & set /a PASSED+=1) else (echo    [FALLO] Containers NO registrado & set /a FAILED+=1)

curl -s http://localhost:8761/eureka/apps | find "LOGISTICS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Logistics registrado & set /a PASSED+=1) else (echo    [FALLO] Logistics NO registrado & set /a FAILED+=1)

curl -s http://localhost:8761/eureka/apps | find "ACCOUNTING-SERVICE" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Accounting registrado & set /a PASSED+=1) else (echo    [FALLO] Accounting NO registrado & set /a FAILED+=1)

curl -s http://localhost:8761/eureka/apps | find "USERS-SERVICE" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Users registrado & set /a PASSED+=1) else (echo    [FALLO] Users NO registrado & set /a FAILED+=1)

curl -s http://localhost:8761/eureka/apps | find "GATEWAY-SERVICE" >nul
if %ERRORLEVEL% equ 0 (echo    [OK] Gateway registrado & set /a PASSED+=1) else (echo    [FALLO] Gateway NO registrado & set /a FAILED+=1)
echo.

echo =========================================
echo RESUMEN FINAL
echo =========================================
echo.
set /a TOTAL=!PASSED!+!FAILED!
echo Total de pruebas: !TOTAL!
echo Exitosas:         !PASSED!
echo Fallidas:         !FAILED!
echo.

if !FAILED! equ 0 (
    echo ================================================
    echo [EXITO] TODAS LAS PRUEBAS PASARON
    echo ================================================
    echo.
    echo Sistema 100%% operativo:
    echo   - Infraestructura:     7/7
    echo   - Containers Service:  16/16 endpoints
    echo   - Logistics Service:   7/7 endpoints
    echo   - Accounting Service:  8/8 endpoints
    echo   - Users Service:       8/8 endpoints
    echo   - Gateway:             4/4 rutas
    echo   - Eureka:              5/5 servicios
    echo.
    echo TOTAL: !PASSED! pruebas exitosas
) else (
    echo ================================================
    echo [ATENCION] HAY PRUEBAS FALLIDAS
    echo ================================================
    echo.
    echo Para diagnosticar:
    echo   docker-compose logs -f [servicio]
    echo   http://localhost:8761
    echo.
    echo Para reiniciar:
    echo   setup.bat
)
echo.

echo =========================================
echo RECURSOS
echo =========================================
echo.
echo Dashboards:
echo   Eureka:     http://localhost:8761
echo   Config:     http://localhost:8888
echo.
echo Swagger (Documentacion API):
echo   Containers: http://localhost:8101/swagger-ui.html
echo   Logistics:  http://localhost:8111/swagger-ui.html
echo   Accounting: http://localhost:8121/swagger-ui.html
echo   Users:      http://localhost:8131/swagger-ui.html
echo.
echo Gateway (Acceso unificado):
echo   Containers: http://localhost:8080/api/containers
echo   Logistics:  http://localhost:8080/api/logistics
echo   Accounting: http://localhost:8080/api/accounting
echo   Users:      http://localhost:8080/api/users
echo.
pause
