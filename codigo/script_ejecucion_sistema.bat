@echo off
echo =========================================
echo INICIANDO SISTEMA - ALICATADOS PLASENCIA
echo =========================================

REM 1. Eureka Server
echo Iniciando Eureka Server (8761)...
cd ..\eureka-server
start "Eureka Server" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 15 /nobreak

REM 2. Config Server
echo Iniciando Config Server (8888)...
cd ..\config-server
start "Config Server" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 10 /nobreak

REM 3. Gateway Service
echo Iniciando Gateway Service (8080)...
cd ..\gateway-service
start "Gateway Service" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 10 /nobreak

REM 4. Containers Service (2 instancias)
echo Iniciando Containers Service instancia 1 (8101)...
cd ..\containers-service
start "Containers Service 1" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 5 /nobreak

echo Iniciando Containers Service instancia 2 (8102)...
cd ..\containers-service
start "Containers Service 2" cmd /k "mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8102"
cd ..\codigo
timeout /t 5 /nobreak

REM 5. Logistics Service (2 instancias)
echo Iniciando Logistics Service instancia 1 (8111)...
cd ..\logistics-service
start "Logistics Service 1" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 5 /nobreak

echo Iniciando Logistics Service instancia 2 (8112)...
cd ..\logistics-service
start "Logistics Service 2" cmd /k "mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8112"
cd ..\codigo
timeout /t 5 /nobreak

REM 6. Accounting Service (2 instancias)
echo Iniciando Accounting Service instancia 1 (8121)...
cd ..\accounting-service
start "Accounting Service 1" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 5 /nobreak

echo Iniciando Accounting Service instancia 2 (8122)...
cd ..\accounting-service
start "Accounting Service 2" cmd /k "mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8122"
cd ..\codigo
timeout /t 5 /nobreak

REM 7. Users Service (2 instancias)
echo Iniciando Users Service instancia 1 (8131)...
cd ..\users-service
start "Users Service 1" cmd /k "mvn spring-boot:run"
cd ..\codigo
timeout /t 5 /nobreak

echo Iniciando Users Service instancia 2 (8132)...
cd ..\users-service
start "Users Service 2" cmd /k "mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8132"
cd ..\codigo

echo.
echo =========================================
echo SISTEMA INICIADO COMPLETAMENTE
echo =========================================
echo Eureka: http://localhost:8761
echo Gateway: http://localhost:8080
echo Containers: http://localhost:8101, http://localhost:8102
echo Logistics: http://localhost:8111, http://localhost:8112
echo Accounting: http://localhost:8121, http://localhost:8122
echo Users: http://localhost:8131, http://localhost:8132
echo =========================================
echo.
echo NOTA: Cada servicio se ha abierto en su propia ventana.
echo Para detener los servicios, cierra cada ventana o presiona Ctrl+C en cada una.
echo.
pause
