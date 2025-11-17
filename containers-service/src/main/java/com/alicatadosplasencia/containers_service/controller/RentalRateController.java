package com.alicatadosplasencia.containers_service.controller;

import com.alicatadosplasencia.containers_service.model.RentalRate;
import com.alicatadosplasencia.containers_service.service.RentalRateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * Controller REST para gestión de tarifas de alquiler
 */
@RestController
@RequestMapping("/rates")
@Tag(name = "Rental Rates", description = "API de Tarifas de Alquiler")
public class RentalRateController {

    @Autowired
    private RentalRateService rentalRateService;

    @GetMapping
    @Operation(summary = "Listar todas las tarifas")
    public ResponseEntity<List<RentalRate>> getAll() {
        return ResponseEntity.ok(rentalRateService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener tarifa por ID")
    public ResponseEntity<RentalRate> getById(@PathVariable Long id) {
        return ResponseEntity.ok(rentalRateService.findById(id));
    }

    @GetMapping("/container-type/{containerTypeId}/active")
    @Operation(summary = "Obtener tarifas activas por tipo de contenedor")
    public ResponseEntity<List<RentalRate>> getActiveByContainerType(@PathVariable Long containerTypeId) {
        return ResponseEntity.ok(rentalRateService.findActiveRatesByContainerType(containerTypeId));
    }

    @PostMapping
    @Operation(summary = "Crear nueva tarifa")
    public ResponseEntity<RentalRate> create(@RequestBody RentalRate rentalRate) {
        RentalRate created = rentalRateService.save(rentalRate);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar tarifa")
    public ResponseEntity<RentalRate> update(@PathVariable Long id, @RequestBody RentalRate rentalRate) {
        rentalRate.setId(id);
        RentalRate updated = rentalRateService.save(rentalRate);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar tarifa")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        rentalRateService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
