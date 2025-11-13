package com.example.cicd_demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {

    @GetMapping("/")
    public String home() {
        // This is the initial message (Version 1.0)
        return "Hello from Spring Boot CI/CD Demo! Version 1.0";
    }
}