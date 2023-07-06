import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/models/member_model.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/utils_service.dart';

class DBService {
  static final _firestore = FirebaseFirestore.instance;
  static String folder_user = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";

  static String folder_followers = "followers";
  static String folder_followings = "followings";

  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();
    Map<String, String> params = await Utils.deviceParams();
    print(params);

    member.device_id = params["device_id"]!;
    member.device_type = params["device_type"]!;
    member.device_token = params["device_token"]!;

    return _firestore
        .collection(folder_user)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = AuthService.currentUserId();
    var value = await _firestore.collection(folder_user).doc(uid).get();
    Member member = Member.frromJson(value.data()!);
    var querySnapshot1 = await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_followers)
        .get();
    member.followers_count = querySnapshot1.docs.length;

    var querySnapshot2 = await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_followings)
        .get();
    member.following_count = querySnapshot2.docs.length;
    return member;
  }

  static Future updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    return _firestore.collection(folder_user).doc(uid).update(member.toJson());
  }

  static Future<List<Member>> searchMember(String keyword) async {
    List<Member> members = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await _firestore
        .collection(folder_user)
        .orderBy("email")
        .startAt([keyword]).get();
    print(querySnapshot.docs.length);

    querySnapshot.docs.forEach((result) {
      Member newMember = Member.frromJson(result.data());
      if (newMember.uid != uid) {
        members.add(newMember);
      }
    });

    return members;
  }

  // Post

  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = _firestore
        .collection(folder_user)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;
    await _firestore
        .collection(folder_user)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = AuthService.currentUserId();
    await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_posts)
        .get();

    querySnapshot.docs.forEach((element) {
      posts.add(Post.fromJson(element.data()));
    });
    return posts;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .get();

    querySnapshot.docs.forEach((element) {
      posts.add(Post.fromJson(element.data()));
    });
    return posts;
  }

  static Future likePost(Post post, bool liked) async {
    String uid = AuthService.currentUserId();
    post.liked = liked;
    await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_posts)
        .doc(post.id)
        .set(post.toJson());
    await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> getLikedPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .where("liked", isEqualTo: true)
        .get();

    querySnapshot.docs.forEach((element) {
      Post post = Post.fromJson(element.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    });
    return posts;
  }

  static Future<Member> followMember(Member member) async {
    Member me = await loadMember();

    //I follow to someone
    await _firestore
        .collection(folder_user)
        .doc(me.uid)
        .collection(folder_followings)
        .doc(member.uid)
        .set(member.toJson());

    //i am in someone`s followers
    await _firestore
        .collection(folder_user)
        .doc(member.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .set(me.toJson());

    return member;
  }

  static Future<Member> unFollowMember(Member member) async {
    Member me = await loadMember();

    //I un followed to someone
    await _firestore
        .collection(folder_user)
        .doc(me.uid)
        .collection(folder_followings)
        .doc(member.uid)
        .delete();

    //i am not in someone`s followers
    await _firestore
        .collection(folder_user)
        .doc(member.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .delete();

    return member;
  }

  static Future storePostsToMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await _firestore
        .collection(folder_user)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    querySnapshot.docs.forEach((element) {
      var post = Post.fromJson(element.data());
      post.liked = false;
      posts.add(post);
    });

    for (Post post in posts) {
      storeFeed(post);
    }
  }

  static Future removePostsToMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await _firestore
        .collection(folder_user)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    querySnapshot.docs.forEach((element) {
      var post = Post.fromJson(element.data());
      posts.add(post);
    });

    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = AuthService.currentUserId();
    return _firestore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .delete();
  }
}
