import 'dart:convert';

class Group {
  final String SenderID;
  final String name;
  final String GrpID;
  final String lastMessage;
  final String GroupPic;
  final List<String> membersUID;
  final DateTime timeSent;

  Group(
      {required this.SenderID,
      required this.name,
      required this.GrpID,
      required this.lastMessage,
      required this.GroupPic,
      required this.membersUID,
      required this.timeSent});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'SenderID': SenderID});
    result.addAll({'name': name});
    result.addAll({'GrpID': GrpID});
    result.addAll({'lastMessage': lastMessage});
    result.addAll({'GroupPic': GroupPic});
    result.addAll({'membersUID': membersUID});
    result.addAll({'timeSent': timeSent});

    return result;
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      SenderID: map['SenderID'] ?? '',
      name: map['name'] ?? '',
      GrpID: map['GrpID'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      GroupPic: map['GroupPic'] ?? '',
      membersUID: List<String>.from(map['membersUID']),
      timeSent: map['timeSent'],
    );
  }
}
