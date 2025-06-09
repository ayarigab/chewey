import 'package:decapitalgrille/utils/common_services.dart';

class DetailPage1 extends StatefulWidget {
  final String title;
  final String author;
  final String image;
  final String content;
  final List<String>? category;
  final String time;

  const DetailPage1({
    super.key,
    required this.title,
    required this.author,
    required this.image,
    required this.content,
    required this.time,
    this.category,
  });
  @override
  // ignore: library_private_types_in_public_api
  _DetailPage1State createState() => _DetailPage1State();
}

class _DetailPage1State extends State<DetailPage1> {
  var isPressed = true;
  String formatList(List<String> items) {
    return items.join(', ');
  }

  Widget mainImageWidget(height) => Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Container(
              height: height / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        FluentIcons.arrow_left_32_filled,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: isPressed
                          ? const Icon(FluentIcons.bookmark_32_regular,
                              color: Colors.white, size: 28)
                          : const Icon(FluentIcons.bookmark_32_filled,
                              color: Colors.white, size: 28),
                      onPressed: () {
                        setState(() {
                          isPressed = !isPressed;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: height / 3,
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
      );

  Widget bottomContent(height, width) => Container(
        margin: const EdgeInsets.only(top: 12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title
              Text(
                widget.title,
                style: const TextStyle(
                  height: 1.1,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              Row(
                children: [
                  const Icon(FluentIcons.clock_20_regular, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    widget.time,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 20),
                  const Icon(FluentIcons.person_circle_20_regular, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    widget.author,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                Core.removeHtmlTags(widget.content),
                style: const TextStyle(
                  fontSize: 16.5,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
              if (widget.category != null) const SizedBox(height: 20),
              if (widget.category != null)
                Text(
                  formatList(widget.category!),
                  style: const TextStyle(
                    fontSize: 16.5,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black12,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: mainImageWidget(height),
          ),
          Positioned.fill(
            top: height / 5.5,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: height / 2.6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: bottomContent(height, width),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
