package com.alicatadosplasencia.containers_service.repository;

import com.alicatadosplasencia.containers_service.model.ContainerInspection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository para ContainerInspection
 * Gestiona el acceso a datos de inspecciones de contenedores
 */
@Repository
public interface ContainerInspectionRepository extends JpaRepository<ContainerInspection, Long> {

    /**
     * Encuentra todas las inspecciones de un alquiler específico
     */
    List<ContainerInspection> findByRentalId(Long rentalId);
}
