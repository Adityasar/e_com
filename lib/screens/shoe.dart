import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/loggedin.dart';
import 'package:e_com/screens/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShoePage extends StatelessWidget {
  const ShoePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference shoes = FirebaseFirestore.instance.collection('shoes');
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final shoe = ModalRoute.of(context)!.settings.arguments as Shoes;

    Future<void> addFavourite() {
      return shoes.doc(uid).collection('favourite').doc(shoe.name).set({
        "name": shoe.name,
        "brand": shoe.brand,
        "category": shoe.category,
        "color": shoe.color,
        "price": shoe.price,
        "thumbnail": shoe.image.thumbnail,
        "images": shoe.image.images
      });
    }

    Future<void> addtoCart() {
      return shoes.doc(uid).collection('cart').doc(shoe.name).set({
        "name": shoe.name,
        "brand": shoe.brand,
        "category": shoe.category,
        "color": shoe.color,
        "price": shoe.price,
        "thumbnail": shoe.image.thumbnail,
        "images": shoe.image.images
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.solidHeart),
                onPressed: () {
                  addFavourite();
                  streamController.add(2);
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.grey[350]),
      ),
      bottomSheet: BottomSheet(
        elevation: 2,
        builder: (context) {
          return Card(
            margin: const EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: SizedBox(
              height: 77,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                              color: Colors.grey[350],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹ ' + shoe.price.toString(),
                          style: TextStyle(
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.amber[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14))),
                        onPressed: () {
                          addtoCart();
                          streamController.add(1);
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Center(
                              child: Text(
                            'Add to Cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        onClosing: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 360,
                      child: Text(
                        shoe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.amber[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(shoe.category,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: CarouselSlider(
                              items: shoe.image.images
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(e)))),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  height: 200,
                                  initialPage: 0,
                                  viewportFraction: 1)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Size',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.amber[700]),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 55,
              child: FutureBuilder<Sizes>(
                  future: sizes(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: snapshot.data!.sizes
                                  .map((e) => SizedBox(
                                        width: 85,
                                        child: SelectableCard(
                                          card: Card(
                                            child: Center(
                                                child: Text(e.toString())),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      );
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
      ),
    );
  }
}
