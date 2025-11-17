# Script de ejecución del sistema para Windows PowerShell
# Alicatados Plasencia - Sistema de Microservicios

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "INICIANDO SISTEMA - ALICATADOS PLASENCIA" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Obtener el directorio raíz del proyecto
$rootDir = Split-Path -Parent $PSScriptRoot

# Array para almacenar los procesos
$processes = @()

# Función para iniciar un servicio
function Start-Service {
    param(
        [string]$ServiceName,
        [string]$ServicePath,
        [string]$Arguments = "",
        [int]$WaitSeconds = 5
    )

    Write-Host "`nIniciando $ServiceName..." -ForegroundColor Yellow

    Push-Location $ServicePath

    if ($Arguments -eq "") {
        $process = Start-Process "cmd" -ArgumentList "/k", "mvn spring-boot:run" -PassThru -WindowStyle Normal
    } else {
        $process = Start-Process "cmd" -ArgumentList "/k", "mvn spring-boot:run $Arguments" -PassThru -WindowStyle Normal
    }

    Pop-Location

    Start-Sleep -Seconds $WaitSeconds
    return $process
}

# 1. Eureka Server
$processes += Start-Service "Eureka Server (8761)" "$rootDir\eureka-server" "" 15

# 2. Config Server
$processes += Start-Service "Config Server (8888)" "$rootDir\config-server" "" 10

# 3. Gateway Service
$processes += Start-Service "Gateway Service (8080)" "$rootDir\gateway-service" "" 10

# 4. Containers Service (2 instancias)
$processes += Start-Service "Containers Service Instancia 1 (8101)" "$rootDir\containers-service" "" 5
$processes += Start-Service "Containers Service Instancia 2 (8102)" "$rootDir\containers-service" "-Dspring-boot.run.arguments=--server.port=8102" 5

# 5. Logistics Service (2 instancias)
$processes += Start-Service "Logistics Service Instancia 1 (8111)" "$rootDir\logistics-service" "" 5
$processes += Start-Service "Logistics Service Instancia 2 (8112)" "$rootDir\logistics-service" "-Dspring-boot.run.arguments=--server.port=8112" 5

# 6. Accounting Service (2 instancias)
$processes += Start-Service "Accounting Service Instancia 1 (8121)" "$rootDir\accounting-service" "" 5
$processes += Start-Service "Accounting Service Instancia 2 (8122)" "$rootDir\accounting-service" "-Dspring-boot.run.arguments=--server.port=8122" 5

# 7. Users Service (2 instancias)
$processes += Start-Service "Users Service Instancia 1 (8131)" "$rootDir\users-service" "" 5
$processes += Start-Service "Users Service Instancia 2 (8132)" "$rootDir\users-service" "-Dspring-boot.run.arguments=--server.port=8132" 5

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "SISTEMA INICIADO COMPLETAMENTE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Eureka: http://localhost:8761" -ForegroundColor White
Write-Host "Gateway: http://localhost:8080" -ForegroundColor White
Write-Host "Containers: http://localhost:8101, http://localhost:8102" -ForegroundColor White
Write-Host "Logistics: http://localhost:8111, http://localhost:8112" -ForegroundColor White
Write-Host "Accounting: http://localhost:8121, http://localhost:8122" -ForegroundColor White
Write-Host "Users: http://localhost:8131, http://localhost:8132" -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Green
Write-Host "`nNOTA: Cada servicio se ha abierto en su propia ventana." -ForegroundColor Yellow
Write-Host "Para detener los servicios, cierra cada ventana o presiona Ctrl+C en cada una." -ForegroundColor Yellow

Read-Host -Prompt "`nPresiona ENTER para salir"
