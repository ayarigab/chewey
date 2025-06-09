import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/providers/address_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/divider.dart';
import 'package:decapitalgrille/widgets/inputs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool _isLoggedIn = false;
  bool _isUserDataLoaded = false;
  final _formBilling = GlobalKey<FormState>();
  final _formShipping = GlobalKey<FormState>();

  // Billing controllers
  late TextEditingController _billingFirstNameController;
  late TextEditingController _billingLastNameController;
  late TextEditingController _billingEmailController;
  late TextEditingController _billingCompanyController;
  late TextEditingController _billingAddress1Controller;
  late TextEditingController _billingAddress2Controller;
  late TextEditingController _billingCityController;
  late TextEditingController _billingStateController;
  late TextEditingController _billingPostcodeController;
  late TextEditingController _billingCountryController;
  late TextEditingController _billingPhoneController;

  // Shipping controllers
  late TextEditingController _shippingFirstNameController;
  late TextEditingController _shippingLastNameController;
  late TextEditingController _shippingCompanyController;
  late TextEditingController _shippingAddress1Controller;
  late TextEditingController _shippingAddress2Controller;
  late TextEditingController _shippingCityController;
  late TextEditingController _shippingStateController;
  late TextEditingController _shippingPostcodeController;
  late TextEditingController _shippingCountryController;

  @override
  void initState() {
    super.initState();

    // Initialize billing controllers
    _billingFirstNameController = TextEditingController();
    _billingLastNameController = TextEditingController();
    _billingEmailController = TextEditingController();
    _billingCompanyController = TextEditingController();
    _billingAddress1Controller = TextEditingController();
    _billingAddress2Controller = TextEditingController();
    _billingCityController = TextEditingController();
    _billingStateController = TextEditingController();
    _billingPostcodeController = TextEditingController();
    _billingCountryController = TextEditingController();
    _billingPhoneController = TextEditingController();

    // Initialize shipping controllers
    _shippingFirstNameController = TextEditingController();
    _shippingLastNameController = TextEditingController();
    _shippingCompanyController = TextEditingController();
    _shippingAddress1Controller = TextEditingController();
    _shippingAddress2Controller = TextEditingController();
    _shippingCityController = TextEditingController();
    _shippingStateController = TextEditingController();
    _shippingPostcodeController = TextEditingController();
    _shippingCountryController = TextEditingController();

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

  Future<void> _checkUserData() async {
    EasyLoading.show(status: 'Checking Data, Please Wait');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('user_id');

    if (userID != null) {
      try {
        EasyLoading.show(status: 'Checking Data, Please Wait');
        final WooCustomer userData =
            await woocommerce.getCustomerById(id: userID);
        setState(() {
          _billingFirstNameController.text = userData.billing?.firstName ?? '';
          _billingLastNameController.text = userData.billing?.lastName ?? '';
          _billingEmailController.text = userData.billing?.email ?? '';
          _billingCompanyController.text = userData.billing?.company ?? '';
          _billingAddress1Controller.text = userData.billing?.address1 ?? '';
          _billingAddress2Controller.text = userData.billing?.address2 ?? '';
          _billingCityController.text = userData.billing?.city ?? '';
          _billingStateController.text = userData.billing?.state ?? '';
          _billingPostcodeController.text = userData.billing?.postcode ?? '';
          _billingCountryController.text = userData.billing?.country ?? '';
          _billingPhoneController.text = userData.billing?.phone ?? '';

          _shippingFirstNameController.text =
              userData.shipping?.firstName ?? '';
          _shippingLastNameController.text = userData.shipping?.lastName ?? '';
          _shippingCompanyController.text = userData.shipping?.company ?? '';
          _shippingAddress1Controller.text = userData.shipping?.address1 ?? '';
          _shippingAddress2Controller.text = userData.shipping?.address2 ?? '';
          _shippingCityController.text = userData.shipping?.city ?? '';
          _shippingStateController.text = userData.shipping?.state ?? '';
          _shippingPostcodeController.text = userData.shipping?.postcode ?? '';
          _shippingCountryController.text = userData.shipping?.country ?? '';
          _isUserDataLoaded = true;
        });
        EasyLoading.dismiss();
      } catch (error) {
        EasyLoading.dismiss();
        Core.snackThis('Error Loading your data from server', type: 'fail');
      }
    }
  }

  Future<void> _updateUserData() async {
    EasyLoading.show(status: 'Updating, Please Wait');
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('user_id');

    if (userID != null) {
      try {
        final updatedData = {
          'billing': {
            'first_name': _billingFirstNameController.text,
            'last_name': _billingLastNameController.text,
            'email': _billingEmailController.text,
            'company': _billingCompanyController.text,
            'address_1': _billingAddress1Controller.text,
            'address_2': _billingAddress2Controller.text,
            'city': _billingCityController.text,
            'state': _billingStateController.text,
            'postcode': _billingPostcodeController.text,
            'country': _billingCountryController.text,
            'phone': _billingPhoneController.text,
          },
          'shipping': {
            'first_name': _shippingFirstNameController.text,
            'last_name': _shippingLastNameController.text,
            'company': _shippingCompanyController.text,
            'address_1': _shippingAddress1Controller.text,
            'address_2': _shippingAddress2Controller.text,
            'city': _shippingCityController.text,
            'state': _shippingStateController.text,
            'postcode': _shippingPostcodeController.text,
            'country': _shippingCountryController.text,
          },
        };

        await woocommerce.updateCustomer(
          id: userID,
          data: updatedData,
        );

        // Update the provider
        final addressProvider =
            Provider.of<AddressProvider>(context, listen: false);

        addressProvider.setBillingAddress(
          AddressItem(
            firstName: _billingFirstNameController.text,
            lastName: _billingLastNameController.text,
            email: _billingEmailController.text,
            company: _billingCompanyController.text,
            address1: _billingAddress1Controller.text,
            address2: _billingAddress2Controller.text,
            city: _billingCityController.text,
            state: _billingStateController.text,
            postcode: _billingPostcodeController.text,
            country: _billingCountryController.text,
            phone: _billingPhoneController.text,
          ),
        );

        addressProvider.setShippingAddress(
          AddressItem(
            firstName: _shippingFirstNameController.text,
            lastName: _shippingLastNameController.text,
            company: _shippingCompanyController.text,
            address1: _shippingAddress1Controller.text,
            address2: _shippingAddress2Controller.text,
            city: _shippingCityController.text,
            state: _shippingStateController.text,
            postcode: _shippingPostcodeController.text,
            country: _shippingCountryController.text,
          ),
        );

        EasyLoading.show(status: 'Checking Data, Please wait.');
        _checkUserData();
        EasyLoading.dismiss();
        if (context.mounted) {
          Core.snackThis('Account successfully updated.', context: context);
        }
      } catch (error) {
        EasyLoading.dismiss();
        if (context.mounted) {
          Core.snackThis('An error occurred. Try again.',
              context: context, type: 'fail');
        }
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    _billingFirstNameController.dispose();
    _billingLastNameController.dispose();
    _billingEmailController.dispose();
    _billingCompanyController.dispose();
    _billingAddress1Controller.dispose();
    _billingAddress2Controller.dispose();
    _billingCityController.dispose();
    _billingStateController.dispose();
    _billingPostcodeController.dispose();
    _billingCountryController.dispose();
    _billingPhoneController.dispose();

    _shippingFirstNameController.dispose();
    _shippingLastNameController.dispose();
    _shippingCompanyController.dispose();
    _shippingAddress1Controller.dispose();
    _shippingAddress2Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingPostcodeController.dispose();
    _shippingCountryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (!_isLoggedIn) {
      return const AccountPage();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Core.backBut(context),
        title: const Text('Add/Update Addresses'),
      ),
      body: _isUserDataLoaded
          ? SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isDarkMode
                            ? Colors.black.withValues(alpha: 0.8)
                            : Colors.transparent,
                        BlendMode.multiply,
                      ),
                      child: Image.asset(
                        'images/app/decapital_auth_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const NielDivider(
                              text: 'Complete your billing address below',
                              thickness: 1,
                              fadeEnds: true,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Form(
                                  key: _formBilling,
                                  child: _buildBilling(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            const NielDivider(
                              text: 'Complete your Shipping address below',
                              thickness: 1,
                              fadeEnds: true,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Form(
                                  key: _formShipping,
                                  child: _buildShipping(),
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                GestureDetector(
                                  onTap: _updateUserData,
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.greenAccent
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Submit form',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
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
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Core.loadThis(context),
            ),
    );
  }

  Widget _buildBilling() {
    return Column(
      children: <Widget>[
        NielInput(
          id: 'first_name',
          controller: _billingFirstNameController,
          hintText: 'Enter First name',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'last_name',
          controller: _billingLastNameController,
          hintText: 'Enter Last name',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'email',
          controller: _billingEmailController,
          hintText: 'Enter your email',
          type: NielInputType.EMAIL,
          prefixIcon: const Icon(FluentIcons.mail_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'number',
          controller: _billingPhoneController,
          hintText: 'Enter phone number',
          type: NielInputType.NUMBER,
          prefixIcon: const Icon(FluentIcons.phone_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'company',
          controller: _billingCompanyController,
          hintText: 'Enter Company/ Landmark',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.building_checkmark_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'address_1',
          controller: _billingAddress1Controller,
          hintText: 'Enter Address 1',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.home_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'address_2',
          controller: _billingAddress2Controller,
          hintText: 'Enter Address 2 (Optional)',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.home_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'city',
          controller: _billingCityController,
          hintText: 'Enter City',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.my_location_20_filled),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'state',
          controller: _billingStateController,
          hintText: 'Enter State/Province/Region',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.location_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'post_code',
          controller: _billingPostcodeController,
          hintText: 'Enter Postal Address',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.mailbox_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'country',
          controller: _billingCountryController,
          hintText: 'Enter Country',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.map_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.done,
          size: NielInputSize.MEDIUM,
        ),
      ],
    );
  }

  Widget _buildShipping() {
    return Column(
      children: <Widget>[
        NielInput(
          id: 'first_name',
          controller: _shippingFirstNameController,
          hintText: 'Enter First name',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'last_name',
          controller: _shippingLastNameController,
          hintText: 'Enter Last name',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'company',
          controller: _shippingCompanyController,
          hintText: 'Enter Company/ Landmark',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.building_checkmark_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'address_1',
          controller: _shippingAddress1Controller,
          hintText: 'Enter Address 1',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.home_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'address_2',
          controller: _shippingAddress2Controller,
          hintText: 'Enter Address 2 (Optional)',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.home_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'city',
          controller: _shippingCityController,
          hintText: 'Enter City',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.my_location_20_filled),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'state',
          controller: _shippingStateController,
          hintText: 'Enter State/Province/Region',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.location_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'post_code',
          controller: _shippingPostcodeController,
          hintText: 'Enter Postal Address',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.mailbox_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        NielInput(
          id: 'country',
          controller: _shippingCountryController,
          hintText: 'Enter Country',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.map_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.done,
          size: NielInputSize.MEDIUM,
        ),
      ],
    );
  }
}
