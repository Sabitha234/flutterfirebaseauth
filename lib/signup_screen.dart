import 'package:emailpassword/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String u_id='';
  final name = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final phno = TextEditingController();
  AuthServices as = AuthServices();
  final _formKey = GlobalKey<FormState>();
  Country selected_country = Country(phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
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
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/1.png"), fit: BoxFit.cover),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
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
                          style: TextStyle(fontSize: 20, color: Colors.black,),
                          validator: (value) {
                            if (value == null || (value!.isEmpty)) {
                              return "Name field cant be empty";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
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
                          style: TextStyle(fontSize: 20, color: Colors.black,)
                          , validator: (value) {
                          if (value == null || (value!.isEmpty)) {
                            return "Email field cant be empty";
                          }
                        },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
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
                            style: TextStyle(
                              fontSize: 20, color: Colors.black,),
                            validator: (value) {
                              if (value == null || (value!.isEmpty)) {
                                return "Password Field Cant Be Empty";
                              }
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                          countryListTheme: CountryListThemeData(
                                              bottomSheetHeight: 500
                                          ),
                                          context: context,
                                          onSelect: (value) {
                                            setState(() {
                                              selected_country = value;
                                            });
                                          });
                                    },
                                    child: Text("${selected_country
                                        .flagEmoji}+${selected_country
                                        .phoneCode}",
                                      style: TextStyle(fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),),
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
                            style: TextStyle(
                              fontSize: 20, color: Colors.black,),
                            validator: (value) {
                              if (value == null || (value!.isEmpty)) {
                                return "Phone number Field Cant Be Empty";
                              }
                            }
                        ),
                      ),
                      ElevatedButton(onPressed: () {
                        as.phoneAuth(phno.text.trim(),context);
                      }, child: Text("Verify Phone number"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                as.signup(context,name.text,email.text.trim(),phno.text.trim(),u_id,password.text.trim());
                              }
                            },
                            child: Container(
                                color: Colors.pink.shade50,
                                height: 60, width: 200,
                                child: Center(child: Text("Sign Up",
                                  style: TextStyle(fontSize: 20),)))),
                      )
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}