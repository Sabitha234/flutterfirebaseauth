
import 'package:emailpassword/services/authservices.dart';
import 'package:emailpassword/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final password=TextEditingController();
  final email=TextEditingController();
  AuthServices as=AuthServices();

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
                      color: Colors.blue.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            as.login(context,email.text.trim(),password.text.trim());
                          },
                          child: Text("Login",style: TextStyle(fontSize: 22,color: Colors.black),
                        ),
                    ),
                      )
                  ),
                  ),
                  TextButton(style: ButtonStyle(backgroundColor:MaterialStatePropertyAll(Colors.pink.shade50),
                  ),onPressed: (){
                   as.changePassword(email.text.trim(),context);
                  },
                      child: Text("Forget Password",style: TextStyle(fontSize: 20,color: Colors.black))),
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
                as.gmailLogin(context);
              }, icon: FaIcon(FontAwesomeIcons.google,color: Colors.red,), label: Text("Login using Gmail"))
            ],
          ),
        ),
      )
      )
    );
  }

}
