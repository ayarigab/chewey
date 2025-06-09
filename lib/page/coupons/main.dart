import 'package:woocommerce/woocommerce.dart';
import 'package:flutter/services.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<StatefulWidget> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage>
    with SingleTickerProviderStateMixin {
  late Future<List<WooCoupon>?> _coupons;
  late TabController _tabController;
  WooCommerce wooCommerce = WooCommerce(
    baseUrl: url,
    consumerKey: cKey,
    consumerSecret: cCret,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _coupons = fetchCoupons();
  }

  Future<List<WooCoupon>?> fetchCoupons() async {
    try {
      final coupons = await wooCommerce.getCoupons();
      return coupons;
    } catch (e) {
      Core.snackThis('Error fetching coupons');
      return null;
    }
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Core.snackThis(context: context, 'Coupon copied: $code');
  }

  bool _isExpired(WooCoupon coupon) {
    return coupon.dateExpires != null &&
        DateTime.parse(coupon.dateExpires!).isBefore(DateTime.now());
  }

  bool _isUsageRestricted(WooCoupon coupon) {
    return (coupon.usageLimit != null &&
            coupon.usageCount != null &&
            coupon.usageCount! >= coupon.usageLimit!) ||
        (coupon.usageLimitPerUser != null &&
            coupon.usageCount != null &&
            coupon.usageCount! >= coupon.usageLimitPerUser!);
  }

  Widget _buildCouponCard(WooCoupon coupon, bool isExpired) {
    Color dyna = isExpired ? Colors.grey.shade400 : Colors.green;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: isExpired ? Colors.grey.shade300 : Colors.blue.shade100,
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            Image.asset(
              width: 1000,
              'images/account/coup_bg.jpg',
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 92.5,
                  width: 95,
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.grey : Colors.yellow.shade700,
                  ),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        coupon.amount ?? 'N/A',
                        style: const TextStyle(
                          fontFamily: 'Julia',
                          fontSize: 25,
                          letterSpacing: -1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$currency/%',
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: -1.0,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.code ?? 'No code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isExpired ? Colors.black38 : Colors.black,
                      ),
                    ),
                    Text(
                      coupon.dateExpires ?? 'No expiry date',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpired ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                Center(
                  heightFactor: 2.5,
                  child: NielButton(
                    id: 'copy_coupon',
                    onPressed: () {
                      isExpired
                          ? null
                          : () => _copyToClipboard(coupon.code ?? '');
                    },
                    text: 'Use Coupon',
                    size: NielButtonSize.XS,
                    type: NielButtonType.SECONDARY,
                    borderRadius: 0,
                    leftIcon: Icon(
                      FluentIcons.clipboard_20_regular,
                      color: dyna,
                    ),
                    background: Colors.transparent,
                    foregroundColor: dyna,
                    defaultBorderColor: dyna,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   leading: Core.backBut(context),
        //   title: const Text('Coupons, Gifts, and Discounts'),
        //   bottom: TabBar(
        //     controller: _tabController,
        //     tabs: const [
        //       Tab(text: "Available"),
        //       Tab(text: "Expired"),
        //     ],
        //   ),
        // ),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Core.backBut(context),
          pinned: true,
          snap: true,
          floating: true,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Coupons'),
            background: Image.asset(
              'images/app/veggies.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.1),
              colorBlendMode: BlendMode.darken,
            ),
            collapseMode: CollapseMode.pin,
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Available"),
              Tab(text: "Expired"),
            ],
          ),
        ),
        SliverFillRemaining(
          child: FutureBuilder<List<WooCoupon>?>(
            future: _coupons,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Core.loadThis(context);
              } else if (snapshot.hasError) {
                return ErrorHandler.errorThis('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return ErrorHandler.errorThis('No coupons available.');
              } else {
                final availableCoupons = snapshot.data!
                    .where((coupon) => !_isExpired(coupon))
                    .toList();
                final expiredCoupons = snapshot.data!
                    .where((coupon) => _isExpired(coupon))
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    availableCoupons.isEmpty
                        ? ErrorHandler.errorThis(
                            'No coupons available, check back later.')
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: availableCoupons.length,
                            itemBuilder: (context, index) {
                              final coupon = availableCoupons[index];
                              return _buildCouponCard(coupon, false);
                            },
                          ),
                    expiredCoupons.isEmpty
                        ? ErrorHandler.errorThis('This list is empty.')
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: expiredCoupons.length,
                            itemBuilder: (context, index) {
                              final coupon = expiredCoupons[index];
                              return _buildCouponCard(coupon, true);
                            },
                          ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    ));
  }
}
