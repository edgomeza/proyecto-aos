package com.alicatadosplasencia.containers_service.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entidad RentalRate
 * Representa las tarifas dinámicas de alquiler de contenedores
 * Permite configurar precios por día, semana o mes
 */
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

    /**
     * Tipos de periodo para tarifas
     */
    public enum PeriodType {
        DAILY,   // Tarifa diaria
        WEEKLY,  // Tarifa semanal
        MONTHLY  // Tarifa mensual
    }
}
