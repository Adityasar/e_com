import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loggedin.dart';
import 'signinwindow.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return Loggedin(streamController.stream,);
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('something went wrong'),
                );
              } else {
                return const SignInwindow();
              }
            }),
      );
}
