import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/features/chat/widgets/displayFiles.dart';

class senderChatCard extends StatelessWidget {
  final message;
  final date;
  final MessageTypeEnum typeEnum;
  final VoidCallback onRightswipe;
  final String repliedText;
  final String username;
  final MessageTypeEnum repliedMessageType;
  const senderChatCard(
      {super.key,
      required this.message,
      required this.date,
      required this.typeEnum,
      required this.onRightswipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType});

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: (details) {
        onRightswipe();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: senderMessageColor,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: typeEnum == MessageTypeEnum.text
                      ? EdgeInsets.only(left: 10, right: 30, top: 5, bottom: 20)
                      : const EdgeInsets.only(
                          left: 5, top: 5, right: 5, bottom: 25),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: DisplayFile(
                            message: repliedText,
                            typeEnum: repliedMessageType,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                      DisplayFile(
                        message: message,
                        typeEnum: typeEnum,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 13, color: Colors.white60),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // Icon(
                      //   Icons.done_all,
                      //   color: Colors.grey,
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
