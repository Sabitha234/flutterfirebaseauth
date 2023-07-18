import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailpassword/User.dart';
import 'package:emailpassword/login_screen.dart';
import 'package:emailpassword/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late String u_id;
  final name=TextEditingController();
  final password=TextEditingController();
  final email=TextEditingController();
  final phno=TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Country selected_country=Country(phoneCode: "91",
      countryCode: "IN",
      e164Sc:0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:  TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.edit),
                          prefixIconColor: Colors.purple,
                          hintText: "Enter your name",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)
                        ),
                      ),
                      controller: name,
                        style: TextStyle(fontSize: 20,color: Colors.black,),
                      validator: (value){
                        if(value==null||(value!.isEmpty)){
                          return "Name field cant be empty";
                        }
                      },
                    ),
                  ),
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
                        ,validator: (value){
                      if(value==null||(value!.isEmpty)){
                        return "Email field cant be empty";
                      }
                    },
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
                      controller:password,
                        style: TextStyle(fontSize: 20,color: Colors.black,),
                        validator: (value) {
                  if (value == null||(value!.isEmpty)) {
                  return "Password Field Cant Be Empty";
                  }
                  }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: InkWell(
                                    onTap: (){
                                      showCountryPicker(countryListTheme: CountryListThemeData(
                                          bottomSheetHeight: 500
                                      ),context: context, onSelect: (value){
                                        setState(() {
                                          selected_country=value;
                                        });
                                      });
                                    },
                                    child: Text("${selected_country.flagEmoji}+${selected_country.phoneCode}",
                                      style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),


                            hintText: "Enter your phone number",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)
                            ),
                          ),
                          controller: phno,
                            style: TextStyle(fontSize: 20,color: Colors.black,),
                            validator: (value) {
                              if (value == null||(value!.isEmpty)) {
                                return "Phone number Field Cant Be Empty";
                              }
                            }
                        ),
                  ),
                        ElevatedButton(onPressed: (){
                          phoneAuth();
                        }, child: Text("Verify Phone number"),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                                signup();

                          }
                        },
                        child:Container(
                          color: Colors.pink.shade50,
                          height: 60,width: 200,
                            child: Center(child: Text("Sign Up",style: TextStyle(fontSize: 20),)))),
                  )
                ],
              ),
            ),
          ),
        )
        )
    );
  }
  Future<void> signup () async {
    final auth=await FirebaseAuth.instance.
    createUserWithEmailAndPassword(email: email.text, password: password.text);
   try{
     //for verification link
     final _auth=await FirebaseAuth.instance;
     _auth.currentUser!.sendEmailVerification();
     showSnackBar(context, "Email Verification Sent");
     storeToFS();

   }
   on FirebaseAuthException catch(e){
       showSnackBar(context, e.message!);
   }
  }
Future<void> phoneAuth() async{
    var verify=TextEditingController();
    FirebaseAuth firebaseAuth=await FirebaseAuth.instance;
  final auth=await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91"+phno.text.trim(),
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
void storeToFS()async{
    FirebaseAuth firebaseAuth=await FirebaseAuth.instance;
    u_id=firebaseAuth.currentUser!.uid;
   final u=UserDetails(name: name.text, email: email.text, phno: phno.text, uid: u_id);
   Map<String,dynamic> data=u.storeToFirebaseStore();
   await FirebaseFirestore.instance.collection("user_details").doc(u_id).set(data).whenComplete((){
     showSnackBar(context, "new user:${name.text}is created");
     Get.to(LoginPage());
   });

}
}
