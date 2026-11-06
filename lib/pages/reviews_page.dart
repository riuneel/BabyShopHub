import 'package:flutter/material.dart';
import 'package:babyshophub/theme/app_colors.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Elon Musk',
      'product': 'Premium Baby Diapers',
      'rating': 5,
      'comment':
          'These diapers are soft and comfortable for my baby.\nThey keep him dry for hours. Definitely worth the price!',
    },
    {
      'name': 'Alexia Putellas',
      'product': 'Newborn Clothing Set',
      'rating': 5,
      'comment':
          'The material is soft and the clothes fit perfectly.\nI love the quality and would happily buy again!',
    },
    {
      'name': 'John Doe',
      'product': 'Baby Rattle Set',
      'rating': 4,
      'comment':
          'My little one enjoys playing with these rattles.\nThey are colourful, lightweight and easy to hold.',
    },
    {
      'name': 'Fumni Kuti',
      'product': 'Organic Baby Puree',
      'rating': 5,
      'comment':
          'My baby enjoys the taste, and I like the smooth texture.\nIt is a lovely addition to our feeding routine.',
    },
  ];

  final List<Map<String, dynamic>> sellers = [
    {'name': 'Aptech Store', 'average': 4.8, 'count': 120, 'myRating': 0},
    {'name': 'Kiddies Naija', 'average': 4.5, 'count': 85, 'myRating': 0},
    {'name': 'Dev Toys', 'average': 4.2, 'count': 60, 'myRating': 0},
  ];

  // Shows 5 stars. If onSelected is given, the stars can be tapped.
  Widget _buildStars(
    int rating, {
    double size = 20,
    ValueChanged<int>? onSelected,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final star = Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );

        if (onSelected == null) return star;

        return GestureDetector(onTap: () => onSelected(i + 1), child: star);
      }),
    );
  }

  void _rateSeller(int index, int stars) {
    setState(() {
      final seller = sellers[index];
      final double total = seller['average'] * seller['count'] + stars;
      seller['count'] = seller['count'] + 1;
      seller['average'] = total / seller['count'];
      seller['myRating'] = stars;
    });
  }

  void _showAddReviewDialog() {
    _nameController.clear();
    _productController.clear();
    _commentController.clear();
    int selectedRating = 0;
    String? error;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Write a review'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Your name'),
                    ),
                    TextField(
                      controller: _productController,
                      decoration: const InputDecoration(labelText: 'Product'),
                    ),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Your review',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStars(
                      selectedRating,
                      size: 32,
                      onSelected: (value) {
                        setDialogState(() {
                          selectedRating = value;
                        });
                      },
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
                    final product = _productController.text.trim();
                    final comment = _commentController.text.trim();

                    if (name.isEmpty ||
                        product.isEmpty ||
                        comment.isEmpty ||
                        selectedRating == 0) {
                      setDialogState(() {
                        error = 'Fill in every field and choose a star rating.';
                      });
                      return;
                    }

                    setState(() {
                      reviews.insert(0, {
                        'name': name,
                        'product': product,
                        'rating': selectedRating,
                        'comment': comment,
                      });
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showAddReviewDialog,
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text('Write a review'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        review['product'],
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStars(review['rating']),
                      const SizedBox(height: 8),
                      Text(review['comment']),
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

  Widget _buildSellersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sellers.length,
      itemBuilder: (context, index) {
        final seller = sellers[index];
        final int myRating = seller['myRating'];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${seller['average'].toStringAsFixed(1)} (${seller['count']} ratings)',
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  myRating == 0
                      ? 'Rate this seller'
                      : 'You rated this seller $myRating out of 5',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                _buildStars(
                  myRating,
                  size: 30,
                  onSelected: myRating == 0
                      ? (value) => _rateSeller(index, value)
                      : null,
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
    _productController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reviews and Ratings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Product reviews'),
              Tab(text: 'Seller ratings'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildReviewsTab(), _buildSellersTab()]),
      ),
    );
  }
}