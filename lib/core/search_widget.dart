import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/filter_provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterWatches);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterWatches);
    _searchController.dispose();
    super.dispose();
  }

  void _filterWatches() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    filterProvider.filterWatches(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onTapOutside: (PointerDownEvent event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              labelText: 'Search Watches',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Filter Options',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: ['Brand', 'Price', 'Feature'].map((category) {
            final options = _getOptionsForCategory(category);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: options.map((option) {
                    final isSelected = filterProvider.isSelected(category, option);
                    return FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        filterProvider.toggleFilter(category, option, selected);
                      },
                      selectedColor: Colors.blueAccent,
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  List<String> _getOptionsForCategory(String category) {
    // Replace with actual logic to get options for each category
    switch (category) {
      case 'Brand':
        return ['Brand A', 'Brand B', 'Brand C'];
      case 'Price':
        return ['\$0-\$100', '\$100-\$200', '\$200+'];
      case 'Feature':
        return ['Feature 1', 'Feature 2', 'Feature 3'];
      default:
        return [];
    }
  }
}