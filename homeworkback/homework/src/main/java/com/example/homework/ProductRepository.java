package com.example.homework;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    @Query("SELECT p FROM Product p WHERE p.productname ILIKE %:searchTerm% OR p.category ILIKE %:searchTerm%")
    List<Product> findByNameContainingIgnoreCase(String searchTerm);
}
