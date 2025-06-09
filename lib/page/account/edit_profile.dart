import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/providers/auth_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/inputs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isLoggedIn = false;
  late WooCustomer userData;
  String token = '';
  bool _isUserDataLoaded = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _numberController;
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _checkToken();
    _checkUserData();
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
          _emailController = TextEditingController(text: userData.email);
          prefs.setString('user_email', '${userData.email}');
          _numberController =
              TextEditingController(text: userData.billing?.phone);
          prefs.setString('user_phone', '${userData.billing?.phone}');
          _usernameController = TextEditingController(
              text: Core.obscureUsername(userData.username.toString()));
          _firstNameController =
              TextEditingController(text: userData.firstName);
          prefs.setString('user_last_name', '${userData.lastName}');
          _lastNameController = TextEditingController(text: userData.lastName);
          prefs.setString('user_first_name', '${userData.firstName}');
          prefs.setString('user_display_name',
              '${userData.firstName} ${userData.lastName}');
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          authProvider.updateUserInfo(
            acTabName: '${userData.lastName}',
            displayName: '${userData.firstName} ${userData.lastName}',
            email: '${userData.email}',
            avatar: '${userData.avatarUrl}',
            phone: '${userData.billing!.phone}',
          );
          _isUserDataLoaded = true;
        });
      } catch (error) {
        //
      }
    }
  }

  Future<void> _updateUserData() async {
    EasyLoading.show(status: 'Please Wait');
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('user_id');

    if (userID != null) {
      try {
        final updatedData = {
          'email': _emailController.text,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'username': userData.username,
          'phone': _numberController.text,
          'billing': {
            'phone': _numberController.text.isNotEmpty
                ? _numberController.text
                : null,
          },
        };

        await woocommerce.updateCustomer(
          id: userID,
          data: updatedData,
        );
        await _checkUserData();
        EasyLoading.dismiss();
        if (context.mounted) {
          Core.snackThis('Account successfully updated.', context: context);
        }
      } catch (error) {
        EasyLoading.dismiss();
        if (context.mounted) {
          Core.snackThis('An error occured, Try again',
              context: context, type: 'fail');
        }
      }
    } else {
      EasyLoading.dismiss();
      if (context.mounted) {
        Core.snackThis('Oops! Unknown Error', context: context, type: 'fail');
      }
    }
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      setState(() => _isLoggedIn = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) return const AccountPage();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: Core.backBut(context),
        title: const Text('Edit Account'),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Core.logo,
                            Center(child: Core.head(head: 'Edit your account')),
                            Core.inform(
                                text:
                                    'To update your profile picture, kindly visit our website, login and make ammends.'),
                            Form(
                              key: _formKey,
                              child: _buildTextFields(),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            GestureDetector(
                              onTap: _updateUserData,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.green, Colors.greenAccent],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Submit Changes',
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
                  ),
                ],
              ),
            )
          : Center(
              child: Core.loadThis(context),
            ),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: <Widget>[
        NielInput(
          id: 'first_name',
          controller: _firstNameController,
          hintText: 'Enter First name',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
          validator: (value) => _firstNamecheck(value),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        NielInput(
          id: 'last_name',
          controller: _lastNameController,
          hintText: 'Enter Last name',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
          validator: (value) => _lastNamecheck(value),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        NielInput(
          id: 'username',
          enabled: false,
          controller: _usernameController,
          hintText: 'Enter Username',
          type: NielInputType.TEXT,
          prefixIcon: const Icon(FluentIcons.shield_person_20_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
          validator: (value) => _checkPassword(value),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        NielInput(
          id: 'email',
          controller: _emailController,
          hintText: 'Enter your email',
          type: NielInputType.EMAIL,
          prefixIcon: const Icon(FluentIcons.mail_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
          validator: (value) => _checkEmailAddress(value),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        NielInput(
          id: 'number',
          controller: _numberController,
          hintText: 'Enter phone number',
          type: NielInputType.NUMBER,
          prefixIcon: const Icon(FluentIcons.phone_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.MEDIUM,
          validator: (value) => _checkEmailAddress(value),
        ),
      ],
    );
  }

  bool _isValidEmailAddress(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@(gmail\.com|icloud\.com|yahoo\.com)$")
        .hasMatch(email);
  }

  String? _checkEmailAddress(email) {
    if (email.isEmpty) {
      return 'Email field is required';
    }

    if (!_isValidEmailAddress(email)) {
      return 'Please enter a valid (@gmail,@icloud,@yahoo) address';
    }

    setState(() {
      _email = email;
    });

    return null;
  }

  String? _checkPassword(value) {
    if (value.isEmpty) {
      return 'Password field is required';
    }

    setState(() {
      _password = value;
    });

    return null;
  }

  String? _firstNamecheck(value) {
    if (value.isEmpty) {
      return 'First name field is required';
    }

    setState(() {
      _password = value;
    });

    return null;
  }

  String? _lastNamecheck(value) {
    if (value.isEmpty) {
      return 'Last name field is required';
    }

    setState(() {
      _password = value;
    });

    return null;
  }
}
