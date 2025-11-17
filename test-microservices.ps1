# =========================================
# PRUEBAS SISTEMA ALICATADOS PLASENCIA
# Script de pruebas automatizadas para todos los microservicios
# =========================================

# Configurar manejo de errores
$ErrorActionPreference = "SilentlyContinue"

# Variables de conteo
$PASSED = 0
$FAILED = 0

# Generar timestamp �nico para datos de prueba
$TIMESTAMP = Get-Date -Format "HHmmssffff"

# Colores para output
function Write-TestHeader {
    param([string]$message)
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host $message -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-TestResult {
    param(
        [string]$testName,
        [bool]$passed
    )
    if ($passed) {
        Write-Host "   [OK] $testName" -ForegroundColor Green
        $script:PASSED++
    } else {
        Write-Host "   [FALLO] $testName" -ForegroundColor Red
        $script:FAILED++
    }
}

function Write-UseCaseDescription {
    param([string]$description)
    Write-Host ""
    Write-Host "   📋 Caso de Uso: $description" -ForegroundColor Magenta
    Write-Host ""
}

# Banner inicial
Write-Host ""
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "PRUEBAS SISTEMA ALICATADOS PLASENCIA" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "Este script prueba el sistema completo de gestión de alquiler de contenedores:" -ForegroundColor Cyan
Write-Host "  1. Infraestructura y servicios base" -ForegroundColor Gray
Write-Host "  2. Gestión de tipos y contenedores físicos" -ForegroundColor Gray
Write-Host "  3. Tarifas y contratos de alquiler" -ForegroundColor Gray
Write-Host "  4. Inspecciones post-devolución" -ForegroundColor Gray
Write-Host "  5. Rutas de transporte logístico" -ForegroundColor Gray
Write-Host "  6. Facturación de servicios" -ForegroundColor Gray
Write-Host "  7. Gestión de usuarios del sistema" -ForegroundColor Gray
Write-Host "  8. Enrutamiento a través del API Gateway" -ForegroundColor Gray
Write-Host "  9. Descubrimiento de servicios con Eureka" -ForegroundColor Gray
Write-Host ""
Write-Host "NOTA: Para mejores resultados, ejecute con base de datos limpia" -ForegroundColor Yellow
Write-Host "      o reinicie los servicios antes de la primera ejecuci�n." -ForegroundColor Yellow
Write-Host ""

# Verificar que Docker est� ejecut�ndose
Write-Host "Verificando que Docker est� ejecut�ndose..." -NoNewline
try {
    docker ps | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host " ERROR" -ForegroundColor Red
        Write-Host "Docker no est� ejecut�ndose. Por favor, inicie Docker Desktop." -ForegroundColor Red
        exit 1
    }
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " ERROR" -ForegroundColor Red
    Write-Host "Docker no est� instalado o no est� ejecut�ndose." -ForegroundColor Red
    exit 1
}

# =========================================
# 1. INFRAESTRUCTURA (7 pruebas)
# =========================================
Write-TestHeader "1. INFRAESTRUCTURA (7 pruebas)"
Write-UseCaseDescription "Verificar que todos los servicios de infraestructura (Eureka, Config Server, Gateway) y microservicios de negocio estén disponibles y respondiendo correctamente"

# Eureka Server - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Eureka Server" ($response.StatusCode -eq 200)
} catch {
    # Fallback a dashboard si health no está disponible
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8761" -Method Get -TimeoutSec 5 -UseBasicParsing
        Write-TestResult "Eureka Server" ($response.StatusCode -eq 200)
    } catch {
        Write-TestResult "Eureka Server" $false
    }
}

# Config Server - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8888/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Config Server" ($response.StatusCode -eq 200)
} catch {
    # Fallback a endpoint raíz
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8888" -Method Get -TimeoutSec 5 -UseBasicParsing
        Write-TestResult "Config Server" ($response.StatusCode -eq 200)
    } catch {
        Write-TestResult "Config Server" $false
    }
}

