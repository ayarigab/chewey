import 'package:decapitalgrille/page/account/add_address_form.dart';
import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/providers/address_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  bool _isLoggedIn = false;
  WooCustomer? _userData;
  String? _fetchError;

  @override
  void initState() {
    super.initState();
    _checkUserData();
    _checkToken();
  }

  void _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  void _checkUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('user_id');

    if (userID != null) {
      EasyLoading.show(status: 'Loading, Please Wait');
      try {
        final WooCustomer userData =
            await woocommerce.getCustomerById(id: userID);

        final addressProvider =
            Provider.of<AddressProvider>(context, listen: false);

        addressProvider.setBillingAddress(
          AddressItem(
            firstName: userData.billing?.firstName,
            lastName: userData.billing?.lastName,
            company: userData.billing?.company,
            address1: userData.billing?.address1,
            address2: userData.billing?.address2,
            city: userData.billing?.city,
            state: userData.billing?.state,
            postcode: userData.billing?.postcode,
            country: userData.billing?.country,
            email: userData.billing?.email,
            phone: userData.billing?.phone,
          ),
        );

        addressProvider.setShippingAddress(
          AddressItem(
            firstName: userData.shipping?.firstName,
            lastName: userData.shipping?.lastName,
            company: userData.shipping?.company,
            address1: userData.shipping?.address1,
            address2: userData.shipping?.address2,
            city: userData.shipping?.city,
            state: userData.shipping?.state,
            postcode: userData.shipping?.postcode,
            country: userData.shipping?.country,
          ),
        );

        setState(() {
          _fetchError = null;
          EasyLoading.dismiss();
        });
      } catch (error) {
        setState(() {
          _fetchError = 'Error fetching customer data: $error';
        });
        EasyLoading.dismiss();
        Core.snackThis('Error loading your data. Try again later.',
            type: 'fail');
      }
    } else {
      setState(() {
        _fetchError = 'User ID not found in SharedPreferences';
      });
      EasyLoading.dismiss();
      Core.snackThis('Try logging out and logging in again.', type: 'fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const AccountPage();
    }

    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Core.backBut(context),
        title: const Text('Manage Address'),
      ),
      body: Column(
        children: [
          Expanded(
            child: addressProvider.billingAddress != null ||
                    addressProvider.shippingAddress != null
                ? ListView(
                    children: [
                      if (addressProvider.billingAddress != null)
                        _buildAddressCard(
                            'Billing Address',
                            addressProvider.billingAddress,
                            'You may be called by management in case your info is misleading. Courtesy: De Capital Administration'),
                      if (addressProvider.shippingAddress != null)
                        _buildAddressCard(
                            'Shipping Address',
                            addressProvider.shippingAddress,
                            'This address is used when we\'re sending you orders. Please fill with care'),
                    ],
                  )
                : Center(
                    child: _fetchError != null
                        ? ErrorHandler.errorThis(
                            'An error occurred while fetching your addresses. Please try again later.')
                        : ErrorHandler.errorThis(
                            'No address found. Please add a billing and shipping address.',
                            image: 'images/errors/empty_message_error.png'),
                  ),
          ),
          _buildAddAddressButton(),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String label, AddressItem? address, String? inform) {
    if (address == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          Core.smoothFadePageRoute(
            context,
            const AddAddress(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12, left: 8, right: 8),
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FluentIcons.location_ripple_20_filled,
                  color: Colors.red[900],
                  size: 40,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                            fontSize: 20,
                            fontVariations: [FontVariation('wght', 300)]),
                      ),
                      if (inform != '')
                        Text(
                          inform!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[300],
                              fontVariations: const [
                                FontVariation('wght', 300)
                              ]),
                        ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              '${address.firstName ?? ''} ${address.lastName ?? ''}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              '${address.address1 ?? ''}, ${address.city ?? ''}, ${address.state ?? ''}, ${address.country ?? ''}',
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  fontVariations: [FontVariation('wght', 300)]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return Container(
      padding: const EdgeInsets.all(22),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                Core.smoothFadePageRoute(
                  context,
                  const AddAddress(),
                ),
              );
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 255, 38, 0),
                    Color.fromARGB(255, 255, 128, 0),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Click Here to Add/Edit Addresses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          const Text.rich(
            TextSpan(
              style: TextStyle(
                height: 1,
                color: Colors.black45,
                fontVariations: [
                  FontVariation('wght', 200),
                ],
                fontSize: 10,
                letterSpacing: -.2,
              ),
              text:
                  'We use these informations to send your orders to your destination. ',
              children: [
                TextSpan(
                  style: TextStyle(color: Colors.red),
                  text:
                      'Please be sure it’s your true location and can be found on the map.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
