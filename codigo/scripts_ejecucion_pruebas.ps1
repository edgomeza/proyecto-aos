# Script de pruebas para Windows PowerShell
# Alicatados Plasencia - Sistema de Microservicios

$BASE_URL = "http://localhost:8080/api"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "PRUEBAS SISTEMA ALICATADOS PLASENCIA" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Función para hacer peticiones HTTP y mostrar resultados
function Invoke-TestRequest {
    param(
        [string]$Description,
        [string]$Method,
        [string]$Url,
        [string]$Body = $null
    )

    Write-Host "`n$Description" -ForegroundColor Yellow

    try {
        if ($Body) {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Body $Body -ContentType "application/json" -ErrorAction Stop
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -ErrorAction Stop
        }

        $response | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor Green
        return $true
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
        return $false
    }
}

# Prueba 1: Listar tipos de contenedores
Invoke-TestRequest `
    -Description "1. Listar tipos de contenedores disponibles" `
    -Method GET `
    -Url "$BASE_URL/containers/types"

# Prueba 2: Crear nuevo alquiler de contenedor
$rentalBody = @{
    containerId = 1
    customerId = 10
    startDate = "2025-11-20"
    expectedEndDate = "2025-12-05"
    deliveryAddress = "Calle Mayor 25, Plasencia"
    deliveryCity = "Plasencia"
    deliveryPostalCode = "10600"
} | ConvertTo-Json

Invoke-TestRequest `
    -Description "2. Crear alquiler de contenedor" `
    -Method POST `
    -Url "$BASE_URL/containers/rentals" `
    -Body $rentalBody

# Prueba 3: Consultar rutas del día
Invoke-TestRequest `
    -Description "3. Consultar rutas planificadas" `
    -Method GET `
    -Url "$BASE_URL/logistics/routes?date=2025-11-20"

# Prueba 4: Generar nóminas del mes
$payrollBody = @{
    periodMonth = 11
    periodYear = 2025
} | ConvertTo-Json

Invoke-TestRequest `
    -Description "4. Generar nóminas de noviembre 2025" `
    -Method POST `
    -Url "$BASE_URL/accounting/payrolls/generate" `
    -Body $payrollBody

# Prueba 5: Estadísticas financieras
Invoke-TestRequest `
    -Description "5. Consultar estadísticas financieras del mes" `
    -Method GET `
    -Url "$BASE_URL/accounting/statistics?month=11&year=2025"

# Prueba 6: Login de usuario
$loginBody = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

Invoke-TestRequest `
    -Description "6. Autenticación de usuario" `
    -Method POST `
    -Url "$BASE_URL/users/auth/login" `
    -Body $loginBody

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "PRUEBAS COMPLETADAS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Read-Host -Prompt "`nPresiona ENTER para salir"
