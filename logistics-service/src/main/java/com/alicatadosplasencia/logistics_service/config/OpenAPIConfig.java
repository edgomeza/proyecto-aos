package com.alicatadosplasencia.logistics_service.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Configuración de OpenAPI/Swagger para la documentación de la API
 */
@Configuration
public class OpenAPIConfig {

    @Value("${server.port:8111}")
    private String serverPort;

    @Bean
    public OpenAPI logisticsServiceOpenAPI() {
        Server localServer = new Server();
        localServer.setUrl("http://localhost:" + serverPort);
        localServer.setDescription("Servidor local");

        Server gatewayServer = new Server();
        gatewayServer.setUrl("http://localhost:8080/api/logistics");
        gatewayServer.setDescription("API Gateway");

        Contact contact = new Contact();
        contact.setName("Alicatados Plasencia");
        contact.setEmail("info@alicatadosplasencia.com");

        License license = new License()
                .name("Apache 2.0")
                .url("https://www.apache.org/licenses/LICENSE-2.0.html");

        Info info = new Info()
                .title("Logistics Service API")
                .version("1.0.0")
                .description("API REST para gestión de rutas de transporte y logística de contenedores")
                .contact(contact)
                .license(license);

        return new OpenAPI()
                .info(info)
                .servers(List.of(localServer, gatewayServer));
    }
}