# Gateway Service - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Gateway Service" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "Gateway Service" $false
}

# Containers Service - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Containers Service" ($response.StatusCode -eq 200)
} catch {
    # Fallback a endpoint funcional
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8101/types" -Method Get -TimeoutSec 5 -UseBasicParsing
        Write-TestResult "Containers Service" ($response.StatusCode -eq 200)
    } catch {
        Write-TestResult "Containers Service" $false
    }
}

# Logistics Service - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8111/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Logistics Service" ($response.StatusCode -eq 200)
} catch {
    # Fallback a endpoint funcional
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8111/routes" -Method Get -TimeoutSec 5 -UseBasicParsing
        Write-TestResult "Logistics Service" ($response.StatusCode -eq 200)
    } catch {
        Write-TestResult "Logistics Service" $false
    }
}

# Accounting Service - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Accounting Service" ($response.StatusCode -eq 200)
} catch {
    # Fallback a endpoint funcional
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices" -Method Get -TimeoutSec 5 -UseBasicParsing
        Write-TestResult "Accounting Service" ($response.StatusCode -eq 200)
    } catch {
        Write-TestResult "Accounting Service" $false
    }
}

# Users Service - Health check
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/actuator/health" -Method Get -TimeoutSec 5 -UseBasicParsing
    Write-TestResult "Users Service" ($response.StatusCode -eq 200)
} catch {
    # Fallback a endpoint funcional
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8131/users" -Method Get -TimeoutSec 5 -UseBasicParsing
        Write-TestResult "Users Service" ($response.StatusCode -eq 200)
    } catch {
        Write-TestResult "Users Service" $false
    }
}

# =========================================
# 2. CONTAINERS SERVICE - Tipos (3 pruebas)
# =========================================
Write-TestHeader "2. CONTAINERS SERVICE - Tipos (3 pruebas)"
Write-UseCaseDescription "Gestionar catálogo de tipos de contenedores disponibles (5m3, 10m3, etc.). Consultar todos los tipos, filtrar solo activos, y crear nuevos tipos para el sistema"

# Variable para almacenar el ID del tipo creado
$createdTypeId = $null

# GET /types
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/types" -Method Get -TimeoutSec 5
    Write-TestResult "GET /types" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /types" $false
}

# GET /types/active
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/types/active" -Method Get -TimeoutSec 5
    Write-TestResult "GET /types/active" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /types/active" $false
}

# POST /types
try {
    $body = @{
        name = "Test Container 5m3 $TIMESTAMP"
        capacityM3 = 5.0
        active = $true
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8101/types" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
    $success = ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
    Write-TestResult "POST /types" $success

    # Capturar el ID del tipo creado
    if ($success) {
        $responseObj = $response.Content | ConvertFrom-Json
        $createdTypeId = $responseObj.id
        Write-Host "     [INFO] Tipo creado con ID: $createdTypeId" -ForegroundColor DarkGray
    }
} catch {
    Write-TestResult "POST /types" $false
}

# =========================================
# 3. CONTAINERS SERVICE - Contenedores (4 pruebas)
# =========================================
Write-TestHeader "3. CONTAINERS SERVICE - Contenedores (4 pruebas)"
Write-UseCaseDescription "Gestionar inventario de contenedores físicos. Consultar todos los contenedores, filtrar por disponibilidad, consultar por estado específico, y registrar nuevos contenedores en el sistema"

# Variable para almacenar el ID del contenedor creado
$createdContainerId = $null

# GET /containers
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/containers" -Method Get -TimeoutSec 5
    Write-TestResult "GET /containers" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /containers" $false
}

# GET /containers/available
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/containers/available" -Method Get -TimeoutSec 5
    Write-TestResult "GET /containers/available" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /containers/available" $false
}

