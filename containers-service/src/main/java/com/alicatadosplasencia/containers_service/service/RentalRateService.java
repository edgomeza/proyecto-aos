package com.alicatadosplasencia.containers_service.service;

import com.alicatadosplasencia.containers_service.model.RentalRate;
import com.alicatadosplasencia.containers_service.repository.RentalRateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * Service para gestión de tarifas de alquiler
 */
@Service
public class RentalRateService {

    @Autowired
    private RentalRateRepository rentalRateRepository;

    public List<RentalRate> findAll() {
        return rentalRateRepository.findAll();
    }

    public RentalRate findById(Long id) {
        return rentalRateRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("RentalRate not found with id: " + id));
    }

    public List<RentalRate> findActiveRatesByContainerType(Long containerTypeId) {
        return rentalRateRepository.findByContainerTypeIdAndActiveTrue(containerTypeId);
    }

    @Transactional
    public RentalRate save(RentalRate rentalRate) {
        return rentalRateRepository.save(rentalRate);
    }

    @Transactional
    public void delete(Long id) {
        rentalRateRepository.deleteById(id);
    }
}
