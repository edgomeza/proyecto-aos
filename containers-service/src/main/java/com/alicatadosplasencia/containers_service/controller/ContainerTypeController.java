package com.alicatadosplasencia.containers_service.controller;

import com.alicatadosplasencia.containers_service.model.ContainerType;
import com.alicatadosplasencia.containers_service.service.ContainerTypeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * Controller REST para gestión de tipos de contenedores
 */
@RestController
@RequestMapping("/types")
@Tag(name = "Container Types", description = "API de Tipos de Contenedores")
public class ContainerTypeController {

    @Autowired
    private ContainerTypeService containerTypeService;

    @GetMapping
    @Operation(summary = "Listar todos los tipos de contenedores")
    public ResponseEntity<List<ContainerType>> getAll() {
        return ResponseEntity.ok(containerTypeService.findAll());
    }

    @GetMapping("/active")
    @Operation(summary = "Listar tipos de contenedores activos")
    public ResponseEntity<List<ContainerType>> getActive() {
        return ResponseEntity.ok(containerTypeService.findActiveTypes());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener tipo de contenedor por ID")
    public ResponseEntity<ContainerType> getById(@PathVariable Long id) {
        return ResponseEntity.ok(containerTypeService.findById(id));
    }

    @PostMapping
    @Operation(summary = "Crear nuevo tipo de contenedor")
    public ResponseEntity<ContainerType> create(@RequestBody ContainerType containerType) {
        ContainerType created = containerTypeService.save(containerType);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar tipo de contenedor")
    public ResponseEntity<ContainerType> update(@PathVariable Long id, @RequestBody ContainerType containerType) {
        containerType.setId(id);
        ContainerType updated = containerTypeService.save(containerType);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar tipo de contenedor")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        containerTypeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
