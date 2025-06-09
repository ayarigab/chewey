import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/page/search.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

void main() => runApp(const CategoryPage());

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

WooCommerce wooCommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'label': 'All',
      'category': null,
      'search': null,
      'icon': FluentIcons.grid_20_regular
    },
    {
      'label': 'Breakfast',
      'category': '48',
      'icon': FluentIcons.drink_coffee_20_regular
    },
    {
      'label': 'Lunch',
      'category': '51',
      'icon': FluentIcons.service_bell_20_regular
    },
    {
      'label': 'Drinks',
      'category': '53',
      'icon': FluentIcons.drink_wine_20_regular
    },
    {
      'label': 'Local Dishes',
      'category': '37',
      'icon': FluentIcons.bowl_salad_20_regular
    },
    {
      'label': 'Starters',
      'category': '45',
      'icon': FluentIcons.drink_bottle_20_regular
    },
    {
      'label': 'Vegetarian',
      'category': '153',
      'icon': FluentIcons.bowl_salad_20_regular
    },
    {
      'label': 'Snacks',
      'category': '49',
      'icon': FluentIcons.food_toast_20_regular
    },
    {
      'label': 'Noodles',
      'category': '50',
      'icon': FluentIcons.bowl_chopsticks_20_regular
    },
    {
      'label': 'Fruits',
      'category': '150',
      'icon': FluentIcons.food_apple_20_regular
    },
    {
      'label': 'Cakes',
      'search': 'cake',
      'icon': FluentIcons.food_cake_20_regular
    },
    {
      'label': 'Pizza',
      'search': 'pizza',
      'icon': FluentIcons.food_pizza_20_regular
    },
    {
      'label': 'De Capital',
      'search': 'decapital',
      'imagePath': 'images/icons/dhr_dark.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          Expanded(
            child: Row(
              children: <Widget>[
                _buildNavigationRail(),
                const VerticalDivider(thickness: 1, width: 1),
                _buildCategoryContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 40, bottom: 0),
      child: Container(
        padding: const EdgeInsets.only(top: 8, left: 40, right: 40, bottom: 8),
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
            padding:
                const EdgeInsets.only(top: 15, left: 25, right: 4, bottom: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.search_32_regular,
                ),
                SizedBox(
                  width: 12,
                ),
                Text('Type here to search..'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRail() {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: _categories.map((item) {
                  return NavigationRailDestination(
                    icon: item['icon'] != null
                        ? Icon(item['icon'], color: Colors.green)
                        : ImageIcon(AssetImage(item['imagePath'])),
                    selectedIcon: item['icon'] != null
                        ? Icon(item['icon'])
                        : ImageIcon(AssetImage(item['imagePath'])),
                    label: Text(item['label']),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryContent() {
    final category = _categories[_selectedIndex];

    return Expanded(
      child: Center(
        child: category['category'] != null
            ? Categorial(peepage: 100, category: category['category'])
            : category['search'] != null
                ? Categorial(peepage: 100, search: category['search'])
                : const Categorial(peepage: 100),
      ),
    );
  }
}

class Categorial extends StatelessWidget {
  final int peepage;
  final String? search;
  final String? category;
  final String? type;
  final String? attribute;
  final String? slug;

  const Categorial({
    super.key,
    required this.peepage,
    this.search,
    this.category,
    this.type,
    this.attribute,
    this.slug,
  });

  Future<List<WooProduct>> fetchProducts(
      peepage, search, category, type, attribute, slug) async {
    final products = await wooCommerce.getProducts(
      perPage: peepage,
      search: search,
      category: category,
      type: type,
      attribute: attribute,
      slug: slug,
    );
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WooProduct>>(
      future: fetchProducts(peepage, search, category, type, attribute, slug),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Core.loadThis(context);
        } else if (snapshot.hasError) {
          return ErrorHandler.errorThis(
              'Error fetching products. Try again later');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products available.'));
        } else {
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productId = product.id ?? 0;
              final productName = product.name ?? 'Unknown Food';
              final productImage =
                  product.images?.first.src ?? 'images/degrille/waitress.jpg';
              final productPrice = double.tryParse(product.price ?? '0') ?? 0;

              void navigateToDetails() async {
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
                    productId: productId,
                    productImageUrl: productImage,
                    productName: productName,
                    productPrice: productPrice,
                    titleColor: titleColor,
                    appBarColor: appBarColor,
                  );
                }
              }

              void showProductDialog() {
                final itemCountController = TextEditingController(text: '1');
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Product Details"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            productImage,
                            fit: BoxFit.cover,
                            height:
                                MediaQuery.of(context).size.width * 180 / 375,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Text(productName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('$currency ${product.price ?? '0'}$currPostFix',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green)),
                        Container(
                          width: 140.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 1.0),
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  var currentCount =
                                      int.tryParse(itemCountController.text) ??
                                          1;
                                  if (currentCount > 1) {
                                    currentCount--;
                                    itemCountController.text =
                                        currentCount.toString();
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.green),
                              ),
                              Container(
                                width: 40.0,
                                height: 30.0,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: itemCountController,
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  var currentCount =
                                      int.tryParse(itemCountController.text) ??
                                          1;
                                  currentCount++;
                                  itemCountController.text =
                                      currentCount.toString();
                                },
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {}, child: const Text('BUY NOW')),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }

              void addToCart() {
                final cartProvider = context.read<CartlistProvider>();
                cartProvider.addItem(CartlistItem(
                  prodId: productId,
                  imageUrl: productImage,
                  name: productName,
                  price: productPrice,
                ));
                Core.snackThis(
                    context: context,
                    '$productName added to Cart',
                    type: 'save');
              }

              return GestureDetector(
                onTap: navigateToDetails,
                child: Card(
                    color: Theme.of(context).colorScheme.onTertiary,
                    surfaceTintColor: Theme.of(context).colorScheme.onTertiary,
                    shadowColor: Theme.of(context).colorScheme.primary,
                    elevation: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: productImage,
                            height: 200,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w900,
                                  fontVariations: const [
                                    FontVariation(
                                      'wght',
                                      300,
                                    ),
                                  ],
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '$currency ${product.price ?? '0'}$currPostFix',
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w900,
                                  fontVariations: [FontVariation('wght', 900)],
                                  color: Colors.red,
                                  fontSize: 26,
                                  height: 0,
                                ),
                              ),
                              Core.buildStarRating(size: 18),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: showProductDialog,
                                icon: const Icon(
                                  FluentIcons.eye_20_filled,
                                  size: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: addToCart,
                                icon: const Icon(
                                  FluentIcons.shopping_bag_add_20_regular,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              );
            },
          );
        }
      },
    );
  }
}
