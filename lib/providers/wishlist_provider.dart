import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  List<WishlistItem> _wishlistItems = [];
  final _prefsKey = 'wishlist_items';

  WishlistProvider() {
    _loadWishlistItems();
  }

  List<WishlistItem> get wishlistItems => _wishlistItems;

  void _loadWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString(_prefsKey);
    if (itemsJson != null) {
      final List<dynamic> itemsData = jsonDecode(itemsJson);
      _wishlistItems =
          itemsData.map((data) => WishlistItem.fromJson(data)).toList();
    }
    notifyListeners();
  }

  void _saveWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = jsonEncode(_wishlistItems);
    prefs.setString(_prefsKey, itemsJson);
  }

  void addItem(WishlistItem item) {
    final itemExists = _wishlistItems.any((existingItem) {
      return existingItem.prodId == item.prodId &&
          existingItem.imageUrl == item.imageUrl &&
          existingItem.name == item.name &&
          existingItem.price == item.price;
    });

    if (!itemExists) {
      _wishlistItems.add(item);
      _saveWishlistItems();
      notifyListeners();
    }
  }

  bool itemExists(WishlistItem item) {
    return _wishlistItems.contains(item);
  }

  void removeItem(WishlistItem item) {
    _wishlistItems.remove(item);
    _saveWishlistItems();
    notifyListeners();
  }

  void removeAll() {
    _wishlistItems.clear();
    _saveWishlistItems();
    notifyListeners();
  }
}

class WishlistItem {
  final int prodId;
  final String imageUrl;
  final String name;
  final double price;

  WishlistItem({
    required this.prodId,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  WishlistItem.fromJson(Map<String, dynamic> json)
      : prodId = json['prodId'],
        imageUrl = json['imageUrl'],
        name = json['name'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    return {
      'prodId': prodId,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WishlistItem &&
        other.prodId == prodId &&
        other.imageUrl == imageUrl &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode {
    return prodId.hashCode ^ imageUrl.hashCode ^ name.hashCode ^ price.hashCode;
  }
}
