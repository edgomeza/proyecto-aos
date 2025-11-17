# Scripts de Ejecución - Alicatados Plasencia Microservices

Este directorio contiene scripts para compilar, ejecutar y probar el sistema de microservicios en **Linux/macOS** y **Windows**.

## 📋 Requisitos Previos

### Para todos los sistemas:
- Java 21 o superior
- Maven 3.6 o superior
- MySQL 8.0 o superior (ejecutándose)

### Para Linux/macOS:
- Bash shell
- `jq` (opcional, para formatear JSON): `sudo apt install jq` o `brew install jq`

### Para Windows:
- PowerShell 5.1 o superior (recomendado)
- CMD (alternativa)
- `curl` (incluido en Windows 10+)

## 🚀 Scripts Disponibles

### 1️⃣ Compilación y Empaquetado

Compila todos los microservicios y genera los archivos JAR.

**Linux/macOS:**
```bash
./script_compilacion_empaquetado.sh
```

**Windows CMD:**
```cmd
script_compilacion_empaquetado.bat
```

**Windows PowerShell:**
```powershell
.\script_compilacion_empaquetado.ps1
```

### 2️⃣ Ejecución del Sistema

Inicia todos los microservicios en el orden correcto:
1. Eureka Server (Puerto 8761) - 15 segundos de espera
2. Config Server (Puerto 8888) - 10 segundos de espera
3. Gateway Service (Puerto 8080) - 10 segundos de espera
4. Containers Service - 2 instancias (Puertos 8101, 8102)
5. Logistics Service - 2 instancias (Puertos 8111, 8112)
6. Accounting Service - 2 instancias (Puertos 8121, 8122)
7. Users Service - 2 instancias (Puertos 8131, 8132)

**Linux/macOS:**
```bash
./script_ejecucion_sistema.sh
```

**Windows CMD:**
```cmd
script_ejecucion_sistema.bat
```

**Windows PowerShell:**
```powershell
.\script_ejecucion_sistema.ps1
```

> **Nota para Windows:** Cada servicio se abrirá en su propia ventana de CMD. Para detener los servicios, cierra cada ventana o presiona `Ctrl+C` en cada una.

### 3️⃣ Pruebas del Sistema

Ejecuta pruebas con `curl` para verificar que todos los microservicios funcionan correctamente.

**Linux/macOS:**
```bash
./scripts_ejecucion_pruebas.sh
```

**Windows CMD:**
```cmd
scripts_ejecucion_pruebas.bat
```

**Windows PowerShell (Recomendado):**
```powershell
.\scripts_ejecucion_pruebas.ps1
```

> **Nota:** El script de PowerShell muestra los resultados en formato JSON legible.

## 🔗 URLs del Sistema

Una vez iniciado el sistema, puedes acceder a:

### Servicios de Infraestructura:
- **Eureka Dashboard**: http://localhost:8761
- **Gateway API**: http://localhost:8080/api

### Swagger UI (Documentación API):
- **Containers**: http://localhost:8101/swagger-ui.html
- **Logistics**: http://localhost:8111/swagger-ui.html
- **Accounting**: http://localhost:8121/swagger-ui.html
- **Users**: http://localhost:8131/swagger-ui.html

### OpenAPI Docs (JSON):
- **Containers**: http://localhost:8101/v3/api-docs
- **Logistics**: http://localhost:8111/v3/api-docs
- **Accounting**: http://localhost:8121/v3/api-docs
- **Users**: http://localhost:8131/v3/api-docs

## 📝 Orden de Inicio Recomendado

Es **muy importante** seguir este orden para evitar errores:

1. **Primero**: Eureka Server (esperar 15 segundos)
2. **Segundo**: Config Server (esperar 10 segundos)
3. **Tercero**: Gateway Service (esperar 10 segundos)
4. **Cuarto**: Microservicios base en cualquier orden (2 instancias de cada uno)

**Tiempo total de inicio**: ~2-3 minutos

## 🛠️ Solución de Problemas

### Linux/macOS

**Si los scripts no tienen permisos de ejecución:**
```bash
chmod +x *.sh
```

**Si encuentras errores de línea de comandos:**
- Asegúrate de que los scripts tengan formato Unix (LF, no CRLF)
- Convierte con: `dos2unix script_*.sh`

### Windows

**Si PowerShell muestra error de ejecución de scripts:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

**Si CMD no encuentra Maven:**
- Verifica que Maven esté en el PATH
- Usa la ruta completa: `C:\ruta\a\maven\bin\mvn.bat`

**Si los servicios no inician:**
- Verifica que MySQL esté ejecutándose
- Verifica que los puertos no estén ocupados: `netstat -ano | findstr :8761`
- Revisa los logs en las ventanas de CMD/PowerShell

## 🐛 Depuración

### Ver logs de un servicio específico:
Los logs se muestran en las ventanas de terminal/CMD de cada servicio.

### Verificar que Eureka detecta todos los servicios:
1. Abre http://localhost:8761
2. Verifica que aparezcan todos los microservicios registrados

### Probar conectividad con curl:
```bash
# Verificar Eureka
curl http://localhost:8761/eureka/apps

# Verificar Gateway
curl http://localhost:8080/actuator/health

# Verificar Containers Service
curl http://localhost:8101/actuator/health
```

## 📚 Estructura de Archivos

```
codigo/
├── README.md                           # Este archivo
├── script_compilacion_empaquetado.sh   # Linux/macOS - Compilación
├── script_compilacion_empaquetado.bat  # Windows CMD - Compilación
├── script_compilacion_empaquetado.ps1  # Windows PowerShell - Compilación
├── script_ejecucion_sistema.sh         # Linux/macOS - Ejecución
├── script_ejecucion_sistema.bat        # Windows CMD - Ejecución
├── script_ejecucion_sistema.ps1        # Windows PowerShell - Ejecución
├── scripts_ejecucion_pruebas.sh        # Linux/macOS - Pruebas
├── scripts_ejecucion_pruebas.bat       # Windows CMD - Pruebas
└── scripts_ejecucion_pruebas.ps1       # Windows PowerShell - Pruebas
```

## 💡 Consejos

1. **Primera ejecución**: Ejecuta primero el script de compilación
2. **Desarrollo**: Puedes ejecutar servicios individuales en lugar de todos
3. **Producción**: Considera usar Docker Compose para un despliegue más robusto
4. **Monitoreo**: Usa Eureka Dashboard para ver el estado de todos los servicios
5. **API Testing**: Usa Swagger UI para probar los endpoints fácilmente

## 🔄 Actualización de Código

Después de hacer cambios en el código:

1. Detén todos los servicios
2. Ejecuta el script de compilación
3. Vuelve a ejecutar el script de ejecución

## 📞 Soporte

Para problemas o preguntas sobre el sistema de microservicios:
- Revisa la documentación en los archivos `.md` del proyecto
- Consulta los logs de cada servicio
- Verifica la configuración en `config-server/src/main/resources/configurations/`
