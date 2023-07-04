import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/models/member_model.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/utils_service.dart';

class DBService{
  static final _firestore = FirebaseStorage.instance;
  static String folder_user = "users";
  static Future storeMember(Member member) async{
    member.uid = AuthService.currentUserId();
    Map<String, String> params = await Utils.deviceParams();
    print(params);

    member.device_id = params["device_id"]!;
    member.device_type = params["device_type"]!;
    member.device_token = params["device_token"]!;

    return _firestore.collection(folder_user).doc(member.uid).set(member.toJson());
  }

  static Future<Member> loadMember() async{
    String uid = AuthService.currentUserId();
    var value = await _firestore.collection(folder_user).doc(uid).get();
    Member member = Member.frromJson(value.data()!);
    return member;
  }

  static Future<Member> updateMember(Member member) async{
    String uid = AuthService.currentUserId();
    return _firestore.collection(folder_user).doc(member.uid).update(member.toJson());
  }

  static Future<List<Member>> searchMember(String keyword) async{
    List<Member> members = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await _firestore.collection(folder_user).orderBy("email").startAt([keyword]).get();
    print(querySnapshot.docs.length);

    querySnapshot.docs.forEach((result){
      Member newMember = Member.frromJson(result.data());
      members.add(newMember);
    });

    return members;
  }
}