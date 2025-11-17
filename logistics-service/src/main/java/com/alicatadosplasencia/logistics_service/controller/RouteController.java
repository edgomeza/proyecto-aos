package com.alicatadosplasencia.logistics_service.controller;

import com.alicatadosplasencia.logistics_service.model.Route;
import com.alicatadosplasencia.logistics_service.model.Route.RouteStatus;
import com.alicatadosplasencia.logistics_service.service.RouteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/routes")
@Tag(name = "Routes", description = "API de Gestión de Rutas de Entrega")
public class RouteController {

    @Autowired
    private RouteService routeService;

    @GetMapping
    @Operation(summary = "Listar todas las rutas")
    public ResponseEntity<List<Route>> getAll() {
        return ResponseEntity.ok(routeService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener ruta por ID")
    public ResponseEntity<Route> getById(@PathVariable Long id) {
        return ResponseEntity.ok(routeService.findById(id));
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "Listar rutas por estado")
    public ResponseEntity<List<Route>> getByStatus(@PathVariable RouteStatus status) {
        return ResponseEntity.ok(routeService.findByStatus(status));
    }

    @GetMapping("/active")
    @Operation(summary = "Listar rutas activas")
    public ResponseEntity<List<Route>> getActive() {
        return ResponseEntity.ok(routeService.findByStatus(RouteStatus.IN_PROGRESS));
    }

    @GetMapping("/planned")
    @Operation(summary = "Listar rutas planificadas")
    public ResponseEntity<List<Route>> getPlanned() {
        return ResponseEntity.ok(routeService.findByStatus(RouteStatus.PLANNED));
    }

    @GetMapping("/date/{date}")
    @Operation(summary = "Listar rutas por fecha")
    public ResponseEntity<List<Route>> getByDate(
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(routeService.findByScheduleDate(date));
    }

    @PostMapping
    @Operation(summary = "Crear nueva ruta")
    public ResponseEntity<Route> create(@Valid @RequestBody Route route) {
        Route created = routeService.save(route);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar ruta")
    public ResponseEntity<Route> update(@PathVariable Long id, @Valid @RequestBody Route route) {
        Route updated = routeService.update(id, route);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar ruta")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        routeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
