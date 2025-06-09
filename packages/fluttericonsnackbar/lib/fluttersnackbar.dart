library fluttersnackbar;

import 'package:flutter/material.dart';
import 'package:icon_animated/icon_animated.dart';

enum SnackBarType {
  save,
  fail,
  alert,
}

/// snackbar style

class SnackBarStyle {
  final Color? backgroundColor;
  final Color iconColor;
  final TextStyle labelTextStyle;

  const SnackBarStyle(
      {this.backgroundColor,
      this.iconColor = Colors.white,
      this.labelTextStyle = const TextStyle()});
}

class IconSnackBar {
  /// Show snack bar
  ///
  /// [required]
  /// BuildContext
  /// label
  /// snackBarType
  ///
  /// [optional]
  /// Duration (animation)
  /// DismissDirection (swipe direction)
  /// SnackBarStyle

  static show({
    required BuildContext context,
    required String label,
    required SnackBarType snackBarType,
    Duration? duration,
    DismissDirection? direction,
    SnackBarStyle snackBarStyle = const SnackBarStyle(),
  }) {
    switch (snackBarType) {
      case SnackBarType.save:
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: duration ?? const Duration(seconds: 2),
          dismissDirection: direction ?? DismissDirection.down,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: SnackBarWidget(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            label: label,
            backgroundColor: snackBarStyle.backgroundColor ?? Colors.green,
            labelTextStyle: snackBarStyle.labelTextStyle,
            iconType: IconType.check,
          ),
        ));
      case SnackBarType.fail:
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: duration ?? const Duration(seconds: 2),
          dismissDirection: direction ?? DismissDirection.down,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: SnackBarWidget(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            label: label,
            backgroundColor: snackBarStyle.backgroundColor ?? Colors.red,
            labelTextStyle: snackBarStyle.labelTextStyle,
            iconType: IconType.fail,
          ),
        ));
      case SnackBarType.alert:
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: duration ?? const Duration(seconds: 2),
          dismissDirection: direction ?? DismissDirection.down,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: SnackBarWidget(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            label: label,
            backgroundColor: snackBarStyle.backgroundColor ?? Colors.black,
            labelTextStyle: snackBarStyle.labelTextStyle,
            iconType: IconType.alert,
          ),
        ));
    }
  }

  /// Show snack bar using Overlay
  ///
  /// This method ensures the Snackbar is displayed above any widget, including modals.
  static void showOverlay({
    required BuildContext context,
    required String label,
    required SnackBarType snackBarType,
    Duration? duration,
    SnackBarStyle snackBarStyle = const SnackBarStyle(),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top * 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: SnackBarWidget(
              onPressed: () {
                // overlayEntry.remove();
              },
              label: label,
              backgroundColor: _getSnackBarColor(snackBarType, snackBarStyle),
              labelTextStyle: snackBarStyle.labelTextStyle,
              iconType: _getIconType(snackBarType),
            ),
          ),
        );
      },
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    // Remove the overlay entry after the specified duration
    Future.delayed(duration ?? const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  /// Helper to get the background color based on type
  static Color _getSnackBarColor(SnackBarType type, SnackBarStyle style) {
    switch (type) {
      case SnackBarType.save:
        return style.backgroundColor ?? Colors.green;
      case SnackBarType.fail:
        return style.backgroundColor ?? Colors.red;
      case SnackBarType.alert:
        return style.backgroundColor ?? Colors.black;
    }
  }

  /// Helper to get the icon type
  static IconType _getIconType(SnackBarType type) {
    switch (type) {
      case SnackBarType.save:
        return IconType.check;
      case SnackBarType.fail:
        return IconType.fail;
      case SnackBarType.alert:
        return IconType.alert;
    }
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// If you click on the snack bar, the logic of the snack bar ends immediately.

class SnackBarWidget extends StatefulWidget implements SnackBarAction {
  const SnackBarWidget({
    Key? key,
    this.textColor,
    this.disabledTextColor,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.black,
    this.labelTextStyle,
    required this.iconType,
    this.disabledBackgroundColor = Colors.black,
  }) : super(key: key);

  @override
  final Color? textColor;

  @override
  final Color? disabledTextColor;

  @override
  final String label;

  @override
  final VoidCallback onPressed;

  @override
  final Color backgroundColor;

  @override
  final Color disabledBackgroundColor;

  final TextStyle? labelTextStyle;
  final IconType iconType;

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  var _fadeAnimationStart = false;
  var disposed = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!disposed) {
        setState(() {
          _fadeAnimationStart = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          color: widget.backgroundColor,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
          height: 50,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 40,
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          child: IconAnimated(
                            color: _fadeAnimationStart
                                ? Colors.white
                                : widget.backgroundColor,
                            active: true,
                            size: 40,
                            iconType: widget.iconType,
                          ),
                        )),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      margin:
                          EdgeInsets.only(left: _fadeAnimationStart ? 0 : 10),
                      duration: const Duration(milliseconds: 400),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: _fadeAnimationStart ? 1.0 : 0.0,
                        child: Text(widget.label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: widget.labelTextStyle ??
                                const TextStyle(
                                    fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
