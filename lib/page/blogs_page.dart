import 'package:decapitalgrille/page/video_shop/main.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:decapitalgrille/page/blog/main_content.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Montserrat',
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.green)),
      home: const BlogPage(),
    ),
  );
}

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.transparent,
        onPressed: () => Navigator.of(context)
            .push(Core.smoothFadePageRoute(context, const VideoShop())),
        child: Visibility(
          visible: true,
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: AssetImage(
                    "images/app/video_store.jpg",
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              height: 80,
              width: 80,
            ),
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 30.0, left: 2.0, right: 2.0, bottom: 0),
        child: SingleChildScrollView(child: MainContent()),
      ),
    );
  }
}
