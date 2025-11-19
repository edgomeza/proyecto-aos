package com.alicatadosplasencia.containers_service.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Entidad Rental
 * Representa un alquiler de contenedor con toda su información financiera y logística
 */
@Entity
@Table(name = "rentals")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Rental {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Rental number is required")
    @Column(name = "rental_number", unique = true, nullable = false, length = 50)
    private String rentalNumber; // RENT-2025-00001

    @NotNull(message = "Container is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "container_id", nullable = false)
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    @Schema(description = "Contenedor alquilado", implementation = Container.class)
    private Container container;

    @NotNull(message = "Customer ID is required")
    @Column(name = "customer_id", nullable = false)
    private Long customerId; // Relación con users-service

    // Fechas del alquiler
    @NotNull(message = "Start date is required")
    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @NotNull(message = "Expected end date is required")
    @Column(name = "expected_end_date", nullable = false)
    private LocalDate expectedEndDate;

    @Column(name = "actual_end_date")
    private LocalDate actualEndDate; // Fecha real de devolución

    // Ubicación de entrega
    @NotBlank(message = "Delivery address is required")
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

    /**
     * Estados posibles de un alquiler
     */
    public enum RentalStatus {
        PENDING,   // Pendiente de entrega
        ACTIVE,    // Alquiler activo
        COMPLETED, // Completado y devuelto
        CANCELLED, // Cancelado
        OVERDUE    // Vencido (no devuelto a tiempo)
    }
}
