import 'dart:convert';

import 'package:emailpassword/User.dart';
import 'package:emailpassword/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Welcome extends StatelessWidget {
  UserDetails? _usermodel;
  UserDetails get usermodel=>_usermodel!;
  String? _uid;
  String get uid=>_uid!;

  GoogleSignIn _googleSignIn=GoogleSignIn();
   Welcome({super.key});
  String? name;
  String? email;
  @override
  Widget build(BuildContext context) {
   getDetails();
   print(name);
   return Scaffold(
      appBar: AppBar(title: Text("User Info"),
        centerTitle: true,backgroundColor: Colors.pink.shade100,),

      drawer:email!=null?Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.pink.shade100),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.cyan,
              ), accountName: Text(name!,style: TextStyle(color: Colors.black),),
              accountEmail:Text(email!,style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ):null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome",style: TextStyle(fontSize: 22),),

           ElevatedButton(onPressed: (){
              logout();
            },
                child:Text("LOG OUT"))
          ],
        ),
      ),
    );
  }

  // Future logoutuser() async{
  //   final FirebaseAuth auth=await FirebaseAuth.instance;
  //    auth.signOut();
  //  Get.to(LoginPage());
  // }
  Future logout() async{
    final FirebaseAuth auth=await FirebaseAuth.instance;
    print(_googleSignIn.currentUser);
    if(await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
      auth.signOut();
      Get.to(LoginPage());
    }
void getDetails(){
  FirebaseAuth fa=FirebaseAuth.instance;
  name=fa.currentUser!.displayName;
  email= fa.currentUser!.email!;
}


}
