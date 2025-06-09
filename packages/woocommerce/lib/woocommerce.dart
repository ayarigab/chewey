library woocommerce;

import 'dart:async';
import "dart:collection";
import 'dart:convert';
import "dart:core";
import 'dart:developer' as dev;
import 'dart:io';
import "dart:math";

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:quiver/strings.dart';
import 'package:woocommerce/models/cart_details_payload.dart';
import 'package:woocommerce/models/cart_totals.dart';
import 'package:woocommerce/models/checkout.dart';
import 'package:woocommerce/models/woo_points.dart';

import 'constants/constants.dart';
import 'models/cart.dart';
import 'models/cart_item.dart';
import 'models/country.model.dart';
import 'models/coupon.dart';
import 'models/customer.dart';
import 'models/customer_download.dart';
// import 'models/jwt_response.dart';
import 'models/order.dart' hide LineItems;
import 'models/order_payload.dart';
import 'models/payment_gateway.dart';
import 'models/product_attribute_term.dart';
import 'models/product_attributes.dart';
import 'models/product_category.dart';
import 'models/product_review.dart';
import 'models/product_shipping_class.dart';
import 'models/product_tag.dart';
import 'models/product_variation.dart';
import 'models/products.dart';
import 'models/shipping_method.dart';
import 'models/shipping_zone.dart';
import 'models/shipping_zone_location.dart';
import 'models/shipping_zone_method.dart';
//import 'models/shipping_zone_method.dart';
import 'models/tax_classes.dart';
import 'models/tax_rate.dart';
import 'models/user.dart';
import 'utilities/local_db.dart';
import 'woocommerce_error.dart';

export 'models/cart.dart' show WooCart;
export 'models/cart_item.dart' show WooCartItem;
export 'models/checkout.dart';
export 'models/coupon.dart' show WooCoupon;
export 'models/customer.dart' show WooCustomer;
export 'models/jwt_response.dart' show WooJWTResponse;
export 'models/order.dart' show WooOrder;
export 'models/order_payload.dart' show WooOrderPayload;
export 'models/perfect_woocommerce_brands.dart';
export 'models/product_attribute_term.dart' show WooProductAttributeTerm;
export 'models/product_attributes.dart' show WooProductAttribute;
export 'models/product_category.dart' show WooProductCategory;
export 'models/product_review.dart' show WooProductReview;
export 'models/product_shipping_class.dart' show WooProductShippingClass;
export 'models/product_tag.dart' show WooProductTag;
export 'models/product_variation.dart' show WooProductVariation;
export 'models/products.dart';
export 'models/shipping_method.dart' show WooShippingMethod;
export 'models/shipping_zone.dart' show WooShippingZone;
export 'models/shipping_zone_location.dart' show WooShippingZoneLocation;
export 'models/shipping_zone_method.dart' show WooShippingZoneMethod;
export 'models/tax_classes.dart' show WooTaxClass;
export 'models/tax_rate.dart' show WooTaxRate;
export 'models/taxonomy_query.dart' show WooProductTaxonomyQuery;
export 'models/user.dart' show WooUser;
export 'models/vendor.dart' show Vendor;
export 'woocommerce_error.dart' show WooCommerceError;

class WooCommerce {
  /// The base url of your site.
  late String baseUrl;

  /// Consumer key provided by wooCommerce
  String? consumerKey;

  /// Consumer secret provided by wooCommerce
  String? consumerSecret;

  /// Flag to check if the url is HTTPS compliant or not
  bool? isHttps;

  /// The api path to woocommerce installation. Provide it if you have changed
  /// the default api path
  late String apiPath;

  /// Flag to toggle logs in the console while developing
  late bool printLogs;

  /// The cookie which is stored for the user.
  String? userCookie;

  WooCommerce({
    required this.baseUrl,
    required this.consumerKey,
    required this.consumerSecret,
    this.apiPath = DEFAULT_WC_API_PATH,
    this.printLogs = false,
  }) {
    if (baseUrl.startsWith("https")) {
      isHttps = true;
    } else {
      isHttps = false;
    }

    // set the user cookie if available
    _loadCookieFromDatabase();
    _loadAuthTokenFromDatabase();
  }

  void _printToLog(String message) {
    if (printLogs) {
      dev.log("WooCommerce Log : $message", name: 'WooCommerce Package');
    }
  }

  String? _authToken;

  String? get authToken => _authToken;

  Uri? queryUri;

  String get apiResourceUrl => queryUri.toString();

  // Header to be sent for JWT auth
  final Map<String, String> _urlHeader = {'Authorization': ''};

  String get urlHeader => _urlHeader['Authorization'] = 'Bearer ${authToken!}';

  final LocalDatabaseService _localDbService = LocalDatabaseService();

  /// Loads the cookie from the database and set it on the main class
  /// variable
  Future<void> _loadCookieFromDatabase() async {
    userCookie = await _localDbService.getUserCookie();
  }

  /// Loads the auth token from the database and set it on the main class
  /// variable
  Future<void> _loadAuthTokenFromDatabase() async {
    _authToken = await _localDbService.getSecurityToken();
  }

  /// Authenticates the user using WordPress JWT authentication and returns the access [_token] string.
  ///
  /// Associated endpoint : example.com/wp-json/jwt-auth/v1/token
  // Future<String?> authenticateViaJWT({String? email, String? password}) async {
  //   final body = {
  //     'username': email,
  //     'password': password,
  //   };

  //   final response = await http.post(
  //     Uri.parse(baseUrl + URL_JWT_TOKEN),
  //     body: body,
  //     headers: {
  //       HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
  //     },
  //   );

