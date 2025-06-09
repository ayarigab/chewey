import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:decapitalgrille/utils/orders_model.dart';
import 'package:decapitalgrille/widgets/orders_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  bool _isLoggedIn = false;
  List<OrderModel> orders = [];
  bool _isLoading = true;
  String? _fetchError;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _checkToken();
    _fetchOrders();
  }

  void _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  Future<void> _fetchOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userID = prefs.getInt('user_id');
      if (userID != null) {
        final fetchedOrders = await woocommerce.getOrders(customer: userID);
        setState(() {
          orders = fetchedOrders
              .map((order) => OrderModel.fromJson(order.toJson()))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception("User ID not found");
      }
    } catch (error) {
      setState(() {
        _fetchError = 'Failed to load orders. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Core.backBut(context),
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'My Orders',
                ),
                background: Image.asset(
                  'images/app/orders_appbar.jpg',
                  fit: BoxFit.cover,
                ),
                collapseMode: CollapseMode.pin,
              ),
            ),
            SliverFillRemaining(
              child: Center(
                child: ErrorHandler.errorThis(
                  'Please login to view all your previous orders.',
                  image: 'images/errors/empty_box_error.png',
                  retryText: 'Login Now',
                  onRetry: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    myHomePageKey.currentState?.setIndex(4);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: Core.backBut(context),
          title: const Text('My Orders'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(
                text: 'All',
              ),
              Tab(text: 'Pending'),
              Tab(text: 'Processing'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Refunded'),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: Core.loadThis(context))
            : _fetchError != null
                ? Center(
                    child: ErrorHandler.errorThis(
                      _fetchError!,
                      image: 'images/errors/empty_box_error.png',
                      retryText: 'Retry',
                      onRetry: _fetchOrders,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(orders),
                      _buildOrderList(
                        orders.where((o) => o.status == 'pending').toList(),
                      ),
                      _buildOrderList(
                        orders.where((o) => o.status == 'processing').toList(),
                      ),
                      _buildOrderList(
                        orders.where((o) => o.status == 'completed').toList(),
                      ),
                      _buildOrderList(
                        orders.where((o) => o.status == 'cancelled').toList(),
                      ),
                      _buildOrderList(
                        orders.where((o) => o.status == 'refunded').toList(),
                      ),
                    ],
                  ),
      );
    }
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return ErrorHandler.errorThis(
          'No orders in this field. Order more to fill up this row',
          image: 'images/icons/1 10.png');
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(order: order);
      },
    );
  }
}
