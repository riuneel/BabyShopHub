import 'package:flutter/material.dart';
import 'package:babyshophub/services/product_service.dart';
import 'package:babyshophub/models/product.dart';
import 'package:babyshophub/widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.categoryName, this.searchValue});

  final String categoryName;
  final String? searchValue;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService _productService = ProductService();
  late Future<List<ProductData>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<ProductData>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // if loop for if the snapshot tells us the task is running
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), //loading screen
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong :(: ${snapshot.error}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            );
          } else if (snapshot.hasData) {
            final List<ProductData> products = snapshot.data!;
            final query = widget.searchValue?.trim().toLowerCase() ?? '';
            final List<ProductData> filteredProducts = query.isNotEmpty
                ? products.where((product) {
                    return product.productName.toLowerCase().contains(query) ||
                        product.productBrand.toLowerCase().contains(query) ||
                        product.productCategory.toLowerCase().contains(query);
                  }).toList()
                : widget.categoryName == 'All'
                ? products
                : products
                      .where(
                        (product) =>
                            product.productCategory == widget.categoryName,
                      )
                      .toList();
            if (filteredProducts.isEmpty) {
              return Center(
                child: Text(
                  'No Products Available :(',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 170,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(product: product);
              },
            );
          } else {
            return Center(
              child: Text(
                'No Products Available :(',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
