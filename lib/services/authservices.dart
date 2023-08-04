import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../User.dart';
import '../login_screen.dart';
import '../utils/utils.dart';

class AuthServices{
  //login
  final _googleSignin=GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user=>_user!;


  Future<void> login(BuildContext context,String email,String password) async {
    final firebaseauth=await FirebaseAuth.instance;
    try {
      await firebaseauth.signInWithEmailAndPassword(
          email: email, password: password).whenComplete(() {

      });
    }
    on FirebaseAuthException catch(e){
      showSnackBar(context,e.message!);
    }
  }

  Future<void>gmailLogin(BuildContext context)async {
    try {
     final google_user = await _googleSignin.signIn();
      if (google_user == null) {
        return;
      }
      _user = google_user;
      final google_auth = await google_user.authentication;
      final credentials = GoogleAuthProvider.credential(
          idToken: google_auth.idToken,
          accessToken: google_auth.accessToken
      );
      await FirebaseAuth.instance.signInWithCredential(credentials).whenComplete(() {
        storeToFS(user.displayName!,user.email,"",user.id,context);
      });
      showSnackBar(context, "logged in as ${user.email}");
    }
    catch(e){
      print(e.toString());
    }
  }
  Future<void> changePassword(String email, BuildContext context)async {
    FirebaseAuth auth=await FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
    showSnackBar(context, "password reset link is sent to your mail id");
  }
  //signup

  Future<void> phoneAuth(String phno, BuildContext context) async{
    var verify=TextEditingController();
    FirebaseAuth firebaseAuth=await FirebaseAuth.instance;
    final auth=await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91"+phno,
        verificationCompleted: (PhoneAuthCredential phoneauth)async{
          await firebaseAuth.signInWithCredential(phoneauth);
        },
        verificationFailed: (error){
          throw Exception(error.message);
        },
        codeSent: (verificationid,forceResendingToken){

          showDialog(context: context,  barrierDismissible: false,
              builder: (BuildContext context){
                return AlertDialog(
                  title:Text("OTP") ,
                  actions: [
                    TextFormField(
                      controller: verify,
                      decoration: InputDecoration(
                        hintText: "Enter the otp",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    IconButton(onPressed: ()async{
                      try{
                        PhoneAuthCredential credentials=PhoneAuthProvider.
                        credential(verificationId: verificationid, smsCode: verify.text);
                        await firebaseAuth.signInWithCredential(credentials).whenComplete(() => showSnackBar(context, "verified")

                        );
                        Navigator.pop(context);
                      }
                      catch(e){
                        showSnackBar(context, e.toString());
                      }
                    },
                        icon: Icon(Icons.verified,size: 30,))
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (verificationId){});
  }

  //firestore

  void storeToFS(String name,String email,String phno,String u_id, BuildContext context)async{
    FirebaseAuth firebaseAuth=await FirebaseAuth.instance;
    u_id=firebaseAuth.currentUser!.uid;
    final u=UserDetails(name: name, email: email, phno: phno, uid: u_id);
    Map<String,dynamic> data=u.storeToFirebaseStore();
    await FirebaseFirestore.instance.collection("user_details").doc(u_id).set(data).whenComplete((){
      showSnackBar(context, "new user:${name}is created");
      Get.to(()=>LoginPage());
    });

  }

  Future<void> signup (BuildContext context, String name,String email,String phno,String u_id, String password) async {
    final auth=await FirebaseAuth.instance.
    createUserWithEmailAndPassword(email: email, password: password);
    try{
      //for verification link
      final _auth=await FirebaseAuth.instance;
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, "Email Verification Sent");
      storeToFS(name,email,phno,u_id,context);

    }
    on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }
  }

}

