import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WelcomeHomePage extends StatefulWidget {
  const WelcomeHomePage({Key? key}) : super(key: key);

  @override
  State<WelcomeHomePage> createState() => _WelcomeHomePageState();
}

class _WelcomeHomePageState extends State<WelcomeHomePage> {
  final _db = FirebaseDatabase.instance.ref().child("users");

  Stream<DatabaseEvent> getData() {
    var user = FirebaseAuth.instance.currentUser!;
    final dbRef =
        FirebaseDatabase.instance.ref().child('users').child(user.uid);
    return dbRef.onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Home'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LoggedIn Successfully',
              textAlign: TextAlign.center,
            ),
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text('SignOut'))
          ],
        ),
      ),
    );
  }
}
