import 'package:e_com/loggedin.dart';
import 'package:e_com/main.dart';
import 'package:e_com/screens/shoefromfavourite.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int price = 0;
  final CollectionReference shoe =
      FirebaseFirestore.instance.collection('shoes');
  final _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> addtoOrders() async {
    var date = DateTime.now();
    var items = await shoe.doc(user.uid).collection('cart').get();
    final allData = items.docs.map((e) => e.id).toList();

    return shoe.doc(user.uid).collection('orders').doc().set({
      "items": allData,
      "date": DateFormat('EEE, M/d/y').format(date),
      "price": "$price"
    });
  }

  Future<void> addtoFailedOrders() async {
    var date = DateTime.now();
    var items = await shoe.doc(user.uid).collection('cart').get();
    final allData = items.docs.map((e) => e.id).toList();
    return shoe.doc(user.uid).collection('orders').doc().set({
      "items": allData,
      "date": DateFormat('EEE, M/d/y').format(date),
      "price": "$price - Failed"
    });
  }

  Future showNotification() {
    return FlutterLocalNotificationsPlugin().show(
        0,
        'Payment Successfull ₹ $price',
        'Your Transaction of ₹ $price is processed successfully',
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.amber,
                playSound: true,
                icon: 'mipmap/ic_launcher')));
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var cart = shoe.doc(user.uid).collection('cart');
    var gotDocuments = await cart.get();
    showNotification();
    addtoOrders();
    streamController.add(3);
    for (var doc in gotDocuments.docs) {
      await doc.reference.delete();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    addtoFailedOrders();

    FlutterLocalNotificationsPlugin().show(
        0,
        'Payment  ₹ $price failed',
        'Your Transaction of ₹ $price failed, any money debited would be refunded within 3-4 working days.',
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.amber,
                playSound: true,
                icon: 'mipmap/ic_launcher')));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  child: Text(
                    'Cart',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  )),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: shoe.doc(user.uid).collection('cart').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text(
                            'Cart is Empty',
                            style: TextStyle(
                              color: Colors.grey[350],
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ));
                        } else {
                          var ds = snapshot.data!.docs;
                          double sum = 0.0;
                          for (int i = 0; i < ds.length; i++) {
                            sum += (ds[i]['price']).toDouble();
                          }
                          void openCheckOut() async {
                            var options = {
                              'key': 'rzp_test_AEvlDhSjSR7yCA',
                              'amount': sum * 100,
                              'name': user.displayName,
                              'description': 'Shoes',
                              'timeout': 300,
                              'prefill': {'email': user.email}
                            };
                            try {
                              _razorpay.open(options);
                            } catch (error) {
                              debugPrint(error.toString());
                            }
                          }

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
                                                        BorderRadius.circular(
                                                            15),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            e['thumbnail']))),
                                                child: Column(
                                                  children: [
                                                    const Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 270,
                                                            child: Text(
                                                              e['name'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
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
                                                                    .circular(
                                                                        14),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Future<void> delete = shoe
                                                                    .doc(user
                                                                        .uid)
                                                                    .collection(
                                                                        'cart')
                                                                    .doc(e[
                                                                        'name'])
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
                                                              ),
                                                            ),
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
                              Container(
                                margin: const EdgeInsets.all(0),
                                child: SizedBox(
                                  height: 77,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                  color: Colors.grey[350],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '₹ ' + sum.toString(),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14))),
                                            onPressed: () async {
                                              price = sum.toInt();
                                              openCheckOut();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(14.0),
                                              child: Center(
                                                  child: Text(
                                                'Checkout',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              )),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber[700],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}