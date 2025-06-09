import 'package:decapitalgrille/utils/niel_input_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
export 'package:decapitalgrille/utils/niel_input_model.dart';

class NielInput extends StatefulWidget {
  const NielInput({
    super.key,
    required this.id,
    this.controller,
    this.prefixIcon,
    this.postfixIcon,
    this.postfixIconButton,
    this.size = NielInputSize.MEDIUM,
    this.type = NielInputType.TEXT,
    this.hintText,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
    this.borderRadius = 12.0,
    this.onChanged,
    this.onTap,
    this.onIconPressed,
    this.validator,
    this.enabled = true,
    this.isSecured = false,
    this.autoValidation = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.isDense = true,
    this.keyboardType,
    this.textInputAction,
  });

  final String id;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? postfixIcon;
  final IconButton? postfixIconButton;
  final NielInputSize size;
  final NielInputType type;
  final String? hintText;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function()? onIconPressed;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool isSecured;
  final bool autoValidation;
  final int maxLines;
  final int minLines;
  final bool isDense;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  // ignore: library_private_types_in_public_api
  _NielInputState createState() => _NielInputState();
}

class _NielInputState extends State<NielInput> {
  bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    if (widget.type == NielInputType.PASSWORD) {
      _isPasswordHidden = widget.isSecured;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate input height based on size
    double inputHeight = widget.size == NielInputSize.LARGE
        ? 56
        : widget.size == NielInputSize.MEDIUM
            ? 48
            : 40;

    // Determine keyboardType based on input type
    TextInputType inputType = widget.keyboardType ??
        (widget.type == NielInputType.NUMBER
            ? TextInputType.number
            : widget.type == NielInputType.EMAIL
                ? TextInputType.emailAddress
                : widget.type == NielInputType.PASSWORD
                    ? TextInputType.visiblePassword
                    : TextInputType.text);

    String? emailValidator(String? value) {
      if (widget.type == NielInputType.EMAIL) {
        if (value == null ||
            !value.contains('@') ||
            !RegExp(r'\.[a-z]{2,}$').hasMatch(value)) {
          return 'Invalid email format';
        }
      }
      return widget.validator?.call(value);
    }

    return Container(
      height: inputHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.type == NielInputType.PASSWORD && _isPasswordHidden,
        enabled: widget.enabled,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.size == NielInputSize.LARGE
              ? 18
              : widget.size == NielInputSize.MEDIUM
                  ? 16
                  : 14,
        ),
        keyboardType: inputType,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        validator: widget.autoValidation ? emailValidator : null,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.postfixIconButton ??
              (widget.type == NielInputType.PASSWORD
                  ? IconButton(
                      icon: Icon(_isPasswordHidden
                          ? FluentIcons.eye_32_regular
                          : FluentIcons.eye_off_32_regular),
                      onPressed: _togglePasswordVisibility,
                    )
                  : widget.postfixIcon),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0.25,
            fontFamily: 'Roboto',
          ),
          border: InputBorder.none,
          isDense: widget.isDense,
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.size == NielInputSize.LARGE ? 16 : 12,
            horizontal: 16,
          ),
        ),
        onChanged: widget.onChanged,
        onTap: widget.onTap,
      ),
    );
  }
}
