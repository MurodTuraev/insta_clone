import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/my_feed_page.dart';
import 'package:insta_clone/pages/signin_page.dart';
import 'package:insta_clone/pages/signup_page.dart';
import 'package:insta_clone/pages/splash_page.dart';

void main() async{
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SplashPage.id: (context) => SplashPage(),
        SignInPage.id: (context) => SignInPage(),
        SignUpPage.id: (context) => SignUpPage(),
        MyFeedPage.id: (context) => MyFeedPage()
    },
    );
  }
}

