import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_color.dart';
import '../../constants/app_images.dart';
import '../../network/api_service.dart';
import '../cart/data/cart_item_model.dart';
import '../cart/logic/cart_function.dart';
import '../cart/presentation/cart_page.dart';
import 'product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  final String imagePath;
  final String name;
  ProductDetailPage({
    super.key,
    required this.productId,
    required this.imagePath,
    required this.name,
  });
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: FutureBuilder<Product>(
        future: fetchProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Something went wrong"));
          }

          final product = snapshot.data!;
          final num? price = product.data['price'];


          return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productTitle(product.name),
                    _productImage(),
                    _detailsSection(product),
                    const SizedBox(height: 100),
                  ],
                ),
            );
        },
      ),
      bottomNavigationBar: FutureBuilder<Product>(
        future: fetchProductById(productId),
        builder: (context, snapshot) {
          final price = snapshot.data?.data['price'];
          return _bottomBar(price);
        },
      ),
    );
  }

  // <--------- APP BAR ---------->
  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: AppColor.headerColor2,
      leading: const BackButton(color: Colors.black),
      title: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search for products",
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      actions: [
        Obx(() {
          final cart = Get.find<CartController>();
          return GestureDetector(
            onTap: () {
              Get.to(() => CartPage());
            },
            child: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                if (cart.totalItems > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cart.totalItems.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
        const SizedBox(width: 12),
      ],
    );
  }

  // <----------- PRODUCT IMAGE ----------->
  Widget _productImage() {
    return Stack(
      children: [
        Image.asset(
          AppImages.getImageByProductId(productId) ?? AppImages.placeholder,
          height: 420,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: const [
              _RoundedIcon(icon: Icons.favorite_rounded),
              SizedBox(height: 10),
              _RoundedIcon(icon: Icons.share_outlined),
            ],
          ),
        ),
        Positioned(
          top: 370,
          left: 0,
          right: 0,
          child: Container(child: _ratingSection()),
        ),
      ],
    );
  }

  // <------ Rating Container ----------->
  Widget _ratingSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Text("4.4", style: TextStyle(color: Colors.black)),
                Icon(Icons.star, color: Colors.green, size: 14),

                const SizedBox(width: 2),
                const Text("| 36", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Product Title
  Widget _productTitle(String name) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color(0XFFE0E0E0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                _priceSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Price Section
  Widget _priceSection() {
    return Row(
      children: const [
        SizedBox(width: 8),
        Text("81% off", style: TextStyle(color: Colors.green)),
        SizedBox(width: 8),
        Text(
          "₹2,599",
          style: TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        SizedBox(width: 8),
        Text("₹485", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // API Details Section
  Widget _detailsSection(Product product) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (product.data.isNotEmpty)
            ...product.data.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      e.value.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            )
          else
            const Text("No details available"),
        ],
      ),
    );
  }

  // Bottom Buy Bar
  Widget _bottomBar( dynamic price) {
    final double safePrice = (price is num) ? price.toDouble() : 0.0;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              cartController.addToCart(
                CartItem(
                  id: productId,
                  name: name,
                  image:
                      AppImages.getImageByProductId(productId) ?? AppImages.placeholder,
                  price: safePrice,
                ),
              );
              Get.snackbar(
                "Added to Cart",
                "Product added successfully",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const _RoundedIcon(icon: Icons.add_shopping_cart),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Buy with EMI",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "From ₹104/m",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEB3B),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
        "₹$safePrice",
        style: TextStyle(fontWeight: FontWeight.bold),

              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Rounded Rectangular Icon
class _RoundedIcon extends StatelessWidget {
  final IconData icon;
  const _RoundedIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.black),
    );
  }
}
