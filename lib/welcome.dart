
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:emailpassword/todo.dart';
class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  GoogleSignIn _googleSignIn=GoogleSignIn();
  String? name="empty";
  String? email;
  String? url1="https://tse4.mm.bing.net/th?id=OIP.IinrjlpXbDCJt28EGzYHfQHaHa&pid=Api&P=0&h=180";
  String uid='';
  @override
  void initState(){
    getuid();
    super.initState();
  }
  getuid()async{
    FirebaseAuth auth=FirebaseAuth.instance;
    final User user=await auth.currentUser!;
    setState(() {
      uid=user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    getDetails();
    print(name);
    return Scaffold(
      appBar: AppBar(title: Text("MY TASKS"),
        centerTitle: true,backgroundColor: Colors.pink.shade100,),

      drawer:email!=null?Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.pink.shade100),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(url1!),
              ), accountName: uid.isNotEmpty?StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user_details').doc(uid).snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.pink.shade100,),
                      ],
                    ),
                  );
                }
                else{
                  var result=snapshot.data;
                  return Text(result?['name'],style: TextStyle(color: Colors.black),);
                }

              },
            ):Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.pink.shade100,),
                ],
              ),
            ),
              accountEmail:Text(email!,style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: (){
                logout();
              },
            )
          ],
        ),
      ):null,
      body: Container(
        color: Colors.pink.shade50,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:uid.isNotEmpty? StreamBuilder(
            stream:FirebaseFirestore.instance.collection('task').doc(uid).collection("myTasks").snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.pink.shade100,),
                    ],
                  ),
                );
              }
              else{
                final docs=snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: docs!.length,
                      itemBuilder: (context,index){
                        String time=(docs[index]['timestamp']as Timestamp) .toDate().toString();
                        String title=docs[index]['title'].toString().toUpperCase();
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Container(
                                color:Colors.pink.shade100,
                                child: ListTile(
                                    title: Text(docs[index]['title']),
                                    subtitle: Text(time,style: TextStyle(color: Colors.grey),),
                                    onTap: (){
                                     showDialog(context: context, builder: (BuildContext context){
                                       return SimpleDialog(
                                         backgroundColor: Colors.pink.shade50,
                                         children: [
                                           Padding(
                                             padding: const EdgeInsets.all(10.0),
                                             child: Column(
                                               children: [
                                                 Center(child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                                                 Text(docs[index]['description']),
                                                 Text(time,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                                               ],
                                             ),
                                           ),
                                         ],
                                       );
                                     });
                                    },
                                    trailing: IconButton(onPressed: ()async{
                                      await FirebaseFirestore.instance.
                                          collection("task").doc(uid).
                                          collection("myTasks").doc(docs[index]['time']).
                                          delete();
                                    },icon:Icon(Icons.delete,)),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                );
              }
            },
          ):Center(
            child: Column(children: [
              CircularProgressIndicator()
            ],),
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade100,
        child: Icon(Icons.add_box_rounded),
        onPressed:(){
          Get.to(ToDo())
          ;},
      ),
    );
  }
  Future logout() async{
    final FirebaseAuth auth=await FirebaseAuth.instance;
     if(await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    }
      auth.signOut();
    }

void getDetails()async{
  FirebaseAuth fa=FirebaseAuth.instance;

  if(fa.currentUser!.displayName==null){
    name="empty";
  }
  else{
    name=fa.currentUser!.displayName!;
  }
  email= fa.currentUser!.email!;
  if(fa.currentUser!.photoURL==null){
    url1="https://tse4.mm.bing.net/th?id=OIP.IinrjlpXbDCJt28EGzYHfQHaHa&pid=Api&P=0&h=180";
  }
  else{
    url1=fa.currentUser!.photoURL;
  }


  }
  void getName()async{

}
}

