# Guía de Implementación Completa - Alicatados Plasencia Microservices

 

## IMPORTANTE: Sigue estos pasos en orden

 

Esta guía te llevará paso a paso para implementar el sistema completo de microservicios de Alicatados Plasencia.

 

---

 

## 📋 Resumen del Sistema

 

**Empresa**: Alicatados Plasencia (Plasencia, Cáceres)

**Actividad**: Venta de materiales de construcción, muebles de baño, ferretería + Alquiler de contenedores

 

**Microservicios (4 Base + 3 Infraestructura)**:

1. **containers-service** ⭐ - Alquiler de contenedores (ÚNICO)

2. **logistics-service** - Planificación de rutas y entregas

3. **accounting-service** ⭐ - Gestión contable y nóminas (ÚNICO)

4. **users-service** - Autenticación y gestión de usuarios (7 roles)

5. **gateway-service** - API Gateway (Puerto 8080)

6. **eureka-server** - Service Discovery (Puerto 8761)

7. **config-server** - Configuración centralizada (Puerto 8888)

 

---

 

## Fase 1: Servicios de Infraestructura

 

### 1.1 Crear Eureka Server

 

**Paso 1**: Ir a https://start.spring.io/

 

**Configuración**:

- Project: Maven

- Language: Java

- Spring Boot: 3.2.0

- Group: com.alicatadosplasencia

- Artifact: eureka-server

- Name: eureka-server

- Packaging: Jar

- Java: 17

 

**Dependencias**:

- Eureka Server

 

**Paso 2**: Descargar, descomprimir e importar en tu IDE

 

**Paso 3**: Clase principal con `@EnableEurekaServer`

 

```java

package com.alicatadosplasencia.eureka;

 

import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

 

@SpringBootApplication

@EnableEurekaServer

public class EurekaServerApplication {

    public static void main(String[] args) {

        SpringApplication.run(EurekaServerApplication.class, args);

        System.out.println("========================================");

        System.out.println("EUREKA SERVER INICIADO");

        System.out.println("Dashboard: http://localhost:8761");

        System.out.println("========================================");

    }

}

```

 

**Paso 4**: Crear `src/main/resources/application.yml`:

 

```yaml

server:

  port: 8761

 

spring:

  application:

    name: eureka-server

 

eureka:

  instance:

    hostname: localhost

  client:

    registerWithEureka: false

    fetchRegistry: false

    serviceUrl:

      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/

  server:

    enable-self-preservation: false

 

logging:

  level:

    com.netflix.eureka: INFO

    com.netflix.discovery: INFO

```

 

**Paso 5**: Ejecutar con `mvn spring-boot:run`

 

**Verificar**: Abrir http://localhost:8761

 

---

 

### 1.2 Crear Config Server

 