# GET /containers/status/AVAILABLE
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/containers/status/AVAILABLE" -Method Get -TimeoutSec 5
    Write-TestResult "GET /containers/status/AVAILABLE" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /containers/status/AVAILABLE" $false
}

# POST /containers
try {
    # Usar el ID del tipo creado anteriormente, o un fallback si no se pudo crear
    $typeIdToUse = if ($createdTypeId) { $createdTypeId } else { 1 }

    $body = @{
        containerCode = "TEST-$TIMESTAMP"
        containerType = @{
            id = $typeIdToUse
        }
        status = "AVAILABLE"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8101/containers" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
    $success = ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
    Write-TestResult "POST /containers" $success

    # Capturar el ID del contenedor creado
    if ($success) {
        $responseObj = $response.Content | ConvertFrom-Json
        $createdContainerId = $responseObj.id
        Write-Host "     [INFO] Contenedor creado con ID: $createdContainerId (usando tipo ID: $typeIdToUse)" -ForegroundColor DarkGray
    }
} catch {
    Write-TestResult "POST /containers" $false
}

# =========================================
# 4. CONTAINERS SERVICE - Tarifas (3 pruebas)
# =========================================
Write-TestHeader "4. CONTAINERS SERVICE - Tarifas (3 pruebas)"
Write-UseCaseDescription "Gestionar tarifas de alquiler por tipo de contenedor. Consultar todas las tarifas, filtrar solo activas, y crear nuevas tarifas con precios base diarios"

# GET /rates
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/rates" -Method Get -TimeoutSec 5
    Write-TestResult "GET /rates" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /rates" $false
}

# GET /rates/active
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/rates/active" -Method Get -TimeoutSec 5
    Write-TestResult "GET /rates/active" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /rates/active" $false
}

# POST /rates
try {
    # Usar el ID del tipo creado anteriormente, o un fallback si no se pudo crear
    $typeIdToUse = if ($createdTypeId) { $createdTypeId } else { 1 }

    $body = @{
        containerType = @{
            id = $typeIdToUse
        }
        periodType = "DAILY"
        basePrice = 25.0
        active = $true
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8101/rates" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
    $success = ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
    Write-TestResult "POST /rates" $success

    if ($success) {
        Write-Host "     [INFO] Tarifa creada para tipo ID: $typeIdToUse" -ForegroundColor DarkGray
    }
} catch {
    Write-TestResult "POST /rates" $false
}

# =========================================
# 5. CONTAINERS SERVICE - Alquileres (4 pruebas)
# =========================================
Write-TestHeader "5. CONTAINERS SERVICE - Alquileres (4 pruebas)"
Write-UseCaseDescription "Gestionar contratos de alquiler de contenedores. Consultar todos los alquileres, filtrar por estado (activos/pendientes), y crear nuevos contratos asociando contenedor con cliente"

# Variable para almacenar el ID del alquiler creado
$createdRentalId = $null

# GET /rentals
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/rentals" -Method Get -TimeoutSec 5
    Write-TestResult "GET /rentals" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /rentals" $false
}

# GET /rentals/active
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/rentals/active" -Method Get -TimeoutSec 5
    Write-TestResult "GET /rentals/active" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /rentals/active" $false
}

# GET /rentals/pending
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/rentals/pending" -Method Get -TimeoutSec 5
    Write-TestResult "GET /rentals/pending" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /rentals/pending" $false
}

