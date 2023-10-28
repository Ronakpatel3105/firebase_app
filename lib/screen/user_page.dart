import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app1/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late FirebaseFirestore db;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('User')),
        body: StreamBuilder(
          stream: db
              .collection("users")
              .where("age", isGreaterThan: 12)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var model =
                      UserModel.fromJson(snapshot.data!.docs[index].data());
                  model.id = snapshot.data!.docs[index].id;
                  print("id: ${model.id}");
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          nameController.text = model.name!;
                          emailController.text = model.email!;
                          ageController.text = model.age!.toString();
                          return Container(
                            padding: const EdgeInsets.all(21),
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? 600
                                    : 1200,
                            color: Colors.blue.shade100,
                            child: Column(
                              children: [
                                const Text('Add User'),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    label: const Text("Name"),
                                    hintText: "Enter name here..",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    label: const Text("Email"),
                                    hintText: "Enter Email here..",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: ageController,
                                  decoration: InputDecoration(
                                    label: const Text("Age"),
                                    hintText: "Enter Age here..",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      /// Update note
                                      db
                                          .collection("users")
                                          .doc(model.id)
                                          .set(UserModel(
                                            name:
                                                nameController.text.toString(),
                                            email:
                                                emailController.text.toString(),
                                            age: int.parse(
                                                ageController.text.toString()),
                                          ).toJson())
                                          .then((value) {});

                                      /* db
                                        .collection("notes")
                                        .add(NoteModel(
                                                title: titleController.text
                                                    .toString(),
                                                body: bodyController.text
                                                    .toString())
                                            .toJson())
                                        .then((value) {
                                      print(value);
                                      print(value.id);
                                    });*/
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update')),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text('${model.name}'),
                      subtitle: Text('${model.age}'),
                      trailing: InkWell(
                          onTap: () {
                            /// Delete Note
                            db
                                .collection("users")
                                .doc(model.id)
                                .delete()
                                .then((value) {
                              print("${model.id} deleted");
                            });
                          },
                          child: const Icon(Icons.delete)),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),

        /*FutureBuilder(
            future: db.collection("notes").get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var model =
                        NoteModel.fromJson(snapshot.data!.docs[index].data());
                    return ListTile(
                      title: Text('${model.title}'),
                      subtitle: Text('${model.body}'),
                    );
                  },
                );
              }
              return Container();
            }),*/

        /// third basic format using model

        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(21),
                    height: MediaQuery.of(context).viewInsets.bottom == 0
                        ? 600
                        : 1200,
                    color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            label: const Text("Name"),
                            hintText: "Enter Name here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            label: const Text("Email"),
                            hintText: "Enter Email here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: ageController,
                          decoration: InputDecoration(
                            label: const Text("Age"),
                            hintText: "Enter Age here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              db
                                  .collection("users")
                                  .add(UserModel(
                                    name: nameController.text.toString(),
                                    email: emailController.text.toString(),
                                    age: int.parse(
                                        ageController.text.toString()),
                                  ).toJson())
                                  .then((value) {
                                print(value);
                                print(value.id);
                              });
                              Navigator.pop(context);
                              nameController.clear();
                              emailController.clear();
                              ageController.clear();
                            },
                            child: const Text('Submit here...')),
                      ],
                    ),
                  );
                },
              );
            }
            /* db.collection("notes").add(NoteModel(
                title: "Wscube",
                body: "Flutter",
              ).toJson())
              .then((value) {
            print(value);
            print(value.id);
          });
        },
        child: const Icon(Icons.add),
      ),*/

            /*
      /// second basic format of firestore initialization with making initstate
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          db.collection("student").add({
            "name": "Ronak",
            "class": "12th",
            "roll no": 1,
          }).then((value) {
            print(value);
            print(value.id);
          });
        },
        child: Icon(Icons.add),
      ),*/
            /*floatingActionButton: FloatingActionButton(
        onPressed: () {

         (1).  /// Basic format of firestore initialization
          var db = FirebaseFirestore.instance;
          db.collection("student").add({
            "name": "Ronak",
            "class": "12th",
            "Roll No": 1,
          }).then((value) {
            print(value);
            print(value.id);
          });
        },
        child: const Icon(Icons.add),
      ),*/
            ));
  }
}
