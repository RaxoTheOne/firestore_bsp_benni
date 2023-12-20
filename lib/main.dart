import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_bsp_benni/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 79, 35, 156)),
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
Future<UserCredential> signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      // return creds
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

  void addUserToDatabase() {
    final user = <String, dynamic>{
      "first": "Juna",
      "middle": "Melina",
      "third": "Seline",
      "last": "Gayda-Knop",
      "born": 2019,
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
        backgroundColor: Colors.amber,
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
                child: const Text("Add User To DB")
                ),
            ElevatedButton(onPressed: signInWithGoogle, child: const Text("Sign In With Google")
            ),
          ],
        ),
      ),
    );
  }
}
