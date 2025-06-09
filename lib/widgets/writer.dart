import 'package:flutter/material.dart';

class NielText extends StatelessWidget {
  const NielText({
    super.key,
    required this.id,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.textAlign = TextAlign.start,
    this.textDecoration = TextDecoration.none,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.lineHeight,
    this.letterSpacing,
    this.isClickable = false,
    this.onTap,
  });

  final String id;
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int? maxLines;
  final TextOverflow overflow;
  final double? lineHeight;
  final double? letterSpacing;
  final bool isClickable; // Enables clickability
  final GestureTapCallback? onTap; // Action when clicked

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
        height: lineHeight,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    // Check if the text is clickable
    if (isClickable && onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: textWidget,
      );
    }

    return textWidget;
  }
}

// NielText(
//   id: 'clickableText',
//   text: 'Click me!',
//   color: Colors.blue,
//   fontSize: 16.0,
//   textDecoration: TextDecoration.underline, // Underlined text
//   isClickable: true, // Enables clickability
//   onTap: () {
//     // Action when clicked
//     print('Text clicked');
//   },
// )

// NielText(
//   id: 'italicText',
//   text: 'This is italic text.',
//   fontStyle: FontStyle.italic, // Italic text
// )

// NielText(
//   id: 'welcomeText',
//   text: 'Welcome to the app!',
//   color: Colors.blue,
//   fontSize: 18.0,
//   fontWeight: FontWeight.bold,
//   textAlign: TextAlign.center,
//   maxLines: 2,
//   overflow: TextOverflow.ellipsis,
// )
