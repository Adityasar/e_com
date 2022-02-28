import 'package:e_com/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInwindow extends StatelessWidget {
  const SignInwindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/abstract-6467845_1280.jpg'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [
              Spacer(),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign In to Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.black,
                  ),
                ),
              ),
              Spacer(),
              /*SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
                  ),
                ),
              ),*/
              Signinbutton(),
            ],
          ),
        ),
      ),
    );
  }
}

class Signinbutton extends StatelessWidget {
  const Signinbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: TextButton.icon(
          onPressed: () {
            Signin().gLogin();
          },
          icon: const FaIcon(
            FontAwesomeIcons.google,
            color: Colors.red,
          ),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      )))),
        ),
      );
}
