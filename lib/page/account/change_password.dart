import 'package:decapitalgrille/page/account/change_password_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:decapitalgrille/page/account_page.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/inputs.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoggedIn = false;
  final _formChangePassword = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  Future<void> _requestResetEmail() async {
    EasyLoading.show(status: 'Validating input...');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('user_email');
    final storedPassword = prefs.getString('password');

    if (_emailController.text.isEmpty || _oldPassword.text.isEmpty) {
      EasyLoading.dismiss();
      Core.snackThis(
        context: context,
        'Enter all your credentials to continue.',
      );
      return;
    }

    // Validate email and password
    if (_emailController.text != storedEmail) {
      EasyLoading.dismiss();
      Core.snackThis(
        context: context,
        'Enter your login email to continue.',
      );
      return;
    }

    if (_oldPassword.text != storedPassword) {
      EasyLoading.dismiss();
      Core.snackThis(
        context: context,
        'Oops! Password does not match.',
      );
      return;
    }

    // Input is validated, proceed to request reset email
    EasyLoading.show(status: 'Sending Reset Link...');
    if (_formChangePassword.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(
              'https://decapitalgrille.com/wp-json/bdpwr/v1/reset-password'),
          body: {'email': _emailController.text},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['data']['status'] == 200) {
            EasyLoading.dismiss();
            Core.snackThis(
              context: context,
              'A password reset email sent to your email.',
            );
            Navigator.of(context).push(
              Core.smoothFadePageRoute(
                context,
                ResetPassword(email: _emailController.text),
              ),
            );
          } else {
            EasyLoading.dismiss();
            Core.snackThis(
              context: context,
              responseData['message'],
            );
          }
        } else {
          final errorData = json.decode(response.body);
          EasyLoading.dismiss();
          Core.snackThis(
            context: context,
            errorData['message'] ??
                'An error occurred while requesting the reset email.',
          );
        }
      } catch (e) {
        EasyLoading.dismiss();
        Core.snackThis(
          context: context,
          'Failed to request password reset. Please try again later.',
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
        title: const Text('Request Password Reset'),
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
                  child: Column(
                    children: [
                      Form(
                        key: _formChangePassword,
                        child: Column(
                          children: [
                            NielInput(
                              id: 'old_password',
                              controller: _oldPassword,
                              hintText: 'Enter old password',
                              type: NielInputType.PASSWORD,
                              prefixIcon: const Icon(
                                  FluentIcons.lock_closed_key_20_regular),
                              borderRadius: 8,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              borderColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                              textInputAction: TextInputAction.next,
                              size: NielInputSize.MEDIUM,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  Core.snackThis(
                                      'Your old password is required for reset.');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            NielInput(
                              id: 'email',
                              controller: _emailController,
                              hintText: 'Enter your email',
                              type: NielInputType.EMAIL,
                              prefixIcon:
                                  const Icon(FluentIcons.person_20_regular),
                              borderRadius: 8,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              borderColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                              textInputAction: TextInputAction.done,
                              size: NielInputSize.MEDIUM,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  Core.snackThis(
                                      'Your email is required to send reset code.');
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _requestResetEmail,
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
                              'Request Reset Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Core.inform(
                        text:
                            'A confirmation code will be sent to your email. Kindly enter it on the next page.',
                        color: Colors.red,
                      ),
                    ],
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
