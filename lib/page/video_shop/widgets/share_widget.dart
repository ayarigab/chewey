import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatefulWidget {
  const ShareWidget({
    super.key,
    this.productPermalink,
    this.productName,
  });

  final String? productPermalink;
  final String? productName;

  @override
  State<ShareWidget> createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          // Share Button
          InkWell(
            onTap: () {
              Share.share(
                  'Hey, this Menu/Food: ${widget.productName} - "${widget.productPermalink}" is best served at De Capital HR. Check it out by visiting the link or downloading the De Capital HR app for your phone, place the order and it will be delivered to your location.',
                  subject:
                      "Check out: ${widget.productName} on De Capital HR - Goaso");
            },
            child: const Column(
              children: [
                Icon(Icons.reply, size: 25, color: Colors.white),
                Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
