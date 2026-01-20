import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cart_item_model.dart';

class CartController extends GetxController {
  static const String _cartKey = 'cart_items';

  final RxList<CartItem> items = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  // ---------------- ADD ----------------
  void addToCart(CartItem item) {
    final index = items.indexWhere((e) => e.id == item.id);

    if (index >= 0) {
      items[index].quantity++;
      items.refresh();
    } else {
      items.add(item);
    }

    _saveCart();
  }

  // ---------------- REMOVE ----------------
  void removeFromCart(CartItem item) {
    items.remove(item);
    _saveCart();
  }

  // ---------------- QTY ----------------
  void increaseQty(CartItem item) {
    item.quantity++;
    items.refresh();
    _saveCart();
  }

  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }
    items.refresh();
    _saveCart();
  }

  // ---------------- TOTALS ----------------
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);


  // ---------------- SAVE ----------------
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartJson);
  }

  // ---------------- LOAD ----------------
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey);

    if (cartJson != null) {
      items.value = cartJson
          .map((e) => CartItem.fromJson(jsonDecode(e)))
          .toList();
      items.refresh();
    }
  }

  // ---------------- CLEAR ----------------
  Future<void> clearCart() async {
    items.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
