import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_app/classification/constants.dart';
import 'package:mini_app/classification/links.dart';
import 'package:mini_app/classification/new_or_most.dart';
import 'package:mini_app/data/firebase_methods.dart';
import 'package:mini_app/data/firebase_repository.dart';
import 'package:mini_app/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData(BuildContext context) {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Links(post: post);
          }));
        },
        child: Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.black54,
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withAlpha(100), blurRadius: 10.0),
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post["name"],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          post["brand"],
                          style:
                              const TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "\ ${post["price"]}",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black87,
                              spreadRadius: 1.0,
                              blurRadius: 4.0,
                              offset: Offset(3.0, 3.0))
                        ],
                      ),
                      height: 100,
                      width: 115,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/${post["image"]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Expanded(
                  //                   child: GestureDetector(
                  //               child: Image.asset(
                  //       "assets/images/${post["image"]}",
                  //       height: double.infinity,

                  //     ),
                  //   onLongPress: (){
                  //     Navigator.push(context, MaterialPageRoute(builder: (context){return Links(post: post);}));
                  //   },),
                  // ),
                ],
              ),
            )),
      ));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData(context);
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  FirebaseMethods authMethods = FirebaseMethods();
  @override
  Widget build(BuildContext context) {
    //   final UserProvider userProvider = Provider.of<UserProvider>(context);
    signOut() async {
      final bool isLoggedOut = await authMethods.signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        // authMethods.setUserState(
        //   userId: userProvider.getUser.uid,
        //   userState: UserState.Offline,
        // );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.black,
        //   leading: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.search, color: Colors.white),
        //       onPressed: () {},
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.person, color: Colors.white),
        //       onPressed: () {},
        //     )
        //   ],
        // ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   "Links",
                    //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    // ),
                    GestureDetector(
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      onTap: () => signOut(),
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {return HomeScreen();},))
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer ? 0 : categoryHeight,
                    child: categoriesScroller),
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform: Matrix4.identity()..scale(scale, scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 20),
                  height: categoryHeight,
                  decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child:
                                  //  FittedBox(
                                  //       child:
                                  Image.asset(
                                "assets/images/favorite.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Text(
                                "Favourite",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )

                      // child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      //     Text(
                      //       "Most\nFavorites",
                      //       style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      //     ),
                      //     SizedBox(
                      //       height: 10,
                      //     ),
                      //   ],
                      // ),

                      ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return NewOrMost(name: "Most");
                    },
                  ));
                },
              ),
              GestureDetector(
                child: Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 20),
                  height: categoryHeight,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.blueGrey,
                                            spreadRadius: 1.0,
                                            blurRadius: 5.0,
                                            offset: Offset(3.0, 3.0))
                                      ],
                                    ),
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        "assets/images/recent.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Recent",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     Text(
                        //       "Newest",
                        //       style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //   ],
                        // ),

                        ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return NewOrMost(name: "Newest");
                    },
                  ));
                },
              ),
              // Container(
              //   width: 150,
              //   margin: EdgeInsets.only(right: 20),
              //   height: categoryHeight,
              //   decoration: BoxDecoration(color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Text(
              //           "Super\nSaving",
              //           style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Text(
              //           "20 Items",
              //           style: TextStyle(fontSize: 16, color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
