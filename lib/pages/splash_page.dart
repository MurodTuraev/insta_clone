import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/signin_page.dart';
import 'package:insta_clone/pages/signup_page.dart';
import 'package:insta_clone/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static final String id = 'splash_page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
  }

  _initTimer(){
    Timer(Duration(seconds: 2),(){
      _callNextPage();
    });
  }

  _callNextPage(){
    if(AuthService.isLogged()){
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Navigator.pushReplacementNamed(context, SignInPage.id);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(247, 119, 55, 1),
              Color.fromRGBO(245, 96, 64, 1)
            ]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text('Instagram',style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Billabong',
                    fontSize: 45,
                ),),
              ),
            ),
            Text('All right reserved', style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
