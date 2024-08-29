import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String videoURL;
  const VideoPlayer({super.key, required this.videoURL});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController videoController;
  bool isPlay = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.videoURL)
      ..initialize().then((value) {
        videoController.setVolume(1);
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoController),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                  onPressed: () {
                    if (isPlay) {
                      videoController.pause();
                    } else {
                      videoController.play();
                    }
                    setState(() {
                      isPlay = !isPlay;
                    });
                  },
                  icon: Icon(isPlay ? Icons.pause_circle : Icons.play_circle)))
        ],
      ),
    );
  }
}
