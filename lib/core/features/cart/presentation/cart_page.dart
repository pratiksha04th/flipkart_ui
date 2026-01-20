import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_color.dart';
import '../data/cart_item_model.dart';
import '../logic/cart_function.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColor.headerColor2,
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
      ),

      body: Obx(() {
        if (cartController.items.isEmpty) {
          return _emptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.items.length,
                itemBuilder: (context, index) {
                  final item = cartController.items[index];
                  return _cartItemCard(item);
                },
              ),
            ),
            _priceSummary(),
          ],
        );
      }),
    );
  }

  //<---------------- EMPTY CART ---------------->
  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //<---------------- CART ITEM CARD ---------------->
  // it contain--- image, product name , price , quantity, delete button
  Widget _cartItemCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // <---- IMAGE ---->
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.image,
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 12),

          // <---- NAME ---->
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                //<------ PRICE ---->
                const SizedBox(height: 6),
                Text(
                  "₹${item.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),

                //<------ QUANTITY ---->
                Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      onTap: () => cartController.decreaseQty(item),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () => cartController.increaseQty(item),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // <---- DELETE BUTTON ---->
          IconButton(
            onPressed: () => cartController.removeFromCart(item),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }


 // <----------------- QUANTITY BUTTON Design---------------->
  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  // ---------------- PRICE SUMMARY ----------------
  Widget _priceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _priceRow("Total Items", cartController.totalItems.toString()),
          const SizedBox(height: 6),
          _priceRow(
            "Total Amount",
            "₹${cartController.totalPrice}",
            isBold: true,
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEB3B),
                foregroundColor: Colors.black,
              ),
              onPressed: () {},
              child: const Text(
                "Place Order",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
