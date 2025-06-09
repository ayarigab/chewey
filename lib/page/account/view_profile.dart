import 'package:decapitalgrille/page/account/edit_profile.dart';
import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool _isLoggedIn = false;
  late WooCustomer userData;
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
    _checkUserData();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      setState(() => _isLoggedIn = true);
    }
  }

  Future<void> _checkUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('user_id');

    if (userID != null) {
      try {
        final fetchedUserData =
            await woocommerce.getCustomerByIdWithApi(id: userID);
        setState(() {
          userData = fetchedUserData;
          _isUserDataLoaded = true;
        });
      } catch (error) {
        // Handle error
      }
    }
  }

  String _sanitizePhone(String? phone) {
    return (phone == null || phone.isEmpty || phone == 'null') ? '-' : phone;
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontVariations: [FontVariation('wght', 900)],
            ),
          ),
        ),
        Expanded(
          child: Text(
            ':    $value',
            style: const TextStyle(
              fontSize: 16,
              fontVariations: [FontVariation('wght', 900)],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    if (!_isLoggedIn) return const AccountPage();

    return Scaffold(
      appBar: AppBar(
        leading: Core.backBut(context),
        title: const Text('My Account'),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.network(
                                  userData.avatarUrl.toString(),
                                  fit: BoxFit.cover,
                                  height: 150,
                                ),
                                Text(
                                  'Date Joined:    ${userData.dateCreatedGmt}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontVariations: [
                                      FontVariation('wght', 700)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildInfoRow('First Name',
                                    userData.firstName.toString()),
                                const Divider(color: Colors.grey, thickness: 2),
                                _buildInfoRow(
                                    'Last Name', userData.lastName.toString()),
                                const Divider(color: Colors.grey, thickness: 2),
                                _buildInfoRow(
                                    'Username',
                                    Core.obscureUsername(
                                        userData.username.toString())),
                                const Divider(color: Colors.grey, thickness: 2),
                                _buildInfoRow(
                                    'Email', userData.email.toString()),
                                const Divider(color: Colors.grey, thickness: 2),
                                _buildInfoRow('Phone No',
                                    _sanitizePhone(userData.billing?.phone)),
                                const Divider(color: Colors.grey, thickness: 2),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                Core.smoothFadePageRoute(
                                    context, const EditProfile()),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.green, Colors.greenAccent],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Edit Account',
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
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Core.loadThis(context,
                  inform: 'Loading account data, please wait.'),
            ),
    );
  }
}
