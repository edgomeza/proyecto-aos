package com.alicatadosplasencia.containers_service.controller;

import com.alicatadosplasencia.containers_service.model.ContainerInspection;
import com.alicatadosplasencia.containers_service.service.ContainerInspectionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * Controller REST para gestión de inspecciones de contenedores
 */
@RestController
@RequestMapping("/inspections")
@Tag(name = "Container Inspections", description = "API de Inspecciones de Contenedores")
public class ContainerInspectionController {

    @Autowired
    private ContainerInspectionService inspectionService;

    @GetMapping
    @Operation(summary = "Listar todas las inspecciones")
    public ResponseEntity<List<ContainerInspection>> getAll() {
        return ResponseEntity.ok(inspectionService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener inspección por ID")
    public ResponseEntity<ContainerInspection> getById(@PathVariable Long id) {
        return ResponseEntity.ok(inspectionService.findById(id));
    }

    @GetMapping("/rental/{rentalId}")
    @Operation(summary = "Obtener inspecciones de un alquiler")
    public ResponseEntity<List<ContainerInspection>> getByRentalId(@PathVariable Long rentalId) {
        return ResponseEntity.ok(inspectionService.findByRentalId(rentalId));
    }

    @PostMapping
    @Operation(summary = "Crear nueva inspección")
    public ResponseEntity<ContainerInspection> create(@Valid @RequestBody ContainerInspection inspection) {
        ContainerInspection created = inspectionService.save(inspection);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar inspección")
    public ResponseEntity<ContainerInspection> update(@PathVariable Long id, @Valid @RequestBody ContainerInspection inspection) {
        inspection.setId(id);
        ContainerInspection updated = inspectionService.save(inspection);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar inspección")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        inspectionService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
