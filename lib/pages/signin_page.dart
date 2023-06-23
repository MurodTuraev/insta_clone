import 'package:flutter/material.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static final String id = 'sign_in_page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn(){
    String email = emailController.text.trim();
    String pasword = passwordController.text.trim();

    if(email.isEmpty || pasword.isEmpty) return;

    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignUpPage(){
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Instagram',style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Billabong',
                      fontSize: 45,
                    ),),
                    SizedBox(height: 20,),
                    // Email
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(7))
                      ),
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    // Password
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(7))
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    // Sign in button
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(width: 2,color: Colors.white.withOpacity(0.2))
                      ),
                      child: TextButton(
                        onPressed: (){
                          _doSignIn();
                        },
                        child: Text("Sign In", style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),),

                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don`t have an account?', style: TextStyle(color: Colors.white, fontSize: 16),),
                TextButton(
                  onPressed: (){
                    _callSignUpPage();
                  },
                  child: Text('Sign Up', style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
