package com.alicatadosplasencia.eureka_server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * Eureka Server Application
 * Alicatados Plasencia - Sistema de Microservicios
 *
 * Puerto: 8761
 *
 * Función: Service Discovery - Registro y descubrimiento de microservicios
 */
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(EurekaServerApplication.class, args);
		System.out.println("========================================");
		System.out.println("EUREKA SERVER INICIADO");
		System.out.println("Dashboard: http://localhost:8761");
		System.out.println("========================================");
	}

}
