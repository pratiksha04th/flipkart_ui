import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_color.dart';
import '../../constants/app_images.dart';
import '../../network/api_service.dart';
import '../cart/logic/cart_function.dart';
import '../cart/presentation/cart_page.dart';
import '../product/product_details.dart';
import '../product/product_model.dart';
import '../search/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: _bottomNav(), // bottom part
      // top part of the home screen
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            collapsedHeight: 120,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final bool isCollapsed =
                    constraints.maxHeight <= 120 + kToolbarHeight;

                return Container(
                  decoration: BoxDecoration(gradient: AppColor.headerColor1),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isCollapsed
                            ? const _CollapsedHeader()
                            : const _ExpandedHeader(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: _centerView()), // central part
        ],
      ),
    );
  }

  // Center view - divided into 3 parts - banner, recent section, suggestion section
  Widget _centerView() {
    return Column(
      children: [
        _banner(),
        _recentSection(),
        _suggestionSection(),
        _banner(),
        _suggestionSection(),
      ],
    );
  }

  // 1. Banner - slider

  Widget _banner() {
    return Column(
      children: const [
        SizedBox(height: 5),
        AutoBannerSlider(),
        SizedBox(height: 10),
      ],
    );
  }

  // 2. Recent section - scrollable horizontally
  Widget _recentSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Still looking for these?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _ProductCard(
                  title: "Women's Heels",
                  imagePath: AppImages.stillLook1,
                  productId: 'ff8081819782e69e019bc67597d65d9b',
                ),
                _ProductCard(
                  title: "Women's Tracksuit",
                  imagePath: AppImages.stillLook2,
                  productId: 'ff8081819782e69e019bc67cade95dcb',
                ),
                _ProductCard(
                  title: "Women's Lounge Wear",
                  imagePath: AppImages.stillLook3,
                  productId: 'ff8081819782e69e019bc67eeeae5dd5',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Suggestion section - scrollable horizontally
  Widget _suggestionSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggestion For You',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _SuggestionCard(title: "Women's Heels"),
                _SuggestionCard(title: "Women's Tracksuit"),
                _SuggestionCard(title: "Women's Lounge Wear"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom navigation bar
  Widget _bottomNav() {
    final CartController cartController = Get.find<CartController>();

    return Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 4) {
            Get.to(() => CartPage());
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'Play',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),

          BottomNavigationBarItem(
            label: 'Cart',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartController.totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartController.totalItems.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//<---------------- CLASS USED IN HOME SCREEN ----------------->

// --------------------  Top Section of Home Screen ---------------------------
// contained 3 widgets - TopCategoryRow, search bar, category row
class _ExpandedHeader extends StatelessWidget {
  const _ExpandedHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('expanded'),
      children: const [
        TopCategoryRow(),
        SizedBox(height: 10),
        SearchBar(),
        SizedBox(height: 10),
        CategoryRow(showIcons: true),
      ],
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('collapsed'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SearchBar(),
        SizedBox(height: 10),
        CategoryRow(showIcons: false),
      ],
    );
  }
}

// <---------- 1. TopCategoryRow -------->

class TopCategoryRow extends StatelessWidget {
  const TopCategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        TopCategoryTile(imagePath: AppImages.flipkartTile),
        TopCategoryTile(imagePath: AppImages.minutes),
        TopCategoryTile(imagePath: AppImages.travel),
        TopCategoryTile(imagePath: AppImages.grocery),
      ],
    );
  }
}

class TopCategoryTile extends StatelessWidget {
  final String imagePath;

  const TopCategoryTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Image.asset(imagePath, fit: BoxFit.fitHeight),
    );
  }
}

//<---------- 2. Search bar ------->

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            onTap: () {
              Get.to(() => SearchPage());
            },
            decoration: InputDecoration(
              hintText: 'laptops tv',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.camera_alt_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 28,
        ),
      ],
    );
  }
}

//<----------- 3. Category icon widget ---------->
class CategoryRow extends StatelessWidget {
  final bool showIcons;