# POST /rentals
try {
    # Usar el ID del contenedor creado anteriormente, o un fallback si no se pudo crear
    $containerIdToUse = if ($createdContainerId) { $createdContainerId } else { 1 }

    $body = @{
        rentalNumber = "RNT-$TIMESTAMP"
        container = @{
            id = $containerIdToUse
        }
        customerId = 1
        startDate = "2025-11-17"
        expectedEndDate = "2025-11-24"
        deliveryAddress = "Test Address 123"
    } | ConvertTo-Json -Depth 10

    $response = Invoke-WebRequest -Uri "http://localhost:8101/rentals" -Method Post -Body $body -ContentType "application/json; charset=utf-8" -TimeoutSec 5
    $success = ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
    Write-TestResult "POST /rentals" $success

    # Capturar el ID del alquiler creado
    if ($success) {
        $responseObj = $response.Content | ConvertFrom-Json
        $createdRentalId = $responseObj.id
        Write-Host "     [INFO] Alquiler creado con ID: $createdRentalId (usando contenedor ID: $containerIdToUse)" -ForegroundColor DarkGray
    }
} catch {
    # Mostrar información de depuración
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "     [DEBUG] Status: $statusCode" -ForegroundColor DarkGray
        if ($statusCode -eq 400 -or $statusCode -eq 404) {
            Write-Host "     [INFO] Error al crear alquiler - verifica que el contenedor existe y está disponible" -ForegroundColor DarkGray
        }
    }
    Write-TestResult "POST /rentals" $false
}

# =========================================
# 6. CONTAINERS SERVICE - Inspecciones (2 pruebas)
# =========================================
Write-TestHeader "6. CONTAINERS SERVICE - Inspecciones (2 pruebas)"
Write-UseCaseDescription "Registrar inspecciones de contenedores al finalizar alquileres. Consultar historial de inspecciones y crear nuevas evaluaciones del estado del contenedor tras su devolución"

# GET /inspections
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8101/inspections" -Method Get -TimeoutSec 5
    Write-TestResult "GET /inspections" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /inspections" $false
}

# POST /inspections
try {
    # Usar el ID del alquiler creado anteriormente, o un fallback si no se pudo crear
    $rentalIdToUse = if ($createdRentalId) { $createdRentalId } else { 1 }

    $body = @{
        rental = @{
            id = $rentalIdToUse
        }
        conditionStatus = "GOOD"
    } | ConvertTo-Json -Depth 10

    $response = Invoke-WebRequest -Uri "http://localhost:8101/inspections" -Method Post -Body $body -ContentType "application/json; charset=utf-8" -TimeoutSec 5
    $success = ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
    Write-TestResult "POST /inspections" $success

    # Mostrar información del resultado
    if ($success) {
        $responseObj = $response.Content | ConvertFrom-Json
        Write-Host "     [INFO] Inspección creada con ID: $($responseObj.id) (usando alquiler ID: $rentalIdToUse)" -ForegroundColor DarkGray
    }
} catch {
    # Mostrar información de depuración
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "     [DEBUG] Status: $statusCode" -ForegroundColor DarkGray
        if ($statusCode -eq 400 -or $statusCode -eq 404) {
            Write-Host "     [INFO] Error al crear inspección - verifica que el alquiler existe" -ForegroundColor DarkGray
        }
    }
    Write-TestResult "POST /inspections" $false
}

# =========================================
# 7. LOGISTICS SERVICE - Rutas (7 pruebas)
# =========================================
Write-TestHeader "7. LOGISTICS SERVICE - Rutas (7 pruebas)"
Write-UseCaseDescription "Gestionar rutas de transporte de contenedores. Consultar rutas, filtrar por estado (planificadas/activas), buscar por fecha, crear nuevas rutas y actualizar información de rutas existentes"

# GET /routes
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes" -Method Get -TimeoutSec 5
    Write-TestResult "GET /routes" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /routes" $false
}

# GET /routes/status/PLANNED
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes/status/PLANNED" -Method Get -TimeoutSec 5
    Write-TestResult "GET /routes/status/PLANNED" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /routes/status/PLANNED" $false
}

# GET /routes/active
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes/active" -Method Get -TimeoutSec 5
    Write-TestResult "GET /routes/active" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /routes/active" $false
}

# GET /routes/planned
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes/planned" -Method Get -TimeoutSec 5
    Write-TestResult "GET /routes/planned" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /routes/planned" $false
}

