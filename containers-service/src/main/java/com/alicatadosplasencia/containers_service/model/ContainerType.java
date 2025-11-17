package com.alicatadosplasencia.containers_service.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

/**
 * Entidad ContainerType
 * Representa los tipos de contenedores disponibles para alquiler
 * Ejemplo: Contenedor 5m³, Contenedor 10m³, etc.
 */
@Entity
@Table(name = "container_types")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContainerType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Container type name is required")
    @Column(nullable = false, length = 100)
    private String name; // Ej: "Contenedor 5m³", "Contenedor 10m³"

    @NotNull(message = "Capacity is required")
    @Column(name = "capacity_m3", nullable = false, precision = 8, scale = 2)
    private BigDecimal capacityM3;

    @Column(length = 100)
    private String dimensions; // Ej: "2m x 1.5m x 1.5m"

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Boolean active = true;
}