  //   print('Body: ${response.body}');

  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     try {
  //       WooJWTResponse authResponse =
  //           WooJWTResponse.fromJson(json.decode(response.body));
  //       _authToken = authResponse.token;
  //       _localDbService.updateSecurityToken(_authToken);
  //       _urlHeader['Authorization'] = 'Bearer ${authResponse.token}';
  //       return _authToken;
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     throw WooCommerceError.fromJson(json.decode(response.body));
  //   }
  //   return null;
  // }

  Future<String?> authenticateViaJWT({String? email, String? password}) async {
    final body = {
      'username': email,
      'password': password,
    };
    final response = await http.post(
      Uri.parse(baseUrl + URL_JWT_TOKEN),
      body: body,
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
    );
    print('Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      throw WooCommerceError.fromJson(json.decode(response.body));
    }
  }

  /// Authenticates the user via JWT and returns a WooCommerce customer object
  /// of the current logged in customer.
  Future<WooCustomer?> loginCustomer({
    required String email,
    required String password,
  }) async {
    // WooCustomer customer;
    try {
      return await _authenticate(email: email, password: password);
    } catch (_) {
      rethrow;
    }
  }

  /// Authenticates the user
  Future<WooCustomer?> _authenticate({String? email, String? password}) async {
    try {
      final http.Response response = await http.post(
          Uri.parse(
              "$baseUrl/wp-json/woostore_pro_api/flutter_user/authenticate/"),
          body: jsonEncode({
            "email": email,
            "password": password,
          }));

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          body['cookie'] != null &&
          body['jwt_token'] != null) {
        // Set the cookie
        userCookie = body['cookie'];
        await _localDbService.updateUserCookie(body['cookie']);

        // Set the auth token
        if (body['jwt_token'] is String) {
          _authToken = body['jwt_token'];
          await _localDbService.updateSecurityToken(body['jwt_token']);
        }

        WooCustomer? customer;
        if (body['user'] != null) {
          customer = WooCustomer.fromJson(body['user']);
        }

        return customer;
      } else {
        throw Exception(
            body['message'] ?? "Could not authenticate please try again.");
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Login with google
  Future<WooCustomer> loginGoogle({String? token}) async {
    try {
      final endPoint = Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/flutter_user/google_login/?access_token=$token");

      final response = await http.get(endPoint);

      final decoded = jsonDecode(response.body);

      if (decoded['user'] == null || decoded["cookie"] == null) {
        throw Exception(decoded['message']);
      }

      // Update the cookie
      userCookie = decoded['cookie'];
      await _localDbService.updateUserCookie(decoded['cookie']);

      // Set the auth token
      if (decoded['jwt_token'] is String) {
        _authToken = decoded['jwt_token'];
        await _localDbService.updateSecurityToken(decoded['jwt_token']);
      }

      return WooCustomer.fromJson(decoded['user']);
    } catch (_) {
      rethrow;
    }
  }

  /// Login with apple
  Future<WooCustomer> loginApple(
      {required String email, String? fullName}) async {
    try {
      var endPoint = Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/flutter_user/apple_login?email=$email&display_name=$fullName&user_name=${email.split("@")[0]}");

      var response = await http.get(endPoint);

      var decoded = jsonDecode(response.body);

      if (decoded['user'] == null || decoded["cookie"] == null) {
        throw Exception(decoded['message']);
      }

      // Update the cookie
      userCookie = decoded['cookie'];
      await _localDbService.updateUserCookie(decoded['cookie']);

      // Set the auth token
      if (decoded['jwt_token'] is String) {
        _authToken = decoded['jwt_token'];
        await _localDbService.updateSecurityToken(decoded['jwt_token']);
      }

      return WooCustomer.fromJson(decoded['user']);
    } catch (_) {
      rethrow;
    }
  }

  /// Login with phone
  Future<WooCustomer> loginPhone({
    String? phone,
    String? countryCode,
    String? phoneNumber,
    bool useDigitsPlugin = false,
  }) async {
    try {
      if (phone == null || isBlank(phone)) {
        throw Exception('Phone number value cannot be empty');
      }

      final endPoint = Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/flutter_user/phone_login");

      final headers = {'Content-Type': 'application/json'};
      final bodyData = jsonEncode({
        'phone': phone,
        'country_code': countryCode,
        'phone_number': phoneNumber,
        'use_digits_plugin': useDigitsPlugin,
      });

      final response = await http.post(
        endPoint,
        body: bodyData,
        headers: headers,
      );

      final decoded = jsonDecode(response.body);

      if (decoded['user'] == null || decoded["cookie"] == null) {
        throw Exception(decoded['message']);
      }

      // Update the cookie
      userCookie = decoded['cookie'];
      await _localDbService.updateUserCookie(decoded['cookie']);

      // Set the auth token
      if (decoded['jwt_token'] is String) {
        _authToken = decoded['jwt_token'];
        await _localDbService.updateSecurityToken(decoded['jwt_token']);
      }

      return WooCustomer.fromJson(decoded['user']);
    } catch (_) {
      rethrow;
    }
  }

  /// Creates an authentication cookie.
  Future<String?> generateAuthCookie({String? email, String? password}) async {
    try {
      final http.Response response = await http.post(
          Uri.parse(
              "$baseUrl/wp-json/woostore_pro_api/flutter_user/generate_auth_cookie/"),
          body: jsonEncode({
            "email": email,
            "password": password,
          }));

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['cookie'] != null) {
        // Set the cookie
        userCookie = body['cookie'];
        await _localDbService.updateUserCookie(body['cookie']);
        return body['cookie'];
      } else {
        throw Exception(
            body['message'] ?? "Could not authenticate please login again.");
      }
    } catch (_) {
      rethrow;
    }
  }

  /// Confirm if a customer is logged in [true] or out [false].
  Future<bool> isCustomerLoggedIn() async {
    if ((authToken == null || authToken!.isEmpty || authToken == '0') &&
        (userCookie == null || userCookie!.isEmpty)) {
      // try again to get the variables
      await _loadAuthTokenFromDatabase();
      await _loadCookieFromDatabase();
      if ((authToken == null || authToken == '0' || authToken!.isEmpty) &&
          (userCookie == null || userCookie!.isEmpty)) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  /// Fetches already authenticated user, using Jwt
  ///
  /// Associated endpoint : /wp-json/wp/v2/users/me
  Future<int?> fetchLoggedInUserId() async {
    _authToken = await _localDbService.getSecurityToken();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';
    final response =
        await http.get(Uri.parse(baseUrl + URL_USER_ME), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      if (jsonStr.length == 0) {
        throw WooCommerceError(
            code: 'wp_empty_user',
            message: "No user found or you dont have permission");
      }
      _printToLog('account user fetch : $jsonStr');
      return jsonStr['id'];
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// Log User out
  ///
  Future<void> logUserOut() async {
    await _localDbService.deleteSecurityToken();
    await _localDbService.deleteUserCookie();
  }

  /// Creates a new Wordpress user and returns whether action was successful
  /// or not using WP Rest User Wordpress plugin.
  ///
  /// Associated endpoint : /register .
  Future<bool> registerNewWpUser({required WooUser user}) async {
    String url = baseUrl + URL_REGISTER_ENDPOINT;

    http.Client client = http.Client();
    http.Request request = http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(user.toJson());
    String response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    _printToLog('registerNewUser response : $dataResponse');
    if (dataResponse['data'] == null) {
      return true;
    } else {
      throw Exception(WooCommerceError.fromJson(dataResponse).toString());
    }
  }

  /// Creates a new Woocommerce Customer and returns the customer object.
  ///
  /// Accepts a customer object as required parameter.
  Future<WooCustomer?> createCustomer(WooCustomer customer) async {
    _printToLog('Creating Customer With info : $customer');
    _setApiResourceUrl(path: 'customers');
    final response = await post(queryUri.toString(), customer.toJson());
    _printToLog('created customer : $response');
    return WooCustomer.fromJson(response);
  }

  /// Creates a new Woocommerce Customer and returns the customer object.
  ///
  /// Accepts a customer object as required parameter.
  Future<WooCustomer> createCustomerWithApi(
    WooCustomer customer,

    /// Use this to add new data while creating user
    /// without changing the old code
    Map<String, dynamic>? extraData,
  ) async {
    final http.Response response = await http.post(
        Uri.parse("$baseUrl/wp-json/woostore_pro_api/flutter_user/sign_up/"),
        body: jsonEncode({
          "first_name": customer.firstName,
          "last_name": customer.lastName,
          "user_pass": customer.password,
          "user_email": customer.email,
          "user_login": customer.username,
          "user_nicename": '${customer.firstName} ${customer.lastName}',
          "display_name": customer.firstName,
          "phone": customer.phone,
          if (extraData != null) "extra_data": extraData,
        }));
    var body = jsonDecode(response.body);
    if (response.statusCode == 200 && body["message"] == null) {
      var cookie = body['cookie'];
      _localDbService.updateUserCookie(cookie);

      if (body['jwt_token'] != null) {
        _authToken = body['jwt_token'];
        _localDbService.updateSecurityToken(body['jwt_token']);
      }
      return WooCustomer(
        id: body['user_id'],
        firstName: customer.firstName,
        lastName: customer.lastName,
        email: customer.email,
      );
    } else {
      var message = body["message"];
      throw Exception(message ?? "Can not create the user.");
    }
  }

  /// Get the user cookie saved while creating the user.
  Future<String> getUserCookie() async {
    return await _localDbService.getUserCookie();
  }

  /// Returns a list of all [WooCustomer], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#customers
  Future<List<WooCustomer>> getCustomers(
      {int? page,
      int? perPage,
      String? search,
      List<int>? exclude,
      List<int>? include,
      int? offset,
      String? order,
      String? orderBy,
      //String email,
      String? role}) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page, 'per_page': perPage, 'search': search,
      'exclude': exclude, 'include': include, 'offset': offset,
      'order': order, 'orderby': orderBy, //'email': email,
      'role': role,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });

    List<WooCustomer> customers = [];
    _setApiResourceUrl(path: 'customers', queryParameters: payload);

    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    for (var c in response) {
      var customer = WooCustomer.fromJson(c);
      _printToLog('customers here : $customer');
      customers.add(customer);
    }
    return customers;
  }

  /// Returns a [WooCustomer], whoose [id] is specified.
  Future<WooCustomer> getCustomerById({required int id}) async {
    WooCustomer customer;
    _setApiResourceUrl(
      path: 'customers/$id',
    );
    final response = await get(queryUri.toString());
    customer = WooCustomer.fromJson(response);
    return customer;
  }

  /// Returns a [WooCustomer], whoose [id] is specified.
  Future<WooCustomer> getCustomerByIdWithApi({required int id}) async {
    final http.Response response = await http.post(
      Uri.parse("$baseUrl/wp-json/woostore_pro_api/flutter_user/get_user"),
      body: jsonEncode({'user_id': id}),
      headers: {'Content-Type': 'application/json'},
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return WooCustomer.fromJson(body as Map<String, dynamic>);
    } else {
      throw WooCommerceError.fromJson(body as Map<String, dynamic>);
    }
  }

  /// Returns a list of all [WooCustomerDownload], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#customers
  Future<List<WooCustomerDownload>> getCustomerDownloads(
      {required int customerId}) async {
    List<WooCustomerDownload> customerDownloads = [];
    _setApiResourceUrl(path: 'customers/$customerId/downloads');

    final response = await get(queryUri.toString());
    _printToLog('getting customer downloads : $response');
    for (var d in response) {
      var download = WooCustomerDownload.fromJson(d);
      _printToLog('download gotten here : $download');
      customerDownloads.add(download);
    }
    return customerDownloads;
  }

  /// Updates an existing Customer and returns the [WooCustomer] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#customer-properties.

  Future<WooCustomer> oldUpdateCustomer(
      {required WooCustomer wooCustomer}) async {
    _printToLog('Updating customer With customerId : ${wooCustomer.id}');
    _setApiResourceUrl(
      path: 'customers/${wooCustomer.id}',
    );
    final response = await put(queryUri.toString(), wooCustomer.toJson());
    return WooCustomer.fromJson(response);
  }

  // Future<WooCustomer> updateCustomer({required int id, Map? data}) async {
  //   print('Updating customer With customerId : $id');
  //   _setApiResourceUrl(
  //     path: 'customers/$id',
  //   );
  //   final response = await put(queryUri.toString(), data);
  //   print(response);
  //   return WooCustomer.fromJson(response);
  // }

  Future<WooCustomer> updateCustomer({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/wp-json/wc/v3/customers/$id');

    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return WooCustomer.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update customer');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<WooCustomer> updateCustomerWithApi(
      {required id, Map? data, String? userCookie}) async {
    if (data == null) {
      throw Exception('Customer data cannot be null');
    }

    userCookie ??= await _localDbService.getUserCookie();

    final http.Response response = await http.post(
      Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/flutter_user/update_user_data/"),
      body: jsonEncode({
        ...data,
        'cookie': userCookie,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return WooCustomer.fromJson(body as Map<String, dynamic>);
    } else {
      throw WooCommerceError.fromJson(body as Map<String, dynamic>);
    }
  }

  Future<bool> updatePasswordWithApi({
    required id,
    Map? data,
  }) async {
    if (data == null) {
      throw Exception('Data cannot be null');
    }

    userCookie ??= await _localDbService.getUserCookie();

    final http.Response response = await http.post(
      Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/flutter_user/change_password/"),
      body: jsonEncode({
        ...data,
        'cookie': userCookie,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 &&
        body['message'] == null &&
        body['cookie'] != null &&
        body['jwt_token'] != null) {
      if (body['cookie'] == null) {
        throw Exception(
            'Your password was reset but something went wrong. Please login again.');
      } else {
        userCookie = body['cookie'];
        await _localDbService.updateUserCookie(body['cookie']);

        if (body['jwt_token'] is String) {
          _authToken = body['jwt_token'];
          await _localDbService.updateSecurityToken(body['jwt_token']);
        }

        print('this is cookie $userCookie');
        print('this is auth token $authToken');

        return true;
      }
    } else {
      throw WooCommerceError.fromJson(body);
    }
  }

  /// The data map should consist the following keys:
  ///
  /// - [password]
  /// - [old_password]
  /// - [email]
  ///
  Future<bool> updatePasswordWithApiV2({
    Map<String, dynamic>? data,
  }) async {
    if (data == null) {
      throw Exception('Data cannot be null');
    }

    final http.Response response = await http.post(
      Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/flutter_user/change_password_v2"),
      body: jsonEncode(data),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 &&
        body['message'] == null &&
        body['cookie'] != null &&
        body['jwt_token'] != null) {
      if (body['cookie'] == null) {
        throw Exception(
            'Your password was reset but something went wrong. Please login again.');
      } else {
        userCookie = body['cookie'];
        await _localDbService.updateUserCookie(body['cookie']);

        if (body['jwt_token'] is String) {
          _authToken = body['jwt_token'];
          await _localDbService.updateSecurityToken(body['jwt_token']);
        }

        print('this is cookie $userCookie');
        print('this is auth token $authToken');

        return true;
      }
    } else {
      throw WooCommerceError.fromJson(body);
    }
  }

  /// Deletes an existing Customer and returns the [WooCustomer] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#customer-properties.

  Future<WooCustomer> deleteCustomer(
      {required int customerId, reassign}) async {
    Map data = {
      'force': true,
    };
    if (reassign != null) data['reassign'] = reassign;
    _printToLog('Deleting customer With customerId : $customerId');
    _setApiResourceUrl(
      path: 'customers/$customerId',
    );
    final response = await delete(queryUri.toString(), data);
    return WooCustomer.fromJson(response);
  }

  /// Returns a list of all [WooProduct], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#products.
  Future<List<WooProduct>> getProducts({
    int? page,
    int? perPage,
    String? search,
    String? after,
    String? before,
    String? order,
    String? orderBy,
    String? slug,
    String? status = 'publish',
    String? type,
    String? sku,
    String? category,
    String? tag,
    String? shippingClass,
    String? attribute,
    String? attributeTerm,
    String? taxClass,
    String? minPrice,
    String? maxPrice,
    String? stockStatus,
    List<int>? exclude,
    List<int>? parentExclude,
    List<int>? include,
    List<int>? parent,
    int? offset,
    bool? featured,
    bool? onSale,
    String? taxonomyQuery,
    String? lang,
    Map<String, dynamic> extraParams = const {},
  }) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'after': after,
      'before': before,
      'exclude': exclude,
      'include': include,
      'offset': offset,
      'order': order,
      'orderby': orderBy,
      'parent': parent,
      'parent_exclude': parentExclude,
      'slug': slug,
      'status': status,
      'type': type,
      'sku': sku,
      'featured': featured,
      'category': category,
      'tag': tag,
      'shipping_class': shippingClass,
      'attribute': attribute,
      'attribute_term': attributeTerm,
      'tax_class': taxClass,
      'on_sale': onSale,
      'min_price': minPrice,
      'max_price': maxPrice,
      'stock_status': stockStatus,
      'taxonomy_query': taxonomyQuery,
      'lang': lang,
      ...extraParams
    }).forEach((k, v) {
      // OLD METHOD
      // if(v!=null)payload[k] = v;

      // NEW METHOD
      if (v != null) {
        if (v.runtimeType == String && v == 'null') {
          // do nothing
        } else {
          payload[k] = v;
        }
      }
    });
    _printToLog("Parameters: $payload");
    List<WooProduct> products = [];
    _setApiResourceUrl(path: 'products', queryParameters: payload);
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    _printToLog('this is the queri uri : $queryUri');
    for (var p in response) {
      var prod = WooProduct.fromJson(p);
      _printToLog('product gotten here : ${prod.name}');
      products.add(prod);
    }
    return products;
  }

  /// Returns a [WooProduct], with the specified [id].
  Future<WooProduct> getProductById({required int id}) async {
    WooProduct product;
    _setApiResourceUrl(
      path: 'products/$id',
    );
    final response = await get(queryUri.toString());
    product = WooProduct.fromJson(response);
    return product;
  }

  /// Returns a list of all [WooProductVariation], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-variations
  Future<List<WooProductVariation>> getProductVariations(
      {required int productId,
      int? page,
      int? perPage,
      String? search,
      String? after,
      String? before,
      List<int>? exclude,
      List<int>? include,
      int? offset,
      String? order,
      String? orderBy,
      List<int>? parent,
      List<int>? parentExclude,
      String? slug,
      String? status = 'publish',
      String? sku,
      String? taxClass,
      bool? onSale,
      String? minPrice,
      String? maxPrice,
      String? stockStatus}) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'after': after,
      'before': before,
      'exclude': exclude,
      'include': include,
      'offset': offset,
      'order': order,
      'orderby': orderBy,
      'parent': parent,
      'parent_exclude': parentExclude,
      'slug': slug,
      'status': status,
      'sku': sku,
      'tax_class': taxClass,
      'on_sale': onSale,
      'min_price': minPrice,
      'max_price': maxPrice,
      'stock_status': stockStatus,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooProductVariation> productVariations = [];
    _setApiResourceUrl(
        path: 'products/$productId/variations', queryParameters: payload);
    _printToLog('this is the curent path : $apiPath');
    final response = await get(queryUri.toString());
    for (var v in response) {
      var prodv = WooProductVariation.fromJson(v);
      _printToLog('prod gotten here : $prodv');
      productVariations.add(prodv);
    }
    return productVariations;
  }

  /// Returns a [WooProductVariation], with the specified [productId] and [variationId].

  Future<WooProductVariation> getProductVariationById(
      {required int productId, variationId}) async {
    WooProductVariation productVariation;
    _setApiResourceUrl(
      path: 'products/$productId/variations/$variationId',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');

    productVariation = WooProductVariation.fromJson(response);
    return productVariation;
  }

  /// Returns a List[WooProductVariation], with the specified [productId] only.

  Future<List<WooProductVariation>> getProductVariationsByProductId(
      {required int productId}) async {
    List<WooProductVariation> productVariations = [];
    _setApiResourceUrl(path: 'products/$productId/variations/');
    final response = await get(queryUri.toString());

    for (var v in response) {
      var prodv = WooProductVariation.fromJson(v);
      _printToLog('prod gotten here : $prodv');
      productVariations.add(prodv);
    }
    return productVariations;
  }

  /// Returns a list of all [WooProductAttribute].
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-attributes

  Future<List<WooProductAttribute>> getProductAttributes() async {
    List<WooProductAttribute> productAttributes = [];
    _setApiResourceUrl(
      path: 'products/attributes',
    );
    final response = await get(queryUri.toString());
    for (var a in response) {
      var att = WooProductAttribute.fromJson(a);
      _printToLog('prod gotten here : $att');
      productAttributes.add(att);
    }
    return productAttributes;
  }

  /// Returns a [WooProductAttribute], with the specified [attributeId].

  Future<WooProductAttribute> getProductAttributeById(
      {required int attributeId}) async {
    WooProductAttribute productAttribute;
    _setApiResourceUrl(
      path: 'products/attributes/$attributeId',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');

    productAttribute = WooProductAttribute.fromJson(response);
    return productAttribute;
  }

  /// Returns a list of all [WooProductAttributeTerm], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-attribute-terms
  Future<List<WooProductAttributeTerm>> getProductAttributeTerms(
      {required int attributeId,
      int? page,
      int? perPage,
      String? search,
      List<int>? exclude,
      List<int>? include,
      String? order,
      String? orderBy,
      bool? hideEmpty,
      int? parent,
      int? product,
      String? slug}) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'exclude': exclude,
      'include': include,
      'order': order,
      'orderby': orderBy,
      'hide_empty': hideEmpty,
      'parent': parent,
      'product': product,
      'slug': slug,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooProductAttributeTerm> productAttributeTerms = [];
    _setApiResourceUrl(
        path: 'products/attributes/$attributeId/terms',
        queryParameters: payload);
    final response = await get(queryUri.toString());
    for (var t in response) {
      var term = WooProductAttributeTerm.fromJson(t);
      _printToLog('term gotten here : $term');
      productAttributeTerms.add(term);
    }
    return productAttributeTerms;
  }

  /// Returns a [WooProductAttributeTerm], with the specified [attributeId] and [termId].

  Future<WooProductAttributeTerm> getProductAttributeTermById(
      {required int attributeId, termId}) async {
    WooProductAttributeTerm productAttributeTerm;
    _setApiResourceUrl(
      path: 'products/attributes/$attributeId/terms/$termId',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');

    productAttributeTerm = WooProductAttributeTerm.fromJson(response);
    return productAttributeTerm;
  }

  /// Returns a list of all [WooProductCategory], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-categories

  Future<List<WooProductCategory>> getProductCategories({
    int? page,
    int? perPage,
    String? search,
    List<int>? exclude,
    List<int>? include,
    String? order,
    String? orderBy,
    bool? hideEmpty,
    int? parent,
    int? product,
    String? slug,
    String? lang,
  }) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'exclude': exclude,
      'include': include,
      'order': order,
      'orderby': orderBy,
      'hide_empty': hideEmpty,
      'parent': parent,
      'product': product,
      'slug': slug,
      'lang': lang,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });

    List<WooProductCategory> productCategories = [];
    _printToLog('payload : $payload');
    _setApiResourceUrl(path: 'products/categories', queryParameters: payload);
    _printToLog('this is the path : $apiPath');
    final response = await get(queryUri.toString());
    for (var c in response) {
      var cat = WooProductCategory.fromJson(c);
      _printToLog('category gotten here : $cat');
      productCategories.add(cat);
    }
    return productCategories;
  }

  /// Returns a [WooProductCategory], with the specified [categoryId].

  Future<WooProductCategory> getProductCategoryById(
      {required int categoryId}) async {
    WooProductCategory productCategory;
    _setApiResourceUrl(
      path: 'products/categories/$categoryId',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    productCategory = WooProductCategory.fromJson(response);
    return productCategory;
  }

  /// Returns a list of all [WooProductShippingClass], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-shipping-classes
  Future<List<WooProductShippingClass>> getProductShippingClasses(
      {int? page,
      int? perPage,
      String? search,
      List<int>? exclude,
      List<int>? include,
      int? offset,
      String? order,
      String? orderBy,
      bool? hideEmpty,
      int? product,
      String? slug}) async {
    Map<String, dynamic> payload = {};
    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'exclude': exclude,
      'include': include,
      'offset': offset,
      'order': order,
      'orderby': orderBy,
      'hide_empty': hideEmpty,
      'product': product,
      'slug': slug,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooProductShippingClass> productShippingClasses = [];
    _setApiResourceUrl(
      path: 'products/shipping_classes',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    for (var c in response) {
      var sClass = WooProductShippingClass.fromJson(c);
      _printToLog('prod gotten here : $sClass');
      productShippingClasses.add(sClass);
    }
    return productShippingClasses;
  }

  /// Returns a [WooProductShippingClass], with the specified [id].

  Future<WooProductShippingClass> getProductShippingClassById(
      {required int id}) async {
    WooProductShippingClass productShippingClass;
    _setApiResourceUrl(
      path: 'products/shipping_classes/$id',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    productShippingClass = WooProductShippingClass.fromJson(response);
    return productShippingClass;
  }

  /// Returns a list of all [ProductTag], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-tags
  Future<List<WooProductTag>> getProductTags({
    int? page,
    int? perPage,
    String? search,
    //List<int> exclude,
    //List<int> include,
    int? offset,
    String? order,
    String? orderBy,
    bool? hideEmpty,
    int? product,
    String? slug,
    String? lang,
  }) async {
    Map<String, dynamic> payload = {};
    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'offset': offset,
      'order': order,
      'orderby': orderBy,
      'hide_empty': hideEmpty,
      'product': product,
      'slug': slug,
      'lang': lang,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooProductTag> productTags = [];
    _printToLog('making request with payload : $payload');
    _setApiResourceUrl(path: 'products/tags', queryParameters: payload);
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    for (var c in response) {
      var tag = WooProductTag.fromJson(c);
      _printToLog('prod gotten here : $tag');
      productTags.add(tag);
    }
    return productTags;
  }

  /// Returns a [WooProductTag], with the specified [id].

  Future<WooProductTag> getProductTagById({required int id}) async {
    WooProductTag productTag;
    _setApiResourceUrl(
      path: 'products/tags/$id',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    productTag = WooProductTag.fromJson(response);
    return productTag;
  }

  /// Creates a Review for the product with the WooStore Pro Api
  Future<WooProductReview> createProductReviewWithApi({
    required int productId,
    required String reviewer,
    required String reviewerEmail,
    required String review,
    int? rating,
    bool? verified,
    List<String>? images,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
        Uri.parse(
            "$baseUrl/wp-json/woostore_pro_api/flutter_products/create-review"),
        headers: headers,
        body: jsonEncode({
          'product_id': productId,
          'reviewer': reviewer,
          'reviewer_email': reviewerEmail,
          'review': review,
          'rating': rating,
          'verified': verified ?? false,
          'jwt': authToken,
          if (images != null) 'images': images,
        }));
    final body = jsonDecode(response.body);
    print(body);
    if (body is! Map<String, dynamic>) {
      throw Exception(body);
    }
    if (response.statusCode == 201 || response.statusCode == 200) {
      return WooProductReview.fromJson(body);
    } else {
      throw Exception(body['message']);
    }
  }

  /// Returns a  [WooProductReview] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-reviews
  Future<WooProductReview> createProductReview(
      {required int productId,
      int? status,
      required String reviewer,
      required String reviewerEmail,
      required String review,
      int? rating,
      bool? verified}) async {
    Map<String, dynamic> payload = {};

    ({
      'product_id': productId,
      'status': status,
      'reviewer': reviewer,
      'reviewer_email': reviewerEmail,
      'review': review,
      'rating': rating,
      'verified': verified,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });

    WooProductReview productReview;
    _setApiResourceUrl(
      path: 'products/reviews',
    );
    final response = await post(queryUri.toString(), payload);
    _printToLog('response gotten : $response');
    productReview = WooProductReview.fromJson(response);
    return productReview;
  }

  /// Returns a list of all [WooProductReview], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-reviews
  Future<List<WooProductReview>> getProductReviews(
      {int? page,
      int? perPage,
      String? search,
      String? after,
      String? before,
      //List<int> exclude,
      //List<int> include,
      int? offset,
      String? order,
      String? orderBy,
      List<int>? reviewer,
      //List<int> reviewerExclude,
      //List<String> reviewerEmail,
      List<int>? product,
      String? status}) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page, 'per_page': perPage, 'search': search,
      'after': after, 'before': before,
      //'exclude': exclude, 'include': include,
      'offset': offset,
      'order': order, 'orderby': orderBy,
      'reviewer': reviewer,
      //'reviewer_exclude': reviewerExclude, 'reviewer_email': reviewerEmail,
      'product': product,
      'status': status,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    String meQueryPath = 'products/reviews?${getQueryString(payload)}';
    List<WooProductReview> productReviews = [];
    // _setApiResourceUrl(path: 'products/reviews', queryParameters: payload);
    final response = await get(meQueryPath);
    _printToLog('response gotten : $response');
    for (var r in response) {
      var rev = WooProductReview.fromJson(r);
      _printToLog('reviews gotten here : $rev');
      productReviews.add(rev);
    }
    return productReviews;
  }

  /// Returns a [WooProductReview], with the specified [reviewId].
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-reviews

  Future<WooProductReview> getProductReviewById({required int reviewId}) async {
    WooProductReview productReview;
    _setApiResourceUrl(
      path: 'products/reviews/$reviewId',
    );
    final response = await get(queryUri.toString());
    _printToLog('response gotten : $response');
    productReview = WooProductReview.fromJson(response);
    return productReview;
  }

  /// Updates an existing Product Review and returns the [WooProductReview] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-reviews

  Future<WooProductReview> updateProductReview(
      {required WooProductReview productReview}) async {
    _printToLog('Updating product review With reviewId : ${productReview.id}');
    _setApiResourceUrl(
      path: 'products/reviews/${productReview.id}',
    );
    final response = await put(queryUri.toString(), productReview.toJson());
    return WooProductReview.fromJson(response);
  }

  /// Deletes an existing Product Review and returns the [WooProductReview] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#product-reviews

  Future<WooProductReview> deleteProductReview({required int reviewId}) async {
    Map data = {
      'force': true,
    };
    _printToLog('Deleting product review With reviewId : $reviewId');
    _setApiResourceUrl(
      path: 'products/review/$reviewId',
    );
    final response = await delete(queryUri.toString(), data);
    return WooProductReview.fromJson(response);
  }

  /**
      /// Accepts an int [id] of a product or product variation, int quantity, and an array of chosen variation attribute objects
      /// Related endpoint : wc/store/cart
      Future<WooCartItem>addToCart({@required int itemId, @required int quantity, List<WooProductVariation> variations}) async{
      Map<String, dynamic> data = {
      'id': itemId,
      'quantity' : quantity,
      };
      if(variations!=null) data['variations'] = variations;
      _setApiResourceUrl(path: 'cart/items', isShop: true);
      final response = await post(queryUri.toString(), data,);
      return WooCartItem.fromJson(response);
      }
   */

  /// Accepts an int [id] of a product or product variation, int quantity, and an array of chosen variation attribute objects
  /// Related endpoint : wc/store/cart
  ///

  Future<WooCartItem> addToMyCart(
      {required String itemId,
      required String quantity,
      List<WooProductVariation>? variations}) async {
    Map<String, dynamic> data = {
      'id': itemId,
      'quantity': quantity,
    };
    if (variations != null) data['variations'] = variations;
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';
    final response = await http.post(
        Uri.parse('$baseUrl${URL_STORE_API_PATH}cart/items'),
        headers: _urlHeader,
        body: data);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('added to my cart : $jsonStr');
      return WooCartItem.fromJson(jsonStr);
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// Returns a list of all [WooCartItem].
  ///
  /// Related endpoint : wc/store/cart/items

  Future<List<WooCartItem>> getMyCartItems() async {
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';
    final response = await http.get(
        Uri.parse('$baseUrl${URL_STORE_API_PATH}cart/items'),
        headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      List<WooCartItem> cartItems = [];
      _printToLog('response gotten : $response');
      for (var p in jsonStr) {
        var prod = WooCartItem.fromJson(p);
        _printToLog('prod gotten here : ${prod.name}');
        cartItems.add(prod);
      }

      _printToLog('account user fetch : $jsonStr');
      return cartItems;
    } else {
      _printToLog(' error : ${response.body}');
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// Returns the current user's [WooCart], information

  Future<WooCart> getMyCart() async {
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';
    WooCart cart;
    final response = await http.get(
        Uri.parse('$baseUrl${URL_STORE_API_PATH}cart'),
        headers: _urlHeader);
    _printToLog('response gotten : $response');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      cart = WooCart.fromJson(jsonStr);
      return cart;
    } else {
      _printToLog(' error : ${response.body}');
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  Future deleteMyCartItem({required String key}) async {
    Map<String, dynamic> data = {
      'key': key,
    };
    _printToLog('Deleting CartItem With Payload : $data');
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';

    final http.Response response = await http.delete(
      Uri.parse('$baseUrl${URL_STORE_API_PATH}cart/items/$key'),
      headers: _urlHeader,
    );
    _printToLog('response of delete cart  : ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _printToLog('response of delete cart oooo   : ${response.body}');
      //final jsonStr = json.decode(response.body);

      //_printToLog('added to my cart : '+jsonStr.toString());
      //return WooCartItem.fromJson(jsonStr);
      return response.body;
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  Future deleteAllMyCartItems() async {
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';

    final http.Response response = await http.delete(
      Uri.parse('$baseUrl${URL_STORE_API_PATH}cart/items/'),
      headers: _urlHeader,
    );
    _printToLog('response of delete cart  : ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// Returns a [WooCartItem], with the specified [key].

  Future<WooCartItem> getMyCartItemByKey(String key) async {
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';
    WooCartItem cartItem;
    final response = await http.get(
        Uri.parse('$baseUrl${URL_STORE_API_PATH}cart/items/$key'),
        headers: _urlHeader);
    _printToLog('response gotten : $response');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      cartItem = WooCartItem.fromJson(jsonStr);
      return cartItem;
    } else {
      _printToLog('error : ${response.body}');
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  Future<WooCartItem> updateMyCartItemByKey(
      {required String key,
      required int id,
      required int quantity,
      List<WooProductVariation>? variations}) async {
    Map<String, dynamic> data = {
      'key': key,
      'id': id.toString(),
      'quantity': quantity.toString(),
    };
    if (variations != null) data['variations'] = variations;
    await getAuthTokenFromDb();
    _urlHeader['Authorization'] = 'Bearer ${_authToken!}';
    final response = await http.put(
        Uri.parse('$baseUrl${URL_STORE_API_PATH}cart/items/$key'),
        headers: _urlHeader,
        body: data);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('added to my cart : $jsonStr');
      return WooCartItem.fromJson(jsonStr);
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// Creates an order and returns the [WooOrder] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#orders.
  Future<WooOrder> createOrder(WooOrderPayload orderPayload) async {
    _printToLog('Creating Order With Payload : $orderPayload');
    _setApiResourceUrl(
      path: 'orders',
    );
    final response = await post(queryUri.toString(), orderPayload.toJson());
    return WooOrder.fromJson(response);
  }

  Future<WooOrder> createOrderWithApi(
    WPICartDetailsPayload cartDetailsPayload, {
    String? status,
  }) async {
    _printToLog('Creating Order With Api - Payload : $cartDetailsPayload');

    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/wp-json/woostore_pro_api/order/create'),
      body: jsonEncode({
        ...cartDetailsPayload.toJson(),
        if (status != null) 'status': status,
      }),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('Create Order Response: $jsonStr');
      return WooOrder.fromJson(jsonStr);
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  Future<WooOrder> updateOrderWithApi({
    required String orderId,
    String? status,
    String? transactionId,
    Map<String, dynamic>? metaData,
  }) async {
    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/wp-json/woostore-pro-api/v2/order/update'),
      body: jsonEncode({
        'id': orderId,
        if (status != null) 'status': status,
        if (transactionId != null) 'transaction_id': transactionId,
        if (metaData != null) 'meta_data': metaData,
      }),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('Create Order Response: $jsonStr');
      return WooOrder.fromJson(jsonStr);
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  Future<WPICartTotals> reviewDetailsWithApi(
    WPICartDetailsPayload cartDetailsPayload,
  ) async {
    _printToLog('Review Cart Details : $cartDetailsPayload');

    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/wp-json/woostore_pro_api/checkout/review-details'),
      body: jsonEncode(cartDetailsPayload.toJson()),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('Review Cart Details Response: $jsonStr');
      return WPICartTotals.fromMap(jsonStr);
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  Future<bool> deleteOrderWithApi(int orderId) async {
    _printToLog('Delete Order With Api - Order ID : $orderId');

    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/wp-json/woostore_pro_api/order/delete'),
      body: jsonEncode({"id": orderId, 'force': true}),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('Delete Order Response: $jsonStr');
      return true;
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// Returns a list of all [Order], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#orders
  Future<List<WooOrder>> getOrders({
    int? page,
    int? perPage,
    String? search,
    String? after,
    String? before,
    List<int>? exclude,
    List<int>? include,
    int? offset,
    String? order,
    String? orderBy,
    List<int>? parent,
    List<int>? parentExclude,
    List<String>?
        status, // Options: any, pending, processing, on-hold, completed, cancelled, refunded, failed and trash. Default is any.
    int? customer,
    int? product,
    int? dp,
    String? lang,
  }) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page,
      'per_page': perPage,
      'search': search,
      'after': after,
      'before': before,
      'exclude': exclude,
      'include': include,
      'offset': offset,
      'order': order,
      'orderby': orderBy,
      'parent': parent,
      'parent_exclude': parentExclude,
      'status': status,
      'customer': customer,
      'product': product,
      'dp': dp,
      'lang': lang,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooOrder> orders = [];
    _printToLog('Getting Order With Payload : $payload');
    _setApiResourceUrl(path: 'orders', queryParameters: payload);
    final response = await get(queryUri.toString());

    // print('API Response: $response');

    for (var o in response) {
      var order = WooOrder.fromJson(o);
      _printToLog('order gotten here : $order');
      orders.add(order);
    }
    return orders;
  }

  /// Returns a [WooOrder] object that matches the provided [id].

  Future<WooOrder> getOrderById(int id, {String? dp}) async {
    Map<String, dynamic> payload = {};
    if (dp != null) payload["dp"] = dp;
    _setApiResourceUrl(path: 'orders/$id', queryParameters: payload);
    final response = await get(queryUri.toString());
    return WooOrder.fromJson(response);
  }

  /// Updates an existing order and returns the [WooOrder] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#orders.

  Future<WooOrder> oldUpdateOrder(WooOrder order) async {
    _printToLog('Updating Order With Payload : $order');
    _setApiResourceUrl(
      path: 'orders/${order.id}',
    );
    final response = await put(queryUri.toString(), order.toJson());
    return WooOrder.fromJson(response);
  }

  Future<WooOrder> updateOrder({Map? orderMap, int? id}) async {
    _printToLog('Updating Order With Payload : $orderMap');
    _setApiResourceUrl(
      path: 'orders/$id',
    );
    final response = await put(queryUri.toString(), orderMap);
    return WooOrder.fromJson(response);
  }

  /// Deletes an existing order and returns the [WooOrder] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#orders.

  Future<WooOrder> deleteOrder({required int orderId}) async {
    Map data = {
      'force': true,
    };
    _printToLog('Deleting Order With Id : $orderId');
    _setApiResourceUrl(
      path: 'orders/$orderId',
    );
    final response = await delete(queryUri.toString(), data);
    return WooOrder.fromJson(response);
  }

  /// Creates an coupon and returns the [WooCoupon] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#coupons.
  Future<WooCoupon> createCoupon({
    String? code,
    String? discountType,
    String? amount,
    bool? individualUse,
    bool? excludeSaleItems,
    String? minimumAmount,
  }) async {
    Map<String, dynamic> payload = {};

    ({
      'code': code,
      'discount_type': discountType,
      'amount': amount,
      'individual_use': individualUse,
      'exclude_sale_items': excludeSaleItems,
      'minimum_amount': minimumAmount,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    WooCoupon coupon;
    _setApiResourceUrl(
      path: 'coupons',
    );
    final response = await post(queryUri.toString(), payload);
    _printToLog('response gotten : $response');
    coupon = WooCoupon.fromJson(response);
    return coupon;
  }

  /// Returns a list of all [WooCoupon], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#coupons
  Future<List<WooCoupon>?> getCoupons({
    int? page,
    int? perPage,
    String? search,
    String? after,
    String? before,
    //List<int> exclude,
    //List<int> include,
    int? offset,
    String? order,
    String? orderBy,
    String? code,
    String? lang,
  }) async {
    Map<String, dynamic> payload = {};
    ({
      'page': page, 'per_page': perPage, 'search': search,
      'after': after, 'before': before,
      //'exclude': exclude, 'include': include,
      'offset': offset,
      'order': order, 'orderby': orderBy, 'code': code, 'lang': lang,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooCoupon>? coupons = [];
    _printToLog('Getting Coupons With Payload : $payload');
    _setApiResourceUrl(path: 'coupons', queryParameters: payload);
    final response = await get(queryUri.toString());
    for (var c in response) {
      var coupon = WooCoupon.fromJson(c);
      _printToLog('prod gotten here : $order');
      coupons.add(coupon);
    }
    return coupons;
  }

  /// Returns a [WooCoupon] object with the specified [id].
  Future<WooCoupon> getCouponById(int id) async {
    _setApiResourceUrl(path: 'coupons/$id');
    final response = await get(queryUri.toString());
    return WooCoupon.fromJson(response);
  }

  Future<WooCoupon> verifyCouponWithApi({
    required String couponCode,
    required List<WPILineItems> lineItems,
    int customerId = 0,
  }) async {
    List<Map<String, dynamic>> lineItemsList = lineItems
        .map((e) => {
              'product_id': e.productId,
              'variation_id': e.variationId,
              'quantity': e.quantity,
            })
        .toList();
    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/wp-json/woostore_pro_api/checkout/verify-coupon'),
      body: jsonEncode({
        'coupon_code': couponCode,
        'line_items': lineItemsList,
        'customer_id': customerId,
      }),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);

      _printToLog('Verify coupon response: $jsonStr');
      if (jsonStr['is_coupon_valid'] != null &&
          jsonStr['is_coupon_valid'] == true &&
          jsonStr['coupon'] != null) {
        return WooCoupon.fromJson(jsonStr['coupon']);
      } else {
        throw WooCommerceError(
          code: 'no_coupon_found',
          message: 'Response did not send a coupon',
          data: Data(status: 404),
        );
      }
    } else {
      WooCommerceError err =
          WooCommerceError.fromJson(json.decode(response.body));
      throw err;
    }
  }

  /// get the points of the customer by id
  Future<WooPoints> getPointsById(int customerId) async {
    final http.Response response = await http.get(Uri.parse(
        '$baseUrl/wp-json/woostore_pro_api/flutter_user/get_points?user_id=$customerId'));

    final Map<String, dynamic> body = jsonDecode(response.body);
    return WooPoints.fromJson(body);
  }

  /// Fetches the product points from the server based on the product id
  Future<int?> getProductPoints(int productId) async {
    final http.Response response = await http.get(Uri.parse(
        '$baseUrl/wp-json/woostore_pro_api/flutter_products/get_product_points?product_id=$productId'));

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['points'];
    } else {
      throw WooCommerceError.fromJson(body);
    }
  }

  /// Fetches the filter min max prices based on the taxonomy parameters
  Future<Map<String, dynamic>> getProductFilterMinMaxPrices(
      List<String>? categoryIds) async {
    final http.Response response = await http.post(
      Uri.parse(
        '$baseUrl/wp-json/woostore_pro_api/flutter_products/get-mix-max-prices',
      ),
      body: jsonEncode({"categories": categoryIds ?? const []}),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body as Map<String, dynamic>;
    } else {
      throw WooCommerceError.fromJson(body);
    }
  }

  /// Returns a list of all [WooTaxRate], with filter options.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#tax-rates.
  Future<List<WooTaxRate>> getTaxRates(
      {int? page,
      int? perPage,
      int? offset,
      String? order,
      String? orderBy,
      String? taxClass}) async {
    Map<String, dynamic> payload = {};

    ({
      'page': page,
      'per_page': perPage,
      'offset': offset,
      'order': order,
      'orderby': orderBy,
      'class': taxClass,
    }).forEach((k, v) {
      if (v != null) payload[k] = v;
    });
    List<WooTaxRate> taxRates = [];
    _printToLog('Getting Taxrates With Payload : $payload');
    _setApiResourceUrl(path: 'taxes', queryParameters: payload);
    final response = await get(queryUri.toString());
    for (var t in response) {
      var tax = WooTaxRate.fromJson(t);
      _printToLog('prod gotten here : $order');
      taxRates.add(tax);
    }
    return taxRates;
  }

  /// Returns a [WooTaxRate] object matching the specified [id].

  Future<WooTaxRate> getTaxRateById(int id) async {
    _setApiResourceUrl(path: 'taxes/$id');
    final response = await get(queryUri.toString());
    return WooTaxRate.fromJson(response);
  }

  /// Returns a list of all [WooTaxClass].
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#tax-classes.
  Future<List<WooTaxClass>> getTaxClasses() async {
    List<WooTaxClass> taxClasses = [];
    _setApiResourceUrl(path: 'taxes/classes');
    final response = await get(queryUri.toString());
    for (var t in response) {
      var tClass = WooTaxClass.fromJson(t);
      _printToLog('tax class gotten here : $tClass');
      taxClasses.add(tClass);
    }
    return taxClasses;
  }

  /// Returns a list of all [WooShippingZone].
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#shipping-zones.
  Future<List<WooShippingZone>> getShippingZones() async {
    List<WooShippingZone> shippingZones = [];
    _setApiResourceUrl(path: 'shipping/zones');
    final response = await get(queryUri.toString());
    for (var z in response) {
      var sZone = WooShippingZone.fromJson(z);
      _printToLog('shipping zones gotten here : $sZone');
      shippingZones.add(sZone);
    }
    return shippingZones;
  }

  /// Returns a [WooShippingZone] object with the specified [id].

  Future<WooShippingZone> getShippingZoneById(int id) async {
    WooShippingZone shippingZone;
    _setApiResourceUrl(path: 'shipping/zones/$id');
    final response = await get(queryUri.toString());
    shippingZone = WooShippingZone.fromJson(response);
    return shippingZone;
  }

  /// Returns a list of all [WooShippingMethod].
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#shipping-methods.
  Future<List<WooShippingMethod>> getShippingMethods() async {
    List<WooShippingMethod> shippingMethods = [];
    _setApiResourceUrl(path: 'shipping_methods');
    final response = await get(queryUri.toString());
    for (var z in response) {
      var sMethod = WooShippingMethod.fromJson(z);
      _printToLog('shipping methods gotten here : $sMethod');
      shippingMethods.add(sMethod);
    }
    return shippingMethods;
  }

  Future<List<WPIShippingMethod>> getShippingMethodsFromApi(
    WPIShippingMethodRequestPackage package,
  ) async {
    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
      Uri.parse(
          "$baseUrl/wp-json/woostore_pro_api/checkout/get-shipping-methods"),
      body: jsonEncode(package.toMap()),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List<Map<String, dynamic>> body =
        List.castFrom(jsonDecode(response.body)).cast<Map<String, dynamic>>();

    final temp = <WPIShippingMethod>[];
    for (var i = 0; i < body.length; ++i) {
      temp.add(WPIShippingMethod.fromJson(body[i]));
    }
    return temp;
  }

  Future<List<WPIPaymentMethod>> getPaymentMethodsFromApi(
    WPICartDetailsPayload package,
  ) async {
    final headers = {'Content-Type': 'application/json'};
    final http.Response response = await http.post(
      Uri.parse(
          "$baseUrl/wp-json/woostore-pro-api/v2/checkout/get-payment-methods"),
      body: jsonEncode(package.toJson()),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List<Map<String, dynamic>> body =
        List.castFrom(jsonDecode(response.body)).cast<Map<String, dynamic>>();

    final temp = <WPIPaymentMethod>[];
    for (var i = 0; i < body.length; ++i) {
      temp.add(WPIPaymentMethod.fromMap(body[i]));
    }
    return temp;
  }

  /// Returns a [WooShippingMethod] object with the specified [id].

  Future<WooShippingMethod> getShippingMethodById(int id) async {
    WooShippingMethod shippingMethod;
    _setApiResourceUrl(path: 'shipping_methods/$id');
    final response = await get(queryUri.toString());
    shippingMethod = WooShippingMethod.fromJson(response);
    return shippingMethod;
  }

  /// Returns a list of all [WooShippingZoneMethod] associated with a shipping zone.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#shipping-zone-locations.
  Future<List<WooShippingZoneMethod>> getAllShippingZoneMethods(
      {required int shippingZoneId}) async {
    List<WooShippingZoneMethod> shippingZoneMethods = [];
    _setApiResourceUrl(path: 'shipping/zones/$shippingZoneId/methods');
    final response = await get(queryUri.toString());
    for (var l in response) {
      var sMethod = WooShippingZoneMethod.fromJson(l);
      _printToLog('shipping zone locations gotten here : $sMethod');
      shippingZoneMethods.add(sMethod);
    }
    return shippingZoneMethods;
  }

  /// Returns a [WooShippingZoneMethod] object from the specified [zoneId] and [methodId].

  Future<WooShippingZoneMethod> getAShippingMethodFromZone(
      {required int zoneId, required int methodId}) async {
    WooShippingZoneMethod shippingZoneMethod;
    _setApiResourceUrl(path: 'shipping/zones/${zoneId}methods/$methodId');
    final response = await get(queryUri.toString());
    shippingZoneMethod = WooShippingZoneMethod.fromJson(response);
    return shippingZoneMethod;
  }

  /// Deletes an existing shipping zone method and returns the [WooShippingZoneMethod] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#orders.

  Future<WooShippingZoneMethod> deleteShippingZoneMethod(
      {required int zoneId, required int methodId}) async {
    Map data = {
      'force': true,
    };
    _printToLog('Deleting shipping zone method with zoneId : $zoneId');
    _setApiResourceUrl(path: 'shipping/zones/${zoneId}methods/$methodId');
    final response = await delete(queryUri.toString(), data);
    return WooShippingZoneMethod.fromJson(response);
  }

  /// Returns a list of all [WooShippingZoneLocation].
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#shipping-zone-locations.
  Future<List<WooShippingZoneLocation>> getShippingZoneLocations(
      {required int shippingZoneId}) async {
    List<WooShippingZoneLocation> shippingZoneLocations = [];
    _setApiResourceUrl(path: 'shipping/zones/$shippingZoneId/locations');
    final response = await get(queryUri.toString());
    for (var l in response) {
      var sZoneLocation = WooShippingZoneLocation.fromJson(l);
      _printToLog('shipping zone locations gotten here : $sZoneLocation');
      shippingZoneLocations.add(sZoneLocation);
    }
    return shippingZoneLocations;
  }

  /// Returns a list of all [WooPaymentGateway] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-payment-gateways.
  Future<List<WooPaymentGateway>> getPaymentGateways() async {
    List<WooPaymentGateway> gateways = [];
    _setApiResourceUrl(path: 'payment_gateways');
    final response = await get(queryUri.toString());
    for (var g in response) {
      if (g['enabled'] != null &&
          g['enabled'] is bool &&
          g['enabled'] == true) {
        var sMethod = WooPaymentGateway.fromJson(g);
        _printToLog('shipping zone locations gotten here : $sMethod');
        gateways.add(sMethod);
      }
    }
    return gateways;
  }

  /// Returns a [WooPaymentGateway] object from the specified [id].

  Future<WooPaymentGateway> getPaymentGatewayById(int id) async {
    WooPaymentGateway paymentGateway;
    _setApiResourceUrl(path: 'payment_gateways/$id');
    final response = await get(queryUri.toString());
    paymentGateway = WooPaymentGateway.fromJson(response);
    return paymentGateway;
  }

  /// Updates an existing order and returns the [WooPaymentGateway] object.
  ///
  /// Related endpoint: https://woocommerce.github.io/woocommerce-rest-api-docs/#orders.

  Future<WooPaymentGateway> updatePaymentGateway(
      WooPaymentGateway gateway) async {
    _printToLog('Updating Payment Gateway With Payload : $gateway');
    _setApiResourceUrl(
      path: 'payment_gateways/${gateway.id!}',
    );
    final response = await put(queryUri.toString(), gateway.toJson());
    return WooPaymentGateway.fromJson(response);
  }

  /// Returns a list of countries
  Future<List<WooCountry>> getCountries() async {
    _setApiResourceUrl(path: COUNTRIES_API_PATH);
    final List<Object> response =
        await (get(queryUri.toString()) as FutureOr<List<Object>>);
    final List<WooCountry> result = [];
    for (final item in response) {
      final WooCountry wooCountry =
          WooCountry.fromMap(item as Map<String, dynamic>);
      result.add(wooCountry);
    }
    return result;
  }

  /// Public function which creates an OAUTH 1.0 compatible url for custom
  /// woocommerce endpoints
  String createOAuthUrl(String requestMethod, String endpoint) {
    return _getOAuthURL(requestMethod, endpoint);
  }

  /// This Generates a valid OAuth 1.0 URL
  ///
  /// if [isHttps] is true we just return the URL with
  /// [consumerKey] and [consumerSecret] as query parameters
  String _getOAuthURL(String requestMethod, String endpoint) {
    String? consumerKey = this.consumerKey;
    String? consumerSecret = this.consumerSecret;

    String token = "";
    _printToLog('oauth token = : $token');
    String url = baseUrl + apiPath + endpoint;
    bool containsQueryParams = url.contains("?");

    if (isHttps == true) {
      return url +
          (containsQueryParams == true
              ? "&consumer_key=${this.consumerKey!}&consumer_secret=${this.consumerSecret!}"
              : "?consumer_key=${this.consumerKey!}&consumer_secret=${this.consumerSecret!}");
    }

    Random rand = Random();
    List<int> codeUnits = List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    /// Random string uniquely generated to identify each signed request
    String nonce = String.fromCharCodes(codeUnits);

    /// The timestamp allows the Service Provider to only keep nonce values for a limited time
    final int timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

    String parameters =
        "oauth_consumer_key=${consumerKey!}&oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timestamp&oauth_nonce=$nonce&oauth_token=$token&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString =
          "$parameterString${Uri.encodeComponent(key)}=${Uri.encodeComponent(treeMap[key])}&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);
    parameterString = parameterString.replaceAll(' ', '%20');

    String method = requestMethod.toUpperCase();
    String baseString =
        "$method&${Uri.encodeComponent(containsQueryParams == true ? url.split("?")[0] : url)}&${Uri.encodeComponent(parameterString)}";

    String signingKey = "${consumerSecret!}&$token";
    crypto.Hmac hmacSha1 =
        crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1

    /// The Signature is used by the server to verify the
    /// authenticity of the request and prevent unauthorized access.
    /// Here we use HMAC-SHA1 method.
    crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));

    String finalSignature = base64Encode(signature.bytes);

    String requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl =
          "${url.split("?")[0]}?$parameterString&oauth_signature=${Uri.encodeComponent(finalSignature)}";
    } else {
      requestUrl =
          "$url?$parameterString&oauth_signature=${Uri.encodeComponent(finalSignature)}";
    }
    return requestUrl;
  }

  _handleError(dynamic response) {
    if (response['message'] == null) {
      return response;
    } else {
      throw WooCommerceError.fromJson(response);
      // throw Exception(
      //     WooCommerceError.fromJson(response).toString());
    }
  }

  Exception _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
      case 401:
      case 404:
      case 500:
        throw Exception(
            WooCommerceError.fromJson(json.decode(response.body)).toString());
      default:
        throw Exception(
            "An error occurred, status code: ${response.statusCode}");
    }
  }

  // Get the auth token from db.

  getAuthTokenFromDb() async {
    _authToken = await _localDbService.getSecurityToken();
    return _authToken;
  }

  // Sets the Uri for an endpoint.
  String _setApiResourceUrl({
    required String path,
    String? host,
    port,
    Map<String, dynamic>? queryParameters,
    bool isShop = false,
  }) {
    apiPath = DEFAULT_WC_API_PATH;
    if (isShop) {
      apiPath = URL_STORE_API_PATH;
    } else {
      apiPath = DEFAULT_WC_API_PATH;
    }
    // getAuthTokenFromDb();
    String query = '';
    if (queryParameters != null) {
      query = getQueryString(queryParameters);
    }
    queryUri = Uri(
      path: path,
      query: query,
      port: port,
      host: host,
    );
    _printToLog('Query : $queryUri');
    return queryUri.toString();
  }

  String getQueryString(
    Map params, {
    String prefix = '&',
    bool inRecursion = false,
  }) {
    final List queryParams = [];

    params.forEach((key, value) {
      if (value is String || value is int || value is double || value is bool) {
        queryParams.add('$key=$value');
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          queryParams.add('$key[$i]=${value[i]}');
        }
      } else if (value is Map) {
        queryParams.add(getQueryString(value));
      }
    });

    return queryParams.join(prefix);
  }

  /// Make a custom get request to a Woocommerce endpoint, using WooCommerce SDK.

  Future<dynamic> get(String endPoint) async {
    String url = _getOAuthURL("GET", endPoint);
    String token = await _localDbService.getSecurityToken();
    String bearerToken = "Bearer $token";
    _printToLog('this is the bearer token : $bearerToken');
    Map<String, String?> headers = HashMap();
    headers.putIfAbsent('Accept', () => 'application/json charset=utf-8');
    // Test Edit Aniket Malik
    headers.putIfAbsent('Authorization', () => bearerToken);
    headers.putIfAbsent('consumer_key', () => consumerKey);
    headers.putIfAbsent('consumer_secret', () => consumerSecret);
    try {
      _printToLog('This is the Url: $url');
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      _handleHttpError(response);
    } on SocketException {
      throw Exception('No Internet connection.');
    }
  }

  Future<dynamic> oldget(String endPoint) async {
    String url = _getOAuthURL("GET", endPoint);

    http.Client client = http.Client();
    http.Request request = http.Request('GET', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    //request.headers[HttpHeaders.authorizationHeader] = _token;
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    String response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    _handleError(dataResponse);
    return dataResponse;
  }

  /// Make a custom post request to Woocommerce, using WooCommerce SDK.

  Future<dynamic> post(
    String endPoint,
    Map data,
  ) async {
    String url = _getOAuthURL("POST", endPoint);

    http.Client client = http.Client();
    http.Request request = http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    //request.headers[HttpHeaders.authorizationHeader] = _bearerToken;
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    String response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    _handleError(dataResponse);
    return dataResponse;
  }

  /// Make a custom put request to Woocommerce, using WooCommerce SDK.

  Future<dynamic> put(String endPoint, Map? data) async {
    String url = _getOAuthURL("PUT", endPoint);

    http.Client client = http.Client();
    http.Request request = http.Request('PUT', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    print(request.toString());
    String response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    _handleError(dataResponse);
    return dataResponse;
  }

  /// Make a custom delete request to Woocommerce, using WooCommerce SDK.

  Future<dynamic> oldelete(String endPoint, Map data) async {
    String url = _getOAuthURL("DELETE", endPoint);

    http.Client client = http.Client();
    http.Request request = http.Request('DELETE', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    //request.headers[HttpHeaders.authorizationHeader] = _urlHeader['Authorization'];
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    final response =
        await client.send(request).then((res) => res.stream.bytesToString());
    _printToLog("this is the delete's response : $response");
    var dataResponse = await json.decode(response);
    _handleHttpError(dataResponse);
    return dataResponse;
  }

  Future<dynamic> delete(String endPoint, Map data, {String? aUrl}) async {
    String realUrl;
    final url = _getOAuthURL("DELETE", endPoint);
    if (aUrl == null) {
      realUrl = url;
    } else {
      realUrl = url;
    }
    // final url = Uri.parse(baseUrl + "notes/delete");
    final request = http.Request("DELETE", Uri.parse(realUrl));
    request.headers.addAll(<String, String>{
      "Accept": "application/json",
    });
    request.body = jsonEncode(data);
    final response = await request.send();
    if (response.statusCode > 300) {
      return Future.error(
          "error: status code ${response.statusCode} ${response.reasonPhrase}");
    }
    final deleteResponse = await response.stream.bytesToString();
    _printToLog("delete response : $deleteResponse");
    return deleteResponse;
  }
}

class QueryString {
  /// Parses the given query string into a Map.
  static Map parse(String query) {
    RegExp search = RegExp('([^&=]+)=?([^&]*)');
    Map result = {};

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);

    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1)!)] = decode(match.group(2)!);
    }
    return result;
  }
}
