import 'package:decapitalgrille/utils/common_services.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    this.productPermalink,
    this.productName,
  });

  final String? productPermalink;
  final String? productName;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late bool localLiked;
  late int localLikes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Core.snackThis(
                  context: context,
                  'Comments not available yet.',
                  type: 'alert');
            },
            child: const Icon(FluentIcons.chat_sparkle_20_filled,
                size: 25.0, color: Colors.white),
          ),
          const Text(
            '1.8K',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
