class ChatContact {
  final String name;
  final String profilePic;
  final String contactID;
  final DateTime TimeSent;
  final String lastMessage;

  ChatContact(
      {required this.name,
      required this.profilePic,
      required this.contactID,
      required this.TimeSent,
      required this.lastMessage});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'profilePic': profilePic});
    result.addAll({'contactID': contactID});
    result.addAll({'TimeSent': TimeSent.millisecondsSinceEpoch});
    result.addAll({'lastMessage': lastMessage});

    return result;
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactID: map['contactID'] ?? '',
      TimeSent: DateTime.fromMillisecondsSinceEpoch(map['TimeSent']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
