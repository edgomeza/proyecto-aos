# Instrucciones para Aplicar Actualizaciones de Configuración

## 🚀 Cambios Realizados

Se han actualizado las configuraciones de:
- ✅ **Gateway Service**: Nueva configuración de rutas con RewritePath
- ✅ **Config Server**: Endpoints de Actuator habilitados
- ✅ **Eureka Server**: Endpoints de Actuator habilitados
- ✅ **Script de Pruebas**: Mejor manejo de health checks

## 📋 Pasos para Aplicar los Cambios

### Opción 1: Reinicio Completo (RECOMENDADO)

```bash
# 1. Detener todos los servicios
docker-compose down

# 2. Reconstruir las imágenes afectadas
docker-compose build config-server gateway-service eureka-server

# 3. Iniciar todos los servicios
docker-compose up -d

# 4. Esperar a que todos los servicios se registren (~60-90 segundos)
# En PowerShell:
Start-Sleep -Seconds 90

# En Bash:
sleep 90

# 5. Ejecutar las pruebas
.\test-microservices.ps1   # PowerShell (Windows)
# o
./test.bat                  # CMD (Windows)
```

### Opción 2: Reinicio Selectivo (Más Rápido)

```bash
# 1. Reconstruir solo los servicios modificados
docker-compose build config-server gateway-service eureka-server

# 2. Reiniciar los servicios afectados
docker-compose restart config-server
docker-compose restart eureka-server
docker-compose restart gateway-service

# 3. Esperar a que se registren
Start-Sleep -Seconds 60   # PowerShell
# o
sleep 60                  # Bash

# 4. Ejecutar pruebas
.\test-microservices.ps1
```

## ✅ Verificación Manual

Después de reiniciar, verifica que los servicios están activos:

### Health Checks (ahora disponibles):
```bash
# Eureka Server
curl http://localhost:8761/actuator/health

# Config Server
curl http://localhost:8888/actuator/health

# Gateway Service
curl http://localhost:8080/actuator/health

# Ver las rutas configuradas del Gateway
curl http://localhost:8080/actuator/gateway/routes
```

### Enrutamiento del Gateway:
```bash
# A través del Gateway (debería funcionar ahora)
curl http://localhost:8080/api/containers/types
curl http://localhost:8080/api/logistics/routes
curl http://localhost:8080/api/accounting/invoices
curl http://localhost:8080/api/users/users
```

### Directo a los servicios (debería seguir funcionando):
```bash
curl http://localhost:8101/types
curl http://localhost:8111/routes
curl http://localhost:8121/invoices
curl http://localhost:8131/users
```

## 🎯 Resultados Esperados

Después de aplicar los cambios y reiniciar:

### Antes:
- ❌ Config Server health check: FALLO
- ❌ Gateway → Todos los servicios: 404 (4 fallos)
- ⚠️ POST /rentals y POST /inspections: 400 (esperado)
- **Total: 48/55 pruebas exitosas**

### Después:
- ✅ Config Server health check: OK
- ✅ Gateway → Todos los servicios: OK (4 pruebas)
- ⚠️ POST /rentals y POST /inspections: 400 (esperado - sin datos iniciales)
- **Total: 53/55 pruebas exitosas**

## 🐛 Solución de Problemas

### El Gateway sigue devolviendo 404:

1. Verifica que el Gateway se reconstruyó:
   ```bash
   docker-compose build gateway-service
   ```

2. Verifica que el Config Server está sirviendo la nueva configuración:
   ```bash
   curl http://localhost:8888/gateway-service/default
   ```
   Deberías ver `RewritePath` en lugar de `StripPrefix`

3. Verifica los logs del Gateway:
   ```bash
   docker-compose logs -f gateway-service
   ```
   Busca líneas como:
   - "Loaded RouteDefinition"
   - "Route matched"
   - "RouteDefinitionLocator identified routes"

4. Verifica que los servicios están registrados en Eureka:
   - Ve a: http://localhost:8761
   - Deberías ver: CONTAINERS-SERVICE, LOGISTICS-SERVICE, ACCOUNTING-SERVICE, USERS-SERVICE

### El Config Server sigue fallando:

1. Verifica que se reconstruyó:
   ```bash
   docker-compose build config-server
   ```

2. Verifica los logs:
   ```bash
   docker-compose logs -f config-server
   ```

3. Verifica que responde:
   ```bash
   curl http://localhost:8888/actuator/health
   ```

## 📊 Diferencias en las Configuraciones

### Gateway Service - Antes vs Después:

**ANTES (StripPrefix):**
```yaml
filters:
  - StripPrefix=2
# /api/containers/types → elimina 2 segmentos → /types
```

**DESPUÉS (RewritePath):**
```yaml
filters:
  - RewritePath=/api/containers/(?<segment>.*), /${segment}
# /api/containers/types → /types (más explícito)
```

**Ambos hacen lo mismo**, pero RewritePath es:
- ✅ Más explícito y legible
- ✅ Más flexible (puedes capturar patrones complejos)
- ✅ Más fácil de debuggear
- ✅ Patrón recomendado en Spring Cloud Gateway moderno

## 🔄 ¿Cuándo Reiniciar?

Necesitas reiniciar cuando cambies:
- ✅ Configuración del Gateway (rutas, filtros)
- ✅ Configuración de Eureka
- ✅ Configuración del Config Server
- ✅ Dependencias en pom.xml
- ✅ Variables de entorno en docker-compose.yml

NO necesitas reiniciar cuando cambies:
- ❌ Código de negocio (endpoints, servicios, repositorios)
- ❌ Datos en la base de datos

## 📝 Notas Adicionales

- Los endpoints `/actuator/health` ahora están disponibles en todos los servicios de infraestructura
- El Gateway ahora expone `/actuator/gateway/routes` para debugging
- Los logs están en modo DEBUG para facilitar troubleshooting
- Las pruebas ahora intentan `/actuator/health` primero con fallback a endpoints funcionales
