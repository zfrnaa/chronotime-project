import 'package:flutter/material.dart';
import '../data/watch_data.dart';
import '../models/watch_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<WatchItem> _filteredWatches = watchList;

  void _filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWatches = watchList;
      } else {
        _filteredWatches = watchList
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a product...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _filterSearchResults,
            ),
          ),
          Expanded(
            child: _filteredWatches.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: _filteredWatches.length,
                    itemBuilder: (context, i) {
                      final watch = _filteredWatches[i];
                      return ListTile(
                        leading: Image.asset(
                          watch.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(watch.name),
                        subtitle: Text('\$${watch.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
