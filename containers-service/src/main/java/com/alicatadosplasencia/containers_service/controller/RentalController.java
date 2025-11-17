package com.alicatadosplasencia.containers_service.controller;

import com.alicatadosplasencia.containers_service.model.Rental;
import com.alicatadosplasencia.containers_service.service.RentalService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller REST para gestión de alquileres de contenedores
 */
@RestController
@RequestMapping("/rentals")
@Tag(name = "Rentals", description = "API de Alquiler de Contenedores")
public class RentalController {

    @Autowired
    private RentalService rentalService;

    @GetMapping
    @Operation(summary = "Listar todos los alquileres")
    public ResponseEntity<List<Rental>> getAll() {
        return ResponseEntity.ok(rentalService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener alquiler por ID")
    public ResponseEntity<Rental> getById(@PathVariable Long id) {
        return ResponseEntity.ok(rentalService.findById(id));
    }

    @GetMapping("/customer/{customerId}")
    @Operation(summary = "Obtener alquileres de un cliente")
    public ResponseEntity<List<Rental>> getByCustomerId(@PathVariable Long customerId) {
        return ResponseEntity.ok(rentalService.findByCustomerId(customerId));
    }

    @PostMapping
    @Operation(summary = "Crear nuevo alquiler de contenedor")
    public ResponseEntity<Rental> create(@RequestBody Rental rental) {
        Rental created = rentalService.createRental(rental);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}/complete")
    @Operation(summary = "Completar alquiler (devolución)")
    public ResponseEntity<Rental> complete(
            @PathVariable Long id,
            @RequestParam LocalDate actualEndDate) {
        Rental completed = rentalService.completeRental(id, actualEndDate);
        return ResponseEntity.ok(completed);
    }

    @PutMapping("/{id}/cancel")
    @Operation(summary = "Cancelar alquiler")
    public ResponseEntity<Void> cancel(
            @PathVariable Long id,
            @RequestParam String reason) {
        rentalService.cancelRental(id, reason);
        return ResponseEntity.noContent().build();
    }
}
