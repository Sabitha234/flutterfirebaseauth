
import 'package:emailpassword/signup_screen.dart';
import 'package:emailpassword/utils/utils.dart';
import 'package:emailpassword/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _googleSignin=GoogleSignIn();
  final password=TextEditingController();
  final email=TextEditingController();
  GoogleSignInAccount? _user;
 GoogleSignInAccount get user=>_user!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:DecoratedBox(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("img/1.png"), fit: BoxFit.cover),
    ),
       child:Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child:  TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconColor: Colors.purple,
                    hintText: "Enter your mailid",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)
                  ),
                ),
                controller: email,
                  style: TextStyle(fontSize: 20,color: Colors.black,)
              ),
            ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child:  TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      prefixIconColor: Colors.purple,
                      hintText: "Enter your password",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                  ),
                  controller: password,
                  style: TextStyle(fontSize: 20,color: Colors.black,)
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 80,height: 50,
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            login();

                          },
                          child: Text("Login",style: TextStyle(fontSize: 22,color: Colors.black),
                        ),
                    ),
                      )
                  ),
                  ),
                  TextButton(onPressed: (){
                    Get.to(SignupPage());
                  }, child: Text("Forget Password",style: TextStyle(fontSize: 20,color: Colors.black))),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("Don't have an account",style: TextStyle(fontSize: 20),),
                      TextButton(onPressed: (){
                        Get.to(SignupPage());
                      }, child: Text("Sign Up",style: TextStyle(fontSize: 20,color: Colors.blue.shade900))),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(onPressed: (){
                gmailLogin();
              }, icon: FaIcon(FontAwesomeIcons.google), label: Text("Login to Gmail"))
            ],
          ),
        ),
      )
      )
    );
  }
  Future<void> login() async {
    final firebaseauth=await FirebaseAuth.instance;
    await  firebaseauth.signInWithEmailAndPassword(email: email.text, password: password.text).whenComplete(() {
      Get.to(Welcome())  ;
    });

  }

  Future<void>gmailLogin()async {
    try {
      final google_user = await _googleSignin.signIn();
      if (google_user == null) {
        return;
      }
      _user = google_user;
      final google_auth = await google_user!.authentication;
      final credentials = GoogleAuthProvider.credential(
          idToken: google_auth.idToken,
          accessToken: google_auth.accessToken
      );
      await FirebaseAuth.instance.signInWithCredential(credentials).whenComplete(() {
        Get.to(Welcome());
      });
      showSnackBar(context, "logged in as ${user.email}");
    }
    catch(e){
      print(e.toString());
    }
  }
}
