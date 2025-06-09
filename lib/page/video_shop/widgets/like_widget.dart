import 'package:decapitalgrille/utils/common_services.dart';

class LikeWidget extends StatefulWidget {
  const LikeWidget(
      {super.key,
      required this.liked,
      required this.likes,
      required this.updateData,
      required this.id});
  final bool liked;
  final int likes;
  final int? id;
  final Function(int likes, bool liked) updateData;
  @override
  State<LikeWidget> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  late bool localLiked;
  late int localLikes;

  @override
  void initState() {
    super.initState();
    localLiked = widget.liked;
    localLikes = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                if (localLiked) {
                  setState(() {
                    localLikes -= 1;
                    localLiked = false;
                    widget.updateData(localLikes, localLiked);
                  });
                } else {
                  setState(() {
                    localLikes += 1;
                    localLiked = true;
                    widget.updateData(localLikes, localLiked);
                  });
                }
              },
              child: Icon(FluentIcons.heart_20_filled,
                  size: 25.0, color: (localLiked) ? Colors.red : Colors.white),
            ),
            Text(
              localLikes.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
