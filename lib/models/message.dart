

import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';

class Message {
  final String senderID;
  final String receiverID;
  final String text;
  final MessageTypeEnum type;
  final DateTime timeSent;
  final String messageID;
  final bool isSeen;

  Message(
      {required this.senderID,
      required this.receiverID,
      required this.text,
      required this.type,
      required this.timeSent,
      required this.messageID,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'senderID': senderID});
    result.addAll({'receiverID': receiverID});
    result.addAll({'text': text});
    result.addAll({'type': type.type});
    result.addAll({'timeSent': timeSent.millisecondsSinceEpoch});
    result.addAll({'messageID': messageID});
    result.addAll({'isSeen': isSeen});
  
    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderID:map['senderID']??'',
      receiverID:map['receiverID'] ?? '',
      text:map['text'] ?? '',
      type:(map['type'] as String).toEnum(),
      timeSent:DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageID:map['messageID'] ?? '',
      isSeen:map['isSeen'] ?? false,
    );
  }
}
