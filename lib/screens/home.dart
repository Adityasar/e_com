import 'package:e_com/screens/shoe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/screens/api.dart';
import 'package:e_com/loggedin.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    color: Colors.amber[600],
                    child: Image.network(
                      user.photoURL.toString(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.displayName.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo[950]),
                    )
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.solidBell,
                  color: Colors.grey[350],
                ),
                onPressed: () {},
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Latest',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                  fontSize: 30,
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: FutureBuilder<List<Shoes>>(
                future: shoes(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      const Text('nothing to show');
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  CarouselSlider(
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        height: 200,
                                        viewportFraction: 1,
                                        aspectRatio: 16 / 11,
                                      ),
                                      items: snapshot.data!
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ShoePage(),
                                                          settings:
                                                              RouteSettings(
                                                                  arguments:
                                                                      e)));
                                                },
                                                child: Card(
                                                  margin:
                                                      const EdgeInsets.all(0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(e
                                                                .image
                                                                .thumbnail))),
                                                  ),
                                                ),
                                              ))
                                          .toList())
                                ]),
                          ),
                        ],
                      );
                    }
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.amber[700],
                  ));
                }),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular',
              style: TextStyle(
                fontSize: 30,
                color: Colors.amber[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 55,
            child: FutureBuilder<Brands>(
                future: brands(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.brands
                            .map((e) => SizedBox(
                                width: 85,
                                height: 55,
                                child: SelectableCard(
                                    card: Card(
                                        child: Center(
                                            child: Text(
                                  e,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))))))
                            .toList());
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber[700],
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Shoes>>(
                future: shoes(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(children: [
                            CarouselSlider(
                                items: snapshot.data!
                                    .map((e) => Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ShoePage(),
                                                    settings:
                                                        RouteSettings(arguments: e)));
                                          },
                                          child: Card(
                                            margin: const EdgeInsets.all(0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Container(
                                              height: 265,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          e.image.thumbnail))),
                                              child: ListTile(
                                                title: Column(
                                                  children: [
                                                    const Spacer(),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 270,
                                                          child: Align(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            child: Text(
                                                              e.name,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow.fade,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15),
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            color: Colors.amber[700],
                                                            child: const Center(
                                                                child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .shoppingBag,
                                                              color: Colors.white,
                                                            )),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1,
                                  height: 265,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: false,
                                ))
                          ]),
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
    );
  }
}

class SelectableCard extends StatefulWidget {
  final Card card;

  const SelectableCard({Key? key, required this.card}) : super(key: key);

  @override
  _SelectableCardState createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelect = !isSelect;
        });
      },
      child: Card(
        color: isSelect ? Colors.amber[600] : widget.card.color,
        shape: widget.card.shape,
        child: widget.card.child,
      ),
    );
  }
}
