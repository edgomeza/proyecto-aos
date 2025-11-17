package com.alicatadosplasencia.containers_service.repository;

import com.alicatadosplasencia.containers_service.model.Rental;
import com.alicatadosplasencia.containers_service.model.Rental.RentalStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

/**
 * Repository para Rental
 * Gestiona el acceso a datos de alquileres de contenedores
 */
@Repository
public interface RentalRepository extends JpaRepository<Rental, Long> {

    /**
     * Encuentra un alquiler por su número único
     */
    Optional<Rental> findByRentalNumber(String rentalNumber);

    /**
     * Encuentra todos los alquileres de un cliente
     */
    List<Rental> findByCustomerId(Long customerId);

    /**
     * Encuentra todos los alquileres por estado
     */
    List<Rental> findByStatus(RentalStatus status);
}
