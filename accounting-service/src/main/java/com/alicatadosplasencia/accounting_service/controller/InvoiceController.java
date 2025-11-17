package com.alicatadosplasencia.accounting_service.controller;

import com.alicatadosplasencia.accounting_service.model.Invoice;
import com.alicatadosplasencia.accounting_service.model.Invoice.InvoiceStatus;
import com.alicatadosplasencia.accounting_service.service.InvoiceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/invoices")
@Tag(name = "Invoices", description = "API de Gestión de Facturas")
public class InvoiceController {

    @Autowired
    private InvoiceService invoiceService;

    @GetMapping
    @Operation(summary = "Listar todas las facturas")
    public ResponseEntity<List<Invoice>> getAll() {
        return ResponseEntity.ok(invoiceService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener factura por ID")
    public ResponseEntity<Invoice> getById(@PathVariable Long id) {
        return ResponseEntity.ok(invoiceService.findById(id));
    }

    @GetMapping("/status/{status}")
    @Operation(summary = "Listar facturas por estado")
    public ResponseEntity<List<Invoice>> getByStatus(@PathVariable InvoiceStatus status) {
        return ResponseEntity.ok(invoiceService.findByStatus(status));
    }

    @GetMapping("/pending")
    @Operation(summary = "Listar facturas pendientes")
    public ResponseEntity<List<Invoice>> getPending() {
        return ResponseEntity.ok(invoiceService.findByStatus(InvoiceStatus.PENDING));
    }

    @GetMapping("/paid")
    @Operation(summary = "Listar facturas pagadas")
    public ResponseEntity<List<Invoice>> getPaid() {
        return ResponseEntity.ok(invoiceService.findByStatus(InvoiceStatus.PAID));
    }

    @GetMapping("/overdue")
    @Operation(summary = "Listar facturas vencidas")
    public ResponseEntity<List<Invoice>> getOverdue() {
        return ResponseEntity.ok(invoiceService.findByStatus(InvoiceStatus.OVERDUE));
    }

    @GetMapping("/customer/{customerId}")
    @Operation(summary = "Listar facturas de un cliente")
    public ResponseEntity<List<Invoice>> getByCustomerId(@PathVariable Long customerId) {
        return ResponseEntity.ok(invoiceService.findByCustomerId(customerId));
    }

    @PostMapping
    @Operation(summary = "Crear nueva factura")
    public ResponseEntity<Invoice> create(@Valid @RequestBody Invoice invoice) {
        Invoice created = invoiceService.save(invoice);
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar factura")
    public ResponseEntity<Invoice> update(@PathVariable Long id, @Valid @RequestBody Invoice invoice) {
        Invoice updated = invoiceService.update(id, invoice);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar factura")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        invoiceService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
