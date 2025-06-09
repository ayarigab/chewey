import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decapitalgrille/const/constants.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/theme/color_schemes.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:decapitalgrille/utils/translations.dart';
import 'package:decapitalgrille/widgets/button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttersnackbar/fluttersnackbar.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:local_auth/local_auth.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:ndialog/ndialog.dart';
import 'package:niel_spins/niel_spins.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woocommerce/models/cart_details_payload.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/woocommerce.dart';

// export 'package:auto_size_text/auto_size_text.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:decapitalgrille/const/constants.dart';
export 'package:decapitalgrille/theme/color_schemes.dart';
export 'package:decapitalgrille/utils/translations.dart';
export 'package:decapitalgrille/widgets/button.dart';
export 'package:fluentui_system_icons/fluentui_system_icons.dart';
export 'package:flutter/material.dart';
export 'package:flutter_svg/svg.dart';
export 'package:fluttersnackbar/fluttersnackbar.dart';
export 'package:palette_generator/palette_generator.dart';
// export 'package:in_app_review/in_app_review.dart';
// export 'package:map_launcher/map_launcher.dart';
export 'package:niel_spins/niel_spins.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:permission_handler/permission_handler.dart';

class Core {
  static const foreCol = NielCol.white;
  static final appVer = TranslationService().translate('app_ver').toString();
  final LocalAuthentication auth = LocalAuthentication();

