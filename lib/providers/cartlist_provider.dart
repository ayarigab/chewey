import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartlistProvider extends ChangeNotifier {
  List<CartlistItem> _cartlistItems = [];
  final _prefsKey = 'cartlist_items';

  int get totalItemsCount => _cartlistItems.length;
  double get totalPrice => _calculateTotalPrice(_cartlistItems);

  CartlistProvider() {
    _loadCartlistItems();
  }

  List<CartlistItem> get cartlistItems => _cartlistItems;

  void _loadCartlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = prefs.getString(_prefsKey);

    if (itemsJson != null) {
      final List<dynamic> itemsData = jsonDecode(itemsJson);
      _cartlistItems =
          itemsData.map((data) => CartlistItem.fromJson(data)).toList();
    }
    notifyListeners();
  }

  void _saveCartlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = jsonEncode(_cartlistItems);
    prefs.setString(_prefsKey, itemsJson);
  }

  void addItem(CartlistItem item) {
    final itemExists = _cartlistItems.any((existingItem) {
      return existingItem.prodId == item.prodId &&
          existingItem.imageUrl == item.imageUrl &&
          existingItem.name == item.name &&
          existingItem.price == item.price;
    });

    if (!itemExists) {
      _cartlistItems.add(item);
      _saveCartlistItems();
    } else {
      // If the item already exists, just update the count
      final existingItem = _cartlistItems.firstWhere((element) =>
          element.prodId == item.prodId &&
          element.imageUrl == item.imageUrl &&
          element.name == item.name &&
          element.price == item.price);
      existingItem.count += item.count;
    }

    // Update the total items count
    notifyListeners();
  }

  void removeItem(CartlistItem item) {
    final existingItem = _cartlistItems.firstWhere((element) =>
        element.prodId == item.prodId &&
        element.imageUrl == item.imageUrl &&
        element.name == item.name &&
        element.price == item.price);

    if (existingItem.count > 1) {
      existingItem.count -= 1;
    } else {
      _cartlistItems.remove(existingItem);
    }

    // Update the total items count
    _saveCartlistItems();
    notifyListeners();
  }

  void removeAll() {
    _cartlistItems.clear();
    _saveCartlistItems();
    notifyListeners();
  }

  double _calculateTotalPrice(List<CartlistItem> items) {
    return items.fold(0.0, (total, item) {
      return total + (item.price * (item.count));
    });
  }

  int calculateTotalCount(List<CartlistItem> items) {
    int totalCount = 0;
    for (var item in items) {
      totalCount += item.count;
    }
    return totalCount;
  }
}

class CartlistItem {
  final int prodId;
  final String imageUrl;
  final String name;
  final double price;
  int count;

  CartlistItem({
    required this.prodId,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.count = 1,
  });

  CartlistItem.fromJson(Map<String, dynamic> json)
      : prodId = json['prodId'],
        imageUrl = json['imageUrl'],
        name = json['name'],
        price = json['price'],
        count = json['count'] ?? 1;

  Map<String, dynamic> toJson() {
    return {
      'prodId': prodId,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'count': count,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartlistItem &&
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
