import 'package:flutter/material.dart';
import '../helper/watch_database_helper.dart';

class FilterProvider with ChangeNotifier {
  final Map<String, Set<String>> _selectedFilters = {};
  List<String> _filteredWatchNames = [];

  Map<String, Set<String>> get selectedFilters => _selectedFilters;
  List<String> get filteredWatchNames => _filteredWatchNames;

  FilterProvider() {
    _loadWatchNames();
  }

  Future<void> _loadWatchNames() async {
    final watchItems = await WatchDatabaseHelper().watchItems();
    _filteredWatchNames = watchItems.map((watch) => watch.name).toList();
    notifyListeners();
  }

  void toggleFilter(String category, String option, bool selected) {
    if (!_selectedFilters.containsKey(category)) {
      _selectedFilters[category] = {};
    }

    if (selected) {
      _selectedFilters[category]!.add(option);
    } else {
      _selectedFilters[category]!.remove(option);
    }

    _applyFilters();
  }

  void _applyFilters() async {
    final watchItems = await WatchDatabaseHelper().watchItems();
    _filteredWatchNames = watchItems.where((watch) {
      for (var category in _selectedFilters.keys) {
        if (_selectedFilters[category]!.isNotEmpty &&
            !_selectedFilters[category]!.contains(watch.toMap()[category])) {
          return false;
        }
      }
      return true;
    }).map((watch) => watch.name).toList();
    notifyListeners();
  }

  void filterWatches(String query) async {
    final watchItems = await WatchDatabaseHelper().watchItems();
    _filteredWatchNames = watchItems
        .where((watch) => watch.name.toLowerCase().contains(query.toLowerCase()))
        .map((watch) => watch.name)
        .toList();
    notifyListeners();
  }

  bool isSelected(String category, String option) {
    return _selectedFilters[category]?.contains(option) ?? false;
  }
}