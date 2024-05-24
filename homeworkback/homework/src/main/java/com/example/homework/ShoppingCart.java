package com.example.homework;

import jakarta.persistence.*;

@Entity
@Table(name = "shoppingcart")
public class ShoppingCart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer cartid;

    @Column(name = "userid")
    private Integer userid;

    @Column(name = "productid")
    private Integer productid;

    private Integer quantity;

    // Getters and Setters
    public Integer getCartid() {
        return cartid;
    }

    public void setCartid(Integer cartid) {
        this.cartid = cartid;
    }

    public Integer getUserid() {
        return userid;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }

    public Integer getProductid() {
        return productid;
    }

    public void setProductid(Integer productid) {
        this.productid = productid;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "ShoppingCart{" +
                "cartid=" + cartid +
                ", userid=" + userid +
                ", productid=" + productid +
                ", quantity=" + quantity +
                '}';
    }
}
