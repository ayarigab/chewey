import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/inputs.dart';
import 'package:decapitalgrille/widgets/divider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:woocommerce/woocommerce.dart';

WooCommerce woocommerce = WooCommerce(
  baseUrl: url,
  consumerKey: cKey,
  consumerSecret: cCret,
);

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isDarkMode
                      ? Colors.black.withOpacity(.8)
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
                      Center(child: Core.head(head: 'Create a new account')),
                      Form(
                        key: _formKey,
                        child: _buildTextFields(),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          EasyLoading.show(status: 'Signing Up, please wait.');
                          if (_formKey.currentState?.validate() == true) {
                            FocusScope.of(context).unfocus();
                            try {
                              var newCustomer = WooCustomer(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                username: _emailController.text,
                                password: _passwordController.text,
                              );
                              final createdCustomer =
                                  await woocommerce.createCustomer(newCustomer);
                              if (createdCustomer != null) {
                                _firstNameController.clear();
                                _lastNameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _confirmPassword.clear();
                                print(
                                  'User created: ${createdCustomer.username}',
                                );
                                EasyLoading.dismiss();
                                EasyLoading.showSuccess(
                                    'Successful, Logging In.');
                                Core.snackThis(
                                    context: context,
                                    'Account created successfully, Please login now.');
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                myHomePageKey.currentState?.setIndex(4);
                                // EasyLoading.dismiss();
                              } else {
                                EasyLoading.dismiss();
                                Core.snackThis(
                                    context: context,
                                    'User creation failed.',
                                    type: 'fail');
                              }
                            } catch (e) {
                              EasyLoading.dismiss();
                              Core.snackThis(
                                  context: context,
                                  'Oops! Error, Please try again.',
                                  type: 'fail');
                              print('Error: $e');
                              if (e.toString().contains(
                                  'registration-error-email-exists')) {
                                EasyLoading.dismiss();
                                Core.snackThis(
                                  context: context,
                                  'The User already exists, Please login',
                                  type: 'fail',
                                );
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                myHomePageKey.currentState?.setIndex(4);
                              }
                            }
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('email', _email);
                            prefs.setString('password', _password);
                          } else {
                            final emailError =
                                _checkEmailAddress(_emailController.text);
                            final passwordError =
                                _checkPassword(_passwordController.text);
                            final firstNameError =
                                _firstNamecheck(_firstNameController.text);
                            final lastNameError =
                                _lastNamecheck(_lastNameController.text);
                            final confirmPasswordError =
                                _checkPasswordfield(_confirmPassword.text);

                            String errorMessage = '';

                            if (emailError != null) {
                              errorMessage += '$emailError\n';
                            }
                            if (passwordError != null) {
                              errorMessage += '$passwordError\n';
                            }
                            if (firstNameError != null) {
                              errorMessage += '$firstNameError\n';
                            }
                            if (lastNameError != null) {
                              errorMessage += '$lastNameError\n';
                            }
                            if (confirmPasswordError != null) {
                              errorMessage += '$confirmPasswordError\n';
                            }
                            Core.snackThis(
                                context: context,
                                errorMessage.trim(),
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
                              'Create Account',
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          NielDivider(
                            text: 'Thank you for using our platforms',
                            thickness: 1,
                            fadeEnds: true,
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 4.0,
                                ),
                              ],
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        NielInput(
          id: 'password',
          controller: _passwordController,
          hintText: 'Enter your password',
          type: NielInputType.PASSWORD,
          isSecured: true,
          prefixIcon: const Icon(FluentIcons.lock_closed_48_regular),
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
          id: 'Confirm_password',
          controller: _confirmPassword,
          hintText: 'Confirm your password',
          type: NielInputType.PASSWORD,
          isSecured: true,
          prefixIcon: const Icon(FluentIcons.lock_closed_48_regular),
          borderRadius: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderColor: Theme.of(context).colorScheme.onSecondary,
          textColor: Theme.of(context).colorScheme.onSurface,
          textInputAction: TextInputAction.done,
          size: NielInputSize.MEDIUM,
          validator: (value) => _checkPasswordfield(value),
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

  String? _checkPasswordfield(value) {
    if (value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _password) {
      return 'Passwords do not match';
    }

    setState(() {
      _password = value;
    });

    return null;
  }
}
