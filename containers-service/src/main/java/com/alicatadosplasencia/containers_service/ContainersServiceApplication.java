package com.alicatadosplasencia.containers_service;
 
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
 
/**
 * Containers Service Application
 * Alicatados Plasencia - Sistema de Microservicios
 *
 * Puerto: 8101 (Instancia 1), 8102 (Instancia 2)
 * Base de Datos: containers_db
 *
 * Función: Gestión completa del sistema de alquiler de contenedores para obras
 *
 * Responsabilidades:
 * - Gestión de inventario de contenedores
 * - Alquiler de contenedores con tarifas dinámicas
 * - Devoluciones e inspecciones
 * - Historial de alquileres
 * - Cálculo automático de precios
 */
@SpringBootApplication
@EnableDiscoveryClient
public class ContainersServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ContainersServiceApplication.class, args);
        System.out.println("========================================");
        System.out.println("⭐ CONTAINERS SERVICE INICIADO ⭐");
        System.out.println("Sistema de Alquiler de Contenedores");
        System.out.println("========================================");
    }
}