package com.example.homework;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ShoppingCartService {

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;

    @Autowired
    private ProductRepository productRepository;

    public List<ShoppingCart> findByUserid(Integer userid) {
        return shoppingCartRepository.findByUserid(userid);
    }

    public void addProductToCart(Integer userid, Integer productId) {
        ShoppingCart cartItem = shoppingCartRepository.findByUseridAndProductid(userid, productId);
        if (cartItem != null) {
            cartItem.setQuantity(cartItem.getQuantity() + 1);
        } else {
            cartItem = new ShoppingCart();
            cartItem.setUserid(userid);
            cartItem.setProductid(productId);
            cartItem.setQuantity(1);
        }
        shoppingCartRepository.save(cartItem);
    }

    public void removeProductFromCart(Integer userid, Integer productId) {
        ShoppingCart cartItem = shoppingCartRepository.findByUseridAndProductid(userid, productId);
        if (cartItem != null) {
            shoppingCartRepository.delete(cartItem);
        }
    }

    public void removeSingleItemFromCart(Integer userid, Integer productId) throws Exception {
        ShoppingCart cartItem = shoppingCartRepository.findByUseridAndProductid(userid, productId);
        if (cartItem != null) {
            if (cartItem.getQuantity() > 1) {
                cartItem.setQuantity(cartItem.getQuantity() - 1);
                shoppingCartRepository.save(cartItem);
            } else {
                shoppingCartRepository.delete(cartItem);
            }
        } else {
            throw new Exception("Cart item not found");
        }
    }
}
