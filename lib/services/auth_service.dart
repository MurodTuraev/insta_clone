import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/signin_page.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;
  static bool isLogged(){
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser != null;
  }

  static String currentUserId(){
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser!.uid;
  }

  static Future<User?> signUser(String email, String pass) async{
    await _auth.signInWithEmailAndPassword(email: email, password: pass);
    final User firebaseUser = _auth.currentUser!;
    return firebaseUser;
  }

  static Future<User?> signUpUser(String name, String email, String pass) async{
    var auth_result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    User? user = auth_result.user;
    return user;
  }

  static void signOutUser(BuildContext context){
    _auth.signOut();
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }
}