// ignore_for_file: use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api, unrelated_type_equality_checks
//Theming
import 'dart:math';

import 'package:decapitalgrille/page/report_handling/main.dart';
import 'package:decapitalgrille/page/setting/settings.dart';
import 'package:decapitalgrille/page/video_shop/main.dart';
import 'package:decapitalgrille/providers/address_provider.dart';
import 'package:decapitalgrille/providers/auth_provider.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/providers/wishlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/theme/typography.dart';
//Pages
import 'package:decapitalgrille/page/menus_page.dart';
import 'package:decapitalgrille/page/blogs_page.dart';
import 'package:decapitalgrille/page/categories_page.dart';
import 'package:decapitalgrille/page/cart_page.dart';
import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/page/wishlist/main.dart';
import 'package:decapitalgrille/page/report_handling/no_internet_page.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//UX and Others
import 'package:introduction_screen/introduction_screen.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:provider/provider.dart';
//Inter and Services
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Core.initNotifications();
  await TranslationService().loadLanguage('en');

  EasyLoading.init();
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..indicatorSize = 40.0
    ..radius = 12.0
    ..progressColor = Colors.green
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskType = EasyLoadingMaskType.black
    ..maskColor = Colors.black.withOpacity(0.4)
    ..userInteractions = false
    ..dismissOnTap = false;

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool showIntroduction = prefs.getBool('showIntroduction') ?? true;

  tz.initializeTimeZones();

  if (!showIntroduction) {
    scheduleDailyNotifications();
  }

  final List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();
  bool isDeviceConnected = false;

  try {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
  } catch (e) {
    Core.snackThis('Error checking connection');
  }

  Core.registerRoute('/setting', (context, args) => const SettingsPage());

  runApp(
    connectivityResult != ConnectivityResult.none && isDeviceConnected
        ? MyApp(showIntroduction)
        : const MaterialApp(home: NoInternetPage()),
  );
}

class MyApp extends StatelessWidget {
  final bool showIntroduction;

  const MyApp(this.showIntroduction, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WishlistProvider>(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
        ChangeNotifierProvider<CartlistProvider>(
          create: (_) => CartlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initAuth(),
        ),
      ],
      child: MaterialApp(
        home: showIntroduction
            ? const IntroductionScreenApp()
            : const DeCapitalGrille(),
      ),
    );
  }
}

void scheduleDailyNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('decapitalgrille');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  tz.TZDateTime morningTime =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 15);
  tz.TZDateTime afternoonTime =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 13, 15);
  tz.TZDateTime eveningTime =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 18, 15);

  if (morningTime.isBefore(now)) {
    morningTime = morningTime.add(const Duration(days: 1));
  }
  if (afternoonTime.isBefore(now)) {
    afternoonTime = afternoonTime.add(const Duration(days: 1));
  }
  if (eveningTime.isBefore(now)) {
    eveningTime = eveningTime.add(const Duration(days: 1));
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    getRandomMessage(morningTitles),
    getRandomMessage(morningMessages),
    morningTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_1',
        'Breakfast',
        channelDescription: 'This channel is used for morning notifications.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    2,
    getRandomMessage(afternoonTitles),
    getRandomMessage(afternoonMessages),
    afternoonTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_2',
        'Afternoon Notification',
        channelDescription: 'This channel is used for afternoon notifications.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    3,
    getRandomMessage(eveningTitles),
    getRandomMessage(eveningMessages),
    eveningTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_3',
        'Evening Notification',
        channelDescription: 'This channel is used for evening notifications.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

String getRandomMessage(List<String> messages) {
  final random = Random();
  return messages[random.nextInt(messages.length)];
}

final List<String> morningTitles = [
  "It's Breakfast time",
  "Rise and Shine!",
  "Good Morning, Sunshine!",
  "Wakey, Wakey!",
  "Morning Delight Awaits!"
];
final List<String> morningMessages = [
  "Good morning! 🍵 Breakfast is ready, kindly place an order now.",
  "Start your day with a delicious breakfast! 🌞",
  "Morning! Ready for a hearty breakfast?",
  "Good morning! Treat yourself to a delightful breakfast 🍳.",
  "Rise and shine! A sumptuous breakfast awaits you 🌅."
];
final List<String> afternoonTitles = [
  "Are you hungry?",
  "Lunchtime!",
  "Midday Munchies!",
  "Afternoon Delight",
  "Lunch Break!"
];
final List<String> afternoonMessages = [
  "Good afternoon! Want something special 🍽️ for you and your loved ones?",
  "It’s lunchtime! Treat yourself to something tasty. 😋",
  "Lunch is served! Come and enjoy a great meal. 🍛",
  "Feeling peckish? It’s time for a delightful lunch! 🥪",
  "Savor the afternoon with a delicious meal. 🍜"
];
final List<String> eveningTitles = [
  "Enjoyed the day?",
  "Evening Delight",
  "Good Evening!",
  "Dinner Time!",
  "Evening Feast"
];
final List<String> eveningMessages = [
  "Good evening! We know you had a nice day because we did. Grab your supper and see how we did. 🌙",
  "Wind down with a perfect supper. 🍷",
  "Evening meals to make your day complete. 🍲",
  "The perfect end to a great day: a sumptuous dinner! 🌆",
  "Relax and enjoy a delightful evening meal. 🥂"
];

class IntroductionScreenApp extends StatelessWidget {
  const IntroductionScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroductionScreenPage(),
    );
  }
}

