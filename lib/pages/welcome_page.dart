import 'package:babyshophub/pages/reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:babyshophub/pages/support_page.dart';
import 'package:babyshophub/pages/profile_page.dart';
import 'package:babyshophub/pages/product_page.dart';
import 'package:babyshophub/pages/cart_page.dart';
import 'package:babyshophub/theme/app_colors.dart';
import 'package:babyshophub/widgets/product_card.dart';
import 'package:babyshophub/models/product.dart';
import 'package:babyshophub/services/product_service.dart';

class WelcomePage extends StatefulWidget {
  final String name;
  final String email;

  const WelcomePage({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _searchController = TextEditingController();

  final ProductService _productService = ProductService();

  late Future<List<ProductData>> _productsFuture;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _searchProducts(String value) {
    final query = value.trim();

    if (query.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
          categoryName: 'All',
          searchValue: query,
        ),
      ),
    );
  }

  void _openProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(categoryName: 'All'),
      ),
    );
  }

  void _openCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(categoryName: category),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () => _openCategory(title),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        height: 75,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 35,
              color: iconColor,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularProducts() {
    return FutureBuilder<List<ProductData>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 30,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unable to load popular products.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _productsFuture = _productService.fetchProducts();
                    });
                  },
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No products are currently available.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            ),
          );
        }

        final popularProducts = snapshot.data!.take(4).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: popularProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 180,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = popularProducts[index];

            return ProductCard(
              product: product,
            );
          },
        );
      },
    );
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROMOTIONAL BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.tag,
                              color: AppColors.iconBrown,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            const Expanded(
                              child: Text(
                                'Black Friday Discount - 25%',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.iconBrown,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _openProducts,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          side: const BorderSide(width: 0.5),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.iconBrown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Shop Now',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Valid for two or more purchases.',
                    style: TextStyle(
                      color: AppColors.iconBrown,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PRODUCT CATEGORIES
            const Text(
              'Product Categories',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryCard(
                    title: 'Diapers',
                    icon: LucideIcons.baby,
                    backgroundColor: AppColors.secondary,
                    iconColor: AppColors.iconBlue,
                  ),
                  const SizedBox(width: 12),
                  _buildCategoryCard(
                    title: 'Food',
                    icon: LucideIcons.utensils,
                    backgroundColor: AppColors.primary,
                    iconColor: AppColors.iconBrown,
                  ),
                  const SizedBox(width: 12),
                  _buildCategoryCard(
                    title: 'Toys',
                    icon: Icons.toys_outlined,
                    backgroundColor: AppColors.secondary,
                    iconColor: AppColors.iconBlue,
                  ),
                  const SizedBox(width: 12),
                  _buildCategoryCard(
                    title: 'Clothing',
                    icon: LucideIcons.shirt,
                    backgroundColor: AppColors.primary,
                    iconColor: AppColors.iconBrown,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.starCheck,
                              color: AppColors.iconBlue,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Product reviews coming soon.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.iconBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed:() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewsPage(),
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.iconBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'leave a review',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Share your experience with your favourite products.',
                    style: TextStyle(
                      color: AppColors.iconBlue,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Products',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                OutlinedButton(
                  onPressed: _openProducts,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    side: const BorderSide(
                      color: AppColors.iconBlue,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    foregroundColor: AppColors.iconBlue,
                  ),
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _buildPopularProducts(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: AppColors.secondary,
              scrolledUnderElevation: 0,
              actionsIconTheme: const IconThemeData(size: 24),
              title: Text(
                'Welcome, ${widget.name}👋',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          name: widget.name,
                          email: widget.email,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        widget.name.isNotEmpty
                            ? widget.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.headset),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupportPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _searchProducts,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search products, brands or categories',
                      prefixIcon: const Icon(LucideIcons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          ProductPage(categoryName: 'All'),
          const CartPage(),
          const ReviewsPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.house, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.store, size: 24),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.shoppingCart, size: 24),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.starCheck, size: 24),
            label: 'Ratings',
          ),
        ],
      ),
    );
  }
}
