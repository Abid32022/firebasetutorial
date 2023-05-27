import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:start/views/add_to_cart/add_to_cart.dart';
import 'package:start/views/add_to_cart/stats_cart.dart';

class CartModel extends Model {
  List<Product> cart = [];
  double totalCartValue = 0;

  int get total => cart.length;

  void addProduct(Product product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1)
      updateProduct(product, product.qty + 1);
    else {
      cart.add(product);
      calculateTotal();
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1) {
      cart[index].qty = 1;
      cart.removeAt(index);
      calculateTotal();
      notifyListeners();
    }
  }

  void updateProduct(Product product, int qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1) {
      cart[index].qty = qty;
      if (cart[index].qty == 0) {
        removeProduct(product);
      }
      calculateTotal();
      notifyListeners();
    }
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 1);
    cart.clear();
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    for (var product in cart) {
      totalCartValue += product.price * product.qty;
    }
  }
}
