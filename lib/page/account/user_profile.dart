// ignore_for_file: unused_field
import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/page/account/change_password.dart';
import 'package:decapitalgrille/page/account/edit_profile.dart';
import 'package:decapitalgrille/page/account/my_address.dart';
import 'package:decapitalgrille/page/account/view_profile.dart';
import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/page/notifications/stories.dart';
import 'package:decapitalgrille/page/orders/order_page.dart';
import 'package:decapitalgrille/page/video_shop/main.dart';
import 'package:decapitalgrille/page/wishlist/main.dart';
import 'package:decapitalgrille/providers/address_provider.dart';
import 'package:decapitalgrille/providers/auth_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _isLoggedIn = false;
  String _email = '';
  String userName = '';
  String _token = '';
  String _password = '';
  String _phone = '';
  String _fName = '';
  String userNicename = '';
  String _avatar = '';
  String userRole = '';
  bool _notifValue = false;
  bool _biomValue = false;
  bool _isBiometricSupported = true;
  final Core _core = Core();
  final text = TranslationService().translate('download_cont').toString();

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
      try {
        final WooCustomer userData =
            await woocommerce.getCustomerByIdWithApi(id: userID);
        String? phoneNumber = userData.billing?.phone;

        prefs.setString(
            'user_phone', phoneNumber ?? 'No phone number available');
      } catch (error) {
        //
      }
    }
  }

  void _loadSwitchValue() async {
    String? value = await Core.loadFromPrefs('notifications');
    setState(() {
      _notifValue = value == 'true';
    });
  }

  void _saveSwitchValue(bool value) async {
    await Core.saveToPrefs('notifications', value.toString());
  }

  void _removeSwitchValue() async {
    await Core.removeFromPrefs('notifications');
  }

  void _loadBiomValue() async {
    String? value = await Core.loadFromPrefs('biometrics');
    setState(() {
      _biomValue = value == 'true';
    });
  }

  void _saveBiomValue(bool value) async {
    await Core.saveToPrefs('biometrics', value.toString());
  }

  void _removeBiomValue() async {
    await Core.removeFromPrefs('biometrics');
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
    _loadSwitchValue();
    _loadBiomValue();
    _loadUserData();
    _checkToken();
    _checkUserData();
    _checkBiometricSupport();
    checkBillingShippingStatus();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _email = prefs.getString('user_email') ?? '';
        userName = prefs.getString('user_display_name') ?? '';
        _password = prefs.getString('password') ?? '';
        _phone = prefs.getString('user_phone') ?? '';
        _fName = prefs.getString('user_last_name') ?? '';
        userNicename = prefs.getString('user_nicename') ?? '';
        _avatar = prefs.getString('user_avatar_url') ?? '';
        userRole = prefs.getString('user_role') ?? '';
        _token = prefs.getString('token') ?? '';
      },
    );
  }

  Future<bool> checkBillingShippingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_billing_shipping') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const AccountPage();
    } else {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Image.asset(
              'images/app/decapital_auth_bg.png',
              fit: BoxFit.cover,
            ),
            collapseMode: CollapseMode.pin,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: _launchWhatsApp,
          child: Visibility(
            visible: true,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: const DecorationImage(
                    image: AssetImage(
                      "images/app/whatsapp.png",
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                height: 80,
                width: 80,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            children: <Widget>[
              const UserInfoCard(),
              const AddressErrorCard(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 8,
                ),
                child: Text(
                  "User's settings and info",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Core.tile(
                title: 'My Wishlists',
                subTitle:
                    'Open the list of items you added to wishloved or loved.',
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const WishlistPage(),
                    ),
                  );
                },
                icon: FluentIcons.heart_20_regular,
                bgColor: Colors.red.shade300,
              ),
              Core.tile(
                title: 'My Orders',
                subTitle:
                    'Open to view, edit or delete your placed orders list.',
                onTap: () {
                  try {
                    Navigator.of(context).push(
                      Core.smoothFadePageRoute(
                        context,
                        const OrderPage(),
                      ),
                    );
                    // ignore: empty_catches
                  } on Exception {}
                },
                icon: FluentIcons.cart_20_regular,
                bgColor: Colors.blue.shade300,
              ),
              Core.tile(
                title: 'View Stories',
                subTitle: 'View current stories or statuse in Ahafo.',
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const MoreStories(),
                    ),
                  );
                },
                icon: FluentIcons.video_clip_optimize_20_regular,
                bgColor: Colors.black,
              ),
              Core.tile(
                title: 'DHR Video Shop',
                subTitle:
                    'Watch mouth watering menu/food videos. Click buy when appetized.',
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const VideoShop(),
                    ),
                  );
                },
                icon: FluentIcons.shopping_bag_play_20_regular,
                bgColor: Colors.pink,
              ),
              Core.tile(
                title: 'My Addresses',
                subTitle: 'Change or delete your shipping addresses for orders',
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const MyAddress(),
                    ),
                  );
                },
                icon: FluentIcons.home_20_regular,
                bgColor: Colors.grey.shade700,
              ),
              Core.tile(
                title: 'My Referral Link',
                subTitle:
                    'Share your referral link among others to lore more points.',
                onTap: () async {
                  try {
                    final result = await Share.share(
                      subject:
                          'Download this app using my referral link: https://decapitalrgille.com/referrer/$userNicename',
                      text,
                    );
                    if (result.status == ShareResultStatus.success) {
                      Core.snackThis('Thank you for referring a person!',
                          context: context);
                    } else {
                      Core.snackThis('Referring process incomplete. Try again!',
                          context: context, type: 'alert');
                    }
                  } catch (e) {
                    Core.snackThis('Failed to refer. Try again please',
                        context: context, type: 'fail');
                  }
                },
                icon: FluentIcons.people_community_20_regular,
                bgColor: Colors.amber.shade800,
              ),
              SwitchListTile.adaptive(
                value: _notifValue,
                onChanged: (t) {
                  setState(() {
                    _notifValue = !_notifValue;
                    _saveSwitchValue(_notifValue);

                    if (!_notifValue) {
                      _removeSwitchValue();
                    }
                  });
                },
                secondary: CircleAvatar(
                  foregroundColor: Core.foreCol,
                  backgroundColor: Colors.lightBlue.shade700,
                  child: const Icon(FluentIcons.alert_badge_24_regular),
                ),
                title: const Text("Enable notifications"),
                subtitle: Core.inform(
                    text: "Get notifications on orders, coupons and discounts"),
              ),
              _isBiometricSupported
                  ? SwitchListTile.adaptive(
                      value: _biomValue,
                      onChanged: (t) async {
                        bool currentValue = _biomValue;
                        bool isAuthenticated =
                            await _core.biometricVerification();
                        if (isAuthenticated) {
                          setState(() {
                            _biomValue = !_biomValue;
                            _saveBiomValue(_biomValue);
                          });
                          if (_biomValue) {
                            Core.snackThis(
                              context: context,
                              'Transacting authentications enabled',
                            );
                          } else {
                            Core.snackThis(
                              context: context,
                              'Transacting authentications disabled',
                            );
                          }
                        } else {
                          setState(() {
                            _biomValue = currentValue;
                          });
                          Core.snackThis(
                            context: context,
                            'Please verify your biometrics to proceed',
                            type: 'alert',
                          );
                        }
                        if (!_biomValue) {
                          _removeBiomValue();
                        }
                      },
                      secondary: CircleAvatar(
                        foregroundColor: Core.foreCol,
                        backgroundColor: Colors.lightBlue.shade900,
                        child: const Icon(FluentIcons.fingerprint_48_regular),
                      ),
                      title: const Text("Biometric verifications"),
                      subtitle: Core.inform(
                          text:
                              "Verify biometrics before issuing transactions"),
                    )
                  : ListTile(
                      leading: CircleAvatar(
                        foregroundColor: Core.foreCol,
                        backgroundColor: Colors.grey.shade700,
                        child: const Icon(FluentIcons.fingerprint_48_regular),
                      ),
                      title: const Text("Biometric verifications"),
                      subtitle: Core.inform(
                          text:
                              "Your phone does not support biometric verifications"),
                    ),
              Core.tile(
                title: 'Change Password',
                subTitle:
                    'Change your login password, verification will be required.',
                icon: FluentIcons.lock_closed_key_20_regular,
                bgColor: Colors.green,
                onTap: () => Navigator.of(context).push(
                  Core.smoothFadePageRoute(
                    context,
                    const ChangePassword(),
                  ),
                ),
              ),
              Core.tile(
                title: 'Log Out',
                subTitle: 'Log out your account from the app.',
                icon: FluentIcons.sign_out_20_regular,
                onTap: () async {
                  DialogBackground(
                    dismissable: false,
                    blur: 5,
                    dialog: NDialog(
                      dialogStyle: DialogStyle(
                        titleDivider: true,
                      ),
                      title: Row(
                        children: [
                          const Icon(FluentIcons.sign_out_24_regular),
                          const SizedBox(
                            width: 5,
                          ),
                          Core.title(title: 'Confirm Logout')
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Core.inform(
                                text:
                                    'Are you sure you want to sign out? You will need to sign in again to use our platforms.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Core.goBack(context);
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () async {
                            EasyLoading.show(
                                status: 'Signing out, please wait.');
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('email');
                            prefs.remove('password');
                            prefs.remove('token');
                            await woocommerce.logUserOut();
                            try {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              authProvider.logout(context);
                              setState(() {
                                _isLoggedIn = false;
                              });
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logged Out Successfully'),
                                ),
                              );
                              Core.goBack(context);
                            } catch (e) {
                              EasyLoading.dismiss();
                              Core.snackThis(
                                  context: context,
                                  'Error Logging out, Try again',
                                  type: 'fail');
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                  ).show(context);
                },
                bgColor: Colors.purple.shade600,
              ),
              Core.tile(
                title: 'Delete my Account',
                subTitle:
                    'Permanently terminate your account on all De Capital HR\'s Systems',
                icon: FluentIcons.delete_20_regular,
                onTap: () async {
                  DialogBackground(
                    dismissable: true,
                    blur: 5,
                    dialog: NDialog(
                      dialogStyle: DialogStyle(
                        titleDivider: true,
                      ),
                      title: const Row(
                        children: [
                          Icon(FluentIcons.delete_48_filled),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Confirm Deleting account',
                            style: TextStyle(
                              fontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:
                                    'Are you sure you want to terminate/delete your account? ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'Please note that deleted accounts will lose all their previous orders among other vital data on our platforms.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade700,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const TextSpan(
                                      text:
                                          ' You will need to create an account again to access all our platforms. '),
                                  TextSpan(
                                    text:
                                        'De Capital Hotels & Restaurant will not be held reliable for any misfortunes thereafter. PROCEED WITH CAUTIONS.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Core.goBack(context);
                          },
                        ),
                        TextButton(
                          child: Text(
                            'I UNDERSTAND, PROCEED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          onPressed: () async {
                            Core.goBack(context);
                            DialogBackground(
                              dismissable: true,
                              blur: 5,
                              dialog: NDialog(
                                dialogStyle: DialogStyle(
                                  titleDivider: true,
                                ),
                                title: const Row(
                                  children: [
                                    Icon(FluentIcons.delete_48_filled),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Final Confirmation',
                                      style: TextStyle(
                                        fontSize: 22,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              'This is to certify that you truly mean the action undertaken. ',
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'You may proceed with your account termination now.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade700,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const TextSpan(
                                                text:
                                                    ' We do wish to here from you concerning why you want to terminate your account. '),
                                            TextSpan(
                                              text:
                                                  'After Deleting your account, you will be taken to our website to provide your feedback if you wish to.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Core.goBack(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'YES, DELETE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                    onPressed: () async {
                                      EasyLoading.show(
                                          status:
                                              'Deleting your account, please wait.');
                                      try {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();

                                        // Retrieve the user ID
                                        int? userId = prefs.getInt('user_id');
                                        if (userId == null) {
                                          EasyLoading.dismiss();
                                          Core.snackThis(
                                            context: context,
                                            'User status error. Try logout and login.',
                                            type: 'fail',
                                          );
                                          return;
                                        }

                                        await woocommerce.deleteCustomer(
                                            customerId: userId);

                                        // Clear shared preferences
                                        await woocommerce.logUserOut();
                                        try {
                                          final authProvider =
                                              Provider.of<AuthProvider>(context,
                                                  listen: false);
                                          authProvider.logout(context);
                                        } catch (e) {
                                          EasyLoading.dismiss();
                                          Core.snackThis(
                                              context: context,
                                              'Error Logging out, Try again',
                                              type: 'fail');
                                          print(e);
                                        }
                                        setState(() {
                                          _isLoggedIn = false;
                                        });

                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          myHomePageKey.currentState
                                              ?.setIndex(0);
                                        });
                                        EasyLoading.dismiss();
                                        Core.snackThis(
                                          context: context,
                                          'Your account was deleted successfully.',
                                          type: 'alert',
                                        );
                                      } catch (e) {
                                        EasyLoading.dismiss();
                                        Core.snackThis(
                                          context: context,
                                          'Error deleting account, please try again.',
                                          type: 'alert',
                                        );
                                        print('Error deleting account: $e');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ).show(context);
                          },
                        ),
                      ],
                    ),
                  ).show(context);
                },
                bgColor: Colors.red.shade800,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 8.0,
                ),
                child: Text(
                  "App settings and info",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Core.tile(
                subTitle: 'Reach out to us for any enquiries',
                title: 'Contact US',
                icon: FluentIcons.contact_card_48_filled,
                onTap: () => Core.showContactSheet(context),
                bgColor: Colors.green,
              ),
              Core.tile(
                title: 'Leave a review',
                subTitle: 'Rate us on the Play/App stores',
                icon: FluentIcons.star_half_20_regular,
                onTap: () => Core.reviewApp(),
                bgColor: Colors.grey,
              ),
              Core.tile(
                title: 'Privacy Policies',
                subTitle: 'Guidelines on how we manage users and app data',
                icon: FluentIcons.shield_person_20_regular,
                onTap: () => Core.showCustomSheet(context),
                bgColor: Colors.amber,
              ),
              Core.tile(
                title: 'Terms and Conditions',
                subTitle: 'Read the guidelines on our terms and conditions',
                icon: FluentIcons.document_bullet_list_multiple_20_regular,
                onTap: () => Core.showTermsSheet(context),
                bgColor: Colors.lightBlue.shade800,
              ),
              Core.tile(
                title: 'Share this App',
                subTitle: 'Spread the good news to your family/friends',
                icon: FluentIcons.share_android_32_regular,
                onTap: () async {
                  try {
                    final result = await Share.share(
                      subject: 'Share Decapital HR(Grille) App',
                      text,
                    );
                    if (result.status == ShareResultStatus.success) {
                      Core.snackThis('Thank you for sharing De Capital HR!',
                          context: context);
                    } else {
                      Core.snackThis('Sharing process incomplete. Try again!',
                          context: context, type: 'alert');
                    }
                  } catch (e) {
                    Core.snackThis('Failed to share. Try again please',
                        context: context, type: 'fail');
                  }
                },
                bgColor: Colors.blue,
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              ExpansionTile(
                subtitle: Core.inform(
                    text:
                        'Click here to show other contact and reachout informations.',
                    color: Colors.black54),
                title: const Text("About App"),
                initiallyExpanded: false,
                maintainState: true,
                trailing: const Icon(FluentIcons.info_48_regular),
                children: <Widget>[
                  ListTile(
                    title: Core.inform(
                        text: "De Capital Hotels & Restaurant(DHR)"),
                  ),
                  ListTile(
                    title: Core.inform(text: "Hospitality Redefined"),
                  ),
                  ListTile(
                    title: Core.inform(text: "Phone: 0555113115"),
                  ),
                  ListTile(
                    title: Core.inform(text: "Email: info@decapitalgrille.com"),
                  ),
                  ListTile(
                    title: Text(
                      Core.appVer,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  void _launchWhatsApp() async {
    const String phone = '+233555113115';
    const String message = 'Hello, I need assistance with Decapital HR App!';
    final Uri whatsappUri = Uri.parse(
        "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      Core.snackThis('Could not launch WhatsApp, tray again', type: 'fail');
    }
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 190,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('images/account/card_point.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          authProvider.avatar,
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              'Pts: 10000dc',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 33),
                          NielButton(
                            id: 'userType',
                            leftIcon: Text(
                              '${authProvider.userRole.capitalize()}  ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(221, 55, 0, 137),
                                fontWeight: FontWeight.bold,
                                fontVariations: [
                                  FontVariation('wght', 900),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Core.showDialog(
                                context,
                                'Hello customer: ${authProvider.acTabName}  ',
                                icon: SvgPicture.asset(
                                  'images/app/confetti.svg',
                                  fit: BoxFit.contain,
                                  height: 24,
                                ),
                                contents: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: SvgPicture.asset(
                                        'images/app/thankyou.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 215,
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: Text(
                                        'Thank you ${authProvider.displayName} our most cherished customer for choosing US. We are commited to providing you with all the good customer services you need 24/7',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                gestureName: 'Appreciated',
                                onPress: () => Navigator.of(context).pop(),
                              );
                            },
                            size: NielButtonSize.S,
                            borderRadius: 10,
                            gradient: const [
                              Color.fromARGB(255, 251, 231, 255),
                              Color.fromARGB(255, 249, 239, 233),
                              Color.fromARGB(255, 229, 254, 242),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '${authProvider.displayName}  ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${authProvider.email.capitalize()}  ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${authProvider.phone}  ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NielButton(
                            id: 'editP',
                            onPressed: () => Navigator.of(context).push(
                              Core.smoothFadePageRoute(
                                  context, const EditProfile()),
                            ),
                            background: Colors.black,
                            borderRadius: 6,
                            text: 'Edit Profile',
                            size: NielButtonSize.S,
                          ),
                          const SizedBox(width: 10),
                          NielButton(
                            id: 'viewP',
                            onPressed: () => Navigator.of(context).push(
                              Core.smoothFadePageRoute(
                                context,
                                const ViewProfile(),
                              ),
                            ),
                            borderRadius: 6,
                            background: Colors.transparent,
                            defaultBorderColor: Colors.white,
                            shadowColor: Colors.black,
                            text: 'View Profile',
                            size: NielButtonSize.S,
                            type: NielButtonType.SECONDARY,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddressErrorCard extends StatefulWidget {
  const AddressErrorCard({super.key});

  @override
  State<AddressErrorCard> createState() => _AddressErrorCardState();
}

class _AddressErrorCardState extends State<AddressErrorCard> {
  bool _showError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final addressProvider = Provider.of<AddressProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showError = !addressProvider.hasValidAddresses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      offset: _showError ? Offset.zero : const Offset(-1, 0),
      curve: Curves.elasticInOut,
      child: Visibility(
        visible: _showError,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              Core.smoothFadePageRoute(context, const MyAddress()),
            );
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(254, 3, 0, 1),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(254, 3, 0, 1),
                          ),
                          child: CustomPaint(
                            painter: WarningTextPainter(),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SYSTEM',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                color: Color.fromRGBO(254, 91, 85, .8),
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                height: 0.9,
                                letterSpacing: 1,
                                fontVariations: [
                                  FontVariation('wght', 900),
                                ],
                              ),
                            ),
                            Text(
                              'ERROR!',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                color: Color.fromRGBO(254, 91, 85, .8),
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                height: 0.9,
                                letterSpacing: 1,
                                fontVariations: [
                                  FontVariation('wght', 900),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FluentIcons.error_circle_20_filled,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Invalid or Empty Addresses.',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            wordSpacing: 0,
                            fontSize: 20,
                            height: 1,
                            fontVariations: [FontVariation('wght', 700)],
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      'Please head to "My Addresses" to fill your addresses. We use this information to send orders to your location.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarningTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.2),
      fontSize: 10,
      fontWeight: FontWeight.bold,
      fontVariations: const [FontVariation('wght', 900)],
      letterSpacing: 0,
    );

    final textSpan = TextSpan(
      text: 'WARNING!',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // Draw text at regular intervals across the canvas
    for (double y = 0; y < size.height; y += textHeight * 1.1) {
      for (double x = 0; x < size.width; x += textWidth * 1.1) {
        // Offset each row slightly for a staggered effect
        final offsetX = (y ~/ textHeight) % 2 == 0 ? x : x + textWidth / 10;
        textPainter.paint(canvas, Offset(offsetX, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
