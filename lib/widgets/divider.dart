import 'package:flutter/material.dart';

class NielDivider extends StatelessWidget {
  final String? text;
  final double thickness;
  final Color? lineColor;
  final Color? textColor;
  final bool fadeEnds;
  final bool noText;
  final double linePadding;

  const NielDivider({
    super.key,
    this.text,
    this.thickness = 1.0,
    this.lineColor,
    this.textColor,
    this.fadeEnds = false,
    this.noText = false,
    this.linePadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color effectiveLineColor = lineColor ?? theme.dividerColor;
    final Color effectiveTextColor =
        textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.grey;

    return Row(
      children: <Widget>[
        // Left line
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: linePadding),
            height: thickness,
            decoration: BoxDecoration(
              gradient: fadeEnds
                  ? LinearGradient(
                      colors: [
                        effectiveLineColor.withValues(alpha: 0),
                        effectiveLineColor,
                      ],
                    )
                  : null,
              color: fadeEnds ? null : effectiveLineColor,
            ),
          ),
        ),

        // Text in the middle
        if (!noText && text != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(
              text!,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
                color: effectiveTextColor,
              ),
            ),
          ),

        // Right line
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: linePadding),
            height: thickness,
            decoration: BoxDecoration(
              gradient: fadeEnds
                  ? LinearGradient(
                      colors: [
                        effectiveLineColor,
                        effectiveLineColor.withValues(alpha: 0),
                      ],
                    )
                  : null,
              color: fadeEnds ? null : effectiveLineColor,
            ),
          ),
        ),
      ],
    );
  }
}
