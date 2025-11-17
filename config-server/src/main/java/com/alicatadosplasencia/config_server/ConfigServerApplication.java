package com.alicatadosplasencia.config_server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

/**
 * Config Server Application
 * Alicatados Plasencia - Sistema de Microservicios
 *
 * Puerto: 8888
 *
 * Función: Configuración centralizada para todos los microservicios
 */
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ConfigServerApplication.class, args);
		System.out.println("========================================");
		System.out.println("CONFIG SERVER INICIADO");
		System.out.println("Puerto: 8888");
		System.out.println("========================================");
	}

}
