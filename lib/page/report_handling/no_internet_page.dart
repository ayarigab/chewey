// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'package:decapitalgrille/theme/typography.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:restart_app/restart_app.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result != ConnectivityResult.none) {
        final bool isDeviceConnected =
            InternetConnectionChecker().hasConnection as bool;
        if (isDeviceConnected) {
          // Optionally show a message to user before restarting
          Restart.restartApp();
        }
      }
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashFactory: NoSplash.splashFactory,
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: textTheme,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ErrorHandler.errorThis(
                  'This application needs an active internet connection to work. Please Restart the app',
                  retryText: 'Restart App',
                  image: 'images/errors/no_internet_error.png', onRetry: () {
                Restart.restartApp(
                    notificationTitle: 'App has restarted',
                    notificationBody:
                        'De Capital HR app has restarted. Please tap to open');
              })),
        ),
      ),
    );
  }
}