# GET /routes/date/{date}
try {
    $today = Get-Date -Format "yyyy-MM-dd"
    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes/date/$today" -Method Get -TimeoutSec 5
    Write-TestResult "GET /routes/date/{date}" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /routes/date/{date}" $false
}

# POST /routes
try {
    $body = @{
        routeCode = "RT-TEST-$TIMESTAMP"
        origin = "Plasencia"
        destination = "Caceres"
        scheduleDate = "2025-11-20"
        status = "PLANNED"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-TestResult "POST /routes" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "POST /routes" $false
}

# PUT /routes/{id}
try {
    $body = @{
        routeCode = "RT-001"
        origin = "Plasencia"
        destination = "Madrid"
        scheduleDate = "2025-11-18"
        status = "PLANNED"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8111/routes/1" -Method Put -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-TestResult "PUT /routes/{id}" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "PUT /routes/{id}" $false
}

# =========================================
# 8. ACCOUNTING SERVICE - Facturas (8 pruebas)
# =========================================
Write-TestHeader "8. ACCOUNTING SERVICE - Facturas (8 pruebas)"
Write-UseCaseDescription "Gestionar facturación de servicios. Consultar facturas, filtrar por estado (pendientes/pagadas/vencidas), buscar por cliente, crear nuevas facturas y actualizar estado de pago"

# GET /invoices
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices" -Method Get -TimeoutSec 5
    Write-TestResult "GET /invoices" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /invoices" $false
}

# GET /invoices/status/PENDING
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices/status/PENDING" -Method Get -TimeoutSec 5
    Write-TestResult "GET /invoices/status/PENDING" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /invoices/status/PENDING" $false
}

# GET /invoices/pending
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices/pending" -Method Get -TimeoutSec 5
    Write-TestResult "GET /invoices/pending" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /invoices/pending" $false
}

# GET /invoices/paid
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices/paid" -Method Get -TimeoutSec 5
    Write-TestResult "GET /invoices/paid" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /invoices/paid" $false
}

# GET /invoices/overdue
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices/overdue" -Method Get -TimeoutSec 5
    Write-TestResult "GET /invoices/overdue" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /invoices/overdue" $false
}

# GET /invoices/customer/{id}
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices/customer/1" -Method Get -TimeoutSec 5
    Write-TestResult "GET /invoices/customer/{id}" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /invoices/customer/{id}" $false
}

# POST /invoices
try {
    $body = @{
        invoiceNumber = "INV-TEST-$TIMESTAMP"
        customerId = 1
        invoiceDate = "2025-11-17"
        subtotal = 100.0
        totalAmount = 121.0
        status = "PENDING"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-TestResult "POST /invoices" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "POST /invoices" $false
}

# PUT /invoices/{id}
try {
    $body = @{
        invoiceNumber = "INV-001"
        customerId = 1
        invoiceDate = "2025-11-17"
        subtotal = 150.0
        totalAmount = 181.5
        status = "PAID"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8121/invoices/1" -Method Put -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-TestResult "PUT /invoices/{id}" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "PUT /invoices/{id}" $false
}

# =========================================
# 9. USERS SERVICE - Usuarios (8 pruebas)
# =========================================
Write-TestHeader "9. USERS SERVICE - Usuarios (8 pruebas)"
Write-UseCaseDescription "Gestionar usuarios del sistema. Consultar usuarios, filtrar por rol (clientes/administradores) y estado (activos/inactivos), crear nuevos usuarios, actualizar información y eliminar usuarios"

# GET /users
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/users" -Method Get -TimeoutSec 5
    Write-TestResult "GET /users" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /users" $false
}

# GET /users/role/CUSTOMER
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/users/role/CUSTOMER" -Method Get -TimeoutSec 5
    Write-TestResult "GET /users/role/CUSTOMER" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /users/role/CUSTOMER" $false
}

