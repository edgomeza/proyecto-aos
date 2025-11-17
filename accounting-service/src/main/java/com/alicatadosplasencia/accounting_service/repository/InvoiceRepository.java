package com.alicatadosplasencia.accounting_service.repository;

import com.alicatadosplasencia.accounting_service.model.Invoice;
import com.alicatadosplasencia.accounting_service.model.Invoice.InvoiceStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    List<Invoice> findByStatus(InvoiceStatus status);
    List<Invoice> findByCustomerId(Long customerId);
}
