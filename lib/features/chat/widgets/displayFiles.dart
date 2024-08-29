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
    return typeEnum == MessageTypeEnum.text
        ? Text(
            message,
            style: TextStyle(fontSize: 16),
          )
        : typeEnum == MessageTypeEnum.gif
            ? CachedNetworkImage(imageUrl: message)
            : typeEnum == MessageTypeEnum.video
                ? VideoPlayer(videoURL: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
