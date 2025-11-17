package com.alicatadosplasencia.containers_service.repository;

import com.alicatadosplasencia.containers_service.model.RentalRate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository para RentalRate
 * Gestiona el acceso a datos de tarifas de alquiler
 */
@Repository
public interface RentalRateRepository extends JpaRepository<RentalRate, Long> {

    /**
     * Encuentra todas las tarifas activas para un tipo de contenedor
     */
    List<RentalRate> findByContainerTypeIdAndActiveTrue(Long containerTypeId);
}
