import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_reg_task/widgets/auth_page_widget.dart';

class SignOnPage extends StatefulWidget {
  const SignOnPage({Key? key}) : super(key: key);

  @override
  State<SignOnPage> createState() => _SignOnPageState();
}

class _SignOnPageState extends State<SignOnPage> {
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref().child('users');
  bool _isLoading = false;

  void submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      if (!isLogin) {
        Map mapUserData = {
          'email': email,
          'username': username,
        };

        await _dbRef.child(userCredential.user!.uid).set(mapUserData);

        // await _dbRef.push().set(
        //   {
        //     'email': email,
        //     'username': username,
        //   },
        // );
      }
    } on FirebaseAuthException catch (err) {
      var message = 'Error occured, invalid credentials';

      if (err.message != null) {
        message = err.message!;
      }
      // print(err.message);
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      var message = 'Error occured, invalid credentials';
      if (err.message != null) {
        message = err.message!;
      }
      print(err.message);
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (err) {
      var message = 'Error occured, invalid credentials';

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthPage(
      submitForm: submitAuthForm,
    ));
  }
}
