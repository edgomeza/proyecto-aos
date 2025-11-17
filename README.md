# Sistema de Microservicios - Alicatados Plasencia

Sistema completo de microservicios para gestión de alquiler de contenedores, logística, contabilidad y usuarios.

## 🏗️ Arquitectura del Sistema

### Servicios de Infraestructura (3):
1. **Eureka Server** (Puerto 8761) - Service Discovery
2. **Config Server** (Puerto 8888) - Configuración centralizada
3. **Gateway Service** (Puerto 8080) - API Gateway

### Microservicios Base (4):
1. **Containers Service** (Puerto 8101/8102) - ⭐ Alquiler de contenedores
2. **Logistics Service** (Puerto 8111/8112) - Planificación de rutas y entregas
3. **Accounting Service** (Puerto 8121/8122) - Gestión contable y nóminas
4. **Users Service** (Puerto 8131/8132) - Autenticación y gestión de usuarios

## 📋 Requisitos Previos

### Software Requerido:
- **Java 21** o superior
- **Maven 3.6+**
- **MySQL 8.0+** (ejecutándose en localhost:3306)
- **Git**

### Configuración de Base de Datos:

Crea las siguientes bases de datos en MySQL:

```sql
CREATE DATABASE containers_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE logistics_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE accounting_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE users_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Usuario de MySQL por defecto: `root` / `root` (configurable en `config-server/src/main/resources/configurations/`)

## 🚀 Inicio Rápido

### Opción 1: Usando Scripts Automatizados

Ve al directorio `codigo/` y ejecuta los scripts según tu sistema operativo:

**Linux/macOS:**
```bash
cd codigo
./script_compilacion_empaquetado.sh
./script_ejecucion_sistema.sh
```

**Windows CMD:**
```cmd
cd codigo
script_compilacion_empaquetado.bat
script_ejecucion_sistema.bat
```

**Windows PowerShell:**
```powershell
cd codigo
.\script_compilacion_empaquetado.ps1
.\script_ejecucion_sistema.ps1
```

### Opción 2: Ejecución Manual

**IMPORTANTE:** Sigue este orden para evitar errores:

#### 1. Iniciar Eureka Server (esperar 15 segundos)
```bash
cd eureka-server
mvn spring-boot:run
```

#### 2. Iniciar Config Server (esperar 10 segundos)
```bash
cd config-server
mvn spring-boot:run
```

#### 3. Iniciar Gateway Service (esperar 10 segundos)
```bash
cd gateway-service
mvn spring-boot:run
```

#### 4. Iniciar Microservicios Base (pueden iniciarse en paralelo)

**Containers Service - Instancia 1:**
```bash
cd containers-service
mvn spring-boot:run
```

**Containers Service - Instancia 2 (nueva terminal):**
```bash
cd containers-service
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8102
```

Repite para los demás servicios con sus puertos correspondientes:
- Logistics: 8111, 8112
- Accounting: 8121, 8122
- Users: 8131, 8132

## 🔗 URLs Importantes

### Servicios de Infraestructura:
- **Eureka Dashboard**: http://localhost:8761
- **Config Server**: http://localhost:8888
- **Gateway API**: http://localhost:8080/api

### Documentación API (Swagger UI):
- **Containers Service**: http://localhost:8101/swagger-ui.html
- **Logistics Service**: http://localhost:8111/swagger-ui.html
- **Accounting Service**: http://localhost:8121/swagger-ui.html
- **Users Service**: http://localhost:8131/swagger-ui.html

### OpenAPI JSON:
- **Containers**: http://localhost:8101/v3/api-docs
- **Logistics**: http://localhost:8111/v3/api-docs
- **Accounting**: http://localhost:8121/v3/api-docs
- **Users**: http://localhost:8131/v3/api-docs

## ✅ Verificación del Sistema

### 1. Verificar Eureka
Abre http://localhost:8761 y verifica que todos los servicios estén registrados.

### 2. Probar Gateway
```bash
curl http://localhost:8080/actuator/health
```

### 3. Probar Containers Service
```bash
curl http://localhost:8101/actuator/health
curl http://localhost:8101/types
```

### 4. Ejecutar Suite de Pruebas
```bash
cd codigo
./scripts_ejecucion_pruebas.sh  # Linux/macOS
# o
scripts_ejecucion_pruebas.bat   # Windows
```

## 🛠️ Estructura del Proyecto

```
proyecto-aos/
├── eureka-server/              # Service Discovery
├── config-server/              # Configuración centralizada
│   └── src/main/resources/configurations/  # Archivos de configuración
├── gateway-service/            # API Gateway
├── containers-service/         # ⭐ Microservicio de Contenedores (IMPLEMENTADO)
│   ├── model/                  # Entidades JPA
│   ├── repository/             # Repositorios
│   ├── service/                # Lógica de negocio
│   └── controller/             # API REST
├── logistics-service/          # Microservicio de Logística
├── accounting-service/         # Microservicio de Contabilidad
├── users-service/              # Microservicio de Usuarios
├── codigo/                     # Scripts de compilación y ejecución
│   ├── README.md
│   ├── *.sh                    # Scripts Linux/macOS
│   ├── *.bat                   # Scripts Windows CMD
│   └── *.ps1                   # Scripts Windows PowerShell
└── README.md                   # Este archivo
```

## 📚 Documentación Adicional

- **Guía de Implementación**: `04_Guia_Implementacion_Completa.md`
- **Problemas y Conclusiones**: `05_Problemas_y_Conclusiones.md`
- **Scripts**: Ver `codigo/README.md`

## 🔧 Configuración

La configuración de cada microservicio se gestiona centralizadamente en:
```
config-server/src/main/resources/configurations/
```

Archivos de configuración:
- `application.yml` - Configuración compartida
- `containers-service.yml` - Configuración del servicio de contenedores
- `logistics-service.yml` - Configuración del servicio de logística
- `accounting-service.yml` - Configuración del servicio de contabilidad
- `users-service.yml` - Configuración del servicio de usuarios
- `gateway-service.yml` - Configuración del gateway

## 🐛 Solución de Problemas

### Error: "No spring.config.import property has been defined"
**Solución:** Este error ha sido corregido. Asegúrate de tener la última versión del código.

### Error: "Failed to configure a DataSource"
**Causa:** MySQL no está ejecutándose o las bases de datos no existen.
**Solución:**
1. Verifica que MySQL esté ejecutándose
2. Crea las bases de datos necesarias (ver sección "Configuración de Base de Datos")
3. Verifica credenciales en los archivos de configuración

### Error: "Connection refused" al conectar con Config Server
**Causa:** Config Server no está iniciado o aún no está listo.
**Solución:**
1. Inicia Config Server primero
2. Espera 10 segundos antes de iniciar otros servicios
3. Los servicios se conectarán automáticamente cuando Config Server esté disponible

### Puerto ya en uso
**Solución:**
```bash
# Linux/macOS
lsof -i :8080
kill -9 <PID>

# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Servicios no se registran en Eureka
**Causa:** Eureka Server no estaba listo cuando se iniciaron los servicios.
**Solución:** Reinicia los microservicios o espera 30 segundos (reintentos automáticos).

## 📊 Estado de Implementación

### ✅ Completado:
- [x] Eureka Server
- [x] Config Server
- [x] Gateway Service
- [x] **Containers Service (100%)**
  - [x] 5 Entidades
  - [x] 5 Repositories
  - [x] 5 Services
  - [x] 5 Controllers REST
  - [x] Documentación Swagger

### ⏳ Pendiente:
- [ ] Logistics Service (estructura creada)
- [ ] Accounting Service (estructura creada)
- [ ] Users Service (estructura creada)

## 🔄 Actualizar el Sistema

Después de hacer cambios en el código:

1. Detén todos los servicios
2. Ejecuta el script de compilación
3. Vuelve a ejecutar el script de ejecución

## 🎯 Características del Containers Service

El microservicio de Contenedores incluye:

✅ **Gestión de Tipos de Contenedores**: Diferentes capacidades (5m³, 10m³, etc.)
✅ **Inventario de Contenedores**: Control de estados (AVAILABLE, RENTED, IN_MAINTENANCE, DAMAGED)
✅ **Tarifas Dinámicas**: Precios por día, semana o mes
✅ **Sistema de Alquileres**:
- Cálculo automático de precios
- Gestión de fechas de entrega y recogida
- Ubicación GPS de entrega
- Cargos por días extra (50% recargo)
✅ **Inspecciones**: Registro de daños y deducción de fianzas
✅ **API REST Completa**: Documentada con Swagger/OpenAPI

## 🤝 Contribuir

Para contribuir al proyecto:

1. Crea una rama desde `main`
2. Implementa tus cambios
3. Asegúrate de que todo compile sin errores
4. Ejecuta las pruebas
5. Crea un Pull Request

## 📞 Contacto y Soporte

Para problemas técnicos:
1. Revisa esta documentación
2. Consulta los logs de cada servicio
3. Verifica la configuración en Config Server
4. Revisa el dashboard de Eureka

---

**Proyecto desarrollado para Alicatados Plasencia**
Sistema de Microservicios con Spring Boot 3.5.7 y Spring Cloud 2025.0.0
