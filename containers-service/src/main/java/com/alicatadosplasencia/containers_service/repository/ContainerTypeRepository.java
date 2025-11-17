package com.alicatadosplasencia.containers_service.repository;

import com.alicatadosplasencia.containers_service.model.ContainerType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository para ContainerType
 * Gestiona el acceso a datos de tipos de contenedores
 */
@Repository
public interface ContainerTypeRepository extends JpaRepository<ContainerType, Long> {

    /**
     * Encuentra todos los tipos de contenedores activos
     */
    List<ContainerType> findByActiveTrue();
}
