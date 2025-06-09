import 'package:decapitalgrille/const/constants.dart';
import 'package:decapitalgrille/providers/address_provider.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _avatar = '';
  String _acTabName = 'Account';
  String _displayName = '';
  String _email = '';
  String _phone = '';
  String _userRole = 'Customer';
  bool _hasBillingShipping = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get hasBillShip => _hasBillingShipping;
  String get avatar => _avatar;
  String get acTabName => _acTabName;
  String get displayName => _displayName;
  String get email => _email;
  String get phone => _phone;
  String get userRole => _userRole;

  Future<void> initAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('token') != null;
    _avatar = prefs.getString('user_avatar_url') ?? '';
    _acTabName = prefs.getString('user_last_name') ?? 'Account';
    _displayName = prefs.getString('user_display_name') ?? '';
    _email = prefs.getString('user_email') ?? '';
    _phone = prefs.getString('user_phone') ?? '';
    _userRole = prefs.getString('user_role') ?? 'Customer';
    _hasBillingShipping = prefs.getBool('has_billing_shipping') ?? false;
    notifyListeners();
  }

  Future<void> updateBillingShipping(AddressProvider addressProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasBillingShipping = addressProvider.hasValidAddresses;
    await prefs.setBool('has_billing_shipping', _hasBillingShipping);
    notifyListeners();
  }

  // Update User Info Dynamically
  Future<void> updateUserInfo({
    String? avatar,
    String? acTabName,
    String? displayName,
    String? email,
    String? phone,
    bool? hasBillingShipping,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (avatar != null) {
      _avatar = avatar;
      await prefs.setString('user_avatar_url', avatar);
    }
    if (acTabName != null) {
      _acTabName = acTabName;
      await prefs.setString('user_last_name', acTabName);
    }
    if (displayName != null) {
      _displayName = displayName;
      await prefs.setString('user_display_name', displayName);
    }
    if (email != null) {
      _email = email;
      await prefs.setString('user_email', email);
    }
    if (phone != null) {
      _phone = phone;
      await prefs.setString('user_phone', phone);
    }
    if (hasBillingShipping != null) {
      _hasBillingShipping = hasBillingShipping;
      await prefs.setBool('has_billing_shipping', hasBillingShipping);
    }

    notifyListeners();
  }

  // Handle login
  Future<void> login({
    required String token,
    required int userId,
    required String avatar,
    required String lastName,
    required String email,
    String? password,
    String? firstName,
    String? displayName,
    String? userRole,
    required BuildContext context,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setInt('user_id', userId);
    await prefs.setString('user_avatar_url', avatar);
    await prefs.setString('user_role', userRole!);
    await prefs.setString('user_display_name', displayName!);
    await prefs.setString('user_first_name', firstName!);
    await prefs.setString('user_last_name', lastName);
    await prefs.setString('user_email', email);
    if (password != null) {
      await prefs.setString('password', password);
    }

    bool hasBillingShipping = false;
    try {
      final WooCustomer userData =
          await woocommerce.getCustomerByIdWithApi(id: userId);

      String? phoneNumber = userData.billing?.phone;

      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        await prefs.setString('user_phone', phoneNumber);
      }
      await prefs.setString('user_role', '${userData.role}');
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      if (userData.billing != null) {
        addressProvider.setBillingAddress(AddressItem(
          firstName: userData.billing?.firstName,
          lastName: userData.billing?.lastName,
          company: userData.billing?.company,
          address1: userData.billing?.address1,
          address2: userData.billing?.address2,
          city: userData.billing?.city,
          state: userData.billing?.state,
          postcode: userData.billing?.postcode,
          country: userData.billing?.country,
          email: userData.billing?.email,
          phone: userData.billing?.phone,
        ));
        hasBillingShipping = true;
      }

      if (userData.shipping != null) {
        addressProvider.setShippingAddress(AddressItem(
          firstName: userData.shipping?.firstName,
          lastName: userData.shipping?.lastName,
          company: userData.shipping?.company,
          address1: userData.shipping?.address1,
          address2: userData.shipping?.address2,
          city: userData.shipping?.city,
          state: userData.shipping?.state,
          postcode: userData.shipping?.postcode,
          country: userData.shipping?.country,
        ));
        hasBillingShipping = true;
      }
    } catch (error) {
      debugPrint('Error fetching customer data: $error');
    }

    _hasBillingShipping = hasBillingShipping;
    await prefs.setBool('has_billing_shipping', hasBillingShipping);

    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    await updateBillingShipping(addressProvider);

    _isLoggedIn = true;
    _avatar = avatar;
    _acTabName = lastName;
    _displayName = displayName;
    _email = email;
    _phone = phone;
    _userRole = userRole;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_avatar_url');
    await prefs.remove('user_last_name');

    await prefs.remove('user_email');
    await prefs.remove('password');
    await prefs.remove('user_nicename');
    await prefs.remove('user_display_name');
    await prefs.remove('user_id');
    await prefs.remove('user_first_name');
    await prefs.remove('user_role');
    await prefs.remove('user_registered');
    await prefs.remove('user_status');
    await prefs.remove('user_activation_key');
    await prefs.remove('has_billing_shipping');

    if (context.mounted) {
      final addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.removeBillingAddress();
      addressProvider.removeShippingAddress();

      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      wishlistProvider.removeAll();
      final cartlistProvider =
          Provider.of<CartlistProvider>(context, listen: false);
      cartlistProvider.removeAll();
    }

    _isLoggedIn = false;
    _avatar = '';
    _acTabName = 'Account';
    _hasBillingShipping = false;
    notifyListeners();
  }
}
