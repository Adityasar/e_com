import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_com/screens/accounts.dart';
import 'package:e_com/screens/cart.dart';
import 'package:e_com/screens/favourite.dart';
import 'package:e_com/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

final user = FirebaseAuth.instance.currentUser!;

StreamController<int> streamController = StreamController<int>.broadcast();

class Loggedin extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Loggedin(this.stream);
  final Stream<int> stream;
  @override
  State<Loggedin> createState() => _LoggedinState();
}

class _LoggedinState extends State<Loggedin> {
  var currentindex = 0;
  bool _connected = false;
  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  void myCurrentIndex(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  void initState() {
    widget.stream.asBroadcastStream().listen((index) {
      myCurrentIndex(index);
    });
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          _connected = true;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          _connected = true;
        });
      } else if (result == ConnectivityResult.ethernet) {
        setState(() {
          _connected = true;
        });
      } else if (result == ConnectivityResult.none) {
        setState(() {
          _connected = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  final screens = [const Home(), const Cart(), Favourite(), const Account()];

  @override
  Widget build(BuildContext context) {
    if (_connected) {
      return Scaffold(
        body: SafeArea(child: screens[currentindex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey[350],
          currentIndex: currentindex,
          onTap: (index) {
            setState(() {
              currentindex = index;
            });
          },
          selectedItemColor: Colors.amber[600],
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 32,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.shoppingBag),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidBookmark),
                label: 'Favourites'),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userAlt),
              label: 'Account',
            ),
          ],
        ),
      );
    } else if (!_connected) {
      return Center(
          child: Text(
        'No Internet',
        style: TextStyle(
            color: Colors.grey[350], fontWeight: FontWeight.bold, fontSize: 17),
      ));
    }
    return Center(
      child: CircularProgressIndicator(
        color: Colors.amber[700],
      ),
    );
  }
}
