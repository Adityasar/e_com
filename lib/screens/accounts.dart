import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/loggedin.dart';
import 'package:e_com/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference shoe = FirebaseFirestore.instance
        .collection('shoes')
        .doc(user.uid)
        .collection('orders');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Signin().logout();
              },
              icon: const FaIcon(FontAwesomeIcons.signOutAlt))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Profileimage(
                imagepath: user.photoURL.toString(), onclicked: () {}),
            const SizedBox(
              height: 28,
            ),
            Text(
              user.displayName.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email.toString(),
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Your Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: shoe.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No Orders Yet',
                            style: TextStyle(
                                color: Colors.grey[350],
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Expanded(
                      child: ListView(
                          children: snapshot.data!.docs
                              .map((e) => Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: SizedBox(
                                      height: 130,
                                      child: Column(
                                        children: [
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      e['date'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: Colors
                                                              .amber[700]),
                                                    )),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            e['items']
                                                                .toString()
                                                                .substring(
                                                                    1,
                                                                    e['items']
                                                                            .toString()
                                                                            .length -
                                                                        1),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                                    maxLines: 1,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          )),
                                                          const SizedBox(height: 10,),
                                                      Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: Text('₹' +
                                                            e['price'].toString(),style: TextStyle(color: Colors.amber[700],fontSize: 17,fontWeight: FontWeight.bold),),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList()),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class Profileimage extends StatelessWidget {
  final String imagepath;
  final VoidCallback onclicked;
  const Profileimage(
      {Key? key, required this.imagepath, required this.onclicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildimage(),
    );
  }

  Widget buildimage() {
    final image = NetworkImage(user.photoURL.toString());

    return ClipOval(
      child: Material(
        color: Colors.amber[600],
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: GestureDetector(onTap: () {}),
        ),
      ),
    );
  }
}