import 'package:decapitalgrille/page/products/product_details_page.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/providers/wishlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final wishlistItems = context.watch<WishlistProvider>().wishlistItems;

    if (wishlistItems.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Core.backBut(context),
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'My WishList',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background:
                    Image.asset('images/app/food_plate.png', fit: BoxFit.cover),
                collapseMode: CollapseMode.pin,
              ),
            ),
            SliverFillRemaining(
              child: ErrorHandler.errorThis(
                'You\'ve nothing here yet.',
                image: 'images/icons/bag-dynamic-premium.png',
                imageSize: 150,
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Core.backBut(context),
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'My Wishlist',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background:
                    Image.asset('images/app/food_plate.png', fit: BoxFit.cover),
                collapseMode: CollapseMode.pin,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final wishlistList = wishlistItems.toList();
                  final item = wishlistList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        Core.smoothFadePageRoute(
                          context,
                          ProductDetailsPage(
                              prodId: item.prodId,
                              imageUrl: item.imageUrl,
                              name: item.name,
                              price: item.price),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, left: 8, right: 8),
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
                            imageUrl: item.imageUrl,
                            height: 110,
                            width: 90,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
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
                                    '$currency ${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontVariations: [
                                        FontVariation('wght', 900),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
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
                                                              "Are you sure you want to remove ${item.name} from your wishlist items?"),
                                                    ],
                                                  );
                                                },
                                              ),
                                              gestureName: "Yes Remove",
                                              onPress: () {
                                                final wishlistProvider = context
                                                    .read<WishlistProvider>();
                                                wishlistProvider
                                                    .removeItem(item);
                                                Core.snackThis(
                                                    context: context,
                                                    '${item.name} removed from wishlist',
                                                    type: 'fail');
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            FluentIcons.delete_20_regular,
                                            color: Colors.red,
                                          ),
                                          iconSize: 30,
                                        ),
                                      ),
                                      Expanded(
                                          child: IconButton(
                                        onPressed: () {
                                          final cartProvider =
                                              context.read<CartlistProvider>();
                                          final cartItem = CartlistItem(
                                            prodId: item.prodId,
                                            imageUrl: item.imageUrl,
                                            name: item.name,
                                            price: item.price,
                                          );
                                          cartProvider.addItem(cartItem);
                                          Core.snackThis(
                                              context: context,
                                              '${item.name} added to your Cart',
                                              type: 'save');
                                        },
                                        icon: const Icon(
                                            FluentIcons
                                                .shopping_bag_add_20_regular,
                                            color: Colors.green),
                                        iconSize: 30,
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: wishlistItems.length,
              ),
            ),
          ],
        ),
      );
    }
  }
}
