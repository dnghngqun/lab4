package org.example.sessiontracking;

import java.util.ArrayList;
import java.util.List;

public class CartBean {
    private List<Product> items;
    private double totalPrice;

    public CartBean() {
        this.items = new ArrayList<>();
        this.totalPrice = 0.0;
    }

    public void addProduct(Product product) {
        items.add(product);
        calculateTotal();
    }

    public void removeProduct(int index) {
        if (index >= 0 && index < items.size()) {
            items.remove(index);
            calculateTotal();
        }
    }

    public void clear() {
        items.clear();
        totalPrice = 0.0;
    }

    public void syncWithLocalStorage(List<Product> localProducts) {
        this.items = new ArrayList<>(localProducts);
        calculateTotal();
    }

    private void calculateTotal() {
        totalPrice = items.stream().mapToDouble(Product::getPrice).sum();
    }

    // Getters and Setters
    public List<Product> getItems() { return items; }
    public void setItems(List<Product> items) {
        this.items = items;
        calculateTotal();
    }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public int getItemCount() { return items.size(); }
}