class IntroductionScreenPage extends StatelessWidget {
  IntroductionScreenPage({super.key});

  final String appName = TranslationService().translate('app_name');

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _getPages(),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: false,
      skip: const Text("Skip"),
      next: const Icon(
        FluentIcons.chevron_circle_right_20_regular,
        size: 30,
      ),
      done: Core.inform(text: "Start now"),
      skipOrBackFlex: 1,
      dotsFlex: 2,
      nextFlex: 2,
    );
  }

  List<PageViewModel> _getPages() {
    return [
      _buildPage(
        title: 'Welcome to $appName',
        body:
            'Where our Mission is to Serve you with delicious, fresh, crispy and hot meals every moment. Our vision is to make sure your meals are served to you at the right time and hassle-free. Take a walk as we show you how it is done.',
        image: Core.logoRaw,
      ),
      _buildPage(
        title: 'Browsing the list',
        body:
            'Our menus are selected and prepared with you in mind. Go through the menu and choose your choice of meals to continue. If you find difficulties, try the search or categories section. It is that simple.',
        image: Image.asset('images/app/food.png', height: 200.0, width: 200.0),
      ),
      _buildPage(
        title: 'View your Cart',
        body:
            'Got the meals you want? Hit the add to cart button (Basket) to add your meals to the shopping bag. Don\'t worry, you can always remove unwanted ones later. Add as many as you can.',
        image: Image.asset('images/cart/cart_items.png',
            height: 200.0, width: 200.0),
      ),
      _buildPage(
        title: 'Pay for your orders',
        body:
            'If your Cart is ready with your meals, go to your Cart and hit Order/Pay now button, log in if not done already, and choose your method of payment (ATM Card, MoMo, or Pay On-Delivery) and shipping method to complete the process.',
        image: Image.asset('images/icons/dollar-dynamic-premium.png',
            height: 200.0, width: 200.0),
      ),
      _buildPage(
        title: 'Your meals are on the way',
        body:
            'Boom!!! You\'re just a minute away from your meals. If the process was through and you had the purchase confirmed notification then your meal is on the way. \n Bon Appétit, enjoy your meal.',
        image: Image.asset('images/order/success.png',
            height: 250.0, width: 250.0),
      ),
      _buildPage(
        title: 'Contact Us',
        body:
            'We are always here for you. Reach out to us on any part of the app when necessary. Thiis can be done on the Settings screen under Contact US. Or go to your account page and then click on Customer service button. We love to hear from you.',
        image: Image.asset('images/icons/chat-bubble-dynamic-color.png',
            height: 250.0, width: 250.0),
      ),
    ];
  }

  PageViewModel _buildPage(
      {required String title, required String body, required Widget image}) {
    return PageViewModel(
      titleWidget: Core.head(head: title, color: Colors.black),
      bodyWidget: Core.inform(text: body),
      image: image,
    );
  }

  Future<void> _onIntroEnd(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showIntroduction', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DeCapitalGrille()),
    );
  }
}

class DeCapitalGrille extends StatelessWidget {
  const DeCapitalGrille({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De Capital Grille',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: textTheme,
        fontFamily: 'DMSans',
      ),
      darkTheme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: NoSplash.splashFactory,
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: textTheme,
        fontFamily: 'DMSans',
      ),
      themeMode: ThemeMode.system,
      home: UpgradeAlert(
        showIgnore: false,
        child: _offlineBuilder,
      ),
      builder: EasyLoading.init(),
    );
  }
}

final Widget _offlineBuilder = OfflineBuilder(
  connectivityBuilder: (
    BuildContext context,
    List<ConnectivityResult> connectivity,
    Widget child,
  ) {
    final bool connected = !connectivity.contains(ConnectivityResult.none);
    if (connected) {
      return MyHomePage(
        title: TranslationService().translate('app_name'),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("Lost Internet Connection"),
          content: ErrorHandler.errorThis(
            'It seems your internet connection is lost. Please check your connection and try again.',
            image: 'images/app/404.png',
            imageSize: 300,
          ),
        ),
      );
    }
  },
  child: MyHomePage(
    title: TranslationService().translate('app_name'),
  ),
);

