import 'package:e_com/screens/shoefromfavourite.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../loggedin.dart';

class Favourite extends StatelessWidget {
  Favourite({Key? key}) : super(key: key);

  final CollectionReference shoe =
      FirebaseFirestore.instance.collection('shoes');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: Text(
                'Favourite',
                style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: shoe.doc(user.uid).collection('favourite').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text(
                        'Favourite List is Empty',
                        style: TextStyle(
                          color: Colors.grey[350],
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ));
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: snapshot.data!.docs
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    settings: RouteSettings(
                                                        arguments: e),
                                                    builder: (context) =>
                                                        const FavouriteShoePage()));
                                          },
                                          child: Container(
                                            height: 220,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        e['thumbnail']))),
                                            child: Column(
                                              children: [
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 270,
                                                        child: Text(
                                                          e['name'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        child: InkWell(
                                                            onTap: () {
                                                              Future<void> delete = shoe
                                                                  .doc(user.uid)
                                                                  .collection(
                                                                      'favourite')
                                                                  .doc(
                                                                      e['name'])
                                                                  .delete();
                                                              delete;
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              color: Colors
                                                                  .amber[700],
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          Icon(
                                                                Icons.delete,
                                                                size: 28,
                                                                color: Colors.white,
                                                              )),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber[700],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
