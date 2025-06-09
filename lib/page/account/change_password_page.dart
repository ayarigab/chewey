import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/providers/auth_provider.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/inputs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class ResetPassword extends StatefulWidget {
  final String? email;
  const ResetPassword({super.key, this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isLoggedIn = false;
  final _formResetPassword = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkToken();
    _emailController.text = widget.email ?? '';
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

  Future<void> _validateCodeAndResetPassword() async {
    if (_formResetPassword.currentState!.validate()) {
      EasyLoading.show(status: 'Validating code...');

      final email = _emailController.text;
      final code = _codeController.text;
      final newPassword = _newPasswordController.text;

      try {
        // Validate code
        final validateResponse = await http.post(
          Uri.parse(
              'https://decapitalgrille.com/wp-json/bdpwr/v1/validate-code'),
          body: {'email': email, 'code': code},
        );

        if (validateResponse.statusCode == 200) {
          final validateData = json.decode(validateResponse.body);

          if (validateData['data']['status'] == 200) {
            // Code validated, now reset password
            EasyLoading.show(status: 'Resetting password...');
            final resetResponse = await http.post(
              Uri.parse(
                  'https://decapitalgrille.com/wp-json/bdpwr/v1/set-password'),
              body: {'email': email, 'code': code, 'password': newPassword},
            );

            if (resetResponse.statusCode == 200) {
              final resetData = json.decode(resetResponse.body);

              if (resetData['data']['status'] == 200) {
                EasyLoading.show(status: 'Signing out, please wait.');
                if (context.mounted) {
                  Core.snackThis(
                    context: context,
                    'Password reset successfully. Please log in with your new password.',
                  );
                }
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                prefs.remove('password');
                prefs.remove('token');
                await woocommerce.logUserOut();
                try {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  authProvider.logout(context);
                  setState(() {
                    _isLoggedIn = false;
                  });
                  _isLoggedIn = false;
                  EasyLoading.dismiss();
                  if (context.mounted) {
                    Core.snackThis('You are logged out successfully!',
                        context: context, type: 'alert');
                  }
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  myHomePageKey.currentState?.setIndex(0);
                } catch (e) {
                  EasyLoading.dismiss();
                  Core.snackThis(
                      context: context,
                      'Error Logging out, Try again',
                      type: 'fail');
                  print(e);
                }
              } else {
                EasyLoading.dismiss();
                Core.snackThis(context: context, resetData['message']);
              }
            } else {
              EasyLoading.dismiss();
              Core.snackThis(
                context: context,
                'Failed to reset password. Please try again later.',
              );
            }
          } else {
            EasyLoading.dismiss();
            Core.snackThis(context: context, validateData['message']);
          }
        } else {
          EasyLoading.dismiss();
          Core.snackThis(
            context: context,
            'Invalid code. Please try again.',
          );
        }
      } catch (e) {
        EasyLoading.dismiss();
        Core.snackThis(
          context: context,
          'An error occurred. Please try again later.',
        );
      }
    }
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
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isDarkMode
                      ? Colors.black.withOpacity(0.8)
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
                  child: Form(
                    key: _formResetPassword,
                    child: Column(
                      children: <Widget>[
                        NielInput(
                          id: 'email',
                          controller: _emailController,
                          hintText: 'Enter your email',
                          type: NielInputType.EMAIL,
                          prefixIcon: const Icon(Icons.email_outlined),
                          borderRadius: 8,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          borderColor:
                              Theme.of(context).colorScheme.onSecondary,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          textInputAction: TextInputAction.next,
                          size: NielInputSize.MEDIUM,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        NielInput(
                          id: 'code',
                          controller: _codeController,
                          hintText: 'Enter the code',
                          type: NielInputType.TEXT,
                          prefixIcon: const Icon(Icons.code_outlined),
                          borderRadius: 8,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          borderColor:
                              Theme.of(context).colorScheme.onSecondary,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          textInputAction: TextInputAction.next,
                          size: NielInputSize.MEDIUM,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Code is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        NielInput(
                          id: 'new_password',
                          controller: _newPasswordController,
                          hintText: 'Enter new password',
                          type: NielInputType.PASSWORD,
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          borderRadius: 8,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          borderColor:
                              Theme.of(context).colorScheme.onSecondary,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          textInputAction: TextInputAction.next,
                          size: NielInputSize.MEDIUM,
                          isSecured: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'New password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        NielInput(
                          id: 'confirm_password',
                          controller: _confirmPasswordController,
                          hintText: 'Confirm new password',
                          type: NielInputType.PASSWORD,
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          borderRadius: 8,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          borderColor:
                              Theme.of(context).colorScheme.onSecondary,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          textInputAction: TextInputAction.done,
                          size: NielInputSize.MEDIUM,
                          isSecured: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm password is required';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: _validateCodeAndResetPassword,
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
                                'Reset Password',
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
            ),
          ],
        ),
      ),
    );
  }
}
