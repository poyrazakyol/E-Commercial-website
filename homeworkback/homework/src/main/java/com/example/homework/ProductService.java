package com.example.homework;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public List<Product> searchProducts(String searchTerm) {
        return productRepository.findByNameContainingIgnoreCase(searchTerm);
    }

    public Product findById(Integer productId) {
        return productRepository.findById(productId).orElse(null);
    }
}