  static final logo = Hero(
    tag: 'degrille',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('images/icons/dhr.png'),
    ),
  );

  static final logoRaw =
      SvgPicture.asset('images/icons/dhrM.svg', height: 200.0, width: 200.0);

  static IconButton backBut(BuildContext context) {
    return IconButton(
      icon: const Icon(FluentIcons.arrow_left_32_filled),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  static double responsiveWidth(BuildContext context, double percentage) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * percentage;
  }

  static double responsiveHeight(BuildContext context, double percentage) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * percentage;
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static String obscureUsername(String username) {
    final visibleChars = username.length > 6 ? 6 : 3;
    return username.substring(0, visibleChars).padRight(username.length, '*');
  }

  static final Map<String, Widget Function(BuildContext, Object?)> routes = {};
  static void registerRoute(
      String routeName, Widget Function(BuildContext, Object?) pageBuilder) {
    routes[routeName] = pageBuilder;
  }

  static Future<dynamic> navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool replace = false,
    bool removeUntilHome = false,
    bool requireLogin = false,
  }) async {
    if (requireLogin && !isUserLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must be logged in to access this page."),
        ),
      );
      return;
    }

    final routeBuilder = routes[routeName];
    if (routeBuilder == null) {
      throw Exception('Route $routeName is not registered!');
    }

    final route = Core.customPageRoute(routeBuilder(context, arguments));

    if (removeUntilHome) {
      return Navigator.of(context)
          .pushAndRemoveUntil(route, (route) => route.isFirst);
    } else if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }

  static CustomMaterialPageRoute customPageRoute(Widget page) {
    return CustomMaterialPageRoute(
      builder: (_) => page,
    );
  }

  static void goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  static Route<T> smoothFadePageRoute<T>(BuildContext context, Widget page,
      {bool? requireLogin = false}) {
    if (requireLogin! && !isUserLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You must be logged in to access this page.")),
      );
    }
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const beginOffset = Offset(0, 0.05);
        const endOffset = Offset.zero;
        const curve = Curves.easeOut;

        final tween = Tween(begin: beginOffset, end: endOffset).chain(
          CurveTween(curve: curve),
        );
        final slideAnimation = animation.drive(tween);
        final fadeAnimation = CurvedAnimation(parent: animation, curve: curve);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      reverseTransitionDuration: const Duration(milliseconds: 125),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Widget buildSectionHeader(
      String title, BuildContext context, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 20.0, bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          NielButton(
            id: 'id',
            text: 'Show more',
            size: NielButtonSize.S,
            type: NielButtonType.SECONDARY,
            borderRadius: 8,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            background: Colors.transparent,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }

  static Widget buildProductList(
      Future<List<WooProduct>> fetchProducts, BuildContext context) {
    return Container(
      height: 250.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FutureBuilder<List<WooProduct>>(
        future: fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Core.loadThis(context);
          } else if (snapshot.hasError) {
            return ErrorHandler.errorThis(
                image: 'images/errors/generic_error.png',
                imageSize: 150,
                'Oops! Error occured. Pull down to refresh',
                errorCode: 401
                // onRetry: () {},
                );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ErrorHandler.errorThis(
              image: 'images/errors/empty_box_error.png',
              imageSize: 150,
              'No products available. Try again',
              errorCode: 404,
            );
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return getItem(product.images?[0].src, product, context);
              },
            );
          }
        },
      ),
    );
  }

  static Widget tile({
    required String title,
    String? subTitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? bgColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        foregroundColor: foreCol,
        backgroundColor: bgColor,
        child: Icon(icon),
      ),
      subtitle: Core.inform(text: subTitle ?? ''),
      title: Text(title),
    );
  }

  static Widget getItem(
      String? imageUrl, WooProduct product, BuildContext context) {
    const defaultImageUrl = 'images/degrille/waitress.jpg';

    return GestureDetector(
      onTap: () async {
        final Color? titleColor;
        final Color? appBarColor;
        final PaletteGenerator pg = await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(
            imageUrl ?? defaultImageUrl,
          ),
        );
        titleColor = pg.lightVibrantColor?.color;
        appBarColor = pg.mutedColor?.color;
        if (context.mounted) {
          Core.showProductDetails(
            context,
            productName: product.name ?? 'Unknown Food',
            productImageUrl: imageUrl ?? defaultImageUrl,
            productPrice: double.tryParse(product.price ?? '') ?? 0.0,
            productId: product.id ?? 0,
            productDesc: product.shortDescription ?? '',
            titleColor: titleColor,
            appBarColor: appBarColor,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        width: 150.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl ?? defaultImageUrl,
                cacheKey: imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [Colors.transparent, Theme.of(context).canvasColor],
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                product.name ?? 'Unknown Food',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.shadow,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                ),
              ),
              AutoSizeText(
                '$currency ${product.price ?? '0'}$currPostFix',
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontVariations: [
                    FontVariation('wght', 900),
                  ],
                  color: Colors.red,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget loadThis(BuildContext context, {String? inform}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NielSpinRipple(
            color: Theme.of(context).shadowColor,
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            inform ?? 'Loading, please wait',
          ),
        ],
      ),
    );
  }

  static Widget spinThis({Color? color, String? inform}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NielSpinFadingCircle(
            color: color ?? Colors.grey,
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            inform ?? 'Loading, please wait',
          ),
        ],
      ),
    );
  }

  static Widget buildStarRating({
    int? rating,
    double size = 15.0,
    Color color = const Color.fromARGB(255, 255, 179, 0),
  }) {
    int stars = rating ?? Random().nextInt(3) + 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border_outlined,
          color: index < stars ? color : Colors.grey,
          size: size,
        );
      }),
    );
  }

  static openMapsSheet(context) async {
    try {
      final coords = Coords(6.812005, -2.5199783);
      const title = "De Capital Grille";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: title,
                      ),
                      title: Text(map.mapName),
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink.shade400,
                        child: ClipOval(
                          child: SvgPicture.asset(
                            map.icon,
                            fit: BoxFit.cover,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      Core.snackThis(
          context: context, 'Oops! An Error occured.', type: 'alert');
    }
  }

  static openDirectionsSheet(context) async {
    try {
      final coords = Coords(6.812005, -2.5199783);
      const title = "De Capital Grille";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showDirections(
                        destination: coords,
                        destinationTitle: title,
                      ),
                      title: Text(map.mapName),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: SvgPicture.asset(
                            map.icon,
                            fit: BoxFit.cover,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      Core.snackThis(
          context: context, 'Oops! An Error occured.', type: 'alert');
    }
  }

  static Future<void> sendOrderEmail(String fromName, String message) async {
    Map<String, dynamic> templateParams = {
      'from_name': fromName,
      'message': message
    };

    try {
      await emailjs.send(
        servID,
        tempID,
        templateParams,
        emailjs.Options(
          publicKey: pubKey,
          privateKey: priKey,
        ),
      );
    } catch (error) {
      //
    }
  }

  static Future<void> initiatePayment(BuildContext context) async {
    final wooCommerce = WooCommerce(
      baseUrl: url,
      consumerKey: cKey,
      consumerSecret: cCret,
    );

    const int productId = 1105;
    const int quantity = 10;
    const int customerId = 18;

    try {
      final orderData = {
        'line_items': [
          {
            'product_id': productId,
            'quantity': quantity,
          },
        ],
        'customer_id': customerId,
      };

      final order = await wooCommerce.createOrderWithApi(
        WPICartDetailsPayload(
          paymentMethod: 'paystack',
          paymentMethodTitle: 'Debit/Credit Cards + MoMo',
          customerId: '1',
          billing: Billing(
              firstName: 'Phone',
              lastName: 'Order Test',
              email: 'phoneapporder@test.com',
              phone: '32456786543'),
        ),
        status: 'processing',
      );
      if (context.mounted) {
        Core.snackThis(
          context: context,
          'Payment successful and order placed.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        Core.snackThis(
          context: context,
          'Error initiating payment.',
          type: 'fail',
        );
      }
      debugPrint('Error initiating payment: $e');
    }
  }

  Future<bool> checkBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> biometricVerification() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to do this',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      Core.snackThis('Error during authentication. Please try again');
    }
    return isAuthenticated;
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void snackThis(String message,
      {BuildContext? context, String type = 'save'}) {
    context ??= navigatorKey.currentState?.overlay?.context;

    if (context == null) {
      debugPrint("Error: Unable to retrieve context for displaying SnackBar.");
      return;
    }

    SnackBarType snackBarType;
    switch (type.toLowerCase()) {
      case 'fail':
        snackBarType = SnackBarType.fail;
        break;
      case 'alert':
        snackBarType = SnackBarType.alert;
        break;
      case 'save':
      default:
        snackBarType = SnackBarType.save;
    }

    IconSnackBar.hide(context);
    IconSnackBar.show(
      context: context,
      snackBarType: snackBarType,
      label: message,
    );
  }

  static void showDialog(
    BuildContext context,
    String title, {
    Widget? icon,
    required Widget contents,
    bool? dismissable = true,
    double? blur = 5,
    required String gestureName,
    required GestureTapCallback onPress,
  }) {
    DialogBackground(
      dismissable: dismissable,
      blur: blur,
      dialog: NDialog(
        dialogStyle: DialogStyle(
          titleDivider: true,
        ),
        title: Row(
          children: [
            if (icon != null) icon,
            const SizedBox(width: 5),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: contents,
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Core.goBack(context);
            },
          ),
          TextButton(
            onPressed: onPress,
            child: Text(gestureName),
          ),
        ],
      ),
    ).show(context);
  }

  static String removeHtmlTags(String htmlString) {
    final RegExp shortcodeExp =
        RegExp(r'\[.*?\]', multiLine: true, caseSensitive: false);
    String cleanedString = htmlString.replaceAll(shortcodeExp, '');
    final RegExp htmlExp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    cleanedString = cleanedString.replaceAll(htmlExp, '');
    return HtmlUnescape().convert(cleanedString);
  }

  static void showSnack(String message, {BuildContext? context}) {
    // Ensure context is not null
    context ??= navigatorKey.currentState?.overlay?.context;

    if (context != null) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      debugPrint("Unable to show snack: Context is null.");
    }
  }

  static Widget write(
      {required String text,
      double fontSize = 16.0,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.left,
      FontStyle fontStyle = FontStyle.normal,
      TextOverflow overflow = TextOverflow.fade,
      int? maxLines}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget inform({
    required String text,
    Color color = Colors.grey,
  }) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 13.0),
    );
  }

  static Widget title({required String title, Color color = Colors.black87}) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, color: color),
    );
  }

  static Widget head({
    required String head,
    Color color = Colors.black54,
  }) {
    return Text(
      head,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: 30.0,
      ),
    );
  }

  static Future<void> saveToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> loadFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<bool> checkNotificationPermission() async {
    var status = await Permission.notification.status;
    return status.isGranted;
  }

  static String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  static Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 350,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ListView(
        children: <Widget>[
          _buildListTile(
            context,
            icon: FluentIcons.call_48_regular,
            backgroundColor: Colors.green,
            title: "Phone call",
            subtitle: "Give us a call today for more enquiries",
            url: 'tel:+233555113115',
          ),
          _buildListTile(
            context,
            icon: FluentIcons.location_48_regular,
            backgroundColor: Colors.pink.shade400,
            title: "Get map directions",
            subtitle: "Get directions to our premises through the map",
            onTap: () => Core.openDirectionsSheet(context),
          ),
          _buildListTile(
            context,
            icon: FluentIcons.chat_48_regular,
            backgroundColor: Colors.teal,
            title: "WhatsApp",
            subtitle: "Reach out to us through our WhatsApp Handle",
            url: 'https://wa.me/+233598624778',
          ),
          _buildListTile(
            context,
            icon: FluentIcons.mail_48_regular,
            backgroundColor: Colors.red.shade600,
            title: "Email Us",
            subtitle: "Write to our email sessions",
            url: 'mailto:info@decapitalgrille.com',
          ),
          _buildListTile(
            context,
            icon: FluentIcons.mention_48_regular,
            backgroundColor: NielCol.people,
            title: "Via Website",
            subtitle: "Visit our website",
            url: 'https://decapitalgrille.com',
          ),
          _buildListTile(
            context,
            icon: Icons.facebook,
            backgroundColor: Colors.blue.shade800,
            title: "Our Facebook page",
            subtitle: "Connect with us through our facebook page",
            url: 'https://www.facebook.com/decapitalgrille',
          ),
          _buildListTile(
            context,
            icon: Icons.tiktok,
            backgroundColor: Colors.black,
            title: "Via TikTok",
            subtitle: "Get in touch with our handles available on TikTok",
            url: 'https://www.tiktok.com/@decapitalgrille',
          ),
        ],
      ),
    );
  }

  static Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    String? url,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: () {
        if (url != null) {
          launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
        } else if (onTap != null) {
          onTap();
        }
      },
      leading: CircleAvatar(
        backgroundColor: backgroundColor,
        foregroundColor: foreCol,
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Core.inform(text: subtitle),
    );
  }

  static Future<void> reviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing(
          appStoreId: appStoreId,
        );
      }
    } catch (e) {
      Core.snackThis('Error requesting review');
    }
  }

  static void showContactSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _buildBottomSheet(ctx),
    );
  }

  static Future<dynamic> sheet(
    BuildContext context,
    Widget Function(BuildContext) builder,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      isScrollControlled: true,
      builder: (ctx) => builder(ctx),
    );
  }

  static void showCustomSheet(BuildContext context) {
    Core.sheet(
      context,
      (ctx) => _buildPrivacyDraggableSheet(ctx),
    );
  }

  static void showTermsSheet(BuildContext context) {
    Core.sheet(
      context,
      (ctx) => _buildTermsDraggableSheet(ctx),
    );
  }

  static void showProductDetails(
    BuildContext context, {
    required String productName,
    required String productImageUrl,
    required double productPrice,
    required int productId,
    String? productDesc,
    Color? titleColor,
    Color? appBarColor,
  }) {
    Core.sheet(
        context,
        (ctx) => _buildProductsSheet(
              ctx,
              productName: productName,
              productImageUrl: productImageUrl,
              productPrice: productPrice,
              productId: productId,
              productDesc: productDesc,
              titleColor: titleColor,
              appBarColor: appBarColor,
            ));
  }

  static Widget _buildProductsSheet(
    BuildContext context, {
    required String productName,
    required String productImageUrl,
    required double productPrice,
    required int productId,
    final String? productDesc,
    final Color? titleColor,
    final Color? appBarColor,
  }) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      builder: (ctx, scrollController) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: appBarColor ?? Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomHeaderDelegate(
                      title: productName,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 350,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    productImageUrl,
                                    cacheKey: productImageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.transparent,
                                    appBarColor ?? Theme.of(context).canvasColor
                                  ],
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.transparent,
                                      appBarColor ??
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: titleColor ??
                                    Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              '$currency ${productPrice}0',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontVariations: [
                                  FontVariation('wght', 900),
                                ],
                                color: Colors.redAccent,
                                fontSize: 38,
                              ),
                            ),
                            Core.buildStarRating(
                              color:
                                  titleColor ?? Theme.of(context).primaryColor,
                              size: 25,
                            ),
                            if (productDesc != null && productDesc.isNotEmpty)
                              Text(Core.removeHtmlTags(productDesc)),
                            const SizedBox(
                              height: 22,
                            ),
                            if (productDesc == null || productDesc.isEmpty)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                              ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 22),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.59,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 236, 236, 236),
                                      ),
                                      child: TextButton(
                                          onPressed: () {
                                            final cartProvider = context
                                                .read<CartlistProvider>();
                                            final cartItem = CartlistItem(
                                              prodId: productId,
                                              imageUrl: productImageUrl,
                                              name: productName,
                                              price: productPrice,
                                            );
                                            cartProvider.addItem(cartItem);
                                            IconSnackBar.showOverlay(
                                                context: context,
                                                label:
                                                    '$productName added to Cart',
                                                snackBarType:
                                                    SnackBarType.save);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FluentIcons
                                                    .shopping_bag_add_20_regular,
                                                color: Colors.amber.shade700,
                                              ),
                                              Text(
                                                '  ADD TO CART',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.amber.shade700,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 0, 53, 86),
                                      ),
                                      child: TextButton(
                                          onPressed: () async {},
                                          child: const Row(
                                            children: [
                                              Icon(
                                                FluentIcons
                                                    .money_hand_20_regular,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                '  BUY NOW',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildTermsDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      builder: (ctx, scrollController) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomHeaderDelegate(
                      title: 'Terms and Conditions(TnCs)',
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPolicySection(
                                context,
                                title: "",
                                content: "Last updated December 31, 2023 \n",
                              ),
                              _buildPolicySection(
                                context,
                                number: "-",
                                title: "Introduction",
                                content:
                                    "By using the De Capital Hotels and Restaurant mobile app, you agree to these Terms & Conditions. This agreement sets forth the legally binding terms for your use of our app to order food and beverages for delivery.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "1",
                                title: "Account Registration",
                                content:
                                    "1. User Account: To access certain features of the app, you must register for an account. You agree to provide accurate and complete information and to keep this information up to date.\n\n2. Account Security: You are responsible for maintaining the security of your account, including your password. De Capital Hotels and Restaurant is not liable for any loss or damage resulting from your failure to comply with this security obligation.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "2",
                                title: "Our Menus and Ordering",
                                content:
                                    "1. Menu and Prices: The app provides a menu of food and beverage options with prices. De Capital Hotels and Restaurant reserves the right to change the menu and pricing at any time without prior notice.\n\n2. Order Confirmation: Once you place an order, you will receive an order confirmation through the app and email. Please review your order carefully, as you are responsible for any errors in the order details provided. \n\n3. You are entitled to provide a complete legal address/location to which your orders will be sent to you. We will not be held accountable for wrong address and informations when you have paid for orders and as such refunds will not be made for these related actions.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "3",
                                title: "Payments",
                                content:
                                    "1. Payment Methods: The app accepts payment via credit/debit cards and Mobile Money payment gateways. All payments must be made at the time of order.\n\n2. Billing Information: By providing your payment information, you authorize us to charge the total order amount to your selected payment method.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "4",
                                title: "Delivery",
                                content:
                                    "1. Delivery Location: Orders are delivered to the address provided by you in the app. Ensure that the location is accurate to avoid delays or non-delivery.\n\n2. Delivery Time: Estimated delivery times are provided but are subject to change due to traffic, weather, or other unforeseen factors. De Capital Hotels and Restaurant does not guarantee a specific delivery time.\n\n3. Acceptance of Delivery: You are responsible for accepting the delivery at the provided address. De Capital Hotels and Restaurant is not liable if you are unavailable or unreachable during the delivery attempt.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "5",
                                title: "Cancellations and Refunds",
                                content:
                                    "1. Order Cancellation: You may cancel your order within 5 minutes after placing it on our website as at the moment. After this period, cancellations may not be accepted.\n\n2. Refunds: Refunds are issued at the discretion of De Capital Hotels and Restaurant. Refunds are not guaranteed for late deliveries or minor order errors. Contact customer support for any concerns regarding refunds.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "6",
                                title: "User Responsibilities",
                                content:
                                    "1. Use of the App: You agree to use the app only for lawful purposes and in compliance with all applicable laws.\n\n2. Prohibited Conduct: You may not engage in any conduct that interferes with or disrupts the app, or use the app to defraud or harm other users or De Capital Hotels and Restaurant.\n\n3. Content Ownership: Any images, text, or content you submit to the app remains your property. By submitting content, you grant De Capital Hotels and Restaurant a limited, non-exclusive license to use, display, and distribute the content within the app.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "7",
                                title: "Limitation of Liability",
                                content:
                                    "1. To the maximum extent permitted by law, De Capital Hotels and Restaurant is not liable for any indirect, incidental, or consequential damages resulting from your use of the app.\n\n2. These Terms & Conditions are governed by the laws of Ghana. Any disputes will be resolved exclusively in the courts of Ghana.\n\n3. If you have any questions about these Terms & Conditions, please contact us at admin@decapitalgrille.com\n",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildPrivacyDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      builder: (ctx, scrollController) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomHeaderDelegate(
                      title: 'Privacy Policy',
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPolicySection(
                                context,
                                number: "-",
                                title: "Introduction",
                                content:
                                    "For the purpose of the General Data Protection Regulation, the data controller in De Capital Group of Companies Limited, a registered company in Ghana located Behind The Goaso Nursing and Midwifery Training College, Goaso, Ahafo Region, Ghana, De Capital Hotels and Restaurant (\"We\" or \"Us\" or \"Our\") are committed to ensuring your privacy is protected. This Privacy Policy sets out details of the information that we may collect from you and how we may use that information. Please take your time to read this Privacy Policy carefully. When using our App, this Privacy Policy should be read alongside the terms and conditions.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "1",
                                title: "ABOUT US",
                                content:
                                    "This Privacy Policy describes how De Capital Group, trading as De Capital Hotels and Restaurant (\"we\" or \"us\" or \"our\") collect and process data about individuals on our platforms. We collect personal data when you use our services. This includes, but is not limited to, your full names, email, your phone number, your address, your date of birth, your password and payment information.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "2",
                                title: "Data Usage",
                                content:
                                    "1. To aid Us in sending your orders to your right locations as well reach out to when there is the need. \n\n2. To best identify you our cherish customer so as to ensure that we are dealing with the rightful person. \n\n3. To provide you with the information, products and services that you request from us. \n\n4. Your data is used to enhance your experience on our platforms. \n\n5. To notify you about changes to our service. \n\n6. To ensure that content from our site is presented in the most effective manner for you and for your device. \n\n7. To validate discounts and verify your identify. \n\n8. We may also use it to send you promotional offers. \n\n9. To measure or understand the effectiveness of advertising we serve to you and others, and to deliver relevant advertising to you and others. ",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "3",
                                title: "WHO WE MAY SHARE YOUR INFORMATION WITH",
                                content:
                                    "We may share your informations which may include everything BUT NOT your 'passwords' and/or 'payments informations' to Core members of our company, which means our subsidiaries, our ultimate company holdings and its subsidiaries. We DO NOT share your any information of your informations to persons/companies/groups/organizations NOT in our Core list of members.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(context,
                                  number: "4",
                                  title: "KEEPING YOUR DATA SECURE",
                                  content:
                                      "Data security is of great importance to us and to protect your data we have put in place suitable physical, electronic and managerial procedures to safeguard and secure your collected data. We take core security measures to protect your information including: \n\nLimiting access to our Core App DATA to those that we believe are entitled to be there (by use of passwords, password obfistications, OTPs, encryptions among other related technologies). \n\nCarrying out appropriate risk-based diligence and penetration testing on our Core servers and processors as to ensure any illegal attempt to access our core platforms as well as users information is dealt with. \n\nAll information you provide to us is stored on our secure servers. Any payment transactions will be encrypted using SSL technology. Unfortunately, the transmission of information via the internet is not completely secure. Although we will do our best to protect your personal data, we cannot guarantee the security of your data transmitted to our site; any transmission is at your own risk. Once we have received your information, we will use strict procedures and security features to try to prevent unauthorised access."),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "5",
                                title: "HOW LONG WE WILL STORE YOUR DATA",
                                content:
                                    "We retain a record of your personal information in order to provide you with a high quality and consistent service. We will always retain your personal information in accordance with the General Data Protection Regulation (GDPR) and never retain your information for longer than is necessary. For more information, you may contact our Administrators/Developers below.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "6",
                                title: "YOUR RIGHTS",
                                content:
                                    "Under the Legislation you have the right to make certain requests in relation to the personal information that we hold about you. We will not usually make a charge for dealing with these requests. If you wish to exercise these rights at any time please contact us using the details set out in the \"Contact US\" section.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "7",
                                title:
                                    "WHAT HAPPENS IF OUR BUSNIESS CHANGES HANDS?",
                                content:
                                    "We may, from time to time, expand or reduce our business and this may involve the sale and/or the transfer of control of all or part of our business. Any personal data that you have provided will, where it is relevant to any part of our business that is being transferred, be transferred along with that part and the new owner or newly controlling party will, under the terms of this Privacy Policy, be permitted to use that data only for the purposes for which it was originally collected by us.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "8",
                                title: "CHANGES TO OUR PRIVACY POLICY",
                                content:
                                    "We will make changes to this privacy policy from time to time. Any updates to the privacy policy in the future will be posted on this page. Please check back to see any updates or changes to our privacy policy.",
                              ),
                              const SizedBox(height: 10.0),
                              _buildPolicySection(
                                context,
                                number: "-",
                                title: "CONTACT",
                                content:
                                    "Location: Behind The Goaso Nursing and Midwifery Training College, Goaso, Ahafo Region, Ghana. \n\nPhone: 0555113115 \n\nEmail: admin@decapitalgrille.com \n\nWebsite: https://decapitalgrille.com \n",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildPolicySection(
    BuildContext context, {
    String? number,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number != null)
          CircleAvatar(
            radius: 12.0,
            backgroundColor: const Color.fromARGB(255, 0, 40, 72),
            child: Text(
              number,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 179, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (number != null) const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Flutter Local Notifications Plugin instance
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Method to initialize the plugin (should be called at the app's startup)
  // void main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Core.initNotifications(); // Initialize notifications
  //   runApp(MyApp());
  // }
  static Future<void> initNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // Android Initialization Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('decapitalgrille');
    // iOS Initialization Settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
    String? channelId = 'default_channel',
    String? channelName = 'Default Channel',
    String? channelDescription = 'This is the default notification channel',
    int? customNotificationId,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    int notificationId = customNotificationId ?? 0;

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: 'item id 1',
    );
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  String? subtitle;
  Widget? subtitleWidget;

  _CustomHeaderDelegate({required this.title});

  @override
  double get minExtent => 100;
  @override
  double get maxExtent => 100;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: subtitle != null || subtitleWidget != null
          ? const EdgeInsets.only(left: 12, top: 10)
          : const EdgeInsets.only(left: 12, top: 50),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context)
              .colorScheme
              .shadow
              .withValues(alpha: 1 - shrinkOffset / maxExtent),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CustomHeaderDelegate oldDelegate) {
    return oldDelegate.title != title;
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  CustomMaterialPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  @protected
  bool get hasScopedWillPopCallback => false;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (isFirst) return child;
    final slideTransition =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut))
            .animate(animation);
    return SlideTransition(
      position: slideTransition,
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

bool isUserLoggedIn() {
  return true;
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '';
  }
}