**Paso 1**: Spring Initializr (https://start.spring.io/)

 

**Configuración**:

- Group: com.alicatadosplasencia

- Artifact: config-server

- Dependencias: Config Server, Actuator

 

**Paso 2**: Clase principal con `@EnableConfigServer`

 

```java

package com.alicatadosplasencia.config;

 

import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.cloud.config.server.EnableConfigServer;

 

@SpringBootApplication

@EnableConfigServer

public class ConfigServerApplication {

    public static void main(String[] args) {

        SpringApplication.run(ConfigServerApplication.class, args);

        System.out.println("========================================");

        System.out.println("CONFIG SERVER INICIADO");

        System.out.println("Puerto: 8888");

        System.out.println("========================================");

    }

}

```

 

**Paso 3**: Crear `src/main/resources/application.yml`:

 

```yaml

server:

  port: 8888

 

spring:

  application:

    name: config-server

  cloud:

    config:

      server:

        native:

          search-locations: classpath:/configurations

  profiles:

    active: native

 

logging:

  level:

    org.springframework.cloud.config: DEBUG

```

 

**Paso 4**: Crear archivos de configuración

 

Crear directorio: `src/main/resources/configurations/`

 

**Archivo: `configurations/application.yml`** (configuración compartida):

 

```yaml

# Configuración compartida por todos los microservicios

eureka:

  client:

    serviceUrl:

      defaultZone: http://localhost:8761/eureka/

    fetch-registry: true

    register-with-eureka: true

  instance:

    prefer-ip-address: true

 

spring:

  datasource:

    driver-class-name: com.mysql.cj.jdbc.Driver

  jpa:

    hibernate:

      ddl-auto: update

    show-sql: true

    properties:

      hibernate:

        dialect: org.hibernate.dialect.MySQL8Dialect

        format_sql: true

 

management:

  endpoints:

    web:

      exposure:

        include: health,info,metrics

```

 

**Archivo: `configurations/containers-service.yml`**:

 

```yaml

server:

  port: 8101

 

spring:

  application:

    name: containers-service

  datasource:

    url: jdbc:mysql://localhost:3306/containers_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC

    username: root

    password: root

 

springdoc:

  api-docs:

    path: /v3/api-docs

  swagger-ui:

    path: /swagger-ui.html

 

logging:

  level:

    com.alicatadosplasencia: DEBUG

```

 

**Archivo: `configurations/logistics-service.yml`**:

 

```yaml

server:

  port: 8111

 

spring:

  application:

    name: logistics-service

  datasource:

    url: jdbc:mysql://localhost:3306/logistics_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC

    username: root

    password: root

 

springdoc:

  api-docs:

    path: /v3/api-docs

  swagger-ui:

    path: /swagger-ui.html

 

logging:

  level:

    com.alicatadosplasencia: DEBUG

```

 

**Archivo: `configurations/accounting-service.yml`**:

 

```yaml

server:

  port: 8121

 

spring:

  application:

    name: accounting-service

  datasource:

    url: jdbc:mysql://localhost:3306/accounting_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC

    username: root

    password: root

 

springdoc:

  api-docs:

    path: /v3/api-docs

  swagger-ui:

    path: /swagger-ui.html

 

logging:

  level:

    com.alicatadosplasencia: DEBUG

```

 

**Archivo: `configurations/users-service.yml`**:

 

```yaml

server:

  port: 8131

 

spring:

  application:

    name: users-service

  datasource:

    url: jdbc:mysql://localhost:3306/users_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC

    username: root

    password: root

 

springdoc:

  api-docs:

    path: /v3/api-docs

  swagger-ui:

    path: /swagger-ui.html

 

# Configuración JWT

jwt:

  secret: AlicatadosPlasenciaSecretKey2025MicroservicesSystemVerySecure

  expiration: 86400000

 

logging:

  level:

    com.alicatadosplasencia: DEBUG

```

 

**Archivo: `configurations/gateway-service.yml`**:

 

```yaml

server:

  port: 8080

 

spring:

  application:

    name: gateway-service

  cloud:

    gateway:

      discovery:

        locator:

          enabled: true

          lower-case-service-id: true

      routes:

        - id: containers-service

          uri: lb://containers-service

          predicates:

            - Path=/api/containers/**

          filters:

            - StripPrefix=1

 

        - id: logistics-service

          uri: lb://logistics-service

          predicates:

            - Path=/api/logistics/**

          filters:

            - StripPrefix=1

 

        - id: accounting-service

          uri: lb://accounting-service

          predicates:

            - Path=/api/accounting/**

          filters:

            - StripPrefix=1

 

        - id: users-service

          uri: lb://users-service

          predicates:

            - Path=/api/users/**

          filters:

            - StripPrefix=1

 

logging:

  level:

    org.springframework.cloud.gateway: DEBUG

```

 

---

 

## Fase 2: Microservicio Containers ⭐ (ÚNICO)

 

### 2.1 Crear Proyecto

 

**Spring Initializr**:

- Group: com.alicatadosplasencia

- Artifact: containers-service

- Dependencias:

  - Spring Web

  - Spring Data JPA

  - MySQL Driver

  - Eureka Discovery Client

  - Config Client

  - Spring Boot Actuator

  - Lombok

  - Validation

  - Load Balancer

 

**Agregar dependencia OpenAPI** al `pom.xml`:

 

```xml

<dependency>

    <groupId>org.springdoc</groupId>

    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>

    <version>2.6.0</version>

</dependency>

```

 

### 2.2 Configuración Bootstrap

 

**Crear `src/main/resources/bootstrap.yml`**:

 

```yaml

spring:

  application:

    name: containers-service

  config:

    import: optional:configserver:http://localhost:8888

  cloud:

    config:

      enabled: true

      fail-fast: false

```

 

### 2.3 Clase Principal

 

```java

package com.alicatadosplasencia.containers;

 

import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

 

/**

 * Containers Service Application

 * Alicatados Plasencia - Sistema de Microservicios

 *

 * Puerto: 8101 (Instancia 1), 8102 (Instancia 2)

 * Base de Datos: containers_db

 *

 * Función: Gestión completa del sistema de alquiler de contenedores para obras

 *

 * Responsabilidades:

 * - Gestión de inventario de contenedores

 * - Alquiler de contenedores con tarifas dinámicas

 * - Devoluciones e inspecciones

 * - Historial de alquileres

 * - Cálculo automático de precios

 */

@SpringBootApplication

@EnableDiscoveryClient

public class ContainersServiceApplication {

    public static void main(String[] args) {

        SpringApplication.run(ContainersServiceApplication.class, args);

        System.out.println("========================================");

        System.out.println("⭐ CONTAINERS SERVICE INICIADO ⭐");

        System.out.println("Sistema de Alquiler de Contenedores");

        System.out.println("========================================");

    }

}

```

 

### 2.4 Entidades del Sistema de Alquiler

 

**Entidad: ContainerType**

 

```java

package com.alicatadosplasencia.containers.model;

 

import jakarta.persistence.*;

import lombok.AllArgsConstructor;

import lombok.Data;

import lombok.NoArgsConstructor;

import java.math.BigDecimal;

 

@Entity

@Table(name = "container_types")

@Data

@NoArgsConstructor

@AllArgsConstructor

public class ContainerType {

 

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;

 

    @Column(nullable = false, length = 100)

    private String name; // Ej: "Contenedor 5m³", "Contenedor 10m³"

 

    @Column(name = "capacity_m3", nullable = false, precision = 8, scale = 2)

    private BigDecimal capacityM3;

 

    @Column(length = 100)

    private String dimensions; // Ej: "2m x 1.5m x 1.5m"

 

    @Column(columnDefinition = "TEXT")

    private String description;

 

    @Column(nullable = false)

    private Boolean active = true;

}

```

 

**Entidad: Container** (Inventario físico)

 

```java

package com.alicatadosplasencia.containers.model;

 

import jakarta.persistence.*;

import lombok.AllArgsConstructor;

import lombok.Data;

import lombok.NoArgsConstructor;

import java.time.LocalDate;

import java.time.LocalDateTime;

 

@Entity

@Table(name = "containers")

@Data

@NoArgsConstructor

@AllArgsConstructor

public class Container {

 

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;

 

    @Column(name = "container_code", unique = true, nullable = false, length = 50)

    private String containerCode; // CONT-001, CONT-002, etc.

 

    @ManyToOne(fetch = FetchType.LAZY)

    @JoinColumn(name = "container_type_id", nullable = false)

    private ContainerType containerType;

 

    @Enumerated(EnumType.STRING)

    @Column(nullable = false, length = 20)

    private ContainerStatus status = ContainerStatus.AVAILABLE;

 

    @Column(name = "current_warehouse_id")

    private Long currentWarehouseId;

 

    @Column(name = "last_maintenance_date")

    private LocalDate lastMaintenanceDate;

 

    @Column(name = "acquisition_date")

    private LocalDate acquisitionDate;

 

    @Column(columnDefinition = "TEXT")

    private String notes;

 

    @Column(name = "created_at")

    private LocalDateTime createdAt = LocalDateTime.now();

 

    public enum ContainerStatus {

        AVAILABLE,      // Disponible para alquilar

        RENTED,         // Alquilado actualmente

        IN_MAINTENANCE, // En mantenimiento

        DAMAGED         // Dañado

    }

}

```

 

**Entidad: RentalRate** (Tarifas dinámicas)

 

```java

package com.alicatadosplasencia.containers.model;

 

import jakarta.persistence.*;

import lombok.AllArgsConstructor;

import lombok.Data;

import lombok.NoArgsConstructor;

import java.math.BigDecimal;

import java.time.LocalDate;

 

@Entity

@Table(name = "rental_rates")

@Data

@NoArgsConstructor

@AllArgsConstructor

public class RentalRate {

 

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;

 

    @ManyToOne(fetch = FetchType.LAZY)

    @JoinColumn(name = "container_type_id", nullable = false)

    private ContainerType containerType;

 

    @Enumerated(EnumType.STRING)

    @Column(name = "period_type", nullable = false, length = 20)

    private PeriodType periodType;

 

    @Column(name = "base_price", nullable = false, precision = 10, scale = 2)

    private BigDecimal basePrice; // Precio por día/semana/mes

 

    @Column(name = "delivery_fee", precision = 10, scale = 2)

    private BigDecimal deliveryFee; // Tarifa de entrega

 

    @Column(name = "pickup_fee", precision = 10, scale = 2)

    private BigDecimal pickupFee; // Tarifa de recogida

 

    @Column(name = "deposit_amount", precision = 10, scale = 2)

    private BigDecimal depositAmount; // Fianza

 

    @Column(nullable = false)

    private Boolean active = true;

 

    @Column(name = "valid_from")

    private LocalDate validFrom;

 

    @Column(name = "valid_until")

    private LocalDate validUntil;

 

    public enum PeriodType {

        DAILY,   // Tarifa diaria

        WEEKLY,  // Tarifa semanal

        MONTHLY  // Tarifa mensual

    }

}

```

 

**Entidad: Rental** (Alquileres)

 

```java

package com.alicatadosplasencia.containers.model;

 

import jakarta.persistence.*;

import lombok.AllArgsConstructor;

import lombok.Data;

import lombok.NoArgsConstructor;

import java.math.BigDecimal;

import java.time.LocalDate;

import java.time.LocalDateTime;

 

@Entity

@Table(name = "rentals")

@Data

@NoArgsConstructor

@AllArgsConstructor

public class Rental {

 

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;

 

    @Column(name = "rental_number", unique = true, nullable = false, length = 50)

    private String rentalNumber; // RENT-2025-00001

 

    @ManyToOne(fetch = FetchType.LAZY)

    @JoinColumn(name = "container_id", nullable = false)

    private Container container;

 

    @Column(name = "customer_id", nullable = false)

    private Long customerId; // Relación con users-service

 

    // Fechas del alquiler

    @Column(name = "start_date", nullable = false)

    private LocalDate startDate;

 

    @Column(name = "expected_end_date", nullable = false)

    private LocalDate expectedEndDate;

 

    @Column(name = "actual_end_date")

    private LocalDate actualEndDate; // Fecha real de devolución

 

    // Ubicación de entrega

    @Column(name = "delivery_address", columnDefinition = "TEXT", nullable = false)

    private String deliveryAddress;

 

    @Column(name = "delivery_city", length = 100)

    private String deliveryCity;

 

    @Column(name = "delivery_postal_code", length = 10)

    private String deliveryPostalCode;

 

    @Column(name = "delivery_latitude", precision = 10, scale = 8)

    private BigDecimal deliveryLatitude;

 

    @Column(name = "delivery_longitude", precision = 11, scale = 8)

    private BigDecimal deliveryLongitude;

 

    // Estado del alquiler

    @Enumerated(EnumType.STRING)

    @Column(nullable = false, length = 20)

    private RentalStatus status = RentalStatus.PENDING;

 

    // Financiero

    @Column(name = "daily_rate", precision = 10, scale = 2)

    private BigDecimal dailyRate;

 

    @Column(name = "total_days")

    private Integer totalDays;

 

    @Column(name = "base_amount", precision = 10, scale = 2)

    private BigDecimal baseAmount;

 

    @Column(name = "delivery_fee", precision = 10, scale = 2)

    private BigDecimal deliveryFee;

 

    @Column(name = "pickup_fee", precision = 10, scale = 2)

    private BigDecimal pickupFee;

 

    @Column(name = "deposit_amount", precision = 10, scale = 2)

    private BigDecimal depositAmount;

 

    @Column(name = "total_amount", precision = 10, scale = 2)

    private BigDecimal totalAmount;

 

    @Column(name = "extra_days_amount", precision = 10, scale = 2)

    private BigDecimal extraDaysAmount; // Cargo por días extra

 

    // Seguimiento

    @Column(name = "delivered_at")

    private LocalDateTime deliveredAt;

 

    @Column(name = "picked_up_at")

    private LocalDateTime pickedUpAt;

 

    @Column(columnDefinition = "TEXT")

    private String notes;

 

    @Column(name = "special_instructions", columnDefinition = "TEXT")

    private String specialInstructions;

 

    @Column(name = "created_by")

    private Long createdBy;

 

    @Column(name = "created_at")

    private LocalDateTime createdAt = LocalDateTime.now();

 

    @Column(name = "updated_at")

    private LocalDateTime updatedAt = LocalDateTime.now();

 

    public enum RentalStatus {

        PENDING,   // Pendiente de entrega

        ACTIVE,    // Alquiler activo

        COMPLETED, // Completado y devuelto

        CANCELLED, // Cancelado

        OVERDUE    // Vencido (no devuelto a tiempo)

    }

}

```

 

**Entidad: ContainerInspection** (Inspecciones al devolver)

 

```java

package com.alicatadosplasencia.containers.model;

 

import jakarta.persistence.*;

import lombok.AllArgsConstructor;

import lombok.Data;

import lombok.NoArgsConstructor;

import java.math.BigDecimal;

import java.time.LocalDateTime;

 

@Entity

@Table(name = "container_inspections")

@Data

@NoArgsConstructor

@AllArgsConstructor

public class ContainerInspection {

 

    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;

 

    @ManyToOne(fetch = FetchType.LAZY)

    @JoinColumn(name = "rental_id", nullable = false)

    private Rental rental;

 

    @Column(name = "inspection_date")

    private LocalDateTime inspectionDate = LocalDateTime.now();

 

    @Column(name = "inspector_id")

    private Long inspectorId; // Empleado que inspecciona

 

    @Enumerated(EnumType.STRING)

    @Column(name = "condition_status", nullable = false, length = 20)

    private ConditionStatus conditionStatus;

 

    @Column(name = "damage_description", columnDefinition = "TEXT")

    private String damageDescription;

 

    @Column(name = "repair_cost", precision = 10, scale = 2)

    private BigDecimal repairCost;

 

    @Column(name = "photos_url", columnDefinition = "TEXT")

    private String photosUrl; // URLs de fotos de daños

 

    @Column(name = "deposit_returned")

    private Boolean depositReturned = false;

 

    @Column(name = "deposit_deduction", precision = 10, scale = 2)

    private BigDecimal depositDeduction;

 

    public enum ConditionStatus {

        GOOD,          // Buen estado

        MINOR_DAMAGE,  // Daños menores

        MAJOR_DAMAGE   // Daños mayores

    }

}

```

 

### 2.5 Repositories

 

```java

package com.alicatadosplasencia.containers.repository;

 

import com.alicatadosplasencia.containers.model.ContainerType;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

 

public interface ContainerTypeRepository extends JpaRepository<ContainerType, Long> {

    List<ContainerType> findByActiveTrue();

}

```

 

```java

package com.alicatadosplasencia.containers.repository;

 

import com.alicatadosplasencia.containers.model.Container;

import com.alicatadosplasencia.containers.model.Container.ContainerStatus;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

import java.util.Optional;

 

public interface ContainerRepository extends JpaRepository<Container, Long> {

    Optional<Container> findByContainerCode(String containerCode);

    List<Container> findByStatus(ContainerStatus status);

    List<Container> findByContainerTypeId(Long containerTypeId);

}

```

 

```java

package com.alicatadosplasencia.containers.repository;

 

import com.alicatadosplasencia.containers.model.Rental;

import com.alicatadosplasencia.containers.model.Rental.RentalStatus;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

import java.util.Optional;

 

public interface RentalRepository extends JpaRepository<Rental, Long> {

    Optional<Rental> findByRentalNumber(String rentalNumber);

    List<Rental> findByCustomerId(Long customerId);

    List<Rental> findByStatus(RentalStatus status);

}

```

 

```java

package com.alicatadosplasencia.containers.repository;

 

import com.alicatadosplasencia.containers.model.RentalRate;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

 

public interface RentalRateRepository extends JpaRepository<RentalRate, Long> {

    List<RentalRate> findByContainerTypeIdAndActiveTrue(Long containerTypeId);

}

```

 

### 2.6 Services (Ejemplo: RentalService)

 

```java

package com.alicatadosplasencia.containers.service;

 

import com.alicatadosplasencia.containers.model.*;

import com.alicatadosplasencia.containers.repository.*;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

import java.time.LocalDate;

import java.time.LocalDateTime;

import java.time.temporal.ChronoUnit;

import java.util.List;

 

@Service

public class RentalService {

 

    @Autowired

    private RentalRepository rentalRepository;

 

    @Autowired

    private ContainerRepository containerRepository;

 

    @Autowired

    private RentalRateRepository rentalRateRepository;

 

    public List<Rental> findAll() {

        return rentalRepository.findAll();

    }

 

    public Rental findById(Long id) {

        return rentalRepository.findById(id)

            .orElseThrow(() -> new RuntimeException("Rental not found"));

    }

 

    public List<Rental> findByCustomerId(Long customerId) {

        return rentalRepository.findByCustomerId(customerId);

    }

 

    @Transactional

    public Rental createRental(Rental rental) {

        // 1. Verificar disponibilidad del contenedor

        Container container = containerRepository.findById(rental.getContainer().getId())

            .orElseThrow(() -> new RuntimeException("Container not found"));

 

        if (container.getStatus() != Container.ContainerStatus.AVAILABLE) {

            throw new RuntimeException("Container not available");

        }

 

        // 2. Calcular días y precio

        long days = ChronoUnit.DAYS.between(rental.getStartDate(), rental.getExpectedEndDate());

        rental.setTotalDays((int) days);

 

        // 3. Obtener tarifa

        List<RentalRate> rates = rentalRateRepository

            .findByContainerTypeIdAndActiveTrue(container.getContainerType().getId());

 

        if (rates.isEmpty()) {

            throw new RuntimeException("No active rates found for this container type");

        }

 

        RentalRate rate = rates.get(0); // Tomar la primera tarifa activa

        rental.setDailyRate(rate.getBasePrice());

        rental.setDeliveryFee(rate.getDeliveryFee());

        rental.setPickupFee(rate.getPickupFee());

        rental.setDepositAmount(rate.getDepositAmount());

 

        // 4. Calcular importe total

        BigDecimal baseAmount = rate.getBasePrice().multiply(BigDecimal.valueOf(days));

        rental.setBaseAmount(baseAmount);

 

        BigDecimal total = baseAmount

            .add(rate.getDeliveryFee() != null ? rate.getDeliveryFee() : BigDecimal.ZERO)

            .add(rate.getPickupFee() != null ? rate.getPickupFee() : BigDecimal.ZERO);

        rental.setTotalAmount(total);

 

        // 5. Generar número de alquiler

        String rentalNumber = "RENT-" + LocalDate.now().getYear() + "-" +

            String.format("%05d", rentalRepository.count() + 1);

        rental.setRentalNumber(rentalNumber);

 

        // 6. Cambiar estado del contenedor

        container.setStatus(Container.ContainerStatus.RENTED);

        containerRepository.save(container);

 

        // 7. Guardar alquiler

        return rentalRepository.save(rental);

    }

 

    @Transactional

    public Rental completeRental(Long rentalId, LocalDate actualEndDate) {

        Rental rental = findById(rentalId);

 

        rental.setActualEndDate(actualEndDate);

        rental.setPickedUpAt(LocalDateTime.now());

        rental.setStatus(Rental.RentalStatus.COMPLETED);

 

        // Calcular días extra si aplica

        if (actualEndDate.isAfter(rental.getExpectedEndDate())) {

            long extraDays = ChronoUnit.DAYS.between(rental.getExpectedEndDate(), actualEndDate);

            BigDecimal extraAmount = rental.getDailyRate()

                .multiply(BigDecimal.valueOf(extraDays))

                .multiply(BigDecimal.valueOf(1.5)); // 50% más caro por día extra

            rental.setExtraDaysAmount(extraAmount);

        }

 

        // Liberar contenedor

        Container container = rental.getContainer();

        container.setStatus(Container.ContainerStatus.AVAILABLE);

        containerRepository.save(container);

 

        return rentalRepository.save(rental);

    }

 

    @Transactional

    public void cancelRental(Long rentalId, String reason) {

        Rental rental = findById(rentalId);

 

        if (rental.getStatus() != Rental.RentalStatus.PENDING) {

            throw new RuntimeException("Only pending rentals can be cancelled");

        }

 

        rental.setStatus(Rental.RentalStatus.CANCELLED);

        rental.setNotes(reason);

 

        // Liberar contenedor

        Container container = rental.getContainer();

        container.setStatus(Container.ContainerStatus.AVAILABLE);

        containerRepository.save(container);

 

        rentalRepository.save(rental);

    }

}

```

 

### 2.7 Controllers

 

```java

package com.alicatadosplasencia.containers.controller;

 

import com.alicatadosplasencia.containers.model.Rental;

import com.alicatadosplasencia.containers.service.RentalService;

import io.swagger.v3.oas.annotations.Operation;

import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

import java.util.List;

 

@RestController

@RequestMapping("/rentals")

@Tag(name = "Rentals", description = "API de Alquiler de Contenedores")

public class RentalController {

 

    @Autowired

    private RentalService rentalService;

 

    @GetMapping

    @Operation(summary = "Listar todos los alquileres")

    public List<Rental> getAll() {

        return rentalService.findAll();

    }

 

    @GetMapping("/{id}")

    @Operation(summary = "Obtener alquiler por ID")

    public ResponseEntity<Rental> getById(@PathVariable Long id) {

        return ResponseEntity.ok(rentalService.findById(id));

    }

 

    @GetMapping("/customer/{customerId}")

    @Operation(summary = "Obtener alquileres de un cliente")

    public List<Rental> getByCustomerId(@PathVariable Long customerId) {

        return rentalService.findByCustomerId(customerId);

    }

 

    @PostMapping

    @Operation(summary = "Crear nuevo alquiler de contenedor")

    public ResponseEntity<Rental> create(@RequestBody Rental rental) {

        Rental created = rentalService.createRental(rental);

        return ResponseEntity.status(201).body(created);

    }

 

    @PutMapping("/{id}/complete")

    @Operation(summary = "Completar alquiler (devolución)")

    public ResponseEntity<Rental> complete(

            @PathVariable Long id,

            @RequestParam LocalDate actualEndDate) {

        Rental completed = rentalService.completeRental(id, actualEndDate);

        return ResponseEntity.ok(completed);

    }

 

    @PutMapping("/{id}/cancel")

    @Operation(summary = "Cancelar alquiler")

    public ResponseEntity<Void> cancel(

            @PathVariable Long id,

            @RequestParam String reason) {

        rentalService.cancelRental(id, reason);

        return ResponseEntity.noContent().build();

    }

}

```

 

**IMPORTANTE**: Crear controllers similares para:

- ContainerTypeController

- ContainerController

- RentalRateController

- ContainerInspectionController

 

---

 

## Fase 3: Microservicio Logistics

 

Seguir misma estructura que containers-service.

 

### Entidades a crear:

- Truck

- Driver

- Route

- RouteStop

- DeliveryAgenda

 

### Lógica clave - Optimización de rutas:

 

```java

package com.alicatadosplasencia.logistics.service;

 

import com.alicatadosplasencia.logistics.model.*;

import org.springframework.stereotype.Service;

import java.util.*;

 

@Service

public class RouteOptimizationService {

 

    /**

     * Optimiza ruta usando algoritmo Nearest Neighbor (Vecino más cercano)

     */

    public Route optimizeRoute(List<Long> deliveryIds, Long truckId, Long driverId) {

        // Obtener entregas pendientes

        List<Delivery> deliveries = getDeliveries(deliveryIds);

        List<RouteStop> optimizedStops = new ArrayList<>();

 

        // Punto inicial: Almacén Central

        Point currentPoint = WAREHOUSE_LOCATION;

        Set<Delivery> unvisited = new HashSet<>(deliveries);

        int sequence = 1;

 

        while (!unvisited.isEmpty()) {

            Delivery nearest = findNearest(currentPoint, unvisited);

 

            RouteStop stop = new RouteStop();

            stop.setStopSequence(sequence++);

            stop.setAddress(nearest.getAddress());

            stop.setLatitude(nearest.getLatitude());

            stop.setLongitude(nearest.getLongitude());

            optimizedStops.add(stop);

 

            currentPoint = new Point(nearest.getLatitude(), nearest.getLongitude());

            unvisited.remove(nearest);

        }

 

        Route route = new Route();

        route.setTruckId(truckId);

        route.setDriverId(driverId);

        route.setStops(optimizedStops);

        route.setTotalDistanceKm(calculateTotalDistance(optimizedStops));

 

        return routeRepository.save(route);

    }

 

    private Delivery findNearest(Point from, Set<Delivery> deliveries) {

        return deliveries.stream()

            .min((d1, d2) -> Double.compare(

                distance(from, new Point(d1.getLatitude(), d1.getLongitude())),

                distance(from, new Point(d2.getLatitude(), d2.getLongitude()))

            ))

            .orElse(null);

    }

 

    /**

     * Fórmula de Haversine para calcular distancia entre coordenadas

     */

    private double distance(Point p1, Point p2) {

        double lat1 = Math.toRadians(p1.lat);

        double lon1 = Math.toRadians(p1.lon);

        double lat2 = Math.toRadians(p2.lat);

        double lon2 = Math.toRadians(p2.lon);

 

        double dlon = lon2 - lon1;

        double dlat = lat2 - lat1;

 

        double a = Math.pow(Math.sin(dlat / 2), 2) +

                   Math.cos(lat1) * Math.cos(lat2) * Math.pow(Math.sin(dlon / 2), 2);

        double c = 2 * Math.asin(Math.sqrt(a));

 

        return 6371 * c; // Radio de la Tierra en km

    }

}

```

 

---

 

## Fase 4: Microservicio Accounting ⭐ (ÚNICO)

 

### Entidades principales:

- Invoice (Facturas)

- Payment (Pagos)

- Payroll (Nóminas de los 17 empleados)

- FinancialStatistic (Estadísticas financieras)

- Expense (Gastos)

 

### Ejemplo: Generación automática de nóminas

 

```java

package com.alicatadosplasencia.accounting.service;

 

import com.alicatadosplasencia.accounting.model.Payroll;

import org.springframework.stereotype.Service;

import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;

import java.util.List;

 

@Service

public class PayrollService {

 

    @Autowired

    private PayrollRepository payrollRepository;

 

    @Autowired

    private DiscoveryClient discoveryClient;

 

    /**

     * Genera nóminas para todos los empleados activos (17 empleados)

     */

    @Transactional

    public List<Payroll> generateMonthlyPayrolls(int month, int year) {

        // 1. Obtener lista de 17 empleados de users-service

        List<Employee> employees = getUsersFromUsersService();

 

        List<Payroll> payrolls = new ArrayList<>();

 

        for (Employee employee : employees) {

            Payroll payroll = new Payroll();

            payroll.setEmployeeId(employee.getId());

            payroll.setPeriodMonth(month);

            payroll.setPeriodYear(year);

 

            // 2. Calcular salarios

            BigDecimal baseSalary = employee.getSalary();

            BigDecimal bonuses = calculateBonuses(employee);

            BigDecimal overtime = calculateOvertime(employee);

            BigDecimal grossSalary = baseSalary.add(bonuses).add(overtime);

 

            // 3. Calcular deducciones

            BigDecimal socialSecurity = grossSalary.multiply(BigDecimal.valueOf(0.0635)); // 6.35%

            BigDecimal irpf = calculateIRPF(grossSalary); // Según tramos

            BigDecimal totalDeductions = socialSecurity.add(irpf);

 

            // 4. Calcular neto

            BigDecimal netSalary = grossSalary.subtract(totalDeductions);

 

            payroll.setBaseSalary(baseSalary);

            payroll.setBonuses(bonuses);

            payroll.setOvertime(overtime);

            payroll.setGrossSalary(grossSalary);

            payroll.setSocialSecurity(socialSecurity);

            payroll.setIrpf(irpf);

            payroll.setTotalDeductions(totalDeductions);

            payroll.setNetSalary(netSalary);

            payroll.setStatus(Payroll.PayrollStatus.PENDING);

 

            // 5. Generar número de nómina

            String payrollNumber = "NOM-" + year + "-" +

                String.format("%02d", month) + "-" +

                String.format("%05d", employee.getId());

            payroll.setPayrollNumber(payrollNumber);

 

            payrolls.add(payrollRepository.save(payroll));

        }

 

        // 6. Actualizar estadísticas financieras

        updateFinancialStatistics(month, year, payrolls);

 

        return payrolls;

    }

 

    private List<Employee> getUsersFromUsersService() {

        // Comunicación con users-service

        List<ServiceInstance> instances =

            discoveryClient.getInstances("users-service");

 

        if (instances != null && !instances.isEmpty()) {

            ServiceInstance instance = instances.get(0);

            String url = instance.getUri() + "/api/employees/active";

            RestTemplate restTemplate = new RestTemplate();

 

            return Arrays.asList(restTemplate.getForObject(url, Employee[].class));

        }

        return Collections.emptyList();

    }

}

```

 

---

 

## Fase 5: Microservicio Users

 

### Entidades:

- User (7 roles diferentes)

- Employee (17 empleados)

- Customer

- WarehouseAssignment

- AuditLog

 

### Los 7 Roles del Sistema:

 

```java

public enum UserRole {

    GERENTE,            // Acceso total

    ADMIN,              // Administrativos (3)

    STORE_WORKER,       // Trabajador tienda

    WAREHOUSE_WORKER,   // Mozo almacén

    ACCOUNTANT,         // Contable

    CONTAINER_WORKER,   // Trabajador contenedores

    DRIVER              // Camionero

}

```

 

### Seguridad JWT:

 

```java

package com.alicatadosplasencia.users.service;

 

import io.jsonwebtoken.Jwts;

import io.jsonwebtoken.SignatureAlgorithm;

import org.springframework.beans.factory.annotation.Value;

import org.springframework.stereotype.Service;

import java.util.Date;

 

@Service

public class JwtService {

 

    @Value("${jwt.secret}")

    private String secret;

 

    @Value("${jwt.expiration}")

    private long expiration;

 

    public String generateToken(User user) {

        return Jwts.builder()

            .setSubject(user.getUsername())

            .claim("userId", user.getId())

            .claim("role", user.getRole().name())

            .claim("email", user.getEmail())

            .setIssuedAt(new Date())

            .setExpiration(new Date(System.currentTimeMillis() + expiration))

            .signWith(SignatureAlgorithm.HS512, secret)

            .compact();

    }

 

    public boolean validateToken(String token) {

        try {

            Jwts.parser().setSigningKey(secret).parseClaimsJws(token);

            return true;

        } catch (Exception e) {

            return false;

        }

    }

 

    public String getUsernameFromToken(String token) {

        return Jwts.parser()

            .setSigningKey(secret)

            .parseClaimsJws(token)

            .getBody()

            .getSubject();

    }

 

    public String getRoleFromToken(String token) {

        return (String) Jwts.parser()

            .setSigningKey(secret)

            .parseClaimsJws(token)

            .getBody()

            .get("role");

    }

}

```

 

---

 

## Fase 6: Gateway Service

 

**Spring Initializr**:

- Artifact: gateway-service

- Dependencias:

  - Gateway

  - Eureka Discovery Client

  - Config Client

  - Load Balancer

 

**Clase Principal**:

 

```java

package com.alicatadosplasencia.gateway;

 

import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

 

@SpringBootApplication

@EnableDiscoveryClient

public class GatewayServiceApplication {

    public static void main(String[] args) {

        SpringApplication.run(GatewayServiceApplication.class, args);

        System.out.println("========================================");

        System.out.println("GATEWAY SERVICE INICIADO");

        System.out.println("Puerto: 8080");

        System.out.println("API Base: http://localhost:8080/api");

        System.out.println("========================================");

    }

}

```

 

La configuración de rutas ya está en config-server.

 

---

 

## Fase 7: Ejecutar Instancias Múltiples

 

Para ejecutar 2 instancias de cada microservicio:

 

**Instancia 1** (puerto por defecto):

```bash

cd containers-service

mvn spring-boot:run

```

 

**Instancia 2** (puerto alternativo):

```bash

cd containers-service

mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8102

```

 

Repetir para:

- logistics (8111/8112)

- accounting (8121/8122)

- users (8131/8132)

 

---

 

## Fase 8: Scripts de Ejecución

 

**Archivo: `codigo/script_compilacion_empaquetado.sh`**

 

```bash

#!/bin/bash

 

echo "========================================="

echo "COMPILANDO MICROSERVICIOS - ALICATADOS PLASENCIA"

echo "========================================="

 

# Servicios de infraestructura

echo "1. Compilando eureka-server..."

cd eureka-server && mvn clean package -DskipTests

cd ..

 

echo "2. Compilando config-server..."

cd config-server && mvn clean package -DskipTests

cd ..

 

echo "3. Compilando gateway-service..."

cd gateway-service && mvn clean package -DskipTests

cd ..

 

# Microservicios base

echo "4. Compilando containers-service..."

cd containers-service && mvn clean package -DskipTests

cd ..

 

echo "5. Compilando logistics-service..."

cd logistics-service && mvn clean package -DskipTests

cd ..

 

echo "6. Compilando accounting-service..."

cd accounting-service && mvn clean package -DskipTests

cd ..

 

echo "7. Compilando users-service..."

cd users-service && mvn clean package -DskipTests

cd ..

 

echo "========================================="

echo "COMPILACIÓN COMPLETADA"

echo "========================================="

```

 

**Archivo: `codigo/script_ejecucion_sistema.sh`**

 

```bash

#!/bin/bash

 

echo "========================================="

echo "INICIANDO SISTEMA - ALICATADOS PLASENCIA"

echo "========================================="

 

# 1. Eureka Server

echo "Iniciando Eureka Server (8761)..."

cd eureka-server

mvn spring-boot:run &

EUREKA_PID=$!

cd ..

sleep 15

 

# 2. Config Server

echo "Iniciando Config Server (8888)..."

cd config-server

mvn spring-boot:run &

CONFIG_PID=$!

cd ..

sleep 10

 

# 3. Gateway Service

echo "Iniciando Gateway Service (8080)..."

cd gateway-service

mvn spring-boot:run &

GATEWAY_PID=$!

cd ..

sleep 10

 

# 4. Containers Service (2 instancias)

echo "Iniciando Containers Service instancia 1 (8101)..."

cd containers-service

mvn spring-boot:run &

CONTAINERS1_PID=$!

cd ..

sleep 5

 

echo "Iniciando Containers Service instancia 2 (8102)..."

cd containers-service

mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8102 &

CONTAINERS2_PID=$!

cd ..

sleep 5

 

# 5. Logistics Service (2 instancias)

echo "Iniciando Logistics Service instancia 1 (8111)..."

cd logistics-service

mvn spring-boot:run &

LOGISTICS1_PID=$!

cd ..

sleep 5

 

echo "Iniciando Logistics Service instancia 2 (8112)..."

cd logistics-service

mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8112 &

LOGISTICS2_PID=$!

cd ..

sleep 5

 

# 6. Accounting Service (2 instancias)

echo "Iniciando Accounting Service instancia 1 (8121)..."

cd accounting-service

mvn spring-boot:run &

ACCOUNTING1_PID=$!

cd ..

sleep 5

 

echo "Iniciando Accounting Service instancia 2 (8122)..."

cd accounting-service

mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8122 &

ACCOUNTING2_PID=$!

cd ..

sleep 5

 

# 7. Users Service (2 instancias)

echo "Iniciando Users Service instancia 1 (8131)..."

cd users-service

mvn spring-boot:run &

USERS1_PID=$!

cd ..

sleep 5

 

echo "Iniciando Users Service instancia 2 (8132)..."

cd users-service

mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8132 &

USERS2_PID=$!

cd ..

 

echo "========================================="

echo "SISTEMA INICIADO COMPLETAMENTE"

echo "========================================="

echo "Eureka: http://localhost:8761"

echo "Gateway: http://localhost:8080"

echo "Containers: http://localhost:8101, http://localhost:8102"

echo "Logistics: http://localhost:8111, http://localhost:8112"

echo "Accounting: http://localhost:8121, http://localhost:8122"

echo "Users: http://localhost:8131, http://localhost:8132"

echo "========================================="

 

# Esperar para que el usuario detenga los servicios

read -p "Presiona ENTER para detener todos los servicios..."

 

# Detener todos los procesos

kill $EUREKA_PID $CONFIG_PID $GATEWAY_PID \

     $CONTAINERS1_PID $CONTAINERS2_PID \

     $LOGISTICS1_PID $LOGISTICS2_PID \

     $ACCOUNTING1_PID $ACCOUNTING2_PID \

     $USERS1_PID $USERS2_PID

 

echo "Todos los servicios han sido detenidos."

```

 

---

 

## Fase 9: Scripts de Pruebas con curl

 

**Archivo: `codigo/scripts_ejecucion_pruebas.sh`**

 

```bash

#!/bin/bash

 

BASE_URL="http://localhost:8080/api"

 

echo "========================================="

echo "PRUEBAS SISTEMA ALICATADOS PLASENCIA"

echo "========================================="

 

# Prueba 1: Listar tipos de contenedores

echo ""

echo "1. Listar tipos de contenedores disponibles"

curl -X GET "${BASE_URL}/containers/types" | jq

 

# Prueba 2: Crear nuevo alquiler de contenedor

echo ""

echo "2. Crear alquiler de contenedor"

curl -X POST "${BASE_URL}/containers/rentals" \

  -H "Content-Type: application/json" \

  -d '{

    "containerId": 1,

    "customerId": 10,

    "startDate": "2025-11-20",

    "expectedEndDate": "2025-12-05",

    "deliveryAddress": "Calle Mayor 25, Plasencia",

    "deliveryCity": "Plasencia",

    "deliveryPostalCode": "10600"

  }' | jq

 

# Prueba 3: Consultar rutas del día

echo ""

echo "3. Consultar rutas planificadas"

curl -X GET "${BASE_URL}/logistics/routes?date=2025-11-20" | jq

 

# Prueba 4: Generar nóminas del mes

echo ""

echo "4. Generar nóminas de noviembre 2025"

curl -X POST "${BASE_URL}/accounting/payrolls/generate" \

  -H "Content-Type: application/json" \

  -d '{

    "periodMonth": 11,

    "periodYear": 2025

  }' | jq

 

# Prueba 5: Estadísticas financieras

echo ""

echo "5. Consultar estadísticas financieras del mes"

curl -X GET "${BASE_URL}/accounting/statistics?month=11&year=2025" | jq

 

# Prueba 6: Login de usuario

echo ""

echo "6. Autenticación de usuario"

curl -X POST "${BASE_URL}/users/auth/login" \

  -H "Content-Type: application/json" \

  -d '{

    "username": "admin",

    "password": "admin123"

  }' | jq

 

echo ""

echo "========================================="

echo "PRUEBAS COMPLETADAS"

echo "========================================="

```

 

---

 

## Checklist Final

 

### Servicios de Infraestructura:

- [ ] Eureka Server ejecutándose en :8761

- [ ] Config Server ejecutándose en :8888

- [ ] Gateway Service ejecutándose en :8080

 

### Microservicios Base (2 instancias cada uno):

- [ ] Containers Service: :8101, :8102

- [ ] Logistics Service: :8111, :8112

- [ ] Accounting Service: :8121, :8122

- [ ] Users Service: :8131, :8132

 

### Base de Datos:

- [ ] MySQL instalado y ejecutándose

- [ ] Base de datos `containers_db` creada

- [ ] Base de datos `logistics_db` creada

- [ ] Base de datos `accounting_db` creada

- [ ] Base de datos `users_db` creada

 

### Verificaciones:

- [ ] Todos los servicios registrados en Eureka

- [ ] Swagger UI accesible en todos los microservicios

- [ ] Gateway enruta correctamente a cada microservicio

- [ ] Scripts de compilación funcionan

- [ ] Scripts de ejecución funcionan

- [ ] Scripts de pruebas funcionan

 

---

 

## URLs Importantes

 

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

 

---

 

## Orden de Inicio Recomendado

 

1. **Primero**: Eureka Server (esperar 15 segundos)

2. **Segundo**: Config Server (esperar 10 segundos)

3. **Tercero**: Gateway Service (esperar 10 segundos)

4. **Cuarto**: Microservicios base en cualquier orden (2 instancias de cada uno)

 

**Tiempo total de inicio**: ~2-3 minutos

 

---

 

**¡IMPORTANTE!**:

- Asegúrate de tener MySQL instalado y ejecutándose

- Cada microservicio seguirá la misma estructura: model, repository, service, controller

- Los ejemplos de código son plantillas que debes completar

- Cada microservicio debe tener su propio `pom.xml` y `bootstrap.yml`

 

---

 

**Próximos Pasos**: Una vez completes la implementación, continúa con la documentación en archivos .md y genera los diagramas PlantUML.