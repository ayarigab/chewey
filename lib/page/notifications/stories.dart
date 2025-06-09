import 'dart:convert';
import 'package:decapitalgrille/main.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:story_view/story_view.dart';
import 'package:http/http.dart' as http;

class MoreStories extends StatefulWidget {
  const MoreStories({super.key});

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    loadStories();
  }

  Future<void> loadStories() async {
    const url =
        "https://decapitalgrille.com/wp-content/uploads/do_not_delete_stories_data.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          storyItems = data
              .map((item) {
                if (item['type'] == 'image') {
                  return StoryItem.pageImage(
                    url: item['url'],
                    caption: Text(item['caption'] ?? ''),
                    controller: storyController,
                    duration: Duration(seconds: item['duration'] ?? 5),
                  );
                } else if (item['type'] == 'video') {
                  return StoryItem.pageVideo(
                    item['url'],
                    caption: Text(item['caption'] ?? ''),
                    controller: storyController,
                  );
                } else {
                  return null;
                }
              })
              .whereType<StoryItem>()
              .toList();
        });
      } else {
        // throw Exception("Failed to load stories");
        Core.snackThis(
          'Failed to load stories. Try again later.',
          context: context,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
        myHomePageKey.currentState?.setIndex(2);
      }
    } catch (e) {
      setState(() {
        storyItems = [];
      });
      Core.snackThis(
        'Failed to load stories. Please try again later.',
        context: context,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      myHomePageKey.currentState?.setIndex(2);
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isNotEmpty
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: Core.backBut(context),
                  pinned: true,
                  snap: true,
                  floating: true,
                  expandedHeight: 60.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Status & Updates'),
                    background: Image.asset(
                      'images/app/veggies.jpg',
                      fit: BoxFit.cover,
                    ),
                    collapseMode: CollapseMode.pin,
                  ),
                ),
                SliverFillRemaining(
                  child: StoryView(
                    storyItems: storyItems,
                    onComplete: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      myHomePageKey.currentState?.setIndex(2);
                    },
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    controller: storyController,
                  ),
                ),
              ],
            )
          : Center(
              child: Core.loadThis(context, inform: 'Loading Stories...'),
            ),
    );
  }
}
