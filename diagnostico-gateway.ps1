# Script de Diagnóstico del Gateway
# Ejecutar: .\diagnostico-gateway.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DIAGNÓSTICO DEL API GATEWAY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar que Docker está corriendo
Write-Host "1. Verificando Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "   ✅ Docker está corriendo" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker NO está corriendo" -ForegroundColor Red
    exit 1
}

# 2. Verificar estado de los contenedores
Write-Host ""
Write-Host "2. Estado de los contenedores:" -ForegroundColor Yellow
docker-compose ps

# 3. Verificar que el Gateway está usando Netty (no Tomcat)
Write-Host ""
Write-Host "3. Verificando tipo de servidor del Gateway..." -ForegroundColor Yellow
$gatewayLogs = docker-compose logs gateway-service 2>&1 | Select-String -Pattern "Netty|Tomcat" | Select-Object -First 5

if ($gatewayLogs -match "Netty") {
    Write-Host "   ✅ Gateway usando Netty (Reactivo) - CORRECTO" -ForegroundColor Green
    Write-Host "   $gatewayLogs" -ForegroundColor Gray
} elseif ($gatewayLogs -match "Tomcat") {
    Write-Host "   ❌ Gateway usando Tomcat (MVC) - INCORRECTO" -ForegroundColor Red
    Write-Host "   $gatewayLogs" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   SOLUCIÓN: Reconstruir el Gateway:" -ForegroundColor Yellow
    Write-Host "   docker-compose build gateway-service --no-cache" -ForegroundColor White
    Write-Host "   docker-compose up -d gateway-service" -ForegroundColor White
} else {
    Write-Host "   ⚠️  No se pudo determinar el tipo de servidor" -ForegroundColor Yellow
    Write-Host "   Mostrando logs recientes del Gateway:" -ForegroundColor Gray
    docker-compose logs --tail=20 gateway-service
}

# 4. Verificar registros en Eureka
Write-Host ""
Write-Host "4. Servicios registrados en Eureka:" -ForegroundColor Yellow
try {
    $eurekaApps = Invoke-RestMethod -Uri "http://localhost:8761/eureka/apps" -Method Get -ContentType "application/json"
    $apps = $eurekaApps.applications.application

    if ($apps) {
        foreach ($app in $apps) {
            $appName = $app.name
            $instances = if ($app.instance -is [Array]) { $app.instance.Count } else { 1 }
            Write-Host "   ✅ $appName - $instances instancia(s)" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  No hay servicios registrados en Eureka" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ No se pudo conectar a Eureka" -ForegroundColor Red
}

# 5. Probar endpoints directos de los microservicios
Write-Host ""
Write-Host "5. Probando endpoints directos de microservicios:" -ForegroundColor Yellow

$services = @(
    @{Name="Containers"; Port=8101; Path="/types"},
    @{Name="Logistics"; Port=8111; Path="/routes"},
    @{Name="Accounting"; Port=8121; Path="/invoices"},
    @{Name="Users"; Port=8131; Path="/users"}
)

foreach ($svc in $services) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$($svc.Port)$($svc.Path)" -Method Get -TimeoutSec 2 -ErrorAction Stop
        Write-Host "   ✅ $($svc.Name) (puerto $($svc.Port)): OK - Status $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ $($svc.Name) (puerto $($svc.Port)): FALLO" -ForegroundColor Red
    }
}

# 6. Probar endpoints a través del Gateway
Write-Host ""
Write-Host "6. Probando endpoints a través del Gateway:" -ForegroundColor Yellow

$gatewayRoutes = @(
    @{Name="Containers"; Path="/api/containers/types"},
    @{Name="Logistics"; Path="/api/logistics/routes"},
    @{Name="Accounting"; Path="/api/accounting/invoices"},
    @{Name="Users"; Path="/api/users/users"}
)

foreach ($route in $gatewayRoutes) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080$($route.Path)" -Method Get -TimeoutSec 2 -ErrorAction Stop
        Write-Host "   ✅ Gateway → $($route.Name): OK - Status $($response.StatusCode)" -ForegroundColor Green
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode) {
            Write-Host "   ❌ Gateway → $($route.Name): FALLO - Status $statusCode" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Gateway → $($route.Name): FALLO - No responde" -ForegroundColor Red
        }
    }
}

# 7. Verificar rutas configuradas en el Gateway
Write-Host ""
Write-Host "7. Verificando configuración de rutas del Gateway:" -ForegroundColor Yellow
try {
    $routes = Invoke-RestMethod -Uri "http://localhost:8080/actuator/gateway/routes" -Method Get -ContentType "application/json"

    if ($routes) {
        Write-Host "   Rutas configuradas:" -ForegroundColor Green
        foreach ($route in $routes) {
            Write-Host "   - ID: $($route.route_id)" -ForegroundColor Cyan
            Write-Host "     URI: $($route.uri)" -ForegroundColor Gray
            Write-Host "     Predicates: $($route.predicates -join ', ')" -ForegroundColor Gray
            Write-Host ""
        }
    } else {
        Write-Host "   ⚠️  No se encontraron rutas configuradas" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ No se pudo obtener las rutas del Gateway" -ForegroundColor Red
    Write-Host "   Esto puede indicar que el Gateway no se ha reconstruido correctamente" -ForegroundColor Yellow
}

# 8. Ver últimos logs del Gateway
Write-Host ""
Write-Host "8. Últimos logs del Gateway (últimas 30 líneas):" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Gray
docker-compose logs --tail=30 gateway-service
Write-Host "================================================" -ForegroundColor Gray

# Resumen y recomendaciones
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMEN Y RECOMENDACIONES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Si el Gateway está usando Tomcat (no Netty):" -ForegroundColor Yellow
Write-Host "  1. docker-compose down" -ForegroundColor White
Write-Host "  2. docker-compose build gateway-service --no-cache" -ForegroundColor White
Write-Host "  3. docker-compose up -d" -ForegroundColor White
Write-Host "  4. Start-Sleep -Seconds 60" -ForegroundColor White
Write-Host "  5. .\diagnostico-gateway.ps1  # Ejecutar de nuevo" -ForegroundColor White
Write-Host ""

Write-Host "Si los microservicios no están en Eureka:" -ForegroundColor Yellow
Write-Host "  Esperar 30-60 segundos más y verificar: http://localhost:8761" -ForegroundColor White
Write-Host ""

Write-Host "Si todo lo demás falla:" -ForegroundColor Yellow
Write-Host "  docker-compose down && docker-compose build && docker-compose up -d" -ForegroundColor White
Write-Host ""
