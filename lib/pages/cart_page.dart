import 'package:flutter/material.dart';
import 'package:babyshophub/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:babyshophub/services/cart_service.dart';
import 'package:babyshophub/pages/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> sampleOrders = [
    {
      'orderId': '11',
      'date': 'Nov 7, 2026',
      'status': 'Packaging',
      'items': 'Premium Baby Diapers x 2, Organic Baby Puree x 1',
      'total': 44.50,
    },
    {
      'orderId': '2008',
      'date': 'Sep 27, 2026',
      'status': 'Delivered',
      'items': 'Baby Cotton Romper x 4, Baby Rattle Set x 2',
      'total': 63.00,
    },
    {
      'orderId': '67',
      'date': 'Jan 07, 2026',
      'status': 'Dispatched',
      'items': 'Baby Oatmeal Cereal x 2, Baby Soft Building Blocks x 1',
      'total': 30.00,
    },
  ];
  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final cartItems = cartService.cartItems;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Cart',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Cart (${cartService.getTotalItems()})'),
              Tab(text: 'Orders'),
              Tab(text: 'Tracking'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // CART TAB
            Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(child: Text('Your cart is empty'))
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];

                            return Card(
                              color: const Color.fromARGB(255, 230, 225, 225),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: Image.asset(
                                  item.product.productImage,
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                ),

                                title: Text(
                                  item.product.productName,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.productBrand),

                                    const SizedBox(height: 5),

                                    Text(
                                      '\$${item.product.productPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            context
                                                .read<CartService>()
                                                .updateQuantity(
                                                  item.product.productId,
                                                  item.quantity - 1,
                                                );
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),

                                        Text('${item.quantity}'),

                                        IconButton(
                                          onPressed: () {
                                            context
                                                .read<CartService>()
                                                .updateQuantity(
                                                  item.product.productId,
                                                  item.quantity + 1,
                                                );
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                trailing: IconButton(
                                  onPressed: () {
                                    context.read<CartService>().removeFromCart(
                                      item.product.productId,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${cartService.getTotalPrice().toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cartItems.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckoutPage(),
                                    ),
                                  );
                                },
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sampleOrders.length,
              itemBuilder: (context, index) {
                final order = sampleOrders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order['orderId']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Date: ${order['date']}'),
                        const SizedBox(height: 6),
                        Text('Items: ${order['items']}'),
                        const SizedBox(height: 10),
                        Text(
                          'Total: \$${order['total'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${order['status']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sampleOrders.length,
              itemBuilder: (context, index) {
                final order = sampleOrders[index];
                final String status = order['status'];

                final Color statusColor;
                final double progress;
                final String message;

                if (status == 'Delivered') {
                  statusColor = Colors.green;
                  progress = 1.0;
                  message = 'Your order has been delivered.';
                } else if (status == 'Dispatched') {
                  statusColor = Colors.blue;
                  progress = 0.7;
                  message = 'Your order has been dispatched and is on its way.';
                } else {
                  statusColor = Colors.orange;
                  progress = 0.35;
                  message = 'Your order is being prepared for dispatch.';
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order['orderId']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Items: ${order['items']}'),
                        const SizedBox(height: 12),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade300,
                          color: statusColor,
                        ),
                        const SizedBox(height: 8),
                        Text(message),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
