import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/features/chat/widgets/displayFiles.dart';

class MyChatCard extends StatelessWidget {
  final message;
  final date;
  final MessageTypeEnum typeEnum;
  const MyChatCard(
      {super.key,
      required this.message,
      required this.date,
      required this.typeEnum});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: typeEnum == MessageTypeEnum.text
                    ? EdgeInsets.only(left: 10, right: 30, top: 5, bottom: 20)
                    : const EdgeInsets.only(left: 5,top: 5,right: 5,bottom: 25),
                child: DisplayFile(
                  message: message,
                  typeEnum: typeEnum,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child:Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      color: Colors.grey,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
