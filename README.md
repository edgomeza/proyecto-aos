# Sistema de Microservicios - Alicatados Plasencia

Sistema completo de microservicios para gestión de alquiler de contenedores, logística, contabilidad y usuarios.

## 🏗️ Arquitectura del Sistema

### Servicios de Infraestructura (3):
1. **Eureka Server** (Puerto 8761) - Service Discovery
2. **Config Server** (Puerto 8888) - Configuración centralizada
3. **Gateway Service** (Puerto 8080) - API Gateway

### Microservicios Base (4):
1. **Containers Service** (Puerto 8101) - ⭐ Alquiler de contenedores
2. **Logistics Service** (Puerto 8111) - Planificación de rutas y entregas
3. **Accounting Service** (Puerto 8121) - Gestión contable y nóminas
4. **Users Service** (Puerto 8131) - Autenticación y gestión de usuarios

## 📋 Requisitos Previos

### Software Requerido:
- **Docker Desktop** ([Descargar aquí](https://www.docker.com/products/docker-desktop))
- **Git**

**Nota:** Ya NO necesitas instalar Java, Maven ni MySQL. Docker se encarga de todo.

## 🚀 Inicio Rápido

### ⚡ Usando Docker Compose (RECOMENDADO)

**Windows:**

1. **Compilar y ejecutar todo el sistema:**
```cmd
setup.bat
```

2. **Probar que todo funciona:**
```cmd
test.bat
```

¡Así de simple! El script `setup.bat` se encarga de:
- ✅ Compilar todos los microservicios
- ✅ Crear imágenes Docker
- ✅ Iniciar base de datos MySQL
- ✅ Iniciar todos los servicios con orden de dependencias
- ✅ Esperar a que todo esté listo

**Linux/macOS:**

```bash
# Compilar y ejecutar
docker-compose build
docker-compose up -d

# Esperar 30 segundos para que todo inicie
sleep 30
```

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

Ejecuta el script de pruebas para verificar que todos los servicios funcionan:

```cmd
test.bat
```

Este script verifica:
- ✅ Eureka Server está activo
- ✅ Config Server está activo
- ✅ Gateway Service está activo
- ✅ Containers Service está activo
- ✅ Logistics Service está activo
- ✅ Accounting Service está activo
- ✅ Users Service está activo

## 🐳 Comandos Docker Útiles

### Ver estado de los servicios:
```bash
docker-compose ps
```

### Ver logs de todos los servicios:
```bash
docker-compose logs -f
```

### Ver logs de un servicio específico:
```bash
docker-compose logs -f containers-service
docker-compose logs -f gateway-service
```

### Detener todos los servicios:
```bash
docker-compose down
```

### Detener y eliminar volúmenes (resetear base de datos):
```bash
docker-compose down -v
```

### Reconstruir un servicio específico:
```bash
docker-compose build containers-service
docker-compose up -d containers-service
```

### Reiniciar un servicio:
```bash
docker-compose restart containers-service
```

## 🗄️ Base de Datos

El sistema usa una única base de datos MySQL llamada `alicatados_db` que contiene todas las tablas de todos los microservicios.

**Conexión a la base de datos:**
- Host: `localhost`
- Puerto: `3306`
- Base de datos: `alicatados_db`
- Usuario: `root`
- Contraseña: `root`

**Conectar con MySQL CLI:**
```bash
docker exec -it alicatados-mysql mysql -uroot -proot alicatados_db
```

**Conectar con herramientas GUI** (MySQL Workbench, DBeaver, etc.):
- Usa las credenciales de arriba

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
│   ├── controller/             # API REST
│   └── Dockerfile              # Contenedor Docker
├── logistics-service/          # Microservicio de Logística
│   └── Dockerfile
├── accounting-service/         # Microservicio de Contabilidad
│   └── Dockerfile
├── users-service/              # Microservicio de Usuarios
│   └── Dockerfile
├── docker-compose.yml          # Orquestación de todos los servicios
├── setup.bat                   # Script de instalación (Windows)
├── test.bat                    # Script de pruebas (Windows)
└── README.md                   # Este archivo
```

## 📚 Documentación Adicional

- **Guía de Implementación**: `04_Guia_Implementacion_Completa.md`
- **Problemas y Conclusiones**: `05_Problemas_y_Conclusiones.md`

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

### Error: "Docker no esta instalado"
**Solución:** Instala Docker Desktop desde https://www.docker.com/products/docker-desktop

### Error: "Docker no esta ejecutandose"
**Solución:** Inicia Docker Desktop y espera a que arranque completamente.

### Puerto ya en uso
**Causa:** Otro proceso está usando el puerto.
**Solución:**
```bash
# Detener todos los contenedores
docker-compose down

# Ver qué proceso usa el puerto (Windows)
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Servicios no están listos después de 30 segundos
**Solución:** Algunos servicios pueden tardar más en arrancar la primera vez. Verifica el estado:
```bash
docker-compose ps
docker-compose logs -f
```

### Error: "Fallo la construccion de imagenes"
**Causa:** Problema al compilar el código Java.
**Solución:**
1. Revisa los logs de Docker
2. Asegúrate de tener conexión a internet (Maven descarga dependencias)
3. Intenta de nuevo: `docker-compose build --no-cache`

### Resetear completamente el sistema
```bash
docker-compose down -v
docker system prune -a
setup.bat
```

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
- [x] Docker Compose con todos los servicios
- [x] Scripts automatizados de setup y test

### ⏳ Pendiente:
- [ ] Logistics Service (estructura creada, lógica de negocio pendiente)
- [ ] Accounting Service (estructura creada, lógica de negocio pendiente)
- [ ] Users Service (estructura creada, lógica de negocio pendiente)

## 🔄 Actualizar el Sistema

Después de hacer cambios en el código:

```bash
# 1. Detener servicios
docker-compose down

# 2. Reconstruir
docker-compose build

# 3. Iniciar de nuevo
docker-compose up -d
```

O simplemente ejecuta `setup.bat` de nuevo.

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

### Ejemplos de API

**Listar tipos de contenedores:**
```bash
curl http://localhost:8080/api/containers/types
```

**Crear un nuevo tipo:**
```bash
curl -X POST http://localhost:8080/api/containers/types \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Contenedor 10m³",
    "capacity": 10.0,
    "length": 3.0,
    "width": 2.0,
    "height": 1.7
  }'
```

**Ver todos los contenedores:**
```bash
curl http://localhost:8080/api/containers/containers
```

## 🤝 Contribuir

Para contribuir al proyecto:

1. Crea una rama desde `main`
2. Implementa tus cambios
3. Reconstruye con Docker: `docker-compose build`
4. Prueba: `test.bat`
5. Crea un Pull Request

## 📞 Contacto y Soporte

Para problemas técnicos:
1. Revisa esta documentación
2. Ejecuta `test.bat` para diagnosticar
3. Revisa los logs: `docker-compose logs -f`
4. Verifica el dashboard de Eureka: http://localhost:8761

---

**Proyecto desarrollado para Alicatados Plasencia**
Sistema de Microservicios con Spring Boot 3.5.7 y Spring Cloud 2025.0.0
Desplegado con Docker y Docker Compose
