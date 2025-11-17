package com.alicatadosplasencia.containers_service.service;

import com.alicatadosplasencia.containers_service.model.ContainerInspection;
import com.alicatadosplasencia.containers_service.repository.ContainerInspectionRepository;
import com.alicatadosplasencia.containers_service.repository.RentalRepository;
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

    @Autowired
    private RentalRepository rentalRepository;

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
        // Validate that the rental exists
        if (inspection.getRental() == null || inspection.getRental().getId() == null) {
            throw new IllegalArgumentException("Rental is required for inspection");
        }

        // Verify the rental exists in the database
        if (!rentalRepository.existsById(inspection.getRental().getId())) {
            throw new IllegalArgumentException("Rental not found with id: " + inspection.getRental().getId());
        }

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
