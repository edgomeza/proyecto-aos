# Sistema de Gestión de Alquiler de Contenedores - Alicatados Plasencia

![Arquitectura de Microservicios](arquitectura%20de%20microservicios.png)

## 📋 Índice

- [Sobre la Empresa](#sobre-la-empresa)
- [Descripción del Proyecto](#descripción-del-proyecto)
- [Arquitectura del Sistema](#arquitectura-del-sistema)
- [Casos de Uso](#casos-de-uso)
- [Microservicios](#microservicios)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Uso](#uso)
- [API Documentation](#api-documentation)
- [Pruebas](#pruebas)
- [Diagramas](#diagramas)

---

## 🏢 Sobre la Empresa

**Alicatados Plasencia** es una empresa dedicada al alquiler de contenedores para obras y construcción. La empresa ofrece diferentes tipos de contenedores (5m³, 10m³, 15m³, etc.) para satisfacer las necesidades de sus clientes en el sector de la construcción y alicatados.

### Necesidades del Negocio

La empresa requiere un sistema integral que permita:

- **Gestión de Inventario**: Control completo del inventario de contenedores disponibles, alquilados y en mantenimiento
- **Contratos de Alquiler**: Administración de contratos con clientes, fechas de entrega y devolución
- **Logística**: Planificación de rutas de transporte para entregas y recogidas de contenedores
- **Facturación**: Generación automática de facturas basadas en tarifas y períodos de alquiler
- **Inspecciones**: Registro de inspecciones post-devolución para evaluar daños y estado de los contenedores
- **Gestión de Usuarios**: Control de empleados, clientes y roles de acceso al sistema

---

## 📖 Descripción del Proyecto

Este proyecto implementa una **arquitectura de microservicios** completa para la gestión integral del negocio de alquiler de contenedores. El sistema está diseñado siguiendo las mejores prácticas de desarrollo de software, patrones de diseño empresariales y principios de arquitectura distribuida.

### Características Principales

✅ **Arquitectura de Microservicios**: 7 servicios independientes y escalables
✅ **Service Discovery**: Registro automático de servicios con Netflix Eureka
✅ **API Gateway**: Punto de entrada único para todas las peticiones
✅ **Configuración Centralizada**: Spring Cloud Config Server
✅ **Balanceo de Carga**: Spring Cloud LoadBalancer
✅ **Base de Datos**: MySQL 8.0 con persistencia JPA/Hibernate
✅ **Contenedorización**: Docker y Docker Compose
✅ **Documentación API**: OpenAPI 3.0 / Swagger
✅ **Autenticación**: JWT (JSON Web Tokens)
✅ **Pruebas Automatizadas**: 55 pruebas de integración

### Actores del Sistema

El sistema está diseñado para ser utilizado por diferentes tipos de usuarios:

- **Contable**: Gestión de nóminas, facturas y estadísticas financieras
- **Gerente**: Administración general del sistema, configuración de tarifas
- **Trabajador de Contenedores**: Gestión de devoluciones, inspecciones y alquileres
- **Cliente**: Consulta de contratos y facturas
- **Trabajador de Tienda**: Atención al cliente y gestión de pedidos
- **Camionero**: Gestión de agenda y actualización de entregas
- **Trabajador de Almacén**: Planificación de rutas logísticas

---

## 🏗️ Arquitectura del Sistema

El sistema sigue un patrón de arquitectura de microservicios con los siguientes componentes:

### Componentes de Infraestructura

1. **Config Server** (Puerto 8888)
   - Gestión centralizada de configuraciones
   - Spring Cloud Config Server
   - Permite actualizar configuraciones sin reiniciar servicios

2. **Eureka Server** (Puerto 8761)
   - Servidor de descubrimiento de servicios
   - Registro automático de microservicios
   - Monitoreo de salud de servicios
   - Dashboard disponible en `http://localhost:8761`

3. **Gateway Service** (Puerto 8080)
   - API Gateway unificado
   - Enrutamiento inteligente a microservicios
   - Punto de entrada único para clientes web/móviles
   - Balanceo de carga automático

### Microservicios de Negocio

4. **Containers Service** (Puerto 8101/8102)
   - Gestión de tipos de contenedores
   - Inventario de contenedores físicos
   - Contratos de alquiler
   - Tarifas y pricing
   - Inspecciones post-devolución

5. **Logistics Service** (Puerto 8111/8112)
   - Planificación de rutas de transporte
   - Gestión de entregas y recogidas
   - Seguimiento de estado de rutas
   - Agenda de camioneros

6. **Accounting Service** (Puerto 8121/8122)
   - Generación de facturas
   - Control de pagos
   - Gestión de nóminas de empleados
   - Estadísticas financieras
   - Seguimiento de deudas vencidas

7. **Users Service** (Puerto 8131/8132)
   - Autenticación con JWT
   - Gestión de usuarios y empleados
   - Control de roles (ADMIN, MANAGER, OPERATOR, CUSTOMER)
   - Perfiles de usuario

### Base de Datos

- **MySQL 8.0** (Puerto 3306)
  - Base de datos: `alicatados_db`
  - 8 tablas (una por cada entidad principal)
  - Esquemas independientes por microservicio
  - DDL automático con Hibernate

---

## 📊 Casos de Uso

![Diagrama de Casos de Uso](diagrama%20casos%20de%20uso.png)

### Accounting Service

- **Gestionar Nóminas**: Generación mensual de nóminas para empleados
- **Generar Facturas**: Creación automática de facturas basadas en alquileres
- **Estadísticas Financieras**: Reportes y análisis de datos financieros

### Containers Service

- **Gestionar Tarifas**: Definición de precios por tipo de contenedor
- **Gestionar Devolución**: Registro de devoluciones y actualización de estado
- **Alquilar Contenedor**: Creación de contratos de alquiler

### Users Service

- **Gestionar Empleados**: CRUD de empleados del sistema
- **Autenticación**: Login y generación de tokens JWT

### Logistics Service

- **Planificar Rutas**: Creación de rutas optimizadas para entregas
- **Gestionar Agenda**: Asignación de rutas a camioneros
- **Actualizar Entregas**: Registro de entregas completadas

---

## 🔧 Microservicios

### 1. Config Server

**Responsabilidad**: Configuración centralizada del sistema

**Tecnologías**:
- Spring Cloud Config Server
- Git backend (opcional)

**Puerto**: 8888

**Endpoints**:
- `GET /{application}/{profile}` - Obtener configuración

---

### 2. Eureka Server

**Responsabilidad**: Service Discovery y registro de servicios

**Tecnologías**:
- Netflix Eureka Server
- Spring Cloud Netflix

**Puerto**: 8761

**Dashboard**: `http://localhost:8761`

**Características**:
- Auto-registro de servicios
- Health checks automáticos
- Renovación de heartbeats
- Self-preservation deshabilitado (desarrollo)

---

### 3. Gateway Service

**Responsabilidad**: API Gateway y enrutamiento

**Tecnologías**:
- Spring Cloud Gateway
- Spring Cloud LoadBalancer

**Puerto**: 8080

**Rutas Configuradas**:
```
/api/containers/** → Containers Service (8101/8102)
/api/logistics/** → Logistics Service (8111/8112)
/api/accounting/** → Accounting Service (8121/8122)
/api/users/** → Users Service (8131/8132)
```

**Características**:
- Balanceo de carga round-robin
- Circuit breaker pattern
- Request/Response logging
- CORS configurado

---

### 4. Containers Service

**Responsabilidad**: Gestión completa de contenedores y alquileres

**Puerto**: 8101 (instancia 1), 8102 (instancia 2)

**Modelos de Datos**:

#### ContainerType (Tipos de Contenedores)
```java
- id: Long
- name: String (ej: "5m³", "10m³", "15m³")
- capacity: Double
- description: String
```

#### Container (Inventario)
```java
- id: Long
- serialNumber: String
- containerTypeId: Long
- status: Enum (AVAILABLE, RENTED, IN_MAINTENANCE, DAMAGED)
- currentLocation: String
- purchaseDate: LocalDate
```

#### Rental (Contratos)
```java
- id: Long
- containerId: Long
- customerId: Long
- startDate: LocalDate
- endDate: LocalDate
- deliveryAddress: String
- status: Enum (ACTIVE, COMPLETED, CANCELLED)
- totalAmount: BigDecimal
```

#### RentalRate (Tarifas)
```java
- id: Long
- containerTypeId: Long
- dailyRate: BigDecimal
- weeklyRate: BigDecimal
- monthlyRate: BigDecimal
- effectiveDate: LocalDate
```

#### ContainerInspection (Inspecciones)
```java
- id: Long
- containerId: Long
- rentalId: Long
- inspectionDate: LocalDateTime
- condition: String
- damageDescription: String
- inspectorId: Long
- cleanlinessScore: Integer (1-10)
```

**Endpoints**:

```http
# Container Types
GET    /api/containers/types
POST   /api/containers/types
GET    /api/containers/types/{id}
PUT    /api/containers/types/{id}
DELETE /api/containers/types/{id}

# Containers
GET    /api/containers/containers
POST   /api/containers/containers
GET    /api/containers/containers/{id}
PUT    /api/containers/containers/{id}
DELETE /api/containers/containers/{id}
GET    /api/containers/containers/status/{status}
GET    /api/containers/containers/type/{typeId}

# Rentals
GET    /api/containers/rentals
POST   /api/containers/rentals
GET    /api/containers/rentals/{id}
PUT    /api/containers/rentals/{id}
DELETE /api/containers/rentals/{id}
GET    /api/containers/rentals/active
GET    /api/containers/rentals/customer/{customerId}

# Rental Rates
GET    /api/containers/rates
POST   /api/containers/rates
GET    /api/containers/rates/{id}
PUT    /api/containers/rates/{id}
DELETE /api/containers/rates/{id}
GET    /api/containers/rates/type/{containerTypeId}

# Inspections
GET    /api/containers/inspections
POST   /api/containers/inspections
GET    /api/containers/inspections/{id}
PUT    /api/containers/inspections/{id}
GET    /api/containers/inspections/container/{containerId}
GET    /api/containers/inspections/rental/{rentalId}
```

---

### 5. Logistics Service

**Responsabilidad**: Gestión de rutas y logística de transporte

**Puerto**: 8111 (instancia 1), 8112 (instancia 2)

**Modelos de Datos**:

#### Route (Rutas)
```java
- id: Long
- routeName: String
- driverId: Long
- vehiclePlate: String
- scheduledDate: LocalDate
- startTime: LocalTime
- endTime: LocalTime
- status: Enum (PLANNED, IN_PROGRESS, COMPLETED, CANCELLED)
- stops: List<String> (JSON)
- totalDistance: Double
- estimatedDuration: Integer (minutos)
```

**Endpoints**:

```http
GET    /api/logistics/routes
POST   /api/logistics/routes
GET    /api/logistics/routes/{id}
PUT    /api/logistics/routes/{id}
DELETE /api/logistics/routes/{id}
GET    /api/logistics/routes/active
GET    /api/logistics/routes/planned
GET    /api/logistics/routes/completed
GET    /api/logistics/routes/date/{date}
GET    /api/logistics/routes/driver/{driverId}
PUT    /api/logistics/routes/{id}/status
```

---

### 6. Accounting Service

**Responsabilidad**: Facturación, nóminas y contabilidad

**Puerto**: 8121 (instancia 1), 8122 (instancia 2)

**Modelos de Datos**:

#### Invoice (Facturas)
```java
- id: Long
- invoiceNumber: String
- customerId: Long
- rentalId: Long
- issueDate: LocalDate
- dueDate: LocalDate
- amount: BigDecimal
- taxAmount: BigDecimal
- totalAmount: BigDecimal
- status: Enum (PENDING, PAID, OVERDUE, CANCELLED)
- paymentDate: LocalDate
- notes: String
```

**Endpoints**:

```http
GET    /api/accounting/invoices
POST   /api/accounting/invoices
GET    /api/accounting/invoices/{id}
PUT    /api/accounting/invoices/{id}
DELETE /api/accounting/invoices/{id}
GET    /api/accounting/invoices/pending
GET    /api/accounting/invoices/paid
GET    /api/accounting/invoices/overdue
GET    /api/accounting/invoices/customer/{customerId}
GET    /api/accounting/invoices/rental/{rentalId}
PUT    /api/accounting/invoices/{id}/pay
```

---

### 7. Users Service

**Responsabilidad**: Autenticación y gestión de usuarios

**Puerto**: 8131 (instancia 1), 8132 (instancia 2)

**Modelos de Datos**:

#### User (Usuarios)
```java
- id: Long
- username: String (unique)
- password: String (bcrypt)
- email: String
- firstName: String
- lastName: String
- role: Enum (ADMIN, MANAGER, OPERATOR, CUSTOMER)
- status: Enum (ACTIVE, INACTIVE, SUSPENDED)
- createdAt: LocalDateTime
- lastLogin: LocalDateTime
```

**Roles del Sistema**:
- **ADMIN**: Acceso total al sistema
- **MANAGER**: Gestión de operaciones y reportes
- **OPERATOR**: Operaciones diarias (alquileres, inspecciones)
- **CUSTOMER**: Acceso limitado a sus contratos y facturas

**Endpoints**:

```http
GET    /api/users/users
POST   /api/users/users
GET    /api/users/users/{id}
PUT    /api/users/users/{id}
DELETE /api/users/users/{id}
GET    /api/users/users/active
GET    /api/users/users/inactive
GET    /api/users/users/role/{role}
GET    /api/users/users/username/{username}
```

**Autenticación JWT**:
- Secret Key: `AlicatadosPlasenciaSecretKey2025MicroservicesSystemVerySecure`
- Expiración: 24 horas (86400000 ms)
- Header: `Authorization: Bearer <token>`

---

## 💻 Tecnologías Utilizadas

### Backend Framework
- **Spring Boot**: 3.5.7
- **Spring Cloud**: 2025.0.0
- **Java**: JDK 21

### Microservicios
- **Spring Cloud Gateway**: API Gateway
- **Netflix Eureka**: Service Discovery
- **Spring Cloud Config**: Configuración centralizada
- **Spring Cloud LoadBalancer**: Balanceo de carga

### Persistencia
- **Spring Data JPA**: Capa de datos
- **Hibernate**: ORM
- **MySQL**: 8.0
- **HikariCP**: Connection pooling

### Documentación
- **SpringDoc OpenAPI**: 2.6.0
- **Swagger UI**: Interfaz de documentación

### Seguridad
- **Spring Security**: Framework de seguridad
- **JWT**: JSON Web Tokens
- **BCrypt**: Hash de passwords

### Validación
- **Jakarta Validation**: Bean validation
- **Hibernate Validator**: Implementación

### Utilidades
- **Lombok**: Reducción de boilerplate
- **Spring Boot Actuator**: Métricas y health checks

### DevOps
- **Docker**: Contenedorización
- **Docker Compose**: Orquestación
- **Maven**: Build tool
- **Git**: Control de versiones

---

## 📋 Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- **Java JDK 21** o superior
- **Maven 3.8+** (incluido en el proyecto con Maven Wrapper)
- **Docker Desktop** (Windows/Mac) o **Docker Engine** (Linux)
- **Docker Compose** v2.0+
- **Git** para clonar el repositorio
- **PowerShell** 5.1+ (para ejecutar scripts de prueba en Windows)

### Verificar Instalaciones

```bash
# Java
java -version

# Maven (usando wrapper)
./mvnw -version   # Linux/Mac
mvnw.cmd -version # Windows

# Docker
docker --version
docker-compose --version
```

---

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/edgomeza/proyecto-aos.git
cd proyecto-aos
```

### 2. Estructura del Proyecto

```
proyecto-aos/
├── config-server/              # Servidor de configuración
├── eureka-server/              # Servidor de descubrimiento
├── gateway-service/            # API Gateway
├── containers-service/         # Servicio de contenedores
├── logistics-service/          # Servicio de logística
├── accounting-service/         # Servicio de contabilidad
├── users-service/              # Servicio de usuarios
├── docker-compose.yml          # Configuración Docker
├── setup.bat                   # Script de instalación (Windows)
├── test-microservices.ps1      # Script de pruebas
├── arquitectura de microservicios.png
├── diagrama casos de uso.png
├── diagrama de flujo.png
├── diagrama de secuencia.png
└── README.md                   # Este archivo
```

### 3. Construcción e Inicio del Sistema

#### Opción A: Usar Script Automatizado (Windows)

```cmd
setup.bat
```

Este script realiza:
1. Verificación de Docker
2. Detención de contenedores antiguos
3. Construcción de imágenes Docker
4. Inicio de todos los servicios

#### Opción B: Docker Compose Manual

```bash
# Construir todas las imágenes
docker-compose build

# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f
```

#### Opción C: Maven Manual (para desarrollo)

```bash
# Terminal 1 - Config Server
cd config-server
./mvnw spring-boot:run

# Terminal 2 - Eureka Server
cd eureka-server
./mvnw spring-boot:run

# Terminal 3 - Gateway
cd gateway-service
./mvnw spring-boot:run

# Terminal 4 - Containers Service
cd containers-service
./mvnw spring-boot:run

# Terminal 5 - Logistics Service
cd logistics-service
./mvnw spring-boot:run

# Terminal 6 - Accounting Service
cd accounting-service
./mvnw spring-boot:run

# Terminal 7 - Users Service
cd users-service
./mvnw spring-boot:run
```

### 4. Verificar que los Servicios Estén Ejecutándose

```bash
# Ver contenedores activos
docker-compose ps

# Verificar salud de servicios
curl http://localhost:8761  # Eureka Dashboard
curl http://localhost:8888/actuator/health  # Config Server
curl http://localhost:8080/actuator/health  # Gateway
```

### 5. Tiempo de Inicio

Los servicios tardan aproximadamente 2-3 minutos en iniciarse completamente:

1. **MySQL** (15 segundos)
2. **Config Server** (30 segundos)
3. **Eureka Server** (45 segundos)
4. **Microservicios de negocio** (60 segundos)
5. **Gateway** (último, 90 segundos)

Espera a que todos los servicios se registren en Eureka antes de realizar peticiones.

---

## 🎯 Uso

### Acceso a Dashboards

Una vez iniciado el sistema, puedes acceder a:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| Eureka Dashboard | http://localhost:8761 | Ver servicios registrados |
| Config Server | http://localhost:8888 | Servidor de configuración |
| API Gateway | http://localhost:8080/api | Punto de entrada principal |
| Containers Swagger | http://localhost:8101/swagger-ui.html | Documentación API Containers |
| Logistics Swagger | http://localhost:8111/swagger-ui.html | Documentación API Logistics |
| Accounting Swagger | http://localhost:8121/swagger-ui.html | Documentación API Accounting |
| Users Swagger | http://localhost:8131/swagger-ui.html | Documentación API Users |

### Flujo de Proceso Principal

![Diagrama de Flujo](diagrama%20de%20flujo.png)

#### Proceso de Alquiler de Contenedor

1. **Cliente selecciona contenedor** y proporciona fechas y dirección
2. **Containers Service** verifica disponibilidad
3. Si está disponible:
   - Calcula tarifa según tipo y duración
   - Crea contrato de alquiler
4. **Accounting Service** genera factura automáticamente
5. **Logistics Service** planifica entrega
6. Cliente recibe confirmación con:
   - Número de contrato
   - Fecha de entrega
   - Total a pagar

#### Ejemplo de Flujo con APIs

```bash
# 1. Verificar tipos de contenedores disponibles
curl http://localhost:8080/api/containers/types

# 2. Verificar contenedores disponibles de un tipo
curl http://localhost:8080/api/containers/containers/status/AVAILABLE

# 3. Crear un alquiler
curl -X POST http://localhost:8080/api/containers/rentals \
  -H "Content-Type: application/json" \
  -d '{
    "containerId": 1,
    "customerId": 5,
    "startDate": "2025-11-20",
    "endDate": "2025-12-20",
    "deliveryAddress": "Calle Mayor 123, Plasencia"
  }'

# 4. Generar factura
curl -X POST http://localhost:8080/api/accounting/invoices \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": 5,
    "rentalId": 1,
    "amount": 300.00,
    "dueDate": "2025-12-05"
  }'

# 5. Planificar ruta de entrega
curl -X POST http://localhost:8080/api/logistics/routes \
  -H "Content-Type: application/json" \
  -d '{
    "routeName": "Entrega Contenedor #1",
    "driverId": 3,
    "scheduledDate": "2025-11-20",
    "stops": ["Almacén", "Calle Mayor 123"]
  }'
```

### Diagrama de Secuencia - Generación de Nóminas

![Diagrama de Secuencia](diagrama%20de%20secuencia.png)

El diagrama muestra el proceso completo de generación mensual de nóminas para 17 empleados, incluyendo:

1. Autenticación del contable con JWT
2. Validación de usuario con Users Service
3. Obtención de empleados activos
4. Cálculo de salarios, deducciones y neto
5. Creación de registros de nómina
6. Actualización de estadísticas financieras
7. Aprobación final de nóminas

---

## 📚 API Documentation

Cada microservicio expone su documentación OpenAPI 3.0 mediante Swagger UI.

### Containers Service API

**URL**: http://localhost:8101/swagger-ui.html

**Principales Operaciones**:

```http
# Listar todos los tipos de contenedores
GET /api/containers/types

# Crear nuevo tipo de contenedor
POST /api/containers/types
Content-Type: application/json
{
  "name": "20m³",
  "capacity": 20.0,
  "description": "Contenedor grande para obras"
}

# Obtener contenedores por estado
GET /api/containers/containers/status/AVAILABLE

# Crear alquiler
POST /api/containers/rentals
{
  "containerId": 1,
  "customerId": 5,
  "startDate": "2025-11-20",
  "endDate": "2025-12-20",
  "deliveryAddress": "Calle Principal 456"
}

# Registrar inspección
POST /api/containers/inspections
{
  "containerId": 1,
  "rentalId": 1,
  "inspectionDate": "2025-12-20T14:30:00",
  "condition": "GOOD",
  "cleanlinessScore": 8,
  "damageDescription": ""
}
```

### Logistics Service API

**URL**: http://localhost:8111/swagger-ui.html

**Principales Operaciones**:

```http
# Listar rutas planificadas
GET /api/logistics/routes/planned

# Crear nueva ruta
POST /api/logistics/routes
{
  "routeName": "Ruta Norte - Entregas",
  "driverId": 3,
  "vehiclePlate": "ABC-1234",
  "scheduledDate": "2025-11-21",
  "startTime": "08:00",
  "stops": ["Almacén", "Cliente A", "Cliente B"],
  "totalDistance": 45.5,
  "estimatedDuration": 180
}

# Actualizar estado de ruta
PUT /api/logistics/routes/1/status
{
  "status": "IN_PROGRESS"
}

# Obtener rutas por conductor
GET /api/logistics/routes/driver/3
```

### Accounting Service API

**URL**: http://localhost:8121/swagger-ui.html

**Principales Operaciones**:

```http
# Listar facturas pendientes
GET /api/accounting/invoices/pending

# Crear factura
POST /api/accounting/invoices
{
  "invoiceNumber": "FAC-2025-001",
  "customerId": 5,
  "rentalId": 1,
  "issueDate": "2025-11-20",
  "dueDate": "2025-12-05",
  "amount": 300.00,
  "taxAmount": 63.00,
  "totalAmount": 363.00
}

# Marcar factura como pagada
PUT /api/accounting/invoices/1/pay

# Obtener facturas vencidas
GET /api/accounting/invoices/overdue

# Facturas por cliente
GET /api/accounting/invoices/customer/5
```

### Users Service API

**URL**: http://localhost:8131/swagger-ui.html

**Principales Operaciones**:

```http
# Listar usuarios activos
GET /api/users/users/active

# Crear usuario
POST /api/users/users
{
  "username": "jperez",
  "password": "SecurePass123",
  "email": "jperez@alicatados.com",
  "firstName": "Juan",
  "lastName": "Pérez",
  "role": "OPERATOR",
  "status": "ACTIVE"
}

# Obtener usuarios por rol
GET /api/users/users/role/ADMIN

# Buscar por username
GET /api/users/users/username/jperez

# Actualizar usuario
PUT /api/users/users/1
{
  "status": "INACTIVE"
}
```

---

## 🧪 Pruebas

### Suite de Pruebas Automatizadas

El proyecto incluye un script completo de pruebas con **55 casos de prueba** automatizados.

```powershell
# Ejecutar todas las pruebas (Windows PowerShell)
.\test-microservices.ps1

# Ejecutar sección específica
.\test-microservices.ps1 -Section "Infrastructure"
.\test-microservices.ps1 -Section "Containers"
.\test-microservices.ps1 -Section "Logistics"
.\test-microservices.ps1 -Section "Accounting"
.\test-microservices.ps1 -Section "Users"
```

### Cobertura de Pruebas

#### 1. Pruebas de Infraestructura (7 tests)
- ✅ Config Server health
- ✅ Eureka Server health
- ✅ Gateway health
- ✅ Containers Service health (ambas instancias)
- ✅ Logistics Service health (ambas instancias)
- ✅ Accounting Service health (ambas instancias)
- ✅ Users Service health (ambas instancias)

#### 2. Containers - Tipos (3 tests)
- ✅ Listar tipos de contenedores
- ✅ Crear tipo de contenedor
- ✅ Obtener tipo por ID

#### 3. Containers - Contenedores (4 tests)
- ✅ Listar contenedores
- ✅ Crear contenedor
- ✅ Obtener por estado
- ✅ Obtener por tipo

#### 4. Containers - Tarifas (3 tests)
- ✅ Listar tarifas
- ✅ Crear tarifa
- ✅ Obtener tarifas por tipo

#### 5. Containers - Alquileres (4 tests)
- ✅ Listar alquileres
- ✅ Crear alquiler
- ✅ Obtener alquileres activos
- ✅ Obtener por cliente

#### 6. Containers - Inspecciones (2 tests)
- ✅ Listar inspecciones
- ✅ Crear inspección

#### 7. Logistics - Rutas (7 tests)
- ✅ Listar rutas
- ✅ Crear ruta
- ✅ Obtener rutas activas
- ✅ Obtener rutas planificadas
- ✅ Obtener rutas completadas
- ✅ Obtener por fecha
- ✅ Obtener por conductor

#### 8. Accounting - Facturas (8 tests)
- ✅ Listar facturas
- ✅ Crear factura
- ✅ Obtener facturas pendientes
- ✅ Obtener facturas pagadas
- ✅ Obtener facturas vencidas
- ✅ Obtener por cliente
- ✅ Obtener por alquiler
- ✅ Marcar como pagada

#### 9. Users - Usuarios (8 tests)
- ✅ Listar usuarios
- ✅ Crear usuario
- ✅ Obtener usuarios activos
- ✅ Obtener usuarios inactivos
- ✅ Obtener por rol ADMIN
- ✅ Obtener por rol MANAGER
- ✅ Obtener por rol OPERATOR
- ✅ Buscar por username

#### 10. Gateway - Enrutamiento (4 tests)
- ✅ Ruta a Containers Service
- ✅ Ruta a Logistics Service
- ✅ Ruta a Accounting Service
- ✅ Ruta a Users Service

#### 11. Eureka - Registro (5 tests)
- ✅ Gateway registrado
- ✅ Containers Service registrado
- ✅ Logistics Service registrado
- ✅ Accounting Service registrado
- ✅ Users Service registrado

### Resultados Esperados

Al ejecutar las pruebas, deberías ver:

```
========================================
RESUMEN DE PRUEBAS
========================================
Total de pruebas: 55
Exitosas: 55
Fallidas: 0
Tasa de éxito: 100%
========================================
```

### Pruebas Manuales con cURL

```bash
# Health check de todos los servicios
curl http://localhost:8888/actuator/health
curl http://localhost:8761/actuator/health
curl http://localhost:8080/actuator/health
curl http://localhost:8101/actuator/health
curl http://localhost:8111/actuator/health
curl http://localhost:8121/actuator/health
curl http://localhost:8131/actuator/health

# Verificar servicios registrados en Eureka
curl http://localhost:8761/eureka/apps

# Probar Gateway routing
curl http://localhost:8080/api/containers/types
curl http://localhost:8080/api/logistics/routes
curl http://localhost:8080/api/accounting/invoices
curl http://localhost:8080/api/users/users
```

---

## 📊 Diagramas

### Arquitectura de Microservicios

![Arquitectura de Microservicios](arquitectura%20de%20microservicios.png)

**Componentes visualizados**:
- Clientes Web/Mobile
- Config Server (8888)
- Gateway (8080)
- Microservicios base con puertos duales para redundancia
- Eureka Server (8761)
- Bases de datos MySQL independientes
- Comunicación entre servicios
- Registro de servicios

---

### Casos de Uso del Sistema

![Diagrama de Casos de Uso](diagrama%20casos%20de%20uso.png)

**Actores y funcionalidades**:
- **Contable**: Nóminas, Facturas, Estadísticas
- **Gerente**: Gestión de Tarifas
- **Trabajador Contenedores**: Devoluciones, Alquileres
- **Cliente**: Consultas
- **Trabajador Tienda**: Atención al cliente
- **Camionero**: Agenda, Entregas
- **Trabajador Almacén**: Rutas logísticas

---

### Flujo de Alquiler

![Diagrama de Flujo](diagrama%20de%20flujo.png)

**Proceso**:
1. Cliente selecciona contenedor
2. Indica fechas y dirección
3. Sistema verifica disponibilidad
4. Calcula tarifa
5. Crea alquiler
6. Genera factura
7. Planifica entrega
8. Confirmación al cliente

---

### Secuencia de Generación de Nóminas

![Diagrama de Secuencia](diagrama%20de%20secuencia.png)

**Flujo detallado**:
1. Contable solicita generación de nóminas (mes/año)
2. Gateway valida JWT con Users Service
3. Accounting Service obtiene empleados activos
4. Para cada empleado:
   - Calcula salario bruto
   - Calcula deducciones
   - Calcula salario neto
   - Inserta registro en BD
5. Actualiza estadísticas financieras
6. Retorna resumen: 17 nóminas generadas, total, estado
7. Contable revisa y aprueba
8. Sistema marca todas como PAID

---

## 🗄️ Esquema de Base de Datos

### Base de Datos: alicatados_db

**Motor**: MySQL 8.0
**Puerto**: 3306
**Usuario**: root
**Password**: root

### Tablas

#### 1. container_types
```sql
CREATE TABLE container_types (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capacity DOUBLE NOT NULL,
    description TEXT
);
```

#### 2. containers
```sql
CREATE TABLE containers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    container_type_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL,
    current_location VARCHAR(255),
    purchase_date DATE,
    FOREIGN KEY (container_type_id) REFERENCES container_types(id)
);
```

#### 3. rentals
```sql
CREATE TABLE rentals (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    container_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    delivery_address VARCHAR(500),
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (container_id) REFERENCES containers(id)
);
```

#### 4. rental_rates
```sql
CREATE TABLE rental_rates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    container_type_id BIGINT NOT NULL,
    daily_rate DECIMAL(10,2),
    weekly_rate DECIMAL(10,2),
    monthly_rate DECIMAL(10,2),
    effective_date DATE NOT NULL,
    FOREIGN KEY (container_type_id) REFERENCES container_types(id)
);
```

#### 5. container_inspections
```sql
CREATE TABLE container_inspections (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    container_id BIGINT NOT NULL,
    rental_id BIGINT,
    inspection_date DATETIME NOT NULL,
    condition VARCHAR(50),
    damage_description TEXT,
    inspector_id BIGINT,
    cleanliness_score INT,
    FOREIGN KEY (container_id) REFERENCES containers(id),
    FOREIGN KEY (rental_id) REFERENCES rentals(id)
);
```

#### 6. routes
```sql
CREATE TABLE routes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(200) NOT NULL,
    driver_id BIGINT NOT NULL,
    vehicle_plate VARCHAR(20),
    scheduled_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    status VARCHAR(20) NOT NULL,
    stops TEXT,
    total_distance DOUBLE,
    estimated_duration INT
);
```

#### 7. invoices
```sql
CREATE TABLE invoices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT NOT NULL,
    rental_id BIGINT,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_date DATE,
    notes TEXT
);
```

#### 8. users
```sql
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME,
    last_login DATETIME
);
```

---

## 🔧 Configuración

### Variables de Entorno

Cada microservicio puede configurarse mediante variables de entorno:

```bash
# Application
SPRING_APPLICATION_NAME=containers-service
SERVER_PORT=8101

# Eureka
EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://localhost:8761/eureka/

# Database
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/alicatados_db
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=root

# JPA
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_SHOW_SQL=false
```