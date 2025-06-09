import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef QRViewCreatedCallback = void Function(QRViewController);
typedef PermissionSetCallback = void Function(QRViewController, bool);

class NielScanner extends StatefulWidget {
  final GlobalKey qrKey;
  final QRViewCreatedCallback onQrScannerViewCreated;
  final EdgeInsetsGeometry overlayMargin;
  final CameraFacing cameraFacing;
  final PermissionSetCallback? onPermissionSet;
  final List<BarcodeFormat> formatsAllowed;
  final Gradient? effectGradient;
  final Color? effectColor;
  final Color qrOverlayBorderColor;
  final double qrOverlayBorderRadius;
  final double qrOverlayBorderLength;
  final double qrOverlayBorderWidth;
  final double? cutOutSize;
  final double? cutOutWidth;
  final double? cutOutHeight;
  final double cutOutBottomOffset;
  final double effectWidth;
  final bool isScanComplete;

  const NielScanner(
      {required this.qrKey,
      required this.onQrScannerViewCreated,
      this.overlayMargin = EdgeInsets.zero,
      this.cameraFacing = CameraFacing.back,
      this.onPermissionSet,
      this.formatsAllowed = const <BarcodeFormat>[],
      required this.qrOverlayBorderColor,
      this.qrOverlayBorderRadius = 20,
      this.qrOverlayBorderWidth = 8,
      this.qrOverlayBorderLength = 40,
      this.cutOutSize,
      this.cutOutHeight,
      this.cutOutWidth,
      this.cutOutBottomOffset = 0,
      this.effectGradient,
      this.effectWidth = 250,
      this.isScanComplete = false,
      this.effectColor,
      super.key});

  @override
  State<NielScanner> createState() => _NielScannerState();
}

class _NielScannerState extends State<NielScanner>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -50),
      end: const Offset(0, 50),
    ).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        QRView(
          key: widget.qrKey,
          onQRViewCreated: widget.onQrScannerViewCreated,
          cameraFacing: widget.cameraFacing,
          overlay: QrScannerOverlayShape(
            borderColor: widget.qrOverlayBorderColor,
            borderRadius: widget.qrOverlayBorderRadius,
            borderLength: widget.qrOverlayBorderLength,
            borderWidth: widget.qrOverlayBorderWidth,
            cutOutSize: widget.cutOutSize,
            cutOutWidth: widget.cutOutWidth,
            cutOutHeight: widget.cutOutHeight,
            cutOutBottomOffset: widget.cutOutBottomOffset,
          ),
          onPermissionSet: widget.onPermissionSet,
          formatsAllowed: widget.formatsAllowed,
        ),
        widget.isScanComplete
            ? Align(
                alignment: Alignment.center,
                child: Container(),
              )
            : Align(
                alignment: Alignment.center,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: Container(
                    height: 2,
                    width: widget.effectWidth,
                    decoration: BoxDecoration(
                      color: widget.effectColor,
                      gradient: widget.effectGradient,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
