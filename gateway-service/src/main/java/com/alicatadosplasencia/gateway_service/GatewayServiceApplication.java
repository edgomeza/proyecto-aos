package com.alicatadosplasencia.gateway_service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
 
@SpringBootApplication
@EnableDiscoveryClient
public class GatewayServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(GatewayServiceApplication.class, args);
        System.out.println("========================================");
        System.out.println("GATEWAY SERVICE INICIADO");
        System.out.println("Puerto: 8080");
        System.out.println("API Base: http://localhost:8080/api");
        System.out.println("========================================");
    }

}
