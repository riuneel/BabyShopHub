import 'package:flutter/material.dart';
import 'package:babyshophub/theme/app_colors.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final List<String> statuses = ['Packaging', 'Dispatched', 'Delivered'];

  final List<Map<String, dynamic>> products = [
    {'name': 'Premium Baby Diapers', 'price': 24.50, 'stock': 10},
    {'name': 'Newborn Clothing Set', 'price': 18.99, 'stock': 16},
    {'name': 'Baby Rattle Set', 'price': 9.99, 'stock': 3},
  ];

  final List<Map<String, dynamic>> users = [
    {
      'name': 'Elon Musk',
      'email': 'elon@gmail.com',
      'lastActive': 'Today',
      'blocked': false,
    },
    {
      'name': 'Alexia Putellas',
      'email': 'alexia@gmail.com',
      'lastActive': '2 days ago',
      'blocked': false,
    },
    {
      'name': 'John Doe',
      'email': 'john@doe.com',
      'lastActive': '1 week ago',
      'blocked': false,
    },
  ];

  final List<Map<String, dynamic>> inquiries = [
    {
      'user': 'John Doe',
      'message': 'My order has not arrived yet.',
      'resolved': true,
    },
    {
      'user': 'Alexia Putellas',
      'message': 'How do I change my delivery address?',
      'resolved': true,
    },
  ];

  final List<Map<String, dynamic>> orders = [
    {
      'orderId': '2008',
      'customer': 'Alexia Putellas',
      'total': 63.00,
      'status': 'Packaging',
    },
    {
      'orderId': '11',
      'customer': 'John Doe',
      'total': 44.50,
      'status': 'Dispatched',
    },
    {
      'orderId': '67',
      'customer': 'Elon Musk',
      'total': 30.00,
      'status': 'Delivered',
    },
  ];
  void _showProductDialog({int? index}) {
    final bool isEditing = index != null;

    _nameController.text = isEditing ? products[index]['name'] : '';
    _priceController.text = isEditing ? '${products[index]['price']}' : '';
    _stockController.text = isEditing ? '${products[index]['stock']}' : '';
    String? error;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit product' : 'Add product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                    TextField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock'),
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final price = double.tryParse(_priceController.text.trim());
                    final stock = int.tryParse(_stockController.text.trim());

                    if (name.isEmpty ||
                        price == null ||
                        stock == null ||
                        price < 0 ||
                        stock < 0) {
                      setDialogState(() {
                        error = 'Enter a name, a valid price and a valid stock.';
                      });
                      return;
                    }

                    final Map<String, dynamic> item = {
                      'name': name,
                      'price': price,
                      'stock': stock,
                    };

                    setState(() {
                      if (isEditing) {
                        products[index] = item;
                      } else {
                        products.add(item);
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProductsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showProductDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add product'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final int stock = product['stock'];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '\$${product['price'].toStringAsFixed(2)}  |  Stock: $stock'
                    '${stock < 5 ? '  (Low stock)' : ''}',
                    style: TextStyle(
                      color: stock < 5 ? Colors.red : Colors.black87,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showProductDialog(index: index),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            products.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildUsersTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...users.map((user) {
          final bool blocked = user['blocked'];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                child: Text(user['name'][0].toUpperCase()),
              ),
              title: Text(
                user['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${user['email']}\nLast active: ${user['lastActive']}',
              ),
              trailing: TextButton(
                onPressed: () {
                  setState(() {
                    user['blocked'] = !blocked;
                  });
                },
                child: Text(
                  blocked ? 'Unblock' : 'Block',
                  style: TextStyle(color: blocked ? Colors.green : Colors.red),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        const Text(
          'User inquiries',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...inquiries.map((inquiry) {
          final bool resolved = inquiry['resolved'];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                inquiry['user'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(inquiry['message']),
              trailing: resolved
                  ? const Text(
                      'Resolved',
                      style: TextStyle(color: Colors.green),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          inquiry['resolved'] = true;
                        });
                      },
                      child: const Text('Resolve'),
                    ),
            ),
          );
        }),
      ],
    );
  }
  Widget _buildOrdersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final String status = order['status'];
        final double progress = (statuses.indexOf(status) + 1) / statuses.length;

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
                Text('Customer: ${order['customer']}'),
                Text('Total: \$${order['total'].toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Status: '),
                    DropdownButton<String>(
                      value: status,
                      items: statuses
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          order['status'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: AppColors.primary,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Users'),
              Tab(text: 'Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProductsTab(),
            _buildUsersTab(),
            _buildOrdersTab(),
          ],
        ),
      ),
    );
  }
}