package com.example;

import com.example.Customer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CustomerController {

    @GetMapping("/customer")
    public Customer getCustomer() {
        return new Customer(1L, "John Doe", "johndoe@example.com");
    }
}