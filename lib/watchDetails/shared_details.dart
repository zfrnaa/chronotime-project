import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/bag.dart';
import '../provider/bag_provider.dart';
import '../provider/favorites_provider.dart';
import '../models/bag_item.dart';
import '../models/watch_item.dart';
import '../core/checkout_page.dart';

class SharedDetailsPage extends StatefulWidget {
  final WatchItem watch;

  const SharedDetailsPage({super.key, required this.watch});

  @override
  State<SharedDetailsPage> createState() => _SharedDetailsPageState();
}

class _SharedDetailsPageState extends State<SharedDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: watchDetailsAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: widget.watch.imageUrl.startsWith('http') ||
                        widget.watch.imageUrl.startsWith('https')
                    ? Image.network(
                        widget.watch.imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        widget.watch.imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Watch Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.watch.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'RM${widget.watch.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 101, 245),
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  favoritesProvider.isFavorite(widget.watch.id)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                if (favoritesProvider
                                    .isFavorite(widget.watch.id)) {
                                  favoritesProvider
                                      .removeFromFavorites(widget.watch.id);
                                } else {
                                  favoritesProvider
                                      .addToFavorites(widget.watch);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (widget.watch.warrantyYears > 0)
                            Column(
                              children: [
                                const Icon(Icons.verified_user,
                                    color: Colors.green),
                                Text(
                                  '${widget.watch.warrantyYears} Year\nWarranty',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          Column(
                            children: [
                              const Icon(Icons.security, color: Colors.blue),
                              const Text(
                                'Money Back\nGuarantee',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.local_shipping,
                                  color: Colors.orange),
                              const Text(
                                'Free\nDelivery',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Features
                    const Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._buildFeatures(widget.watch.features),
                    const SizedBox(height: 10),
                    // Watch Description
                    Text(
                      widget.watch.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(128, 128, 128, 0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.share, color: Color(0xFF156BC1)),
              onPressed: () {
                // Add share functionality
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Add buy now functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                      settings: RouteSettings(arguments: [
                        BagItem(
                          id: widget.watch.id,
                          watchName: widget.watch.name,
                          imageUrl: widget.watch.imageUrl,
                          price: widget.watch.price,
                          quantity: 1,
                        )
                      ]),
                      maintainState: false,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF156BC1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF156BC1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  bagProvider.addItem(
                    BagItem(
                      id: widget.watch.id,
                      watchName: widget.watch.name,
                      imageUrl: widget.watch.imageUrl,
                      price: widget.watch.price,
                      quantity: 1,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to Bag'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF156BC1),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Add to Bag',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom AppBar for Watch Details
  AppBar watchDetailsAppBar(context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,
            color: Color.fromARGB(255, 5, 101, 245)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BagPage()),
                  );
                },
                icon: Image.asset('assets/shoppingcart.png',
                    width: 30,
                    height: 30,
                    color: const Color.fromARGB(255, 5, 101, 245)),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${Provider.of<BagProvider>(context).itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // Widget to display individual features
  List<Widget> _buildFeatures(List<String> features) {
    return features.map((feature) {
      return Column(
        children: [
          _buildFeatureRow(Icons.check, feature),
          const SizedBox(height: 6),
        ],
      );
    }).toList();
  }

  Widget _buildFeatureRow(IconData icon, String feature) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 5, 101, 245)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            feature,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
