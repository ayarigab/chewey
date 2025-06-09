// ignore_for_file: use_build_context_synchronously

import 'package:caroulina/caroulina.dart';
import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/page/coupons/main.dart';
import 'package:decapitalgrille/page/orders/order_page.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/providers/wishlist_provider.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:decapitalgrille/slots/clippaths/wave.dart';
import 'package:woocommerce/woocommerce.dart';
import 'package:decapitalgrille/page/setting/settings.dart';
import 'package:decapitalgrille/page/wishlist/main.dart';
import 'package:decapitalgrille/page/notification/main.dart';
import 'package:decapitalgrille/page/search.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'categories_page.dart';

class MenuPage extends StatefulWidget {
  final ScrollController? scrollController;
  const MenuPage({this.scrollController, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  get newMenusKey => null;

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {});
    }

    if (newMenusKey?.currentState != null) {
      newMenusKey.currentState!.onRefresh();
    }

    _refreshController.refreshCompleted();

    if (_refreshController.isLoading) {
      _refreshController.loadComplete();
    }
  }

  void _onLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() {});
    if (_refreshController.isLoading) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistItemsCount =
        context.watch<WishlistProvider>().wishlistItems.length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {},
        child: Visibility(
          visible: true,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                Core.smoothFadePageRoute(
                  context,
                  const CouponsPage(),
                ),
              );
            },
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.asset("images/app/gift-coupon.gif"),
            ),
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        scrollController: widget.scrollController,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 55.0, bottom: 10.0, right: 8.0, left: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            Core.smoothFadePageRoute(
                              context,
                              const SearchPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FluentIcons.search_20_filled,
                              ),
                              DefaultTextStyle(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  onTap: () => Navigator.of(context).push(
                                    Core.smoothFadePageRoute(
                                      context,
                                      const SearchPage(),
                                    ),
                                  ),
                                  pause: const Duration(seconds: 2),
                                  animatedTexts: [
                                    'Search For anything',
                                    'Banku and Okro',
                                    'Fufu with Light soup',
                                    'T.Z and Ayoyo',
                                    'Freshyogurt',
                                    'Hamburgers',
                                    'Special Wakye',
                                    'Special Gob3',
                                    'Special Sobolo',
                                    'Atadwe Drink'
                                  ]
                                      .map((text) => FadeAnimatedText(
                                            text,
                                            textStyle: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(FluentIcons.settings_20_regular,
                              color: Theme.of(context).colorScheme.shadow),
                          onPressed: () {
                            // Core.navigateTo(context, '/setting');
                            Navigator.of(context).push(Core.smoothFadePageRoute(
                                context, const SettingsPage()));
                          },
                        ),
                        IconButton(
                          icon: wishlistItemsCount > 0
                              ? Badge(
                                  label: Text(
                                    wishlistItemsCount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: Icon(FluentIcons.heart_24_regular,
                                      color:
                                          Theme.of(context).colorScheme.shadow),
                                )
                              : Icon(FluentIcons.heart_24_regular,
                                  color: Theme.of(context).colorScheme.shadow),
                          onPressed: () {
                            Navigator.of(context).push(Core.smoothFadePageRoute(
                                context, const WishlistPage()));
                          },
                        ),
                        IconButton(
                          icon: Icon(FluentIcons.document_data_32_regular,
                              color: Theme.of(context).colorScheme.shadow),
                          onPressed: () {
                            Navigator.of(context).push(Core.smoothFadePageRoute(
                                context, const OrderPage()));
                          },
                        ),
                        IconButton(
                          icon: Badge(
                            label: const Text(
                              '4',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(FluentIcons.alert_24_regular,
                                color: Theme.of(context).colorScheme.shadow),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(Core.smoothFadePageRoute(
                                context, const NotifPage()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              NewMenus(key: newMenusKey, onRefresh: _onRefresh),
              const SizedBox(height: 80),
              const Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black54,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black54,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected menus just for you',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const YourContentWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class NewMenus extends StatelessWidget {
  final Function onRefresh;

  const NewMenus({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    double responsiveWidth = Core.responsiveWidth(context, 0.95);
    double responsiveHeight = Core.responsiveHeight(context, 0.3);

    WooCommerce wooCommerce = WooCommerce(
      baseUrl: url,
      consumerKey: cKey,
      consumerSecret: cCret,
    );

    Future<List<WooProduct>> fetchProductsFeatured() async {
      final products = await wooCommerce.getProducts(featured: true);
      return products;
    }

    Future<List<WooProduct>> fetchProductsHot() async {
      final products = await wooCommerce.getProducts(onSale: true);
      return products;
    }

    Future<List<WooProduct>> fetchProductsDegrille() async {
      final products = await wooCommerce.getProducts(search: 'decapital');
      return products;
    }

    Future<List<WooProduct>> fetchProducts() async {
      final products = await wooCommerce.getProducts();
      return products;
    }

    return Column(
      children: <Widget>[
        ClipPath(
          clipper: WaveClip(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            height: 150.0,
            color: Theme.of(context).colorScheme.surface,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('images/degrille/icon/logo.png',
                          width: 70.0, height: 70.0),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            TranslationService().translate('app_name'),
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.amber.shade300,
                            ),
                            // color: Color.fromARGB(119, 255, 255, 255)),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText(
                                    TranslationService().translate('notice')),
                                TyperAnimatedText(TranslationService()
                                    .translate('transition')),
                                TyperAnimatedText(TranslationService()
                                    .translate('notice_click')),
                              ],
                              onTap: () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                myHomePageKey.currentState?.setIndex(2);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0.0, -0.22 * responsiveHeight),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(35.0),
            ),
            height: 150,
            width: responsiveWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Caroulina(
                    images: const [
                      CachedNetworkImageProvider(
                          'https://decapitalgrille.com/wp-content/uploads/2024/10/banner1.webp',
                          cacheKey: 'banner1'),
                      CachedNetworkImageProvider(
                          'https://decapitalgrille.com/wp-content/uploads/2024/10/banner2.webp',
                          cacheKey: 'banner2'),
                      CachedNetworkImageProvider(
                          'https://decapitalgrille.com/wp-content/uploads/2024/10/banner3.webp',
                          cacheKey: 'banner3'),
                      CachedNetworkImageProvider(
                          'https://decapitalgrille.com/wp-content/uploads/2024/10/banner4.webp',
                          cacheKey: 'banner4'),
                      CachedNetworkImageProvider(
                          'https://decapitalgrille.com/wp-content/uploads/2024/10/banner5.webp',
                          cacheKey: 'banner5'),
                    ],
                    dotSize: 4.0,
                    autoplayDuration: const Duration(seconds: 5),
                    dotSpacing: 15.0,
                    dotColor: const Color.fromARGB(255, 255, 255, 255),
                    indicatorBgPadding: 5.0,
                    dotBgColor:
                        const Color.fromARGB(255, 0, 0, 0).withOpacity(0.0),
                    borderRadius: true,
                    overlayShadow: true,
                    onImageChange: (currentImageIndex, currentPage) {},
                    dynamicDots: true,
                    pauseOnInteraction: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 45.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              newCategory("images/categories/local.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      category: '37',
                    ),
                  ),
                );
              }),
              newCategory("images/categories/burger.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      category: '45',
                    ),
                  ),
                );
              }),
              newCategory("images/categories/cake_2.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      text: 'Cake',
                    ),
                  ),
                );
              }),
              newCategory("images/categories/drinks.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      category: '53',
                    ),
                  ),
                );
              }),
              newCategory("images/categories/vegetarian.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      category: '153',
                    ),
                  ),
                );
              }),
              newCategory("images/categories/tea.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      category: '48',
                    ),
                  ),
                );
              }),
              newCategory("images/categories/noodles_3.png", onTap: () {
                Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const SearchPage(
                      category: '50',
                    ),
                  ),
                );
              }),
              newCategory(
                "images/categories/fruits_1.png",
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const SearchPage(
                        category: '150',
                      ),
                    ),
                  );
                },
              ),
              newCategory(
                "images/categories/lunch.png",
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const SearchPage(
                        category: '51',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Core.buildSectionHeader('New Menus', context, () {
          Navigator.of(context).push(
            Core.smoothFadePageRoute(
              context,
              const SearchPage(
                category: '51',
              ),
            ),
          );
        }),
        Core.buildProductList(fetchProducts(), context),
        Core.buildSectionHeader('De Capital\'s Special', context, () {
          Navigator.of(context).push(
            Core.smoothFadePageRoute(
              context,
              const SearchPage(
                text: 'Decapital',
              ),
            ),
          );
        }),
        Core.buildProductList(fetchProductsDegrille(), context),
        Core.buildSectionHeader('Hot Menus', context, () {
          Navigator.of(context).push(
            Core.smoothFadePageRoute(
              context,
              const SearchPage(
                category: '37',
              ),
            ),
          );
        }),
        Core.buildProductList(fetchProductsHot(), context),
        Core.buildSectionHeader('Featured Menus', context, () {
          Navigator.of(context).push(
            Core.smoothFadePageRoute(
              context,
              const SearchPage(
                featured: true,
              ),
            ),
          );
        }),
        Core.buildProductList(fetchProductsFeatured(), context),
      ],
    );
  }
}

