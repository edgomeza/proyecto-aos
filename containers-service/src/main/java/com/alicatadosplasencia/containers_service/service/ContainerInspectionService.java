package com.alicatadosplasencia.containers_service.service;

import com.alicatadosplasencia.containers_service.model.ContainerInspection;
import com.alicatadosplasencia.containers_service.repository.ContainerInspectionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Service para gestión de inspecciones de contenedores
 */
@Service
public class ContainerInspectionService {

    @Autowired
    private ContainerInspectionRepository inspectionRepository;

    public List<ContainerInspection> findAll() {
        return inspectionRepository.findAll();
    }

    public ContainerInspection findById(Long id) {
        return inspectionRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Inspection not found with id: " + id));
    }

    public List<ContainerInspection> findByRentalId(Long rentalId) {
        return inspectionRepository.findByRentalId(rentalId);
    }

    @Transactional
    public ContainerInspection save(ContainerInspection inspection) {
        if (inspection.getInspectionDate() == null) {
            inspection.setInspectionDate(LocalDateTime.now());
        }
        return inspectionRepository.save(inspection);
    }

    @Transactional
    public void delete(Long id) {
        inspectionRepository.deleteById(id);
    }
}
