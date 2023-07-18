import 'package:emailpassword/login_screen.dart';
import 'package:emailpassword/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp (const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,AsyncSnapshot<User?> snapshot){
          if(snapshot.hasData && snapshot.data!=null){
            print(snapshot.data);
            return Welcome();
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator());
          }
          else{
            print("has no data");
            return const LoginPage();
          }
        },
      ),
    );
  }
}

