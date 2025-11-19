package com.alicatadosplasencia.containers_service.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entidad ContainerInspection
 * Representa una inspección realizada al devolver un contenedor
 * Permite registrar daños, costos de reparación y deducción de fianza
 */
@Entity
@Table(name = "container_inspections")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ContainerInspection {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Rental is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rental_id", nullable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    @Schema(description = "Alquiler inspeccionado", implementation = Rental.class)
    private Rental rental;

    @Column(name = "inspection_date")
    private LocalDateTime inspectionDate = LocalDateTime.now();

    @Column(name = "inspector_id")
    private Long inspectorId; // Empleado que inspecciona

    @NotNull(message = "Condition status is required")
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

    /**
     * Estados de condición del contenedor al devolverse
     */
    public enum ConditionStatus {
        GOOD,          // Buen estado
        MINOR_DAMAGE,  // Daños menores
        MAJOR_DAMAGE   // Daños mayores
    }
}
