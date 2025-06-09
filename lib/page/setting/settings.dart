// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:decapitalgrille/utils/common_services.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final text = TranslationService().translate('download_cont').toString();
  final _slectedTheme = "Follow System";
  final _slectedLang = "English";
  bool _updateValue = true;
  bool _notifValue = true;
  bool _biomValue = false;
  bool _isBiometricSupported = true;
  final Core _core = Core();

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
    _loadBiomValue();
    _checkBiometricSupport();
  }

  void _checkBiometricSupport() async {
    bool isSupported = await _core.checkBiometrics();
    setState(() {
      _isBiometricSupported = isSupported;
    });
  }

  // Load the saved switch value from SharedPreferences
  void _loadSwitchValue() async {
    String? value = await Core.loadFromPrefs('notifications');
    setState(() {
      _notifValue = value == 'true';
    });
  }

  // Save the switch value to SharedPreferences
  void _saveSwitchValue(bool value) async {
    await Core.saveToPrefs('notifications', value.toString());
  }

  // Remove the switch value from SharedPreferences
  void _removeSwitchValue() async {
    await Core.removeFromPrefs('notifications');
  }

  void _loadBiomValue() async {
    String? value = await Core.loadFromPrefs('biometrics');
    setState(() {
      _biomValue = value == 'true';
    });
  }

  // Save the switch value to SharedPreferences
  void _saveBiomValue(bool value) async {
    await Core.saveToPrefs('biometrics', value.toString());
  }

  // Remove the switch value from SharedPreferences
  void _removeBiomValue() async {
    await Core.removeFromPrefs('biometrics');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Core.backBut(context),
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Settings'),
              background: Image.asset(
                'images/app/veggies.jpg',
                fit: BoxFit.cover,
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverFillRemaining(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "General Settings",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                ListTile(
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text("Light Mode"),
                      ),
                      const PopupMenuItem(
                        child: Text("Dark Mode"),
                      ),
                      const PopupMenuItem(
                        child: Text("Follow System"),
                      ),
                    ],
                  ),
                  enabled: true,
                  leading: CircleAvatar(
                    foregroundColor: Core.foreCol,
                    backgroundColor: Colors.amber.shade700,
                    child: const Icon(FluentIcons.dark_theme_24_regular),
                  ),
                  subtitle: Core.inform(
                      text: "Choose your preferred color mode: $_slectedTheme"),
                  title: const Text("Select theme mode"),
                ),
                ListTile(
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text("English"),
                      ),
                      const PopupMenuItem(
                        child: Text("French"),
                      ),
                      const PopupMenuItem(
                        child: Text("Portuguese"),
                      ),
                      const PopupMenuItem(
                        child: Text("Spanish"),
                      ),
                    ],
                  ),
                  enabled: true,
                  leading: const CircleAvatar(
                    foregroundColor: Core.foreCol,
                    backgroundColor: NielCol.people,
                    child: Icon(FluentIcons.local_language_28_regular),
                  ),
                  subtitle: Core.inform(
                      text:
                          "Choose your preferred app language: $_slectedLang"),
                  title: const Text("Select language"),
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
                      text:
                          "Get notifications on orders, coupons and discounts"),
                ),
                SwitchListTile.adaptive(
                  value: _updateValue,
                  onChanged: (t) {
                    setState(() {
                      _updateValue = !_updateValue;
                    });
                  },
                  secondary: const CircleAvatar(
                    foregroundColor: Core.foreCol,
                    backgroundColor: Colors.green,
                    child: Icon(FluentIcons.phone_update_checkmark_24_regular),
                  ),
                  title: const Text("Enable auto updates"),
                  subtitle: Core.inform(
                      text: "Check for and install updates automatically"),
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 8.0,
                  ),
                  child: Text(
                    "Other settings and info",
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
                  bgColor: Colors.grey,
                ),
                Core.tile(
                  title: 'Leave a review',
                  subTitle: 'Rate us on the Play/App stores',
                  icon: FluentIcons.star_half_20_regular,
                  onTap: () => Core.reviewApp(),
                  bgColor: Colors.black,
                ),
                Core.tile(
                  title: 'Privacy Policies',
                  subTitle: 'Guidelines on how we manage users and app data',
                  icon: FluentIcons.shield_person_20_regular,
                  onTap: () => Core.showCustomSheet(context),
                  bgColor: Colors.red.shade700,
                ),
                Core.tile(
                  title: 'Terms and Conditions',
                  subTitle: 'Read the guidelines on our terms and conditions',
                  icon: FluentIcons.document_bullet_list_multiple_20_regular,
                  onTap: () => Core.showTermsSheet(context),
                  bgColor: Colors.purple.shade600,
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 8.0,
                  ),
                  child: Text(
                    "Developer Credits",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Core.tile(
                  title: 'Email Developer',
                  subTitle:
                      'Share bugs and suggestions to our developer\'s mails',
                  icon: FluentIcons.mail_20_regular,
                  onTap: () {
                    final phoneUrl = Uri(
                      scheme: 'mailto',
                      path: 'naabagroups@gmail.com',
                      query: {
                        'subject': 'A Report from: Decapital HR mobile app',
                        'body': '''
                          *****WRITE MESSAGE IN THE FORMAT*****

                          Reason: Give your message a title of these
                                  1. Error
                                  2. Suggestion
                                  3. Reachout
                                  4. Other

                          Query/Message: Write your full message

                          *****FOR A QUICKER REPLY*****
                          *****PLEASE MAKE MESSAGE SHORT*****
                          Now write your message below:
                          '''
                      }
                          .entries
                          .map((entry) =>
                              '${entry.key}=${Uri.encodeComponent(entry.value)}')
                          .join('&'),
                    );

                    launchUrl(phoneUrl);
                  },
                  bgColor: Colors.green,
                ),
                Core.tile(
                  title: 'Visit developer\'s Website',
                  subTitle:
                      'Visit the developer\'s website for more info and contacts',
                  icon: FluentIcons.mention_48_regular,
                  onTap: () {
                    final devWeb = Uri(
                      scheme: 'https',
                      host: 'naabatechs.com',
                      // path: 'decapitalhr',
                    );

                    launchUrl(devWeb);
                  },
                  bgColor: Colors.blue.shade600,
                ),
                Core.tile(
                  title: 'Naaba Technologies',
                  subTitle:
                      'Powered by: Naaba Technologies. Themed by: Niel Greatness',
                  icon: FluentIcons.code_circle_20_filled,
                  bgColor: Colors.yellow.shade800,
                ),
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
                      title:
                          Core.inform(text: "Email: info@decapitalgrille.com"),
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
        ],
      ),
    );
  }
}
