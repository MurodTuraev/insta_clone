import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreService{
  static final _storage = FirebaseStorage.instance.ref();
  static final folder = 'post_images';

  static Future<String> uploadImage(File _image) async{
    String img_name = "image_"+DateTime.now().toString();
    var firebaseStorageRef = _storage.child(folder).child(img_name);
    var uploadTask = firebaseStorageRef.putFile(_image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    String downloadUrl = await firebaseStorageRef.getDownloadURL();
    print("img url $downloadUrl");
    return downloadUrl;
  }
}