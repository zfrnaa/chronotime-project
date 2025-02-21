import 'package:chrono_time/watchDetails/tissot1_details.dart';
import 'package:flutter/material.dart';
import 'watchDetails/dw1_details.dart';
import 'watchDetails/suunto5_details.dart';
import 'watchDetails/rhythm_details.dart';

class WatchHighlights extends StatelessWidget {
  const WatchHighlights({super.key});

  Widget _watchHighlightsCard(
      BuildContext context, int index, Map<dynamic, String> watchData) {
    String watchModel = watchData['model'] as String;
    String labelName = watchData['label'] as String;
    String watchImage = watchData['image'] as String;
    String watchPrice = watchData['price'] as String;
    String wAvailable = watchData['stock'] as String;

    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          if (index == 0) {
            return const DanielWDetailsPage(watchId: '4');
          } else if (index == 1) {
            return const Tissot1Details(watchId: '5');
          } else if (index == 2) {
            return const SuuntoPage(watchId: '1');
          } else if (index == 3) {
            return const RhythmDetailsPage(watchId: '3');
          }
          return Container();
        })),
        child: Card(
          elevation: 4,
          shadowColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Stack(children: [
                  Image.asset(
                    watchImage,
                    height: 271,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      wAvailable,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(61, 202, 202, 202),
                            Color.fromARGB(255, 157, 188, 240),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[500],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    labelName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    watchModel,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  watchPrice,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<dynamic, String>> watchHighlightsList = [
      {
        'model': 'DW Classic Black',
        'label': 'New',
        'image': 'assets/dw1.jpeg',
        'brand': 'Daniel Wellington',
        'price': 'RM699.00',
        'stock': 'In Stock',
      },
      
      {
        'model': 'T-Classic Everytime',
        'label': 'Best',
        'image': 'assets/tissot1.jpg',
        'brand': 'Tissot',
        'price': 'RM999.00',
        'stock': 'In Stock',
      },

      {
        'model': 'Suunto 5 Peak',
        'label': 'Best',
        'image': 'assets/suunto1.jpeg',
        'brand': 'Suunto',
        'price': 'RM1499.00',
        'stock': '2 left!',
      },
                  
      {
        'model': 'Rhythm F1502R01 Casual',
        'label': 'Best',
        'image': 'assets/rhythm1.jpg',
        'brand': 'Rhythm',
        'price': 'RM799.00',
        'stock': 'In Stock',
      },
    ];

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: watchHighlightsList.length,
        itemBuilder: (BuildContext context, int index) {
          return _watchHighlightsCard(
              context, index, watchHighlightsList[index]);
        },
      ),
    );
  }
}
