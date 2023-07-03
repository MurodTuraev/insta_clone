import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../models/post.dart';

class RtdbService{
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Post post) async{
    _database.child("insta_clone").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPost() async{
    List<Post> item = [];
    Query _query = _database.ref.child("insta_clone");
    DatabaseEvent event = await _query.once();
    var snapshop = event.snapshot;

    for (var child in snapshop.children){
      var jsonPost = jsonEncode(child.value);
      Map<String, dynamic> map = jsonDecode(jsonPost);
      var post = Post(map['img_post'], map['caption']);
      item.add(post);
    }
    return item;
  }

}