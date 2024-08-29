import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebasestoragerepoProvider = Provider(
    (ref) => Firebasestoragerepo(firebaseStorage: FirebaseStorage.instance));

class Firebasestoragerepo {
  final FirebaseStorage firebaseStorage;

  Firebasestoragerepo({required this.firebaseStorage});

  Future<String> storeFiletoFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downLoadURL = await snap.ref.getDownloadURL();
    return downLoadURL;
  }
}
