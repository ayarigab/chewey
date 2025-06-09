import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/divider.dart';
import 'package:woocommerce/woocommerce.dart';

class ViewOrderPage extends StatefulWidget {
  final String orderNumber;
  final int orderID;
  final int customerID;
  final String customerNote;
  final Map<String, dynamic> customerBilling;
  final Map<String, dynamic> customerShipping;
  final int orderParentID;
  final List<Map<String, dynamic>> orderProducts;
  final List<Map<String, dynamic>> orderShipping;
  final double totalAmount;
  final String status;
  final String discountAmt;
  final String shippingAmt;
  final String totalTax;
  final String totalAmt;
  final DateTime date;
  final DateTime dateMod;
  final bool isPaid;

  const ViewOrderPage({
    super.key,
    required this.orderNumber,
    required this.orderID,
    required this.customerID,
    required this.customerNote,
    required this.customerBilling,
    required this.customerShipping,
    required this.orderParentID,
    required this.orderProducts,
    required this.orderShipping,
    required this.totalAmount,
    required this.status,
    required this.discountAmt,
    required this.shippingAmt,
    required this.totalTax,
    required this.totalAmt,
    required this.date,
    required this.dateMod,
    required this.isPaid,
  });

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, bool>> statusSteps = getStatusSteps(widget.status);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Core.backBut(context),
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Order Details #${widget.orderNumber}'),
              background: Image.asset(
                'images/app/orders_appbar.jpg',
                fit: BoxFit.cover,
              ),
              collapseMode: CollapseMode.pin,
              stretchModes: const <StretchMode>[StretchMode.fadeTitle],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Invoice Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Invoice ',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: [
                                  TextSpan(
                                    text: '#${widget.orderNumber}',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Order Status Section
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: statusSteps.map((step) {
                            final label = step.keys.first;
                            final isActive = step.values.first;
                            return buildStatusIcon(label, isActive);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.44,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Billing Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ..._buildAddressLines(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.44,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Shipping Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ..._buildAddressShip(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Order Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            buildSummaryRow("Subtotal:",
                                "$curSymbol ${widget.totalAmount.toStringAsFixed(2)}"),
                            buildSummaryRow("Shipping Fee:",
                                "$curSymbol ${widget.shippingAmt}"),
                            buildSummaryRow("Discount:",
                                "- $curSymbol ${widget.discountAmt}"),
                            const NielDivider(
                                fadeEnds: true, text: 'Total Amt'),
                            buildSummaryRow("",
                                "$currency ${widget.totalAmount.toStringAsFixed(2)}",
                                isBold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Product(s)'),
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = widget.orderProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 12,
                    right: 12,
                  ),
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FutureBuilder<String?>(
                            future: getProductImage(product['product_id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Core.loadThis(context, inform: '');
                              } else if (snapshot.hasError ||
                                  !snapshot.hasData) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        'images/degrille/waitress.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Unknown Product',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black54,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    "$currency ${product['price'] ?? '0.00'}",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "x ${product['quantity'] ?? '1'}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black45,
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
                );
              },
              childCount: widget.orderProducts.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusIcon(String status, bool isActive) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          color: isActive ? Colors.green : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  List<Map<String, bool>> getStatusSteps(String status) {
    return [
      {
        "Pending": status == "pending" ||
            status == "on-hold" ||
            status == "processing" ||
            status == "completed"
      },
      {
        "On Hold": status == "on-hold" ||
            status == "processing" ||
            status == "completed"
      },
      {"Processing": status == "processing" || status == "completed"},
      {"Completed": status == "completed"},
    ];
  }

  List<Widget> _buildAddressLines() {
    List<String?> fields = [
      '${widget.customerBilling['first_name']} ${widget.customerBilling['last_name']}',
      widget.customerBilling['phone'],
      widget.customerBilling['email'],
      widget.customerBilling['company'],
      widget.customerBilling['address_1'],
      widget.customerBilling['address_2'],
      widget.customerBilling['city'],
      widget.customerBilling['state'],
      widget.customerBilling['postcode'],
      widget.customerBilling['country'],
    ];

    return fields
        .where((field) => field != null && field.isNotEmpty)
        .map(
          (field) => Text(
            field!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Colors.black45,
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildAddressShip() {
    List<String?> fields = [
      '${widget.customerShipping['first_name']} ${widget.customerShipping['last_name']}',
      widget.customerShipping['phone'],
      widget.customerShipping['email'],
      widget.customerShipping['company'],
      widget.customerShipping['address_1'],
      widget.customerShipping['address_2'],
      widget.customerShipping['city'],
      widget.customerShipping['state'],
      widget.customerShipping['postcode'],
      widget.customerShipping['country'],
    ];

    return fields
        .where((field) => field != null && field.isNotEmpty)
        .map(
          (field) => Text(
            field!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: Colors.black45,
            ),
          ),
        )
        .toList();
  }

  Widget buildSummaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(
                color: Colors.black45,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Future<String?> getProductImage(int productId) async {
    final wooCommerce = WooCommerce(
      baseUrl: url,
      consumerKey: cKey,
      consumerSecret: cCret,
    );
    try {
      WooProduct product = await wooCommerce.getProductById(id: productId);
      return product.images?.isNotEmpty == true
          ? product.images!.first.src
          : null;
    } catch (e) {
      return null;
    }
  }
}
