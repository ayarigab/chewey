import 'package:decapitalgrille/page/notifications/stories.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/utils/error_handler.dart';
import 'package:story_view/controller/story_controller.dart';
import 'detail_page1.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchBlogPosts() async {
  final Uri url = Uri.parse('https://decapitalgrille.com/wp-json/wp/v2/posts');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> json = jsonDecode(response.body);

    final List<Map<String, dynamic>> blogPosts =
        json.map<Map<String, dynamic>>((post) {
      return {
        'id': post['id'],
        'title': post['title']['rendered'],
        'content': post['content']['rendered'],
        'author': post['author'],
        'tag': post['tag'],
        'category': post['category'],
        'modified_gmt': post['modified_gmt'],
        'jetpack_featured_media_url': post['jetpack_featured_media_url'],
      };
    }).toList();

    return blogPosts;
  } else {
    throw Exception('Failed to fetch blog posts');
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final StoryController controller = StoryController();
  Widget getHead() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Core.head(head: 'Decapital HR\'s Blog'),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    Core.smoothFadePageRoute(
                      context,
                      const MoreStories(),
                    ),
                  );
                },
                hoverColor: Colors.green,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(12, 12)),
                    image: DecorationImage(
                      image: AssetImage("images/app/stories.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Core.title(title: 'Featured blogs'),
          ),
        ],
      );

  Widget getListItem(String coverImage, String title, String author,
          String time, String authorImage) =>
      Container(
        margin: const EdgeInsets.only(right: 10),
        height: 100,
        width: 230,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          image: DecorationImage(
              image: NetworkImage(coverImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(
                        FluentIcons.bookmark_20_regular,
                        color: Colors.white,
                        size: 22,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 1, bottom: 10),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 8.0,
                          color: Color.fromARGB(204, 0, 0, 0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 10),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.elliptical(12, 12)),
                          image: DecorationImage(
                            image: AssetImage(authorImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 8.0,
                            color: Color.fromARGB(204, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          FluentIcons.clock_20_regular,
                          size: 16,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                            shadows: const [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 8.0,
                                color: Color.fromARGB(204, 0, 0, 0),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );

  Widget popularWidget(String title, String subtitle, String time, String like,
          String image) =>
      Row(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              height: 95,
              width: 90,
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(12, 12)),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 12),
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[100],
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 4)),
                    Icon(
                      Icons.thumb_up,
                      size: 14,
                      color: Colors.grey[100],
                    ),
                    const Padding(padding: EdgeInsets.only(left: 4)),
                    Text(
                      like,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 30,
          ),
          getHead(),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('images/blog/hotel.jpg'),
                  fit: BoxFit.cover),
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(186, 2, 27, 51),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'images/degrille/icon/logo.png',
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    // Use Expanded to make Column take available space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hotel Bookings Coming Soon',
                          style: TextStyle(
                            color: Colors.amber[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontVariations: const [
                              FontVariation('wght', 900),
                            ],
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 5), // Add spacing between texts
                        Expanded(
                          // Add Expanded to the Text to allow wrapping
                          child: Text(
                            "Coming up there will be integrations that will allow users to book hotel rooms right from this app.",
                            style: TextStyle(
                              color: Colors.amber[50],
                              height: 1.3,
                            ),
                            // maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchBlogPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Core.loadThis(context);
              } else if (snapshot.hasError) {
                return ErrorHandler.errorThis('Error Fetching Blogs');
              } else if (!snapshot.hasData) {
                return ErrorHandler.errorThis('No Blogs found. Try again');
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final blogPosts = snapshot.data!;

                return SizedBox(
                  width: 350,
                  height: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blogPosts.length,
                      itemBuilder: (context, index) {
                        final post = blogPosts[index];
                        return InkWell(
                          hoverColor: Colors.white70,
                          enableFeedback: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              Core.smoothFadePageRoute(
                                context,
                                DetailPage1(
                                  title: post['title'],
                                  author: 'Author\'s Name',
                                  image: post['jetpack_featured_media_url'],
                                  content: post['content'],
                                  category: post['category'],
                                  time: post['modified_gmt'],
                                ),
                              ),
                            );
                          },
                          child: getListItem(
                            post['jetpack_featured_media_url'] ??
                                "images/account/user.png",
                            post['title'],
                            'Author\'s Name',
                            post['modified_gmt'],
                            "images/account/user.png",
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const Text('No blog posts found.');
              }
            },
          ),
        ],
      ),
    );
  }
}
