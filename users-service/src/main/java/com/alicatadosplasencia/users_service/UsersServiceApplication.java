package com.alicatadosplasencia.users_service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class UsersServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(UsersServiceApplication.class, args);
		System.out.println("========================================");
        System.out.println("⭐ USERS SERVICE INICIADO ⭐");
        System.out.println("Sistema de Usuarios");
        System.out.println("========================================");
	}

}
