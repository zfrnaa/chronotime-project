import 'package:chrono_time/home.dart';
import 'package:flutter/material.dart';

class WatchBrand extends StatelessWidget {
  const WatchBrand({super.key});

  final List<String> brandLogos = const [
    'assets/suuntologo.png',
    'assets/danielwellingtonlogo.jpeg',
    'assets/seikologo.jpg',
    'assets/omega.jpg',
    'assets/casiologo.png',
    'assets/longineslogo.jpg',
    'assets/tagheuerlogo.png',
    'assets/breitlinglogo.jpg',
  ];

  Widget _viewAll(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 500,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('More Brands',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: brandLogos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getImageBrandHome(brandLogos[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text(
        'View all',
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          color: const Color.fromARGB(255, 1, 50, 123),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 4; i++) getImageBrandHome(brandLogos[i]),
              ],
            ),
          ),
        ),
        _viewAll(context),
      ],
    );
  }
}