  const CategoryRow({super.key, required this.showIcons});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: showIcons ? 50 : 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CategoryItem(
            icon: Icons.local_mall_outlined,
            label: 'For You',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda13575e0eb1', 'ff8081819782e69e019bda1465e30eb6'], // mackbook Silver , campus black shoes
          ),
          CategoryItem(
            icon: Icons.checkroom_outlined,
            label: 'Fashion',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bc67cade95dcb', 'ff8081819782e69e019bc67597d65d9b'], // womens' tracksuit , black heels
          ),
          CategoryItem(
            icon: Icons.phone_android,
            label: 'Mobiles',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda0ca7f50e93', 'ff8081819782e69e019bda11d7e50ea8'], //mobile phoes, moto
          ),
          CategoryItem(
            icon: Icons.brush_outlined,
            label: 'Beauty',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda1699ec0ebd', 'ff8081819782e69e019bda1766b70ec0'], //moisturizer, perfume
          ),
          CategoryItem(
            icon: Icons.laptop_chromebook_outlined,
            label: 'Electronics',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda1a3c150ed3', 'ff8081819782e69e019bda0b8f8d0e90'], // TV silver Grey ,washing machine
          ),
          CategoryItem(
            icon: Icons.light_mode_outlined,
            label: 'Home',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda1b78210ed8', 'ff8081819782e69e019bda1c256a0edc'], // bedsheets,  Cookware
          ),
          CategoryItem(
            icon: Icons.tv_outlined,
            label: 'Appliances',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda1d78bd0ee7', 'ff8081819782e69e019bda1e457a0ee8'], // Fans, heater
          ),
          CategoryItem(
            icon: Icons.sports_baseball_outlined,
            label: 'Sports',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda1f76c00eeb', 'ff8081819782e69e019bda1ffa8e0eee'], // bedminton , gym combo
          ),
          CategoryItem(
            icon: Icons.toys_outlined,
            label: 'Toys',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda21c7150ef3', 'ff8081819782e69e019bda225dc30ef4'], // remote control car, baby gifts
          ),
          CategoryItem(
            icon: Icons.fastfood_outlined,
            label: 'Food',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda236ff30efa', 'ff8081819782e69e019bda240dc60efd'], // dry fruits, oil and ghee
          ),
          CategoryItem(
            icon: Icons.menu_book_sharp,
            label: 'Books',
            showIcon: showIcons,
            ids: ['ff8081819782e69e019bda257f8f0f00', 'ff8081819782e69e019bda2616e80f01'], // comics , biographies
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showIcon;
  final List<String> ids;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.showIcon,
    required this.ids,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ids.isNotEmpty) {
          _showMultipleProducts(context, label, ids);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(icon, color: Colors.white, size: 25),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// <--------------------Central part of home screen ---------------------->

// <-------  1.AutoBannerSlider ---------->
class AutoBannerSlider extends StatefulWidget {
  const AutoBannerSlider({super.key});

  @override
  State<AutoBannerSlider> createState() => _AutoBannerSliderState();
}

class _AutoBannerSliderState extends State<AutoBannerSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> banners = [
    AppImages.banner1,
    AppImages.banner2,
    AppImages.banner3,
    AppImages.banner4,
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentIndex = (_currentIndex + 1) % banners.length;
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.black
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// <---------- 2. ProductCard widget ----------->
class _ProductCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String productId;

  const _ProductCard({
    required this.title,
    required this.imagePath,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailPage(productId: productId, imagePath: imagePath, name: title),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 140,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}

//<---------- 3. SuggestionCard ------------->
class _SuggestionCard extends StatelessWidget {
  final String title;

  const _SuggestionCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

//<------------- function used to call api ----------------->
void _showMultipleProducts(
  BuildContext context,
  String title,
  List<String> ids,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Product>>(
          future: fetchProductsByIds(ids),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 2,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(height: 200),
                    CircularProgressIndicator(),
                    SizedBox(height: 50),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            final products = snapshot.data ?? [];

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ListTile(
                      title: Text(
                        product.name,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: product.data.isNotEmpty
                          ? Text(
                              product.data.entries
                                  .map((e) => "${e.key}: ${e.value}")
                                  .join(", "),
                            )
                          : const Text("No details available"),
                      onTap: () {
                        Get.to(
                          () => ProductDetailPage(
                            productId: product.id,
                            name: product.name,
                            imagePath:
                                AppImages.getImageByProductId(product.id) ??
                                AppImages.placeholder,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
