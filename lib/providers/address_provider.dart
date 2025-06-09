import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider extends ChangeNotifier {
  AddressItem? _billingAddress;
  AddressItem? _shippingAddress;
  final _billingPrefsKey = 'billing_address';
  final _shippingPrefsKey = 'shipping_address';

  AddressProvider() {
    _loadAddresses();
  }

  AddressItem? get billingAddress => _billingAddress;
  AddressItem? get shippingAddress => _shippingAddress;

  void _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final billingJson = prefs.getString(_billingPrefsKey);
    if (billingJson != null) {
      _billingAddress = AddressItem.fromJson(jsonDecode(billingJson));
    }

    final shippingJson = prefs.getString(_shippingPrefsKey);
    if (shippingJson != null) {
      _shippingAddress = AddressItem.fromJson(jsonDecode(shippingJson));
    }

    notifyListeners();
  }

  bool get hasValidAddresses {
    return _billingAddress != null &&
        _shippingAddress != null &&
        _billingAddress!.isValid &&
        _shippingAddress!.isValid;
  }

  bool get hasAnyAddress {
    return _billingAddress != null || _shippingAddress != null;
  }

  void _saveAddress(String key, AddressItem address) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(address.toJson()));
  }

  void setBillingAddress(AddressItem address) {
    _billingAddress = address;
    _saveAddress(_billingPrefsKey, address);
    notifyListeners();
  }

  void setShippingAddress(AddressItem address) {
    _shippingAddress = address;
    _saveAddress(_shippingPrefsKey, address);
    notifyListeners();
  }

  void updateBillingAddress(AddressItem updatedAddress) {
    if (_billingAddress != null) {
      _billingAddress = updatedAddress;
      _saveAddress(_billingPrefsKey, updatedAddress);
      notifyListeners();
    }
  }

  void updateShippingAddress(AddressItem updatedAddress) {
    if (_shippingAddress != null) {
      _shippingAddress = updatedAddress;
      _saveAddress(_shippingPrefsKey, updatedAddress);
      notifyListeners();
    }
  }

  void removeBillingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    _billingAddress = null;
    prefs.remove(_billingPrefsKey);
    notifyListeners();
  }

  void removeShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    _shippingAddress = null;
    prefs.remove(_shippingPrefsKey);
    notifyListeners();
  }
}

class AddressItem {
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final String? email;
  final String? phone;

  AddressItem({
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.email,
    this.phone,
  });

  AddressItem.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        company = json['company'],
        address1 = json['address_1'],
        address2 = json['address_2'],
        city = json['city'],
        state = json['state'],
        postcode = json['postcode'],
        country = json['country'],
        email = json['email'],
        phone = json['phone'];

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'email': email,
      'phone': phone,
    };
  }

  bool get isValid {
    return address1 != null &&
        address1!.isNotEmpty &&
        firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty &&
        city != null &&
        city!.isNotEmpty &&
        state != null &&
        state!.isNotEmpty &&
        postcode != null &&
        postcode!.isNotEmpty &&
        country != null &&
        country!.isNotEmpty;
  }
}
