# Verificación Rápida del Gateway
Write-Host "🔍 VERIFICACIÓN RÁPIDA DEL GATEWAY" -ForegroundColor Cyan
Write-Host ""

# Verificar si está usando Netty o Tomcat
Write-Host "Tipo de servidor:" -ForegroundColor Yellow
$serverType = docker-compose logs gateway-service 2>&1 | Select-String -Pattern "Netty started|Tomcat started" | Select-Object -First 1

if ($serverType -match "Netty") {
    Write-Host "✅ Netty (Reactivo) - CORRECTO" -ForegroundColor Green
} elseif ($serverType -match "Tomcat") {
    Write-Host "❌ Tomcat (MVC) - NECESITA RECONSTRUIR" -ForegroundColor Red
    Write-Host ""
    Write-Host "Ejecuta estos comandos:" -ForegroundColor Yellow
    Write-Host "  docker-compose down"
    Write-Host "  docker-compose build gateway-service --no-cache"
    Write-Host "  docker-compose up -d"
    Write-Host "  Start-Sleep -Seconds 60"
    exit 1
} else {
    Write-Host "⚠️  No determinado - Ver logs completos" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Estado de servicios:" -ForegroundColor Yellow
docker-compose ps | Select-String -Pattern "gateway-service|containers-service|logistics-service"

Write-Host ""
Write-Host "Prueba rápida:" -ForegroundColor Yellow
try {
    $direct = Invoke-WebRequest -Uri "http://localhost:8111/routes" -Method Get -TimeoutSec 2
    Write-Host "✅ Directo a Logistics (8111): OK" -ForegroundColor Green
} catch {
    Write-Host "❌ Directo a Logistics (8111): FALLO" -ForegroundColor Red
}

try {
    $gateway = Invoke-WebRequest -Uri "http://localhost:8080/api/logistics/routes" -Method Get -TimeoutSec 2
    Write-Host "✅ A través del Gateway: OK" -ForegroundColor Green
} catch {
    Write-Host "❌ A través del Gateway: FALLO" -ForegroundColor Red
    Write-Host ""
    Write-Host "Para diagnóstico completo ejecuta:" -ForegroundColor Yellow
    Write-Host "  .\diagnostico-gateway.ps1"
}
