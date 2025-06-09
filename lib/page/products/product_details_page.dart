// ignore_for_file: library_private_types_in_public_api

import 'package:decapitalgrille/providers/cartlist_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/theme/typography.dart';
import 'package:provider/provider.dart';

void main() => runApp(const NielTheme());

class NielTheme extends StatelessWidget {
  const NielTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niel Theme',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: textTheme,
      ),
      themeMode: ThemeMode.system,
      home: const ProductDetailsPage(
        prodId: 0,
        imageUrl:
            'http://www.decapitalgrille.com/wp-content/uploads/2023/08/degrille-1.jpg',
        name: 'Unknown Product',
        price: 0,
      ),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  final int prodId;
  final String imageUrl;
  final String name;
  final double price;

  const ProductDetailsPage({
    super.key,
    required this.prodId,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late List<PaletteColor> dycolors;
  late int _index;
  Color? appBarColor;
  Color? titleColor;

  @override
  void initState() {
    super.initState();
    dycolors = [];
    _index = 0;
    addColor(widget.imageUrl);
  }

  Future<void> addColor(String imageUrl) async {
    final PaletteGenerator pg = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(imageUrl),
    );

    setState(() {
      dycolors.add((pg.mutedColor ?? Colors.greenAccent) as PaletteColor);
      appBarColor = dycolors.isEmpty
          ? Theme.of(context).primaryColor
          : dycolors[_index].color;
      titleColor = pg.lightVibrantColor?.color;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: appBarColor ?? Theme.of(context).canvasColor,
        appBar: AppBar(
          leading: Core.backBut(context),
          title: Text(
            widget.name,
            style: TextStyle(
              color: titleColor ?? Theme.of(context).primaryColor,
            ),
          ),
          elevation: 15,
          backgroundColor: appBarColor ?? Theme.of(context).canvasColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.imageUrl,
                      scale: 5.5, cacheKey: widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.transparent,
                      appBarColor ?? Theme.of(context).canvasColor
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor ?? Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      '$currency ${widget.price}0',
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
                      color: titleColor ?? Theme.of(context).primaryColor,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.59,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 236, 236, 236),
                      ),
                      child: TextButton(
                          onPressed: () {
                            final cartProvider =
                                context.read<CartlistProvider>();
                            final cartItem = CartlistItem(
                              prodId: widget.prodId,
                              imageUrl: widget.imageUrl,
                              name: widget.name,
                              price: widget.price,
                            );
                            cartProvider.addItem(cartItem);
                            Core.snackThis(
                                context: context,
                                '${widget.name} added to Cart',
                                type: 'save');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.shopping_bag_add_20_regular,
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 53, 86),
                      ),
                      child: TextButton(
                          onPressed: () async {},
                          child: const Row(
                            children: [
                              Icon(
                                FluentIcons.money_hand_20_regular,
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
      );
}
