import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/services/auth_service.dart';

class FileService{
  static final _storage = FirebaseStorage.instance.ref();
  static final foldr_user = "user_images";

  static Future<String> uploadUserImage(File _image) async{
    String uid = AuthService.currentUserId();
    String img_name = uid;
    var firebaseStorageRef = _storage.child(foldr_user).child(img_name);
    var uploadTask = firebaseStorageRef.putFile(_image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    final String downloadUrl = await firebaseStorageRef.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}