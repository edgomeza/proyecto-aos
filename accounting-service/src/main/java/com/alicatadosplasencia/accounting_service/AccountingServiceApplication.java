package com.alicatadosplasencia.accounting_service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AccountingServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(AccountingServiceApplication.class, args);
		System.out.println("========================================");
        System.out.println("⭐ ACCOUNTING SERVICE INICIADO ⭐");
        System.out.println("Sistema de Contabilidad");
        System.out.println("========================================");
	}

}
