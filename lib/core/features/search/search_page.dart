import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_color.dart';
import '../../constants/app_images.dart';
import '../../network/api_service.dart';
import '../product/product_details.dart';
import '../product/product_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await fetchAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      Get.snackbar("Error", "Failed to load products");
    }
  }

  void _searchByName(String query) {
    setState(() {
      _filteredProducts = query.isEmpty
          ? _allProducts
          : _allProducts
          .where(
            (product) =>
            product.name.toLowerCase().contains(query.toLowerCase()),
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            controller: _searchController,
            onChanged: _searchByName,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Search by product name",
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filteredProducts.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return _productTile(product);
        },
      ),
    );
  }

  Widget _productTile(Product product) {
    final imagePath = AppImages.getImageByProductId(product.id);

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: _highlightText(product.name, _searchController.text),
      onTap: () {
        Get.to(
              () => ProductDetailPage(
            productId: product.id,
            imagePath: imagePath,
            name: product.name,
          ),
        );
      },
    );
  }
}
Widget _highlightText(String text, String query) {
  if (query.isEmpty) {
    return Text(text);
  }

  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();

  if (!lowerText.contains(lowerQuery)) {
    return Text(text);
  }

  final startIndex = lowerText.indexOf(lowerQuery);
  final endIndex = startIndex + query.length;

  return RichText(
    text: TextSpan(
      style: const TextStyle(color: Colors.black, fontSize: 16),
      children: [
        TextSpan(text: text.substring(0, startIndex)),
        TextSpan(
          text: text.substring(startIndex, endIndex),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: text.substring(endIndex)),
      ],
    ),
  );
}
