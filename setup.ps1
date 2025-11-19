# =========================================
# ALICATADOS PLASENCIA - SETUP COMPLETO
# =========================================
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "ALICATADOS PLASENCIA - SETUP COMPLETO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Docker
Write-Host "Verificando Docker..." -NoNewline
try {
    $dockerCommand = Get-Command docker -ErrorAction Stop
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " ERROR" -ForegroundColor Red
    Write-Host "ERROR: Docker no esta instalado" -ForegroundColor Red
    Write-Host "Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Read-Host "Presiona Enter para salir"
    exit 1
}

# Verificar que Docker está ejecutándose
Write-Host "Verificando que Docker este ejecutandose..." -NoNewline
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker no está ejecutándose"
    }
    Write-Host " OK" -ForegroundColor Green
} catch {
    Write-Host " ERROR" -ForegroundColor Red
    Write-Host "ERROR: Docker no esta ejecutandose" -ForegroundColor Red
    Write-Host "Por favor, inicia Docker Desktop" -ForegroundColor Yellow
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "[1/3] Deteniendo contenedores antiguos..." -ForegroundColor Yellow
docker-compose down -v 2>&1 | Out-Null

Write-Host ""
Write-Host "[2/3] Construyendo imagenes Docker..." -ForegroundColor Yellow
Write-Host "Esto puede tardar varios minutos la primera vez..." -ForegroundColor Gray
docker-compose build

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Fallo la construccion de imagenes" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "[3/3] Iniciando todos los servicios..." -ForegroundColor Yellow
docker-compose up -d --build

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "SISTEMA INICIADO CORRECTAMENTE" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Esperando a que los servicios esten listos..." -ForegroundColor Gray
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "URLs disponibles:" -ForegroundColor Cyan
Write-Host "  - Eureka Dashboard: http://localhost:8761"
Write-Host "  - Gateway API:      http://localhost:8080/api"
Write-Host "  - Containers API:   http://localhost:8101/swagger-ui.html"
Write-Host "  - Logistics API:    http://localhost:8111/swagger-ui.html"
Write-Host "  - Accounting API:   http://localhost:8121/swagger-ui.html"
Write-Host "  - Users API:        http://localhost:8131/swagger-ui.html"
Write-Host ""
Write-Host "Comandos utiles:" -ForegroundColor Yellow
Write-Host "  Ver logs:           docker-compose logs -f"
Write-Host "  Ver estado:         docker-compose ps"
Write-Host "  Detener sistema:    docker-compose down"
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Read-Host "Presiona Enter para salir"
