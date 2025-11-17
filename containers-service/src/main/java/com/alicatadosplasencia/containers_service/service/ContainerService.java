package com.alicatadosplasencia.containers_service.service;

import com.alicatadosplasencia.containers_service.model.Container;
import com.alicatadosplasencia.containers_service.model.Container.ContainerStatus;
import com.alicatadosplasencia.containers_service.repository.ContainerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Service para gestión de inventario de contenedores
 */
@Service
public class ContainerService {

    @Autowired
    private ContainerRepository containerRepository;

    public List<Container> findAll() {
        return containerRepository.findAll();
    }

    public Container findById(Long id) {
        return containerRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Container not found with id: " + id));
    }

    public Container findByCode(String containerCode) {
        return containerRepository.findByContainerCode(containerCode)
            .orElseThrow(() -> new RuntimeException("Container not found with code: " + containerCode));
    }

    public List<Container> findByStatus(ContainerStatus status) {
        return containerRepository.findByStatus(status);
    }

    public List<Container> findByContainerType(Long containerTypeId) {
        return containerRepository.findByContainerTypeId(containerTypeId);
    }

    @Transactional
    public Container save(Container container) {
        if (container.getCreatedAt() == null) {
            container.setCreatedAt(LocalDateTime.now());
        }
        return containerRepository.save(container);
    }

    @Transactional
    public Container updateStatus(Long id, ContainerStatus newStatus) {
        Container container = findById(id);
        container.setStatus(newStatus);
        return containerRepository.save(container);
    }

    @Transactional
    public void delete(Long id) {
        containerRepository.deleteById(id);
    }
}
