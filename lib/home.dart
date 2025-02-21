import 'package:chrono_time/pages/home_content.dart';
import 'package:flutter/material.dart';
import '/menuPage/favourites.dart';
import '/menuPage/bills.dart';
import '/menuPage/order.dart';
import '/menuPage/profile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    FavouritesPage(),
    BillsPage(),
    OrderPage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, index, child) {
        return Scaffold(
          body: _widgetOptions.elementAt(index),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Bills',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: index,
            unselectedItemColor: Colors.black87,
            selectedItemColor: const Color(0xFF0565F5),
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

Widget getImageBrandHome(String imageName) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageName,
            width: 120,
            height: 66,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/image_not_exist.png',
                height: 80,
              ); // Display placeholder on error
            },
          ),
        ),
      ),
    ],
  );
}