# GET /users/role/ADMIN
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/users/role/ADMIN" -Method Get -TimeoutSec 5
    Write-TestResult "GET /users/role/ADMIN" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /users/role/ADMIN" $false
}

# GET /users/active
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/users/active" -Method Get -TimeoutSec 5
    Write-TestResult "GET /users/active" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /users/active" $false
}

# GET /users/inactive
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/users/inactive" -Method Get -TimeoutSec 5
    Write-TestResult "GET /users/inactive" ($response.StatusCode -eq 200)
} catch {
    Write-TestResult "GET /users/inactive" $false
}

# POST /users
try {
    $body = @{
        username = "testuser$TIMESTAMP"
        email = "test$TIMESTAMP@example.com"
        password = "Test123456"
        role = "CUSTOMER"
        active = $true
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8131/users" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-TestResult "POST /users" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "POST /users" $false
}

# PUT /users/{id}
try {
    $body = @{
        username = "admin"
        email = "admin@example.com"
        password = "Admin123456"
        role = "ADMIN"
        active = $true
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:8131/users/1" -Method Put -Body $body -ContentType "application/json" -TimeoutSec 5
    Write-TestResult "PUT /users/{id}" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "PUT /users/{id}" $false
}

# DELETE /users/{id}
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8131/users/999" -Method Delete -TimeoutSec 5
    Write-TestResult "DELETE /users/{id}" ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)
} catch {
    Write-TestResult "DELETE /users/{id}" $false
}

# =========================================
# 10. GATEWAY - Enrutamiento (4 pruebas)
# =========================================
Write-TestHeader "10. GATEWAY - Enrutamiento (4 pruebas)"
Write-UseCaseDescription "Verificar que el API Gateway enruta correctamente las peticiones a cada microservicio. Prueba acceso unificado a todos los servicios a través del puerto 8080"

# Gateway -> Containers
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/containers/types" -Method Get -TimeoutSec 10 -UseBasicParsing
    Write-TestResult "Gateway -> Containers" ($response.StatusCode -eq 200)
} catch {
    # Mostrar más información sobre el error
    if ($_.Exception.Response) {
        Write-Host "     [DEBUG] Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor DarkGray
    }
    Write-TestResult "Gateway -> Containers" $false
}

# Gateway -> Logistics
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/logistics/routes" -Method Get -TimeoutSec 10 -UseBasicParsing
    Write-TestResult "Gateway -> Logistics" ($response.StatusCode -eq 200)
} catch {
    if ($_.Exception.Response) {
        Write-Host "     [DEBUG] Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor DarkGray
    }
    Write-TestResult "Gateway -> Logistics" $false
}

# Gateway -> Accounting
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/accounting/invoices" -Method Get -TimeoutSec 10 -UseBasicParsing
    Write-TestResult "Gateway -> Accounting" ($response.StatusCode -eq 200)
} catch {
    if ($_.Exception.Response) {
        Write-Host "     [DEBUG] Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor DarkGray
    }
    Write-TestResult "Gateway -> Accounting" $false
}

# Gateway -> Users
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/users/users" -Method Get -TimeoutSec 10 -UseBasicParsing
    Write-TestResult "Gateway -> Users" ($response.StatusCode -eq 200)
} catch {
    if ($_.Exception.Response) {
        Write-Host "     [DEBUG] Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor DarkGray
    }
    Write-TestResult "Gateway -> Users" $false
}

# =========================================
# 11. EUREKA - Registro (5 pruebas)
# =========================================
Write-TestHeader "11. EUREKA - Registro (5 pruebas)"
Write-UseCaseDescription "Verificar que todos los microservicios se han registrado correctamente en Eureka para descubrimiento de servicios. Confirma que el sistema puede localizar dinámicamente cada microservicio"

# Containers registrado
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -Method Get -TimeoutSec 5
    Write-TestResult "Containers registrado" ($response.Content -like "*CONTAINERS-SERVICE*")
} catch {
    Write-TestResult "Containers NO registrado" $false
}

