import 'package:flutter/foundation.dart';
import '../models/watch_item.dart';

class FavoritesProvider with ChangeNotifier {
  final List<WatchItem> _favorites = [];

  List<WatchItem> get favorites => _favorites;

  void addToFavorites(WatchItem watch) {
    if (!_favorites.any((item) => item.id == watch.id)) {
      _favorites.add(watch);
      notifyListeners();
    }
  }

  void removeFromFavorites(String watchId) {
    _favorites.removeWhere((item) => item.id == watchId);
    notifyListeners();
  }

  bool isFavorite(String watchId) {
    return _favorites.any((item) => item.id == watchId);
  }
}