// ignore_for_file: unused_field, unused_local_variable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/page/products/product_details_page.dart';
import 'package:decapitalgrille/providers/wishlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';

class CartPage extends StatefulWidget {
  final ScrollController scrollController;
  const CartPage({required this.scrollController, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _biomValue = false;
  bool _isBiometricSupported = true;
  final Core _core = Core();

  void _loadBiomValue() async {
    String? value = await Core.loadFromPrefs('biometrics');
    setState(() {
      _biomValue = value == 'true';
    });
  }

  void _checkBiometricSupport() async {
    bool isSupported = await _core.checkBiometrics();
    setState(() {
      _isBiometricSupported = isSupported;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBiomValue();
    _checkBiometricSupport();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartlistProvider>();
    final cartItems = cartProvider.cartlistItems;
    if (cartItems.isEmpty) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ErrorHandler.errorThis(
                'You have no products in your cart',
                image: 'images/icons/1 10.png',
                retryText: 'Add Products Now',
                retryIcon: FluentIcons.add_20_regular,
                onRetry: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  myHomePageKey.currentState?.setIndex(0);
                },
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          '${context.read<CartlistProvider>().calculateTotalCount(context.watch<CartlistProvider>().cartlistItems)} Items || $currency ${context.watch<CartlistProvider>().totalPrice}0',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontVariations: const [FontVariation('wght', 900)],
                            color: Colors.amber[700],
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          'Extra charges may apply.',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 53, 86),
                      ),
                      child: TextButton(
                          onPressed: () async {
                            if (cartItems.isEmpty) {
                              Core.snackThis(
                                context: context,
                                'Kindly add products to checkout.',
                                type: 'alert',
                              );
                            } else {
                              if (_biomValue) {
                                // print(_biomValue);
                                bool isAuthenticated =
                                    await _core.biometricVerification();
                                if (isAuthenticated) {
                                  debugPrint(_biomValue.toString());
                                  if (context.mounted) {
                                    Core.initiatePayment(context);
                                  }
                                } else {
                                  if (context.mounted) {
                                    Core.snackThis(
                                      context: context,
                                      'Verify your biometrics to begin.',
                                      type: 'fail',
                                    );
                                  }
                                }
                              }
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(
                                FluentIcons.money_hand_20_regular,
                                color: Colors.white,
                              ),
                              Text(
                                '  PAY NOW',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: widget.scrollController,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final itemCountController = TextEditingController(
                          text: cartItem.count.toString());
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            Core.smoothFadePageRoute(
                              context,
                              ProductDetailsPage(
                                prodId: cartItem.prodId,
                                imageUrl: cartItem.imageUrl,
                                name: cartItem.name,
                                price: cartItem.price,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(top: 12, left: 8, right: 8),
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: cartItem.imageUrl,
                                height: 110,
                                width: 90,
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            height: 1.1,
                                            fontSize: 14,
                                            fontFamily: 'DMSans',
                                            fontVariations: [
                                              FontVariation('wght', 300),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "$currency ${cartItem.price}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                            fontVariations: [
                                              FontVariation('wght', 900),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                var currentCount = int.tryParse(
                                                        itemCountController
                                                            .text) ??
                                                    1;
                                                if (currentCount > 1) {
                                                  currentCount--;
                                                  itemCountController.text =
                                                      currentCount.toString();
                                                  cartItem.count = currentCount;
                                                  context
                                                      .read<CartlistProvider>()
                                                      .notifyListeners();
                                                } else {
                                                  final cartProvider = context
                                                      .read<CartlistProvider>();
                                                  cartProvider
                                                      .removeItem(cartItem);
                                                }
                                              },
                                              icon: const Icon(
                                                FluentIcons
                                                    .subtract_circle_20_regular,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Container(
                                              width: 35,
                                              height: 25,
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: TextField(
                                                enabled: true,
                                                readOnly: true,
                                                controller: itemCountController,
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black54),
                                                  hintText: '1',
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                var currentCount = int.tryParse(
                                                        itemCountController
                                                            .text) ??
                                                    1;
                                                currentCount++;
                                                itemCountController.text =
                                                    currentCount.toString();

                                                cartItem.count = currentCount;

                                                context
                                                    .read<CartlistProvider>()
                                                    .notifyListeners();
                                              },
                                              icon: const Icon(
                                                FluentIcons
                                                    .add_circle_20_regular,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: 110,
                                width: 40,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.red[900],
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Core.showDialog(
                                                context,
                                                "Confirm Removal",
                                                contents: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Core.inform(
                                                            text:
                                                                "Are you sure you want to remove ${cartItem.name} from your cart list items?"),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                gestureName: "Yes Remove",
                                                onPress: () async {
                                                  itemCountController.text =
                                                      '0';
                                                  cartItem.count = 0;
                                                  context
                                                      .read<CartlistProvider>()
                                                      .notifyListeners();

                                                  final cartProvider = context
                                                      .read<CartlistProvider>();
                                                  cartProvider
                                                      .removeItem(cartItem);

                                                  Core.snackThis(
                                                    context: context,
                                                    '${cartItem.name} removed from cart.',
                                                    type: 'alert',
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              FluentIcons.delete_20_regular,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Expanded(
                                      child: DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Core.showDialog(
                                                context,
                                                "Add item to Wishlist",
                                                contents: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Core.inform(
                                                            text:
                                                                "Add ${cartItem.name} to your wishlist? This way you can always go back and grab it easily."),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                gestureName: "Add wishlist",
                                                onPress: () async {
                                                  final item = WishlistItem(
                                                      prodId: cartItem.prodId,
                                                      imageUrl:
                                                          cartItem.imageUrl,
                                                      name: cartItem.name,
                                                      price: cartItem.price);

                                                  final wishlistProvider =
                                                      context.read<
                                                          WishlistProvider>();
                                                  final isInWishlist =
                                                      wishlistProvider
                                                          .itemExists(item);
                                                  if (isInWishlist) {
                                                    Core.snackThis(
                                                        context: context,
                                                        '${cartItem.name} already in your Wishlist',
                                                        type: 'alert');
                                                  } else {
                                                    wishlistProvider
                                                        .addItem(item);
                                                    Core.snackThis(
                                                        context: context,
                                                        '${cartItem.name} added to Wishlist',
                                                        type: 'save');
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                            icon: Consumer<WishlistProvider>(
                                              builder: (context,
                                                  wishlistProvider, child) {
                                                final isInWishlist =
                                                    wishlistProvider
                                                        .wishlistItems
                                                        .any((item) =>
                                                            item.prodId ==
                                                            cartItem.prodId);
                                                return Icon(
                                                  isInWishlist
                                                      ? FluentIcons
                                                          .heart_20_filled
                                                      : FluentIcons
                                                          .heart_20_regular,
                                                  color: Colors.white,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 238, 238, 238),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              '${context.read<CartlistProvider>().calculateTotalCount(context.watch<CartlistProvider>().cartlistItems)} Items || $currency ${context.watch<CartlistProvider>().totalPrice}0',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontVariations: const [
                                  FontVariation('wght', 900)
                                ],
                                color: Colors.amber[700],
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              'Extra charges may apply.',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 53, 86),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (cartItems.isEmpty) {
                                Core.snackThis(
                                  context: context,
                                  'Kindly add products to checkout.',
                                  type: 'alert',
                                );
                              } else {
                                if (_biomValue) {
                                  bool isAuthenticated =
                                      await _core.biometricVerification();
                                  if (isAuthenticated) {
                                    debugPrint(_biomValue.toString());
                                    if (context.mounted) {
                                      Core.initiatePayment(context);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      Core.snackThis(
                                        context: context,
                                        'Verify your biometrics to begin.',
                                        type: 'fail',
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  FluentIcons.money_hand_20_regular,
                                  color: Colors.white,
                                ),
                                Text(
                                  '  PAY NOW',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
