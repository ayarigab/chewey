// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:decapitalgrille/theme/color_schemes.dart';
import 'package:decapitalgrille/theme/typography.dart';
import 'package:decapitalgrille/utils/niel_button_model.dart';
export 'package:decapitalgrille/utils/niel_button_model.dart';
import 'package:niel_spins/niel_spins.dart';

class NielButton extends StatefulWidget {
  const NielButton({
    super.key,
    required this.id,
    this.text,
    required this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.size = NielButtonSize.M,
    this.state = NielButtonState.DEFAULT,
    this.type = NielButtonType.PRIMARY,
    this.background = NielCol.darkMainCol,
    this.foregroundColor = NielCol.white,
    this.defaultBorderColor = NielCol.dim,
    this.autoResize = true,
    this.borderLineWidth = 1,
    this.removePaddings = false,
    this.horizontalAlignment = MainAxisAlignment.center,
    this.isLoading = false,
    this.loadingDuration = const Duration(seconds: 0),
    this.triggerLoadingOnPress = false,
    this.borderRadius,
    this.gradient,
    this.gradientDirection = GradientDirection.horizontal,
    this.elevation = 0.0, // Default elevation
    this.shadowColor = Colors.black, // Default shadow color
    this.shadowSpread = 1.0, // Default shadow spread
  });

  final String id;
  final String? text;
  final GestureTapCallback onPressed;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final NielButtonSize size;
  final NielButtonState state;
  final NielButtonType type;
  final Color background;
  final Color foregroundColor;
  final Color defaultBorderColor;
  final bool autoResize;
  final double borderLineWidth;
  final bool removePaddings;
  final MainAxisAlignment horizontalAlignment;
  final bool isLoading;
  final Duration loadingDuration;
  final bool triggerLoadingOnPress;
  final double? borderRadius;
  final List<Color>? gradient;
  final GradientDirection gradientDirection;
  final double elevation; // Shadow elevation
  final Color shadowColor; // Shadow color
  final double shadowSpread; // Shadow spread

  @override
  _NielButtonState createState() => _NielButtonState();
}

