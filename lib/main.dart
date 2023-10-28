import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app1/model/note_model.dart';
import 'package:firebase_app1/screen/user_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore db;
  var titleController = TextEditingController();
  var bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Note')),
        body: StreamBuilder(
          stream: db.collection("notes").snapshots(),
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
                  model.id = snapshot.data!.docs[index].id;
                  print("id: ${model.id}");
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          titleController.text = model.title!;
                          bodyController.text = model.body!;
                          return Container(
                            padding: const EdgeInsets.all(21),
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? 400
                                    : 800,
                            color: Colors.blue.shade100,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    label: const Text("Title"),
                                    hintText: "Enter Title here..",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: bodyController,
                                  decoration: InputDecoration(
                                    label: const Text("Body"),
                                    hintText: "Enter Desc here..",
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
                                          .collection("notes")
                                          .doc(model.id)
                                          .set(NoteModel(
                                            title:
                                                titleController.text.toString(),
                                            body:
                                                bodyController.text.toString(),
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
                      title: Text('${model.title}'),
                      subtitle: Text('${model.body}'),
                      trailing: InkWell(
                          onTap: () {
                            /// Delete Note
                            db
                                .collection("notes")
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
                        ? 400
                        : 800,
                    color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            label: const Text("Title"),
                            hintText: "Enter Title here..",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: bodyController,
                          decoration: InputDecoration(
                            label: const Text("Body"),
                            hintText: "Enter Desc here..",
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
                                  .collection("notes")
                                  .add(NoteModel(
                                          title:
                                              titleController.text.toString(),
                                          body: bodyController.text.toString())
                                      .toJson())
                                  .then((value) {
                                print(value);
                                print(value.id);
                              });
                              Navigator.pop(context);
                              titleController.clear();
                              bodyController.clear();
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
