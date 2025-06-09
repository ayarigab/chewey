import 'package:decapitalgrille/page/video_shop/widgets/buy_widget.dart';
import 'package:decapitalgrille/page/video_shop/widgets/comment_widget.dart';
import 'package:decapitalgrille/page/video_shop/widgets/like_widget.dart';
import 'package:decapitalgrille/page/video_shop/widgets/share_widget.dart';
import 'package:decapitalgrille/utils/common_services.dart';
import 'package:video_shop_flutter/page/page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoShop extends StatefulWidget {
  const VideoShop({super.key});

  @override
  State<VideoShop> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VideoShop> {
  List<Map<String, dynamic>> data = [];
  List<String> videoWatched = [];

  Future<void> fetchPlaylist() async {
    final response = await http.get(Uri.parse(
        "https://decapitalgrille.com/wp-content/uploads/do_not_delete_video_shop_data.json"));
    if (response.statusCode == 200) {
      final List<dynamic> playlistData = json.decode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(playlistData);
      });
    } else {
      // Handle error
    }
  }

  @override
  void initState() {
    fetchPlaylist();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    final response = await http.get(Uri.parse(
        "https://decapitalgrille.com/wp-content/uploads/do_not_delete_video_shop_data.json"));
    if (response.statusCode == 200) {
      final List<dynamic> playlistData = json.decode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(playlistData);
      });
    } else {
      // Handle error
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Core.backBut(context),
        title: const Text('DHR Video Shop'),
      ),
      body: VideoShopFlutter(
        updateLastSeenPage: (lastSeenPageIndex) {},
        listData: data,
        videoWatched: videoWatched,
        pageSize: 4,
        enableBackgroundContent: true,
        loadMore: (page, pageSize) async {
          List<Map<String, dynamic>> newData = data;
          if (newData.isNotEmpty) {
            setState(() {
              data = [...data, ...newData];
            });
          }
          //.
        },
        likeWidget: (video, updateData) {
          return LikeWidget(
            likes: video?.likes ?? 0,
            liked: video?.liked ?? false,
            updateData: updateData,
            id: video?.id,
          );
        },
        buyWidget: (video) {
          return BuyWidget(
            productPermalink: video!.productPermalink,
          );
        },
        shareWidget: (video) {
          return ShareWidget(
            productName: video!.productName,
            productPermalink: video.productPermalink,
          );
        },
        commentWidget: (video) {
          return const CommentWidget();
        },
      ),
    );
  }
}
