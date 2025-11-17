# Guía de Uso - Bases de Datos con Docker Compose

Esta guía explica cómo usar Docker Compose para gestionar las bases de datos MySQL del proyecto.

## 📋 Requisitos Previos

- **Docker** instalado ([Descargar Docker Desktop](https://www.docker.com/products/docker-desktop))
- **Docker Compose** (incluido con Docker Desktop)

## 🚀 Iniciar las Bases de Datos

### Opción 1: Docker Compose (Recomendado)

Desde la raíz del proyecto, ejecuta:

```bash
docker-compose up -d
```

Este comando:
- ✅ Descarga la imagen MySQL 8.0 (si no la tienes)
- ✅ Crea 4 contenedores MySQL (uno por microservicio)
- ✅ Crea las bases de datos automáticamente
- ✅ Configura usuarios y contraseñas
- ✅ Inicia phpMyAdmin en el puerto 8090
- ✅ Ejecuta en modo detached (background)

### Opción 2: Usar scripts automatizados

**Linux/macOS:**
```bash
./start-databases.sh
```

**Windows PowerShell:**
```powershell
.\start-databases.ps1
```

**Windows CMD:**
```cmd
start-databases.bat
```

## 🔍 Verificar que las Bases de Datos están Funcionando

### Ver el estado de los contenedores:
```bash
docker-compose ps
```

Deberías ver algo como:
```
NAME                   STATUS         PORTS
mysql-containers-db    Up 30 seconds  0.0.0.0:3306->3306/tcp
mysql-logistics-db     Up 30 seconds  0.0.0.0:3307->3306/tcp
mysql-accounting-db    Up 30 seconds  0.0.0.0:3308->3306/tcp
mysql-users-db         Up 30 seconds  0.0.0.0:3309->3306/tcp
phpmyadmin             Up 30 seconds  0.0.0.0:8090->80/tcp
```

### Ver los logs:
```bash
docker-compose logs -f
```

Para ver logs de un servicio específico:
```bash
docker-compose logs -f mysql-containers
```

## 🗄️ Configuración de Bases de Datos

### Bases de Datos Creadas:

| Servicio | Base de Datos | Puerto | Usuario Root | Password Root |
|----------|---------------|--------|--------------|---------------|
| Containers | containers_db | 3306 | root | root |
| Logistics | logistics_db | 3307 | root | root |
| Accounting | accounting_db | 3308 | root | root |
| Users | users_db | 3309 | root | root |

### Conexión desde los Microservicios:

Los microservicios están configurados para conectarse a:
- **Host**: `localhost`
- **Puerto**: `3306` (containers), `3307` (logistics), `3308` (accounting), `3309` (users)
- **Usuario**: `root`
- **Password**: `root`

**IMPORTANTE:** Las URLs de conexión están en:
```
config-server/src/main/resources/configurations/
```

## 🌐 phpMyAdmin - Interfaz Web

phpMyAdmin está disponible en: **http://localhost:8090**

### Conectarse a cada base de datos:

1. **Containers DB:**
   - Servidor: `mysql-containers` o `localhost:3306`
   - Usuario: `root`
   - Password: `root`

2. **Logistics DB:**
   - Servidor: `mysql-logistics` o `localhost:3307`
   - Usuario: `root`
   - Password: `root`

3. **Accounting DB:**
   - Servidor: `mysql-accounting` o `localhost:3308`
   - Usuario: `root`
   - Password: `root`

4. **Users DB:**
   - Servidor: `mysql-users` o `localhost:3309`
   - Usuario: `root`
   - Password: `root`

## ⏸️ Detener las Bases de Datos

### Detener sin eliminar datos:
```bash
docker-compose stop
```

### Detener y eliminar contenedores (mantiene los datos):
```bash
docker-compose down
```

### Detener y ELIMINAR TODO (incluidos los datos):
```bash
docker-compose down -v
```
⚠️ **CUIDADO:** Esto eliminará todos los datos almacenados.

## 🔄 Reiniciar las Bases de Datos

```bash
docker-compose restart
```

O reiniciar un servicio específico:
```bash
docker-compose restart mysql-containers
```

## 🧹 Limpiar y Empezar de Cero

Si necesitas borrar todo y empezar de nuevo:

```bash
# Detener y eliminar contenedores, redes y volúmenes
docker-compose down -v

# Reiniciar
docker-compose up -d
```

## 📊 Comandos Útiles

### Conectarse a MySQL desde terminal:

**Containers DB:**
```bash
docker exec -it mysql-containers-db mysql -uroot -proot containers_db
```

**Logistics DB:**
```bash
docker exec -it mysql-logistics-db mysql -uroot -proot logistics_db
```

**Accounting DB:**
```bash
docker exec -it mysql-accounting-db mysql -uroot -proot accounting_db
```

**Users DB:**
```bash
docker exec -it mysql-users-db mysql -uroot -proot users_db
```

### Ver uso de recursos:
```bash
docker stats
```

### Ver volúmenes creados:
```bash
docker volume ls | grep alicatados
```

### Backup de una base de datos:

**Containers DB:**
```bash
docker exec mysql-containers-db mysqldump -uroot -proot containers_db > backup-containers.sql
```

### Restaurar una base de datos:
```bash
docker exec -i mysql-containers-db mysql -uroot -proot containers_db < backup-containers.sql
```

## 🔧 Personalizar la Configuración

Para cambiar usuarios, contraseñas o puertos, edita el archivo `docker-compose.yml`:

```yaml
mysql-containers:
  environment:
    MYSQL_ROOT_PASSWORD: tu_password
    MYSQL_DATABASE: tu_base_de_datos
    MYSQL_USER: tu_usuario
    MYSQL_PASSWORD: tu_password_usuario
  ports:
    - "tu_puerto:3306"
```

Después de modificar el archivo:
```bash
docker-compose down
docker-compose up -d
```

## 🐛 Solución de Problemas

### Problema: "port is already allocated"
**Causa:** El puerto ya está en uso.

**Solución:**
```bash
# Ver qué está usando el puerto
# Linux/macOS:
lsof -i :3306

# Windows:
netstat -ano | findstr :3306

# Cambiar el puerto en docker-compose.yml o detener el servicio que usa el puerto
```

### Problema: Contenedores no inician
**Causa:** Docker no tiene suficientes recursos.

**Solución:**
- Abre Docker Desktop → Settings → Resources
- Aumenta CPU y Memoria
- Reinicia Docker

### Problema: No se puede conectar desde los microservicios
**Causa:** URL de conexión incorrecta o contenedores no saludables.

**Verificar:**
```bash
# Estado de health checks
docker-compose ps

# Si un contenedor no está "healthy", ver logs:
docker-compose logs mysql-containers
```

### Problema: Datos perdidos después de reiniciar
**Causa:** Los volúmenes fueron eliminados con `-v`.

**Prevención:**
- Usa `docker-compose stop` en lugar de `docker-compose down -v`
- Haz backups regulares

## 📝 Notas Importantes

1. **Primera ejecución:** La primera vez puede tardar unos minutos en descargar las imágenes Docker.

2. **Health Checks:** Los contenedores tienen health checks que verifican que MySQL esté listo antes de aceptar conexiones.

3. **Persistencia:** Los datos se almacenan en volúmenes Docker y persisten entre reinicios.

4. **Puertos:** Cada base de datos usa un puerto diferente para evitar conflictos:
   - 3306 (Containers)
   - 3307 (Logistics)
   - 3308 (Accounting)
   - 3309 (Users)

5. **Red:** Todos los contenedores están en la misma red Docker (`alicatados-network`) para comunicación interna.

## 🎯 Flujo de Trabajo Recomendado

1. **Iniciar bases de datos:**
   ```bash
   docker-compose up -d
   ```

2. **Esperar a que estén listas (30 segundos):**
   ```bash
   docker-compose logs -f
   # Presiona Ctrl+C cuando veas "ready for connections"
   ```

3. **Iniciar microservicios:**
   ```bash
   cd codigo
   ./script_ejecucion_sistema.sh  # Linux/macOS
   # o
   script_ejecucion_sistema.bat   # Windows
   ```

4. **Al terminar, detener todo:**
   ```bash
   # Detener microservicios (Ctrl+C en cada terminal)

   # Detener bases de datos
   docker-compose stop
   ```

## 📚 Recursos Adicionales

- [Documentación Docker Compose](https://docs.docker.com/compose/)
- [MySQL Docker Hub](https://hub.docker.com/_/mysql)
- [phpMyAdmin Docker Hub](https://hub.docker.com/_/phpmyadmin)

---

**Proyecto Alicatados Plasencia** - Sistema de Microservicios
