import 'dart:io';
import 'package:decapitalgrille/page/qr_scanner/niel_scanner.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(const MaterialApp(home: ScannerPage()));

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isPermissionGranted = false;
  String? _lastScannedData;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Scan QR Code'),
      ),
      body: _buildScannerView(context),
    );
  }

  Widget _buildScannerView(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildQrView(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (result != null)
                  Text(
                    'Data: ${result!.code}',
                    style: const TextStyle(color: Colors.white),
                  )
                else
                  const Text(
                    'Point your camera at a QR code to scan',
                    style: TextStyle(color: Colors.white),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NielButton(
                      id: 'toggle_flash',
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      leftIcon: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          return Icon(
                            snapshot.data == true
                                ? FluentIcons.lightbulb_filament_24_filled
                                : FluentIcons.lightbulb_24_regular,
                            color: snapshot.data == true
                                ? Colors.yellow
                                : Colors.white,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    NielButton(
                      id: 'switch_camera',
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      leftIcon: const Icon(
                        FluentIcons.camera_switch_24_filled,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    return NielScanner(
      qrKey: qrKey,
      onQrScannerViewCreated: _onQRViewCreated,
      qrOverlayBorderColor: Colors.redAccent,
      cutOutSize: (MediaQuery.of(context).size.width < 300 ||
              MediaQuery.of(context).size.height < 400)
          ? 250.0
          : 300.0,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      effectColor: Colors.red,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _handleQRResult(result!.code);
      });
    });
  }

  void _handleQRResult(String? code) {
    if (code == null || !_isValidLink(code)) {
      _showSnackIfNew("Invalid Code. Only  De Capital's supported.");
      return;
    }

    if (code.contains('https://decapitalgrille.com')) {
      _lastScannedData = code;
      _launchURL(code);
    } else {
      _showSnackIfNew("Sorry, only De Capital Codes are supported.");
    }
  }

  bool _isValidLink(String code) {
    final uri = Uri.tryParse(code);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _showSnackIfNew(String message) {
    if (_lastScannedData != result?.code) {
      Core.snackThis(message, context: context, type: 'alert');
      _lastScannedData = result?.code;
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    setState(() {
      isPermissionGranted = p;
    });
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera Permission Denied')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
