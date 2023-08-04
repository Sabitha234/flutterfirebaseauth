import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailpassword/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  TextEditingController title=TextEditingController();
  TextEditingController desc=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: Text("New Task"),
        backgroundColor: Colors.blue.shade100,),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                    labelText: "Enter Title",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    )
                  ),
                ),
              ),
             SizedBox(height: 20,),
              Container(
                child: TextField(
                  controller: desc,
                  decoration: InputDecoration(
                      labelText: "Enter Description",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      )
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                height: 60,
                color: Colors.blue.shade100,
                child: ListTile(
                  onTap: (){addTaskToFirebase();},
                  title: Center(child: Text("ADD TASK")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addTaskToFirebase()async{
    FirebaseAuth auth=await FirebaseAuth.instance;
    String uid=await auth.currentUser!.uid;
    var time=DateTime.now();
    await FirebaseFirestore.instance.collection("task").doc(uid).
    collection("myTasks").doc(time.toString()).
    set({
      'title':title.text,
      'description':desc.text,
      'time':time.toString(),
      'timestamp':time
    }).whenComplete(() => showSnackBar(context, "Task Added"));
  }

}
