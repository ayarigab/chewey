// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:decapitalgrille/page/account/forgot_password.dart';
import 'package:decapitalgrille/page/account/sign_up.dart';
import 'package:decapitalgrille/providers/auth_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/divider.dart';
import 'package:decapitalgrille/widgets/inputs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

import 'package:decapitalgrille/page/account/user_profile.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class AccountPage extends StatefulWidget {
  // final VoidCallback? onLoginStatusChanged;
  final ScrollController? scrollController;

  const AccountPage({
    this.scrollController,
    super.key,
  });

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _email = '';
  String _password = '';
  bool _isLoggedIn = false;

  void _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_isLoggedIn) {
      return const UserPage();
    } else {
      return Scaffold(
        body: SafeArea(
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
                  controller: widget.scrollController ?? ScrollController(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    // padding: const EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.10,
                            ),
                            Core.logo,
                            Center(child: Core.head(head: 'Login')),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Form(
                              key: _formKey,
                              child: _buildTextFields(),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                final emailError = _checkEmailAddress(email);
                                final passwordError = _checkPassword(password);
                                if (emailError == null &&
                                    passwordError == null) {
                                  await _performLogin();
                                } else {
                                  String errorMessage = '';
                                  if (emailError != null &&
                                      passwordError != null) {
                                    errorMessage +=
                                        'Email and Password fields are required';
                                  }
                                  if (emailError != null) {
                                    errorMessage += '$emailError ';
                                  }
                                  if (passwordError != null) {
                                    errorMessage += passwordError;
                                  }
                                  Core.snackThis(
                                      context: context,
                                      errorMessage,
                                      type: 'fail');
                                }
                              },
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
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        NielButton(
                                          id: 'create_account',
                                          foregroundColor: NielCol.nature,
                                          background: Colors.transparent,
                                          text: 'Create Account',
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              Core.smoothFadePageRoute(
                                                context,
                                                const SignUpPage(),
                                              ),
                                            );
                                          },
                                          type: NielButtonType.SECONDARY,
                                          defaultBorderColor: NielCol.nature,
                                          borderLineWidth: 1,
                                          size: NielButtonSize.S,
                                          borderRadius: 4,
                                        ),
                                        NielButton(
                                          id: 'forgot_password',
                                          foregroundColor: NielCol.mainCol,
                                          background: Colors.transparent,
                                          text: 'Forgot Password',
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              Core.smoothFadePageRoute(
                                                context,
                                                const ForgotPassword(),
                                              ),
                                            );
                                          },
                                          type: NielButtonType.SECONDARY,
                                          defaultBorderColor: NielCol.mainCol,
                                          borderLineWidth: 1,
                                          size: NielButtonSize.S,
                                          borderRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                child: const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    NielDivider(
                                      text: 'Thank you for using our platform',
                                      thickness: 1,
                                      fadeEnds: true,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        NielInput(
          id: 'username',
          controller: _emailController,
          hintText: 'Enter your email',
          type: NielInputType.EMAIL,
          prefixIcon: const Icon(FluentIcons.person_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.next,
          size: NielInputSize.LARGE,
          validator: (value) => _checkEmailAddress(value),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        NielInput(
          id: 'password',
          controller: _passwordController,
          prefixIcon: const Icon(FluentIcons.lock_closed_48_regular),
          hintText: 'Enter your password',
          type: NielInputType.PASSWORD,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          size: NielInputSize.LARGE,
          textInputAction: TextInputAction.done,
          borderRadius: 8,
          isSecured: true,
          validator: (value) => _checkPassword(value),
        ),
      ],
    );
  }

  bool _isValidEmailAddress(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  String? _checkEmailAddress(email) {
    if (email.isEmpty) {
      return 'Email field is required';
    }

    if (!_isValidEmailAddress(email)) {
      return 'Please enter a valid email address';
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

  Future<void> _performLogin() async {
    EasyLoading.show(status: 'Please Wait');
    try {
      final response = await woocommerce.authenticateViaJWT(
        email: _email,
        password: _password,
      );
      debugPrint('Response Body: $response');

      if (response != null) {
        final responseBody = json.decode(response);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responseBody['token']);
        prefs.setString('user_email', responseBody['user_email']);
        prefs.setString('user_last_name', responseBody['user_last_name']);
        prefs.setString('user_avatar_url', responseBody['user_avatar_url']);
        // widget.onLoginStatusChanged!();
        prefs.setString('user_display_name',
            '${responseBody['user_first_name']} ${responseBody['user_last_name']}');
        prefs.setString('user_first_name', responseBody['user_first_name']);
        prefs.setInt('user_id', int.parse(responseBody['user_id'].toString()));

        prefs.setString('password', _password);
        prefs.setString('user_nicename', responseBody['user_nicename']);
        prefs.setString('user_role', responseBody['user_role']);
        prefs.setString('user_registered', responseBody['user_registered']);
        prefs.setInt(
            'user_status', int.parse(responseBody['user_status'].toString()));
        prefs.setString(
            'user_activation_key', responseBody['user_activation_key']);

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.login(
          token: responseBody['token'],
          userId: int.parse(responseBody['user_id'].toString()),
          avatar: responseBody['user_avatar_url'],
          lastName: responseBody['user_last_name'],
          email: responseBody['user_email'] ?? _emailController.text,
          password: _password,
          displayName:
              '${responseBody['user_first_name']} ${responseBody['user_last_name']}',
          firstName: responseBody['user_first_name'],
          userRole: responseBody['user_role'],
          context: context,
        );
        setState(() {
          _isLoggedIn = true;
        });
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged In'),
          ),
        );
      } else {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred during login'),
          ),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred during login'),
        ),
      );
    }
  }
}
