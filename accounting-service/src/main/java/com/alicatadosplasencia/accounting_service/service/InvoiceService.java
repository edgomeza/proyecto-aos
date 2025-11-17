package com.alicatadosplasencia.accounting_service.service;

import com.alicatadosplasencia.accounting_service.model.Invoice;
import com.alicatadosplasencia.accounting_service.model.Invoice.InvoiceStatus;
import com.alicatadosplasencia.accounting_service.repository.InvoiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InvoiceService {

    @Autowired
    private InvoiceRepository invoiceRepository;

    public List<Invoice> findAll() {
        return invoiceRepository.findAll();
    }

    public Invoice findById(Long id) {
        return invoiceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Invoice not found"));
    }

    public List<Invoice> findByStatus(InvoiceStatus status) {
        return invoiceRepository.findByStatus(status);
    }

    public List<Invoice> findByCustomerId(Long customerId) {
        return invoiceRepository.findByCustomerId(customerId);
    }

    public Invoice save(Invoice invoice) {
        return invoiceRepository.save(invoice);
    }

    public Invoice update(Long id, Invoice invoiceDetails) {
        Invoice invoice = findById(id);

        // Update fields
        invoice.setInvoiceNumber(invoiceDetails.getInvoiceNumber());
        invoice.setCustomerId(invoiceDetails.getCustomerId());
        invoice.setCustomerName(invoiceDetails.getCustomerName());
        invoice.setInvoiceDate(invoiceDetails.getInvoiceDate());
        invoice.setDueDate(invoiceDetails.getDueDate());
        invoice.setSubtotal(invoiceDetails.getSubtotal());
        invoice.setTaxAmount(invoiceDetails.getTaxAmount());
        invoice.setTotalAmount(invoiceDetails.getTotalAmount());
        invoice.setStatus(invoiceDetails.getStatus());
        invoice.setDescription(invoiceDetails.getDescription());

        return invoiceRepository.save(invoice);
    }

    public void delete(Long id) {
        invoiceRepository.deleteById(id);
    }
}