final GlobalKey<_MyHomePageState> myHomePageKey = GlobalKey<_MyHomePageState>();

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title}) : super(key: myHomePageKey);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> appPages = [];
  final Map<int, ScrollController> _scrollControllers = {};
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 5; i++) {
      _scrollControllers[i] = ScrollController();
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.2).animate(_controller);

    appPages.addAll([
      const MenuPage(),
      const CategoryPage(),
      const BlogPage(),
      CartPage(scrollController: _scrollControllers[3]!),
      AccountPage(scrollController: _scrollControllers[4]!),
    ]);

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'my_cart') {
        setState(() => _currentIndex = 3);
      } else if (shortcutType == 'food_menus') {
        setState(() => _currentIndex = 0);
      } else if (shortcutType == 'wishlist') {
        Navigator.of(context).push(Core.smoothFadePageRoute(
          context,
          const WishlistPage(),
        ));
      } else if (shortcutType == 'video_store') {
        Navigator.of(context).push(Core.smoothFadePageRoute(
          context,
          const VideoShop(),
        ));
      }
    });
    quickActions.setShortcutItems([
      const ShortcutItem(
          type: 'my_cart', localizedTitle: 'My Cart', icon: 'cart_icon'),
      const ShortcutItem(
          type: 'food_menus', localizedTitle: 'Food Menus', icon: 'food_icon'),
      const ShortcutItem(
          type: 'wishlist',
          localizedTitle: 'My Wishlists',
          icon: 'wishlist_icon'),
      const ShortcutItem(
          type: 'video_store',
          localizedTitle: 'Video Store',
          icon: 'video_store_icon'),
    ]);
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleTabTap(int index) {
    final now = DateTime.now();
    final currentTime = now.millisecondsSinceEpoch;
    int lastTapIndex = -1;
    int lastTapTime = 0;
    const int doubleTapTimeout = 400;

    if (_currentIndex != index) {
      HapticFeedback.selectionClick();
      Posthog().screen(
        screenName: 'Example Screen',
      );
      setState(() => _currentIndex = index);
      _controller.forward().then((_) => _controller.reverse());
      lastTapIndex = index;
      lastTapTime = currentTime;
      return;
    }

    // Same tab tapped
    if (lastTapIndex == index &&
        (currentTime - lastTapTime) < doubleTapTimeout) {
      _scrollControllers[index]?.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    lastTapIndex = index;
    lastTapTime = currentTime;
  }

  @override
  Widget build(BuildContext context) {
    final int cartlistItemsCount = context
        .read<CartlistProvider>()
        .calculateTotalCount(context.watch<CartlistProvider>().cartlistItems);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.99, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
            ),
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: IndexedStack(
            key: ValueKey<int>(_currentIndex),
            index: _currentIndex,
            children: appPages,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          enableFeedback: true,
          useLegacyColorScheme: false,
          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? ScaleTransition(
                      scale: _animation,
                      child: const Icon(FluentIcons.home_20_regular),
                    )
                  : const Icon(FluentIcons.home_20_regular),
              activeIcon: ScaleTransition(
                scale: _animation,
                child: const Icon(FluentIcons.home_20_filled),
              ),
              label: 'Home',
              backgroundColor: Colors.amber,
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? ScaleTransition(
                      scale: _animation,
                      child: const Icon(FluentIcons.food_20_regular),
                    )
                  : const Icon(FluentIcons.food_20_regular),
              activeIcon: ScaleTransition(
                scale: _animation,
                child: const Icon(FluentIcons.food_20_filled),
              ),
              label: 'Our Menus',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? ScaleTransition(
                      scale: _animation,
                      child: const Icon(FluentIcons.news_20_regular),
                    )
                  : const Icon(FluentIcons.news_20_regular),
              activeIcon: ScaleTransition(
                scale: _animation,
                child: const Icon(FluentIcons.news_20_filled),
              ),
              label: 'Blogs',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? ScaleTransition(
                      scale: _animation,
                      child: cartlistItemsCount > 0
                          ? Badge(
                              label: Text(
                                cartlistItemsCount.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: const Icon(
                                  FluentIcons.shopping_bag_20_regular),
                            )
                          : const Icon(FluentIcons.shopping_bag_20_regular),
                    )
                  : cartlistItemsCount > 0
                      ? Badge(
                          label: Text(
                            cartlistItemsCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          child:
                              const Icon(FluentIcons.shopping_bag_20_regular),
                        )
                      : const Icon(FluentIcons.shopping_bag_20_regular),
              activeIcon: ScaleTransition(
                scale: _animation,
                child: cartlistItemsCount > 0
                    ? Badge(
                        label: Text(
                          cartlistItemsCount.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        child: const Icon(FluentIcons.shopping_bag_20_filled),
                      )
                    : const Icon(FluentIcons.shopping_bag_20_filled),
              ),
              label: 'Cart',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? ScaleTransition(
                      scale: _animation,
                      child: authProvider.isLoggedIn
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  authProvider.avatar,
                                  fit: BoxFit.cover,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            )
                          : const Icon(FluentIcons.person_circle_20_regular),
                    )
                  : authProvider.isLoggedIn
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              authProvider.avatar,
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        )
                      : const Icon(FluentIcons.person_circle_20_regular),
              activeIcon: ScaleTransition(
                scale: _animation,
                child: authProvider.isLoggedIn
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            authProvider.avatar,
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      )
                    : const Icon(FluentIcons.person_circle_20_filled),
              ),
              label:
                  authProvider.isLoggedIn ? authProvider.acTabName : 'Account',
            )
          ],
          elevation: 10,
          onTap: _handleTabTap,
        ),
      ),
    );
  }
}