# Logistics registrado
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -Method Get -TimeoutSec 5
    Write-TestResult "Logistics registrado" ($response.Content -like "*LOGISTICS-SERVICE*")
} catch {
    Write-TestResult "Logistics NO registrado" $false
}

# Accounting registrado
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -Method Get -TimeoutSec 5
    Write-TestResult "Accounting registrado" ($response.Content -like "*ACCOUNTING-SERVICE*")
} catch {
    Write-TestResult "Accounting NO registrado" $false
}

# Users registrado
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -Method Get -TimeoutSec 5
    Write-TestResult "Users registrado" ($response.Content -like "*USERS-SERVICE*")
} catch {
    Write-TestResult "Users NO registrado" $false
}

# Gateway registrado
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -Method Get -TimeoutSec 5
    Write-TestResult "Gateway registrado" ($response.Content -like "*GATEWAY-SERVICE*")
} catch {
    Write-TestResult "Gateway NO registrado" $false
}

# =========================================
# RESUMEN FINAL
# =========================================
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "RESUMEN FINAL" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$TOTAL = $PASSED + $FAILED
Write-Host "Total de pruebas: $TOTAL"
Write-Host "Exitosas:         " -NoNewline
Write-Host "$PASSED" -ForegroundColor Green
Write-Host "Fallidas:         " -NoNewline
Write-Host "$FAILED" -ForegroundColor $(if ($FAILED -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($FAILED -eq 0) {
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "[EXITO] TODAS LAS PRUEBAS PASARON" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Sistema 100% operativo:" -ForegroundColor Green
    Write-Host "  - Infraestructura:     7/7"
    Write-Host "  - Containers Service:  16/16 endpoints"
    Write-Host "  - Logistics Service:   7/7 endpoints"
    Write-Host "  - Accounting Service:  8/8 endpoints"
    Write-Host "  - Users Service:       8/8 endpoints"
    Write-Host "  - Gateway:             4/4 rutas"
    Write-Host "  - Eureka:              5/5 servicios"
    Write-Host ""
    Write-Host "TOTAL: $PASSED pruebas exitosas" -ForegroundColor Green
} else {
    Write-Host "================================================" -ForegroundColor Red
    Write-Host "[ATENCION] HAY PRUEBAS FALLIDAS" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Para diagnosticar:" -ForegroundColor Yellow
    Write-Host "  docker-compose logs -f [servicio]"
    Write-Host "  http://localhost:8761"
    Write-Host ""
    Write-Host "Para reiniciar:" -ForegroundColor Yellow
    Write-Host "  .\setup.bat  (Windows)"
    Write-Host "  docker-compose down && docker-compose up -d  (Manual)"
}
Write-Host ""

# =========================================
# RECURSOS
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "RECURSOS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Dashboards:" -ForegroundColor Yellow
Write-Host "  Eureka:     http://localhost:8761"
Write-Host "  Config:     http://localhost:8888"
Write-Host ""
Write-Host "Swagger (Documentaci�n API):" -ForegroundColor Yellow
Write-Host "  Containers: http://localhost:8101/swagger-ui.html"
Write-Host "  Logistics:  http://localhost:8111/swagger-ui.html"
Write-Host "  Accounting: http://localhost:8121/swagger-ui.html"
Write-Host "  Users:      http://localhost:8131/swagger-ui.html"
Write-Host ""
Write-Host "Gateway (Acceso unificado):" -ForegroundColor Yellow
Write-Host "  Containers: http://localhost:8080/api/containers"
Write-Host "  Logistics:  http://localhost:8080/api/logistics"
Write-Host "  Accounting: http://localhost:8080/api/accounting"
Write-Host "  Users:      http://localhost:8080/api/users"
Write-Host ""

# Salir con c�digo de error si hay fallos
if ($FAILED -gt 0) {
    exit 1
}
exit 0
