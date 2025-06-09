import 'package:decapitalgrille/utils/common_services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class ErrorHandler {
  static Widget errorThis(
    String error, {
    String? image,
    String? retryText,
    IconData? retryIcon,
    int? errorCode,
    double? imageSize,
    VoidCallback? onRetry,
    bool enableLogging = false,
    BuildContext? context,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image ?? 'images/errors/search_empty_error.png',
            height: imageSize ?? 150,
            width: imageSize ?? 150,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(156, 255, 153, 127),
              ),
            ),
          ),
          if (errorCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Core.inform(
                  text: 'Error Code: $errorCode', color: Colors.grey.shade400),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onRetry != null)
                NielButton(
                  id: error,
                  onPressed: onRetry,
                  text: retryText ?? 'Retry Again',
                  borderRadius: 6,
                  background: const Color.fromARGB(165, 255, 17, 0),
                  size: NielButtonSize.S,
                  leftIcon: Icon(
                    retryIcon ?? FluentIcons.arrow_clockwise_20_regular,
                    color: Colors.white,
                  ),
                ),
              if (enableLogging) ...[
                const SizedBox(width: 10),
                NielButton(
                  id: error,
                  onPressed: () => _sendErrorLog(error, errorCode, context),
                  text: 'Send Error',
                  borderRadius: 6,
                  foregroundColor: const Color.fromARGB(165, 255, 17, 0),
                  defaultBorderColor: const Color.fromARGB(165, 255, 17, 0),
                  background: Colors.transparent,
                  type: NielButtonType.SECONDARY,
                  size: NielButtonSize.S,
                  leftIcon: Icon(
                    retryIcon ?? FluentIcons.send_20_regular,
                    color: const Color.fromARGB(165, 255, 17, 0),
                  ),
                ),
              ],
            ],
          ),
          // if (kDebugMode)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 20.0),
          //     child: Text(
          //       'Stack Trace:\n${StackTrace.fromString('stackTraceString')}',
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(color: Colors.grey),
          //     ),
          //   ),
        ],
      ),
    );
  }

  static Future<void> _sendErrorLog(
      String error, int? code, BuildContext? context) async {
    final deviceInfo = await _getDeviceInfo();
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'naabalogistics@gmail.com',
      query: {
        'subject': 'Error in De capital Hr Mobile app',
        'body': '''
        *****DONT DELETE THE TRACE BELOW*****
        Error Encountered: $error
        Error Code: $code
        Device Info: $deviceInfo
        Context: $context
        *****DONT DELETE THE TRACE ABOVE*****
        Write your additional message below (if any):
        '''
      }
          .entries
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
          .join('&'),
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('Unable to send email')),
      );
    }
  }

  static Future<String> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceData = 'Unknown';

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData =
          'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})\n'
          'Manufacturer: ${androidInfo.manufacturer}\n'
          'Model: ${androidInfo.model}';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = 'iOS ${iosInfo.systemVersion}\n'
          'Model: ${iosInfo.utsname.machine}';
    }

    return deviceData;
  }

  static void logError(String error, {int? errorCode, StackTrace? stackTrace}) {
    debugPrint('Error: $error');
    if (errorCode != null) {
      debugPrint('Error Code: $errorCode');
    }
    if (stackTrace != null) {
      debugPrint('Stack Trace: $stackTrace');
    }
  }
}
