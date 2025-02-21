import 'package:flutter/material.dart';
import '../models/watch_item.dart';
import 'helper/watch_database_helper.dart';

class WatchCarousel extends StatefulWidget {
  const WatchCarousel({super.key});

  @override
  State<WatchCarousel> createState() => _WatchCarouselState();
}

class _WatchCarouselState extends State<WatchCarousel> {
  List<WatchItem> _watchList = [];

  @override
  void initState() {
    super.initState();
    _loadWatchItems();
  }

  Future<void> _loadWatchItems() async {
    final watchItems = await WatchDatabaseHelper().watchItems();
    setState(() {
      _watchList = watchItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xff156BC1),
          borderRadius: BorderRadius.circular(20),
        ),
        height: (_watchList.length / 2).ceil() * 260.0,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: _watchList.length,
          itemBuilder: (context, index) {
            final watch = _watchList[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/shared_details',
                  arguments: watch,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      width: double.infinity,
                      child: watch.imageUrl.startsWith('http') ||
                              watch.imageUrl.startsWith('https')
                          // set image from network or local asset
                          ? Image.network(watch.imageUrl,
                              width: 110, height: 110, fit: BoxFit.contain)
                          : Image.asset(
                              watch.imageUrl,
                              width: 110,
                              height: 110,
                              fit: BoxFit.contain,
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      watch.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'RM${watch.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 5, 101, 245),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
