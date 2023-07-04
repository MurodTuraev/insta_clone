import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/member_model.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/signin_page.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/db_service.dart';
import 'package:insta_clone/services/utils_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static final String id = 'sign_up_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confpassController = TextEditingController();

  bool _isValidateEmail(String email){
    print(EmailValidator.validate(email));
    return EmailValidator.validate(email);
  }

  bool _validatePassword(String password) {
    print("validate Password");
    // Create a regular expression that matches the required format of the password.
    RegExp passwordRegExp = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@#\$%^&+=])");
    // Check if the input string matches the regular expression.
    print(passwordRegExp.hasMatch(password));
    return passwordRegExp.hasMatch(password);
  }

  _doSignUp() async {
    String fullname = fullnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confpass = confpassController.text.trim();

    if(fullname.isEmpty || email.isEmpty || password.isEmpty) return;

    if(confpass != password){
      Utils.fireToast("Parollar bir biriga tog`ri kelmaydi!");
      return;
    }

    if(_isValidateEmail(email) && _validatePassword(password)) return;

    var res = await AuthService.signUpUser(fullname, email, password);
    Member member = Member(fullname, email);
    DBService.storeMember(member).then((value) => {
      storeMemberToDB(member)
    });
  }

  void storeMemberToDB(Member member){
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignInPage(){
    Navigator.pushReplacementNamed(context, SignInPage.id);
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
        child: Stack(
          children: [
            Column(
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
                        // #Fullname
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(7))
                          ),
                          child: TextField(
                            controller: fullnameController,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                            decoration: InputDecoration(
                                hintText: "Fullname",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 18
                                ),
                                border: InputBorder.none
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        // #Email
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
                        // #Password
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

                        // #Confirm Password
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(7))
                          ),
                          child: TextField(
                            controller: confpassController,
                            obscureText: true,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                            decoration: InputDecoration(
                                hintText: "Confirm password",
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
                              _doSignUp();
                            },
                            child: Text("Sign Up", style: TextStyle(
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
                    Text('Already have an account?', style: TextStyle(color: Colors.white, fontSize: 16),),
                    TextButton(
                      onPressed: (){
                        _callSignInPage();
                      },
                      child: Text('Sign In', style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),),
                    )
                  ],
                )
              ],
            ),
            isLoading? Center(
              child: CircularProgressIndicator(),
            ): SizedBox.shrink(),
          ],
        )
      ),
    );
  }
}
