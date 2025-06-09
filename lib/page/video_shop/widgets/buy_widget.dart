import 'package:decapitalgrille/utils/common_services.dart';

class BuyWidget extends StatefulWidget {
  const BuyWidget({
    super.key,
    this.productPermalink,
  });

  final String? productPermalink;

  @override
  State<BuyWidget> createState() => _BuyWidgetState();
}

class _BuyWidgetState extends State<BuyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buy Button
        InkWell(
          onTap: () async {
            final url = widget.productPermalink;
            if (await canLaunchUrl(Uri.parse(url!))) {
              await launchUrl(Uri.parse(url));
            } else {
              if (context.mounted) {
                Core.snackThis(
                  context: context,
                  'Could not launch the product link.',
                );
              }
            }
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Icon(FluentIcons.shopping_bag_play_20_filled,
                    size: 25, color: Colors.white),
                Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
