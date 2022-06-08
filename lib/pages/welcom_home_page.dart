import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WelcomeHomePage extends StatefulWidget {
  const WelcomeHomePage({Key? key}) : super(key: key);

  @override
  State<WelcomeHomePage> createState() => _WelcomeHomePageState();
}

class _WelcomeHomePageState extends State<WelcomeHomePage> {
  String userId = (FirebaseAuth.instance.currentUser!).uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome Home'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(userId)
              .get(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = (snapshot.data!.value as dynamic);
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${data['username']}!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Your Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data['username'],
                    style: const TextStyle(fontSize: 17),
                  ),
                  const Text(
                    'Your Email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data['email'],
                    style: const TextStyle(fontSize: 17),
                  ),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text('SignOut'))
                ],
              ),
            );
          },
        )

        // SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Text(
        //         'LoggedIn Successfully',
        //         textAlign: TextAlign.center,
        //       ),
        //       Text(getCurrentOnLineUserInfo().toString()),
        //       TextButton(
        //           onPressed: () {
        //             FirebaseAuth.instance.signOut();
        //           },
        //           child: const Text('SignOut'))
        //     ],
        //   ),
        // ),
        );
  }
}
