package com.example.homework;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@RestController
@RequestMapping("/api")
public class Controller {

    @Autowired
    private UserService userService;

    @Autowired
    private ProductService productService;

    @Autowired
    private ShoppingCartService shoppingCartService;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody User user) {
        User foundUser = userService.findByEmail(user.getEmail());
        if (foundUser != null && foundUser.getPassword().equals(user.getPassword())) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Login successful");
            response.put("userId", foundUser.getUserid());
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody User user) {
        try {
            userService.saveUser(user);
            return ResponseEntity.status(HttpStatus.CREATED).body("User registered successfully");
        } /*catch (DataIntegrityViolationException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Email already in use");
        }*/ catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Email already in use");
        }
    }

    @GetMapping("/products")
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productService.getAllProducts();
        return new ResponseEntity<>(products, HttpStatus.OK);
    }

    @GetMapping("/products/search")
    public ResponseEntity<List<Product>> searchProducts(@RequestParam String searchTerm) {
        List<Product> products = productService.searchProducts(searchTerm);
        return new ResponseEntity<>(products, HttpStatus.OK);
    }

    @GetMapping("/cart/{userid}")
    public ResponseEntity<List<Map<String, Object>>> getCartItems(@PathVariable Integer userid) {
        List<ShoppingCart> cartItems = shoppingCartService.findByUserid(userid);
        List<Map<String, Object>> response = new ArrayList<>();
        for (ShoppingCart item : cartItems) {
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("quantity", item.getQuantity());
            itemMap.put("product", productService.findById(item.getProductid()));
            response.add(itemMap);
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/cart/add")
    public ResponseEntity<String> addToCart(@RequestBody ShoppingCartRequest request) {
        shoppingCartService.addProductToCart(request.getUserid(), request.getProductid());
        return ResponseEntity.status(HttpStatus.CREATED).body("Product added to cart");
    }

    @PostMapping("/cart/remove")
    public ResponseEntity<String> removeFromCart(@RequestBody ShoppingCartRequest request) {
        shoppingCartService.removeProductFromCart(request.getUserid(), request.getProductid());
        return ResponseEntity.status(HttpStatus.OK).body("Product removed from cart");
    }

    @PostMapping("/cart/removeSingle")
    public ResponseEntity<String> removeSingleItemFromCart(@RequestBody ShoppingCartRequest request) {
        try {
            shoppingCartService.removeSingleItemFromCart(request.getUserid(), request.getProductid());
            return ResponseEntity.status(HttpStatus.OK).body("Single product item removed from cart");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error removing item: " + e.getMessage());
        }
    }


    @GetMapping("/user/{userid}")
    public ResponseEntity<User> getUserById(@PathVariable Long userid) {
        User user = userService.findById(userid);
        if (user != null) {
            return new ResponseEntity<>(user, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/userinfo/{userid}")
    public ResponseEntity<UserDTO> getUserInfoById(@PathVariable int userid) {
        UserDTO user = userService.findUserInfoById(userid);
        if (user != null) {
            return new ResponseEntity<>(user, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}

class ShoppingCartRequest {
    private Integer userid;
    private Integer productid;

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
}
