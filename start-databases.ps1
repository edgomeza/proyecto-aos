# Script para iniciar bases de datos con Docker Compose
# Windows PowerShell

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "INICIANDO BASES DE DATOS - Docker Compose" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Verificar si Docker está instalado
$dockerInstalled = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerInstalled) {
    Write-Host "`nERROR: Docker no está instalado." -ForegroundColor Red
    Write-Host "Instala Docker desde: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Read-Host -Prompt "Presiona ENTER para salir"
    exit 1
}

# Verificar si Docker está ejecutándose
try {
    docker info | Out-Null
} catch {
    Write-Host "`nERROR: Docker no está ejecutándose." -ForegroundColor Red
    Write-Host "Por favor, inicia Docker Desktop." -ForegroundColor Yellow
    Read-Host -Prompt "Presiona ENTER para salir"
    exit 1
}

Write-Host "`nIniciando contenedores MySQL..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "`nEsperando a que las bases de datos estén listas..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "BASES DE DATOS INICIADAS" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Write-Host "`nEstado de los contenedores:" -ForegroundColor White
docker-compose ps

Write-Host "`nBases de datos disponibles:" -ForegroundColor White
Write-Host "  - Containers DB:  localhost:3306 (containers_db)" -ForegroundColor Cyan
Write-Host "  - Logistics DB:   localhost:3307 (logistics_db)" -ForegroundColor Cyan
Write-Host "  - Accounting DB:  localhost:3308 (accounting_db)" -ForegroundColor Cyan
Write-Host "  - Users DB:       localhost:3309 (users_db)" -ForegroundColor Cyan

Write-Host "`nphpMyAdmin: http://localhost:8090" -ForegroundColor Magenta
Write-Host "  Usuario: root" -ForegroundColor White
Write-Host "  Password: root" -ForegroundColor White

Write-Host "`nPara ver logs: docker-compose logs -f" -ForegroundColor Yellow
Write-Host "Para detener: docker-compose stop" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Green

Read-Host -Prompt "`nPresiona ENTER para continuar"
