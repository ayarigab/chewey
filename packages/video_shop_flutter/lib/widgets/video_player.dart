import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerApp extends StatefulWidget {
  /// Create video player.
  const VideoPlayerApp({super.key, required this.controller});
  final VideoPlayerController controller;
  @override
  State<VideoPlayerApp> createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  bool _showPause = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.value.isPlaying) {
        if (_showPause) {
          if (mounted) {
            setState(() {
              _showPause = false;
            });
          }
        }
      } else {
        if (!_showPause) {
          if (mounted) {
            setState(() {
              _showPause = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenRatio = MediaQuery.of(context).size.aspectRatio;
    return GestureDetector(
      onTap: () {
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
          setState(() {
            _showPause = true;
          });
        } else {
          widget.controller.play();
          setState(() {
            _showPause = false;
          });
        }
      },
      child: (widget.controller.value.aspectRatio < screenRatio)
          ? AbsorbPointer(
              child: Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: widget.controller.value.size.width,
                      height: widget.controller.value.size.height,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                ),
                if (_showPause) const PauseIcon(),
              ],
            ))
          : AbsorbPointer(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(widget.controller),
                    if (_showPause) const PauseIcon(),
                  ],
                ),
              ),
            ),
    );
  }
}

class PauseIcon extends StatelessWidget {
  /// Create pause icon.
  const PauseIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Icon(Icons.pause_circle_outline_outlined,
              color: Colors.white.withOpacity(0.5), size: 60),
        ),
      ),
    );
  }
}
