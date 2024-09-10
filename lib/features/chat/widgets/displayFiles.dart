import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/features/chat/widgets/videoPlayer.dart';

class DisplayFile extends StatelessWidget {
  final String message;
  final MessageTypeEnum typeEnum;
  const DisplayFile({super.key, required this.message, required this.typeEnum});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return typeEnum == MessageTypeEnum.text
        ? Text(
            message,
            style: TextStyle(fontSize: 16),
          )
        : typeEnum == MessageTypeEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
              audioPlayer.onPlayerComplete.listen((event) {
                  setState(() {
                    isPlaying = false;
                  });
                });
                return IconButton(
                    constraints: BoxConstraints(minWidth: 100),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle));
              })
            : typeEnum == MessageTypeEnum.gif
                ? CachedNetworkImage(imageUrl: message)
                : typeEnum == MessageTypeEnum.video
                    ? VideoPlayer(videoURL: message)
                    : CachedNetworkImage(imageUrl: message);
  }
}
