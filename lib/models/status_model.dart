

class Status {
  final String Uid;
  final String Username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusID;
  final List<String> whoCanSee;

  Status(
      {required this.Uid,
      required this.Username,
      required this.phoneNumber,
      required this.photoUrl,
      required this.createdAt,
      required this.profilePic,
      required this.statusID,
      required this.whoCanSee});

  Map<String, dynamic> toMap() {
   
    return {
      'Uid':Uid,
      'Username':Username,
      'phoneNumber':phoneNumber,
      'photoUrl':photoUrl,
      'createdAt':createdAt,
      'profilePic':profilePic,
      'statusID':statusID,
      'whoCanSee':whoCanSee
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
     return Status(
      Uid: map['uid'] ?? '',
      Username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
      statusID: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }

  
}
