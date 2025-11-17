package com.alicatadosplasencia.containers_service.service;

import com.alicatadosplasencia.containers_service.model.ContainerType;
import com.alicatadosplasencia.containers_service.repository.ContainerTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * Service para gestión de tipos de contenedores
 */
@Service
public class ContainerTypeService {

    @Autowired
    private ContainerTypeRepository containerTypeRepository;

    public List<ContainerType> findAll() {
        return containerTypeRepository.findAll();
    }

    public List<ContainerType> findActiveTypes() {
        return containerTypeRepository.findByActiveTrue();
    }

    public ContainerType findById(Long id) {
        return containerTypeRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("ContainerType not found with id: " + id));
    }

    @Transactional
    public ContainerType save(ContainerType containerType) {
        return containerTypeRepository.save(containerType);
    }

    @Transactional
    public void delete(Long id) {
        containerTypeRepository.deleteById(id);
    }
}
