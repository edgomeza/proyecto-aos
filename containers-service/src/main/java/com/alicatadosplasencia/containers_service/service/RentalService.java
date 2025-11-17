package com.alicatadosplasencia.containers_service.service;

import com.alicatadosplasencia.containers_service.model.*;
import com.alicatadosplasencia.containers_service.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Service para gestión de alquileres de contenedores
 * Implementa toda la lógica de negocio para alquileres
 */
@Service
public class RentalService {

    @Autowired
    private RentalRepository rentalRepository;

    @Autowired
    private ContainerRepository containerRepository;

    @Autowired
    private RentalRateRepository rentalRateRepository;

    /**
     * Obtiene todos los alquileres
     */
    public List<Rental> findAll() {
        return rentalRepository.findAll();
    }

    /**
     * Obtiene un alquiler por ID
     */
    public Rental findById(Long id) {
        return rentalRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Rental not found with id: " + id));
    }

    /**
     * Obtiene todos los alquileres de un cliente
     */
    public List<Rental> findByCustomerId(Long customerId) {
        return rentalRepository.findByCustomerId(customerId);
    }

    /**
     * Crea un nuevo alquiler de contenedor
     * Calcula automáticamente precios, tarifas y genera el número de alquiler
     */
    @Transactional
    public Rental createRental(Rental rental) {
        // 1. Verificar disponibilidad del contenedor
        Container container = containerRepository.findById(rental.getContainer().getId())
            .orElseThrow(() -> new RuntimeException("Container not found"));

        if (container.getStatus() != Container.ContainerStatus.AVAILABLE) {
            throw new RuntimeException("Container not available for rental");
        }

        // 2. Calcular días y precio
        long days = ChronoUnit.DAYS.between(rental.getStartDate(), rental.getExpectedEndDate());
        if (days <= 0) {
            throw new RuntimeException("Invalid rental period");
        }
        rental.setTotalDays((int) days);

        // 3. Obtener tarifa activa
        List<RentalRate> rates = rentalRateRepository
            .findByContainerTypeIdAndActiveTrue(container.getContainerType().getId());

        if (rates.isEmpty()) {
            throw new RuntimeException("No active rates found for this container type");
        }

        RentalRate rate = rates.get(0); // Tomar la primera tarifa activa
        rental.setDailyRate(rate.getBasePrice());
        rental.setDeliveryFee(rate.getDeliveryFee() != null ? rate.getDeliveryFee() : BigDecimal.ZERO);
        rental.setPickupFee(rate.getPickupFee() != null ? rate.getPickupFee() : BigDecimal.ZERO);
        rental.setDepositAmount(rate.getDepositAmount() != null ? rate.getDepositAmount() : BigDecimal.ZERO);

        // 4. Calcular importe total
        BigDecimal baseAmount = rate.getBasePrice().multiply(BigDecimal.valueOf(days));
        rental.setBaseAmount(baseAmount);

        BigDecimal total = baseAmount
            .add(rental.getDeliveryFee())
            .add(rental.getPickupFee());
        rental.setTotalAmount(total);

        // 5. Generar número de alquiler
        String rentalNumber = "RENT-" + LocalDate.now().getYear() + "-" +
            String.format("%05d", rentalRepository.count() + 1);
        rental.setRentalNumber(rentalNumber);

        // 6. Establecer estado inicial
        rental.setStatus(Rental.RentalStatus.PENDING);
        rental.setCreatedAt(LocalDateTime.now());
        rental.setUpdatedAt(LocalDateTime.now());

        // 7. Cambiar estado del contenedor
        container.setStatus(Container.ContainerStatus.RENTED);
        containerRepository.save(container);

        // 8. Guardar alquiler
        return rentalRepository.save(rental);
    }

    /**
     * Completa un alquiler (devolución del contenedor)
     * Calcula cargos por días extra si aplica
     */
    @Transactional
    public Rental completeRental(Long rentalId, LocalDate actualEndDate) {
        Rental rental = findById(rentalId);

        if (rental.getStatus() != Rental.RentalStatus.ACTIVE &&
            rental.getStatus() != Rental.RentalStatus.PENDING) {
            throw new RuntimeException("Only active or pending rentals can be completed");
        }

        rental.setActualEndDate(actualEndDate);
        rental.setPickedUpAt(LocalDateTime.now());
        rental.setStatus(Rental.RentalStatus.COMPLETED);
        rental.setUpdatedAt(LocalDateTime.now());

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

    /**
     * Cancela un alquiler
     * Solo se pueden cancelar alquileres en estado PENDING
     */
    @Transactional
    public void cancelRental(Long rentalId, String reason) {
        Rental rental = findById(rentalId);

        if (rental.getStatus() != Rental.RentalStatus.PENDING) {
            throw new RuntimeException("Only pending rentals can be cancelled");
        }

        rental.setStatus(Rental.RentalStatus.CANCELLED);
        rental.setNotes(reason);
        rental.setUpdatedAt(LocalDateTime.now());

        // Liberar contenedor
        Container container = rental.getContainer();
        container.setStatus(Container.ContainerStatus.AVAILABLE);
        containerRepository.save(container);

        rentalRepository.save(rental);
    }

    /**
     * Actualiza el estado de un alquiler
     */
    @Transactional
    public Rental updateRentalStatus(Long rentalId, Rental.RentalStatus newStatus) {
        Rental rental = findById(rentalId);
        rental.setStatus(newStatus);
        rental.setUpdatedAt(LocalDateTime.now());
        return rentalRepository.save(rental);
    }
}
