import 'package:decapitalgrille/page/qr_scanner/scan_page.dart';
import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

class SearchPage extends StatefulWidget {
  final String? text;
  final String? category;
  final bool? featured;

  const SearchPage({super.key, this.text, this.category, this.featured});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  WooCommerce wooCommerce = WooCommerce(
    baseUrl: url,
    consumerKey: cKey,
    consumerSecret: cCret,
  );

  List<WooProduct> products = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Check if a search text or category was passed and initiate search if so
    if ((widget.text?.isNotEmpty ?? false) ||
        (widget.category?.isNotEmpty ?? false) ||
        (widget.featured ?? false)) {
      searchController.text = widget.text ?? '';
      performSearch();
    }
  }

  void performSearch() async {
    String query = searchController.text;
    setState(() {
      isLoading = true;
      products.clear();
    });

    if (query.isNotEmpty ||
        widget.text != null ||
        widget.category != null ||
        widget.featured != false) {
      List<WooProduct> searchResults = await wooCommerce.getProducts(
          search: widget.text ?? query,
          perPage: 100,
          category: widget.category,
          featured: widget.featured);

      setState(() {
        products = searchResults;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Core.backBut(context),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.orange.shade900,
              ),
              borderRadius: BorderRadius.circular(100.0),
            ),
            margin: const EdgeInsets.only(left: 10),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: searchController,
              keyboardType: TextInputType.name,
              autofocus: widget.text == null || widget.text!.isEmpty,
              textInputAction: TextInputAction.search,
              enableIMEPersonalizedLearning: true,
              onSubmitted: (_) => performSearch(),
              decoration: InputDecoration(
                hintText: 'Type here to search...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  FluentIcons.search_32_regular,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      Core.smoothFadePageRoute(
                        context,
                        const ScannerPage(),
                      ),
                    );
                  },
                  color: Colors.grey,
                  icon: const Icon(FluentIcons.scan_camera_48_regular),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  if (isLoading)
                    SliverToBoxAdapter(
                      child: Core.loadThis(
                        context,
                        inform:
                            'Searching for ${searchController.text}, Please wait',
                      ),
                    )
                  else if (products.isEmpty)
                    SliverToBoxAdapter(
                      child: ErrorHandler.errorThis(
                        'No product found, Try searching again.',
                        image: 'images/errors/no_result_found_error.png',
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Showing search results for ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'DMSans',
                              fontVariations: const [
                                FontVariation('wght', 300),
                              ],
                              color: Colors.grey[500],
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: searchController.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'DMSans',
                                  fontVariations: const [
                                    FontVariation('wght', 900),
                                  ],
                                  color: Colors.grey[700],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        WooProduct product = products[index];
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
                            if (context.mounted) {
                              Core.showProductDetails(
                                context,
                                productName: product.name ?? 'Unknown Food',
                                productImageUrl: product.images?[0].src ?? '',
                                productPrice:
                                    double.tryParse(product.price ?? '') ?? 0.0,
                                productId: product.id ?? 0,
                                titleColor: titleColor,
                                appBarColor: appBarColor,
                              );
                            }
                          },
                          child: Card(
                            color: Theme.of(context).colorScheme.onTertiary,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.onTertiary,
                            shadowColor: Theme.of(context).colorScheme.primary,
                            elevation: 5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: product.images?[0].src ??
                                        'images/degrille/waitress.jpg',
                                    height: 125.0,
                                    fit: BoxFit.cover,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    product.name ?? 'Unknown Food',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '$currency ${product.price ?? '0'}$currPostFix',
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      fontVariations: [
                                        FontVariation('wght', 900)
                                      ],
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Core.buildStarRating(size: 18),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              final itemCountController =
                                                  TextEditingController(
                                                      text: '1');
                                              return AlertDialog(
                                                title: const Text(
                                                    "Product Details"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      child: Image.network(
                                                        product.images?[0]
                                                                .src ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        cacheHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                180 ~/
                                                                375,
                                                        cacheWidth:
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width)
                                                                .toInt(),
                                                      ),
                                                    ),
                                                    Text(
                                                      product.name ??
                                                          'Unknown Food',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$currency ${product.price ?? '0'}$currPostFix',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    Container(
                                                        width: 140.0,
                                                        height: 40.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.green,
                                                            width: 1.0,
                                                          ),
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                                            itemCountController.text) ??
                                                                        1;
                                                                if (currentCount >
                                                                    1) {
                                                                  currentCount--;
                                                                  itemCountController
                                                                          .text =
                                                                      currentCount
                                                                          .toString();
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .remove_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 40.0,
                                                              height: 30.0,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10.0,
                                                                      bottom:
                                                                          0.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black12,
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
                                                                    TextAlign
                                                                        .center,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      InputBorder
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
                                                                            itemCountController.text) ??
                                                                        1;
                                                                currentCount++;
                                                                itemCountController
                                                                        .text =
                                                                    currentCount
                                                                        .toString();
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .add_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child:
                                                        const Text('BUY NOW'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                            FluentIcons.eye_20_filled),
                                        color: Colors.grey[600],
                                        iconSize: 25,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          final cartProvider =
                                              context.read<CartlistProvider>();
                                          final cartItem = CartlistItem(
                                            prodId: product.id ?? 0,
                                            imageUrl:
                                                product.images?[0].src ?? '',
                                            name:
                                                product.name ?? 'Unknown Food',
                                            price: double.tryParse(
                                                    product.price ?? '0') ??
                                                0,
                                          );
                                          cartProvider.addItem(cartItem);
                                          Core.snackThis(
                                            context: context,
                                            '${product.name} added to Cart',
                                            type: 'save',
                                          );
                                        },
                                        icon: const Icon(FluentIcons
                                            .shopping_bag_add_20_regular),
                                        color: Colors.grey[600],
                                        iconSize: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
