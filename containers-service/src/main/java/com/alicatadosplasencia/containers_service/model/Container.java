package com.alicatadosplasencia.containers_service.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entidad Container
 * Representa el inventario físico de contenedores
 * Cada contenedor tiene un código único y un estado
 */
@Entity
@Table(name = "containers")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Container {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Container code is required")
    @Column(name = "container_code", unique = true, nullable = false, length = 50)
    private String containerCode; // CONT-001, CONT-002, etc.

    @NotNull(message = "Container type is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "container_type_id", nullable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    @Schema(description = "Tipo de contenedor", implementation = ContainerType.class)
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

    /**
     * Estados posibles de un contenedor
     */
    public enum ContainerStatus {
        AVAILABLE,      // Disponible para alquilar
        RENTED,         // Alquilado actualmente
        IN_MAINTENANCE, // En mantenimiento
        DAMAGED         // Dañado
    }
}
