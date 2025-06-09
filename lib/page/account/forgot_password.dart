import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/widgets/inputs.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final String _email = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Core.logo,
                  Center(child: Core.head(head: 'Reset your password')),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Core.inform(
                    text: 'Enter your Email below to send a reset link.',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Form(
                    key: _formKey,
                    child: NielInput(
                      id: 'email',
                      controller: _emailController,
                      hintText: 'Enter your email',
                      type: NielInputType.EMAIL,
                      prefixIcon: const Icon(FluentIcons.mail_48_regular),
                      borderRadius: 8,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      borderColor: Theme.of(context).colorScheme.onSecondary,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      textInputAction: TextInputAction.done,
                      size: NielInputSize.MEDIUM,
                      validator: _checkEmailAddress,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final email = _emailController.text;
                      final emailError = _checkEmailAddress(email);
                      if (emailError == null) {
                      } else {
                        Core.snackThis(
                            context: context, emailError, type: 'fail');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidEmailAddress(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  String? _checkEmailAddress(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email field is required';
    }
    if (!_isValidEmailAddress(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