Widget newCategory(String imgPath, {VoidCallback? onTap, dynamic data}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      width: 50.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgPath),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
    ),
  );
}

Widget getItemImg(String? imageUrl) {
  const defaultImageUrl = 'images/degrille/waitress.jpg';

  return Container(
    margin: const EdgeInsets.all(5),
    // height: 180,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: CachedNetworkImageProvider(imageUrl ?? defaultImageUrl,
            cacheKey: imageUrl),
        fit: BoxFit.cover,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
  );
}

class YourContentWidget extends StatefulWidget {
  const YourContentWidget({super.key});

  @override
  State<YourContentWidget> createState() {
    return _YourContentWidgetState();
  }
}

class _YourContentWidgetState extends State<YourContentWidget> {
  late Future<List<WooProduct>> _products;

  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }

  Future<List<WooProduct>> fetchProducts() async {
    final products = await wooCommerce.getProducts(
        order: 'asc', orderBy: 'popularity', perPage: 20);
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WooProduct>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Core.loadThis(context);
        } else if (snapshot.hasError) {
          return ErrorHandler.errorThis(
            image: 'images/errors/no_internet_error.png',
            'An error occured! Refresh/try again',
            onRetry: () => _MenuPageState()._onRefresh,
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return ErrorHandler.errorThis(
            image: 'images/errors/empty_box_error.png',
            'No products available!',
            onRetry: () => _MenuPageState()._onRefresh,
          );
        } else {
          final products = snapshot.data!;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (.7),
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () async {
                  final Color? titleColor;
                  final Color? appBarColor;
                  final PaletteGenerator pg =
                      await PaletteGenerator.fromImageProvider(
                    CachedNetworkImageProvider(
                      product.images?[0].src ?? '',
                    ),
                  );
                  titleColor = pg.mutedColor?.color;
                  appBarColor = pg.lightVibrantColor?.color;
                  Core.showProductDetails(
                    context,
                    productName: product.name ?? 'Unknown Food',
                    productImageUrl: product.images?[0].src ?? '',
                    productPrice: double.tryParse(product.price ?? '') ?? 0.0,
                    productId: product.id ?? 0,
                    productDesc: product.description ?? '',
                    titleColor: titleColor,
                    appBarColor: appBarColor,
                  );
                },
                child: SizedBox(
                  height: 350,
                  child: Card(
                      color: Theme.of(context).colorScheme.onTertiary,
                      surfaceTintColor:
                          Theme.of(context).colorScheme.onTertiary,
                      shadowColor: Theme.of(context).colorScheme.primary,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 150.0,
                              child: Stack(
                                children: [
                                  getItemImg(product.images?[0].src),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: [0.0, 0.5],
                                              colors: [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Colors.transparent
                                              ],
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 15.0,
                                            backgroundColor:
                                                Colors.white.withAlpha(220),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                onPressed: () {
                                                  final item = WishlistItem(
                                                    prodId: product.id ?? 0,
                                                    imageUrl: product
                                                            .images?[0].src ??
                                                        '',
                                                    name: product.name ??
                                                        'Unknown Food',
                                                    price: double.tryParse(
                                                            product.price ??
                                                                '0') ??
                                                        0,
                                                  );

                                                  final wishlistProvider =
                                                      context.read<
                                                          WishlistProvider>();
                                                  final isInWishlist =
                                                      wishlistProvider
                                                          .itemExists(item);

                                                  if (isInWishlist) {
                                                    Core.snackThis(
                                                        context: context,
                                                        '${product.name} already in your Wishlist',
                                                        type: 'alert');
                                                  } else {
                                                    wishlistProvider
                                                        .addItem(item);
                                                    Core.snackThis(
                                                        context: context,
                                                        '${product.name} added to Wishlist',
                                                        type: 'save');
                                                  }
                                                },
                                                icon:
                                                    Consumer<WishlistProvider>(
                                                  builder: (context,
                                                      wishlistProvider, child) {
                                                    final isInWishlist =
                                                        wishlistProvider
                                                            .wishlistItems
                                                            .any((item) =>
                                                                item.prodId ==
                                                                product.id);
                                                    return Icon(
                                                      size: 15,
                                                      isInWishlist
                                                          ? FluentIcons
                                                              .heart_20_filled
                                                          : FluentIcons
                                                              .heart_12_regular,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 251, 62, 62),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? 'Unknown Food',
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '$currency ${product.price ?? '0'}$currPostFix',
                                  style: const TextStyle(
                                    fontFamily: 'DMSans',
                                    fontVariations: [
                                      FontVariation('wght', 900),
                                    ],
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                ),
                                Core.buildStarRating(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final itemCountController =
                                            TextEditingController(text: '1');
                                        int itemCount = 1;
                                        return NDialog(
                                          dialogStyle: DialogStyle(
                                            titleDivider: true,
                                            backgroundColor: Colors.white,
                                          ),
                                          title: Core.title(
                                              title: "Product Details"),
                                          // shape: Border.all(),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: Image.network(
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const Center(
                                                      heightFactor: 3,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    );
                                                  },
                                                  product.images?[0].src ?? '',
                                                  height: 170,
                                                  // width: ,
                                                  fit: BoxFit.cover,
                                                  cacheHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          180 ~/
                                                          375,
                                                  cacheWidth:
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                          .toInt(),
                                                ),
                                              ),
                                              Text(
                                                product.name ?? 'Unknown Food',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '$currency ${(product.price ?? '0') * itemCount}$currPostFix',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Container(
                                                  width: 140.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.green,
                                                      width: 1.0,
                                                    ),
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          var currentCount =
                                                              int.tryParse(
                                                                      itemCountController
                                                                          .text) ??
                                                                  1;
                                                          if (currentCount >
                                                              1) {
                                                            currentCount--;
                                                            itemCountController
                                                                    .text =
                                                                currentCount
                                                                    .toString();
                                                            itemCount =
                                                                currentCount;
                                                          }
                                                        },
                                                        icon: const Icon(
                                                          FluentIcons
                                                              .subtract_circle_20_regular,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 40.0,
                                                        height: 30.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0,
                                                                bottom: 0.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: TextField(
                                                          enabled: true,
                                                          readOnly: true,
                                                          controller:
                                                              itemCountController,
                                                          textAlign:
                                                              TextAlign.center,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                            hintText: '1',
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          var currentCount =
                                                              int.tryParse(
                                                                      itemCountController
                                                                          .text) ??
                                                                  1;
                                                          currentCount++;
                                                          itemCountController
                                                                  .text =
                                                              currentCount
                                                                  .toString();
                                                          itemCount =
                                                              currentCount;
                                                        },
                                                        icon: const Icon(
                                                          FluentIcons
                                                              .add_circle_20_regular,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('BUY NOW'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(FluentIcons.eye_20_filled),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final cartProvider =
                                        context.read<CartlistProvider>();
                                    final cartItem = CartlistItem(
                                      prodId: product.id ?? 0,
                                      imageUrl: product.images?[0].src ?? '',
                                      name: product.name ?? 'Unknown Food',
                                      price: double.tryParse(
                                              product.price ?? '0') ??
                                          0,
                                    );
                                    cartProvider.addItem(cartItem);
                                    Core.snackThis(
                                        context: context,
                                        '${product.name} added to Cart',
                                        type: 'save');
                                  },
                                  icon: const Icon(
                                      FluentIcons.shopping_bag_add_20_regular),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
          );
        }
      },
    );
  }
}
