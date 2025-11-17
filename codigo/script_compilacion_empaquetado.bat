@echo off
echo =========================================
echo COMPILANDO MICROSERVICIOS - ALICATADOS PLASENCIA
echo =========================================

REM Servicios de infraestructura
echo 1. Compilando eureka-server...
cd ..\eureka-server
call mvn clean package -DskipTests
cd ..\codigo

echo 2. Compilando config-server...
cd ..\config-server
call mvn clean package -DskipTests
cd ..\codigo

echo 3. Compilando gateway-service...
cd ..\gateway-service
call mvn clean package -DskipTests
cd ..\codigo

REM Microservicios base
echo 4. Compilando containers-service...
cd ..\containers-service
call mvn clean package -DskipTests
cd ..\codigo

echo 5. Compilando logistics-service...
cd ..\logistics-service
call mvn clean package -DskipTests
cd ..\codigo

echo 6. Compilando accounting-service...
cd ..\accounting-service
call mvn clean package -DskipTests
cd ..\codigo

echo 7. Compilando users-service...
cd ..\users-service
call mvn clean package -DskipTests
cd ..\codigo

echo =========================================
echo COMPILACION COMPLETADA
echo =========================================
pause
