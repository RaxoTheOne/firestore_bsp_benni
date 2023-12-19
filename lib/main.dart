import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_bsp_benni/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 79, 35, 156)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Firestore Beispiel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void addUserToDatabase() {
    final user = <String, dynamic>{
      "first": "Benjamin",
      "middle": "Jonas",
      "last": "Gayda-Knop",
      "born": 1994,
    };

    var db = FirebaseFirestore.instance;
    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<void> readUserFromDatabase() async {
    // Instanz holen
    var db = FirebaseFirestore.instance;
    // Dokumente herunterladen
    await db.collection('users').get().then((event) {
      for (var doc in event.docs) {
        print('${doc.id} => ${doc.data()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: readUserFromDatabase,
                child: const Text('read Data')),
            ElevatedButton(
                onPressed: addUserToDatabase,
                child: const Text("Add User To DB")),
          ],
        ),
      ),
    );
  }
}
