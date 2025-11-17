# Script para detener bases de datos
# Windows PowerShell

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "DETENIENDO BASES DE DATOS - Docker Compose" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

docker-compose stop

Write-Host "`nBases de datos detenidas." -ForegroundColor Green
Write-Host "Los datos se mantienen en los volúmenes Docker." -ForegroundColor Yellow

Write-Host "`nPara reiniciar: .\start-databases.ps1" -ForegroundColor White
Write-Host "Para eliminar TODO (incluidos datos): docker-compose down -v" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Cyan

Read-Host -Prompt "`nPresiona ENTER para continuar"
