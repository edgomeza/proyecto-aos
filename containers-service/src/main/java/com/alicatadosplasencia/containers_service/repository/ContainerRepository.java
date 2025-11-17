package com.alicatadosplasencia.containers_service.repository;

import com.alicatadosplasencia.containers_service.model.Container;
import com.alicatadosplasencia.containers_service.model.Container.ContainerStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

/**
 * Repository para Container
 * Gestiona el acceso a datos del inventario de contenedores
 */
@Repository
public interface ContainerRepository extends JpaRepository<Container, Long> {

    /**
     * Encuentra un contenedor por su código único
     */
    Optional<Container> findByContainerCode(String containerCode);

    /**
     * Encuentra todos los contenedores por estado
     */
    List<Container> findByStatus(ContainerStatus status);

    /**
     * Encuentra todos los contenedores de un tipo específico
     */
    List<Container> findByContainerTypeId(Long containerTypeId);
}
