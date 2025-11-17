# Script de compilación para Windows PowerShell
# Alicatados Plasencia - Sistema de Microservicios

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "COMPILANDO MICROSERVICIOS - ALICATADOS PLASENCIA" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Función para compilar un servicio
function Compile-Service {
    param(
        [string]$ServiceName,
        [string]$ServicePath
    )

    Write-Host "`nCompilando $ServiceName..." -ForegroundColor Yellow
    Push-Location $ServicePath
    mvn clean package -DskipTests
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error compilando $ServiceName" -ForegroundColor Red
        Pop-Location
        return $false
    }
    Pop-Location
    return $true
}

# Obtener el directorio raíz del proyecto
$rootDir = Split-Path -Parent $PSScriptRoot

# Servicios de infraestructura
Compile-Service "Eureka Server" "$rootDir\eureka-server"
Compile-Service "Config Server" "$rootDir\config-server"
Compile-Service "Gateway Service" "$rootDir\gateway-service"

# Microservicios base
Compile-Service "Containers Service" "$rootDir\containers-service"
Compile-Service "Logistics Service" "$rootDir\logistics-service"
Compile-Service "Accounting Service" "$rootDir\accounting-service"
Compile-Service "Users Service" "$rootDir\users-service"

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "COMPILACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Read-Host -Prompt "Presiona ENTER para continuar"
