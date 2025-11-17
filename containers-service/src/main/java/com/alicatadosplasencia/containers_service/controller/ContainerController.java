package com.alicatadosplasencia.containers_service.controller;

import com.alicatadosplasencia.containers_service.model.Container;
import com.alicatadosplasencia.containers_service.model.Container.ContainerStatus;
import com.alicatadosplasencia.containers_service.service.ContainerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * Controller REST para gestión de inventario de contenedores
 */
@RestController
@RequestMapping("/containers")
@Tag(name = "Containers", description = "API de Gestión de Inventario de Contenedores")
public class ContainerController {

    @Autowired
    private ContainerService containerService;

    @GetMapping
    @Operation(summary = "Listar todos los contenedores")
    public ResponseEntity<List<Container>> getAll() {
        return ResponseEntity.ok(containerService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener contenedor por ID")
    public ResponseEntity<Container> getById(@PathVariable Long id) {
        return ResponseEntity.ok(containerService.findById(id));
    }

    @GetMapping("/code/{containerCode}")
    @Operation(summary = "Obtener contenedor por código")
    public ResponseEntity<Container> getByCode(@PathVariable String containerCode) {
        return ResponseEntity.ok(containerService.findByCode(containerCode));
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "Listar contenedores por estado")
    public ResponseEntity<List<Container>> getByStatus(@PathVariable ContainerStatus status) {
        return ResponseEntity.ok(containerService.findByStatus(status));
    }

    @GetMapping("/type/{containerTypeId}")
    @Operation(summary = "Listar contenedores por tipo")
    public ResponseEntity<List<Container>> getByType(@PathVariable Long containerTypeId) {
        return ResponseEntity.ok(containerService.findByContainerType(containerTypeId));
    }

    @PostMapping
    @Operation(summary = "Crear nuevo contenedor")
    public ResponseEntity<Container> create(@RequestBody Container container) {
        Container created = containerService.save(container);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar contenedor")
    public ResponseEntity<Container> update(@PathVariable Long id, @RequestBody Container container) {
        container.setId(id);
        Container updated = containerService.save(container);
        return ResponseEntity.ok(updated);
    }

    @PutMapping("/{id}/status")
    @Operation(summary = "Actualizar estado del contenedor")
    public ResponseEntity<Container> updateStatus(
            @PathVariable Long id,
            @RequestParam ContainerStatus status) {
        Container updated = containerService.updateStatus(id, status);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar contenedor")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        containerService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