class _NielButtonState extends State<NielButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) {
      _startLoading();
    }
  }

  @override
  void didUpdateWidget(NielButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_isLoading) {
      _startLoading();
    } else if (!widget.isLoading && _isLoading) {
      _stopLoading();
    }
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(widget.loadingDuration, () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  void _handlePress() {
    if (widget.triggerLoadingOnPress) {
      _startLoading();
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (widget.leftIcon != null) {
      children.add(Padding(
        padding: EdgeInsets.only(
          right: widget.removePaddings
              ? 0
              : widget.text != null
                  ? _getIconPadding()
                  : widget.rightIcon != null
                      ? (widget.size == NielButtonSize.XS ? 5 : 10)
                      : 0,
        ),
        child: widget.leftIcon!,
      ));
    }

    if (widget.text != null) {
      children.add(Text(
        widget.text!,
        style: _getTextStyle().apply(color: widget.foregroundColor),
      ));
    }

    if (widget.rightIcon != null) {
      children.add(Padding(
        padding: EdgeInsets.only(
          left: widget.removePaddings
              ? 0
              : widget.text != null
                  ? _getIconPadding()
                  : widget.leftIcon != null
                      ? (widget.size == NielButtonSize.XS ? 5 : 10)
                      : 0,
        ),
        child: widget.rightIcon!,
      ));
    }

    double borderRadius =
        widget.borderRadius ?? (widget.size == NielButtonSize.XS ? 12 : 16);

    // Determine gradient direction
    Alignment beginAlignment;
    Alignment endAlignment;
    switch (widget.gradientDirection) {
      case GradientDirection.vertical:
        beginAlignment = Alignment.topCenter;
        endAlignment = Alignment.bottomCenter;
        break;
      case GradientDirection.diagonal:
        beginAlignment = Alignment.topLeft;
        endAlignment = Alignment.bottomRight;
        break;
      case GradientDirection.horizontal:
        // default:
        beginAlignment = Alignment.centerLeft;
        endAlignment = Alignment.centerRight;
        break;
    }

    return Opacity(
      opacity: widget.state == NielButtonState.DISABLED ? 0.48 : 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RawMaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            fillColor: widget.background,
            constraints: const BoxConstraints(),
            onPressed:
                widget.state == NielButtonState.DISABLED ? null : _handlePress,
            shape: RoundedRectangleBorder(
                side: widget.type == NielButtonType.PRIMARY
                    ? BorderSide.none
                    : BorderSide(
                        color: widget.defaultBorderColor,
                        width: widget.borderLineWidth),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            child: Container(
              decoration: BoxDecoration(
                color: widget.gradient == null ? widget.background : null,
                gradient: widget.gradient != null
                    ? LinearGradient(
                        colors: widget.gradient!,
                        begin: beginAlignment,
                        end: endAlignment,
                      )
                    : null,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: widget.elevation > 0
                    ? [
                        BoxShadow(
                          color: widget.shadowColor.withValues(alpha: 0.5),
                          spreadRadius: widget.shadowSpread,
                          blurRadius: widget.elevation,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              padding: EdgeInsets.fromLTRB(
                widget.removePaddings
                    ? 0
                    : (widget.leftIcon != null
                        ? (widget.size == NielButtonSize.XL
                            ? 28 // Adjust padding for XL size
                            : widget.size == NielButtonSize.L
                                ? 24
                                : widget.size == NielButtonSize.M
                                    ? 16
                                    : widget.size == NielButtonSize.S
                                        ? 8
                                        : 4) // Adjust padding for XS size
                        : (widget.size == NielButtonSize.XL
                            ? 28
                            : widget.size == NielButtonSize.L
                                ? 24
                                : (widget.size == NielButtonSize.S &&
                                        widget.text == null
                                    ? 8
                                    : widget.size == NielButtonSize.XS
                                        ? 4 // Padding for XS without leftIcon
                                        : 16))),
                widget.removePaddings
                    ? 0
                    : (widget.size == NielButtonSize.XS
                        ? 2 // Padding for XS top
                        : widget.size == NielButtonSize.S
                            ? 8
                            : widget.size == NielButtonSize.XL
                                ? 20 // Padding for XL top
                                : 16),
                widget.removePaddings
                    ? 0
                    : (widget.rightIcon != null
                        ? (widget.size == NielButtonSize.XL
                            ? 28 // Padding for XL rightIcon
                            : widget.size == NielButtonSize.L
                                ? 24
                                : widget.size == NielButtonSize.M
                                    ? 16
                                    : widget.size == NielButtonSize.S
                                        ? 8
                                        : 4) // Padding for XS rightIcon
                        : (widget.size == NielButtonSize.XL
                            ? 28
                            : widget.size == NielButtonSize.L
                                ? 24
                                : (widget.size == NielButtonSize.S &&
                                        widget.text == null
                                    ? 4
                                    : widget.size == NielButtonSize.XS
                                        ? 6
                                        : 16))),
                widget.removePaddings
                    ? 0
                    : (widget.size == NielButtonSize.XS
                        ? 2
                        : widget.size == NielButtonSize.S
                            ? 8
                            : widget.size == NielButtonSize.XL
                                ? 20
                                : 16),
              ),
              child: Row(
                mainAxisSize:
                    widget.autoResize ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: widget.horizontalAlignment,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: NielCol.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Center(
                  child: NielSpinFadingCircle(
                    color: NielCol.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case NielButtonSize.XS:
        return NielText.buttonExtraSmall;
      case NielButtonSize.S:
        return NielText.buttonSmall;
      case NielButtonSize.M:
        return NielText.buttonMedium;
      case NielButtonSize.L:
        return NielText.buttonLarge;
      case NielButtonSize.XL:
        return NielText.buttonExtraLarge;
    }
  }

  // Helper to get padding for icons based on size
  double _getIconPadding() {
    switch (widget.size) {
      case NielButtonSize.XS:
        return 4;
      case NielButtonSize.S:
        return 9;
      case NielButtonSize.M:
        return 14;
      case NielButtonSize.L:
        return 18;
      case NielButtonSize.XL:
        return 22;
    }
  }
}

// NielButton(
//   id: 'forgot_password',
//   foregroundColor: NielCol.white,
//   background: Colors.transparent,
//   text: 'Forgot Password',
//   onPressed: () {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) => const ForgotPassword(),
//     ));
//   },
//   type: NielButtonType.PRIMARY,
//   size: NielButtonSize.LARGE,
//   borderRadius: 4,
//   gradient: const [
//     Color.fromARGB(255, 251, 231, 255), // #fbe7ff
//     Color.fromARGB(255, 249, 239, 233), // #f9efe9
//     Color.fromARGB(255, 229, 254, 242), // #e5fef2
//   ],
//   gradientDirection: GradientDirection.horizontal,
//   elevation: 10,
//   shadowColor: NielCol.grey,
//   shadowSpread: 1,
// ),
