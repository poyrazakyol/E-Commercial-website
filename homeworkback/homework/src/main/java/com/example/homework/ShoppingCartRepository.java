package com.example.homework;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ShoppingCartRepository extends JpaRepository<ShoppingCart, Integer> {
    List<ShoppingCart> findByUserid(Integer userid);
    ShoppingCart findByUseridAndProductid(Integer userid, Integer productId);
}
