# 🚀 Guía de Inicio Rápido - Alicatados Plasencia

Esta guía te ayudará a ejecutar el sistema completo en **menos de 5 minutos**.

## ✅ Requisitos

Antes de empezar, asegúrate de tener instalado:
- ✅ **Docker Desktop** ([Descargar](https://www.docker.com/products/docker-desktop))
- ✅ **Java 21** ([Descargar](https://adoptium.net/))
- ✅ **Maven 3.6+** ([Descargar](https://maven.apache.org/download.cgi))

## 📝 Pasos para Ejecutar el Sistema

### **Paso 1: Iniciar las Bases de Datos** (30 segundos)

Abre una terminal en la raíz del proyecto y ejecuta:

#### Windows (PowerShell):
```powershell
.\start-databases.ps1
```

#### Windows (CMD):
```cmd
start-databases.bat
```

#### Linux/macOS:
```bash
./start-databases.sh
```

**Espera 30 segundos** hasta que veas el mensaje "BASES DE DATOS INICIADAS".

✅ Verificación:
- Abre http://localhost:8090 (phpMyAdmin debe cargar)
- Usuario: `root`, Password: `root`

---

### **Paso 2: Iniciar los Microservicios** (2-3 minutos)

#### Opción A: Usando Scripts Automatizados ⭐ RECOMENDADO

Abre una **NUEVA terminal** y ejecuta:

**Windows (PowerShell):**
```powershell
cd codigo
.\script_ejecucion_sistema.ps1
```

**Windows (CMD):**
```cmd
cd codigo
script_ejecucion_sistema.bat
```

**Linux/macOS:**
```bash
cd codigo
./script_ejecucion_sistema.sh
```

El script iniciará automáticamente:
1. Eureka Server (8761)
2. Config Server (8888)
3. Gateway Service (8080)
4. Todos los microservicios (2 instancias de cada uno)

---

#### Opción B: Inicio Manual (paso a paso)

Si prefieres tener más control, abre **terminales separadas** para cada servicio:

**Terminal 1 - Eureka Server:**
```bash
cd eureka-server
mvn spring-boot:run
```
⏱️ Espera 15 segundos

**Terminal 2 - Config Server:**
```bash
cd config-server
mvn spring-boot:run
```
⏱️ Espera 10 segundos

**Terminal 3 - Gateway Service:**
```bash
cd gateway-service
mvn spring-boot:run
```
⏱️ Espera 10 segundos

**Terminal 4 - Containers Service:**
```bash
cd containers-service
mvn spring-boot:run
```

Ahora el **Containers Service debe iniciar correctamente** sin errores de base de datos.

---

### **Paso 3: Verificar que Todo Funciona** ✅

#### 1. Verificar Eureka (Service Discovery)
```
http://localhost:8761
```
Deberías ver todos los servicios registrados.

#### 2. Verificar Gateway
```bash
curl http://localhost:8080/actuator/health
```
Debería responder: `{"status":"UP"}`

#### 3. Verificar Containers Service
```bash
curl http://localhost:8101/actuator/health
```
Debería responder: `{"status":"UP"}`

#### 4. Probar la API de Containers
Abre en el navegador:
```
http://localhost:8101/swagger-ui.html
```

Deberías ver la documentación Swagger de la API.

---

## 🎯 URLs Importantes

Una vez todo esté ejecutándose:

### Servicios de Infraestructura:
- **Eureka Dashboard**: http://localhost:8761
- **Gateway API**: http://localhost:8080/api
- **phpMyAdmin**: http://localhost:8090

### Documentación API (Swagger):
- **Containers Service**: http://localhost:8101/swagger-ui.html
- **Logistics Service**: http://localhost:8111/swagger-ui.html
- **Accounting Service**: http://localhost:8121/swagger-ui.html
- **Users Service**: http://localhost:8131/swagger-ui.html

### Actuator Health Checks:
- **Containers**: http://localhost:8101/actuator/health
- **Logistics**: http://localhost:8111/actuator/health
- **Accounting**: http://localhost:8121/actuator/health
- **Users**: http://localhost:8131/actuator/health

---

## 🛑 Detener el Sistema

### Detener Microservicios:
Presiona `Ctrl+C` en cada terminal donde estén ejecutándose.

### Detener Bases de Datos:

**Windows (PowerShell):**
```powershell
.\stop-databases.ps1
```

**Windows (CMD):**
```cmd
stop-databases.bat
```

**Linux/macOS:**
```bash
./stop-databases.sh
```

---

## 🔧 Solución de Problemas Comunes

### ❌ Error: "port is already allocated"
**Causa:** El puerto ya está en uso.

**Solución:**
```bash
# Windows
netstat -ano | findstr :3306
taskkill /PID <numero> /F

# Linux/macOS
lsof -i :3306
kill -9 <PID>
```

### ❌ Error: "Connection refused: getsockopt"
**Causa:** Config Server no está iniciado o aún no está listo.

**Solución:**
1. Asegúrate de que Config Server esté ejecutándose
2. Espera 10 segundos adicionales
3. Reinicia el microservicio que falla

### ❌ Error: "Failed to configure a DataSource"
**Causa:** Las bases de datos Docker no están iniciadas.

**Solución:**
1. Ejecuta `./start-databases.sh` (o .bat/.ps1)
2. Verifica que los contenedores estén corriendo: `docker-compose ps`
3. Todos deben mostrar "Up" en el estado

### ❌ Error: "Eureka Dashboard está vacío"
**Causa:** Los servicios aún se están registrando.

**Solución:**
- Espera 30 segundos adicionales
- Los servicios se registran automáticamente cada 30 segundos
- Refresca la página del dashboard

---

## 📊 Ver Logs

### Logs de Bases de Datos:
```bash
docker-compose logs -f
```

Para un contenedor específico:
```bash
docker-compose logs -f mysql-containers
```

### Logs de Microservicios:
Los logs aparecen en la terminal donde está ejecutándose cada servicio.

---

## 🎓 Tutoriales Rápidos

### Crear un Nuevo Tipo de Contenedor (vía Swagger):

1. Abre http://localhost:8101/swagger-ui.html
2. Busca `POST /types`
3. Haz clic en "Try it out"
4. Pega este JSON:
```json
{
  "name": "Contenedor 5m³",
  "capacityM3": 5.00,
  "dimensions": "2m x 1.5m x 1.5m",
  "description": "Contenedor pequeño para escombros",
  "active": true
}
```
5. Haz clic en "Execute"
6. Deberías ver respuesta 201 (Created)

### Listar Todos los Tipos de Contenedores:

1. En Swagger, busca `GET /types`
2. Haz clic en "Try it out"
3. Haz clic en "Execute"
4. Verás la lista de tipos creados

### Consultar Desde Terminal (curl):

```bash
# Listar tipos
curl http://localhost:8101/types

# Crear tipo (Windows PowerShell)
Invoke-RestMethod -Uri http://localhost:8101/types -Method POST -Body (@{
  name = "Contenedor 10m³"
  capacityM3 = 10.00
  dimensions = "3m x 2m x 1.5m"
  description = "Contenedor mediano"
  active = $true
} | ConvertTo-Json) -ContentType "application/json"

# Crear tipo (Linux/macOS)
curl -X POST http://localhost:8101/types \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Contenedor 10m³",
    "capacityM3": 10.00,
    "dimensions": "3m x 2m x 1.5m",
    "description": "Contenedor mediano",
    "active": true
  }'
```

---

## 📚 Documentación Completa

- **README Principal**: [README.md](README.md)
- **Guía Docker Compose**: [DOCKER-DATABASE.md](DOCKER-DATABASE.md)
- **Scripts de Ejecución**: [codigo/README.md](codigo/README.md)
- **Guía de Implementación**: [04_Guia_Implementacion_Completa.md](04_Guia_Implementacion_Completa.md)

---

## ✨ Resumen - Lo Esencial

```bash
# 1. Iniciar bases de datos
./start-databases.sh  # (o .bat/.ps1)

# 2. Esperar 30 segundos

# 3. Iniciar microservicios
cd codigo
./script_ejecucion_sistema.sh  # (o .bat/.ps1)

# 4. Esperar 2-3 minutos

# 5. Verificar
# http://localhost:8761  (Eureka - todos los servicios registrados)
# http://localhost:8101/swagger-ui.html  (API de Containers)
```

---

**¡Listo! Tu sistema de microservicios está funcionando** 🎉

Si tienes problemas, revisa la sección de **Solución de Problemas** o consulta la documentación completa.
