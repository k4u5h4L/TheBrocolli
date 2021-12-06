import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thebrocolli/model/core/news.dart';
// import 'package:thebrocolli/model/helper/news_helper.dart';
import 'package:thebrocolli/route/slide_page_route.dart';
// import 'package:thebrocolli/view/screens/breaking_news_page.dart';
import 'package:thebrocolli/view/screens/profile_page.dart';
// import 'package:thebrocolli/view/widgets/breaking_news_card.dart';
import 'package:thebrocolli/view/widgets/custom_app_bar.dart';
import 'package:thebrocolli/view/widgets/featured_news_card.dart';
import 'package:thebrocolli/view/widgets/news_tile.dart';
import 'package:scroll_indicator/scroll_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _featuredNewsScrollController = ScrollController();
  CollectionReference news = FirebaseFirestore.instance.collection('news');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leadingIcon: SvgPicture.asset(
          'assets/icons/Menu.svg',
          color: Colors.white,
        ),
        onPressedLeading: () {
          Scaffold.of(context).openDrawer();
        },
        // title: SvgPicture.asset('assets/icons/appname.svg'),
        title: Text(
          'TheBrocolli',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        // profilePicture: Image.asset(
        //   'assets/images/pp.png',
        //   fit: BoxFit.cover,
        // ),
        profilePicture: Icon(Icons.person),
        onPressedProfilePicture: () {
          Navigator.of(context).push(SlidePageRoute(child: ProfilePage()));
        },
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // section 1 - Featured News
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            width: MediaQuery.of(context).size.width,
            height: 390,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 320,
                  child: FutureBuilder<QuerySnapshot>(
                    future: news.get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      List<News> data = [];
                      snapshot.data.docs.forEach((a) => {
                            if (a['trending'] == true)
                              {
                                data.add(
                                  (News(
                                      title: a['title'],
                                      description: a['description'],
                                      photo: a['photo'],
                                      author: a['author'],
                                      date: a['date'],
                                      trending: a['trending'])),
                                )
                              }
                          });

                      return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        controller: _featuredNewsScrollController,
                        padding: EdgeInsets.only(left: 16),
                        scrollDirection: Axis.horizontal,
                        // itemCount: featuredNewsData.length,
                        itemCount: data.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 16);
                        },
                        itemBuilder: (context, index) {
                          return FeaturedNewsCard(
                            // data: featuredNewsData[index],
                            data: data[index],
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trending news',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                      ScrollIndicator(
                        scrollController: _featuredNewsScrollController,
                        height: 6,
                        width: 30,
                        indicatorWidth: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.3)),
                        indicatorDecoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // section 2 - Breaking News
          // ###################################################################
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 16),
          //   width: MediaQuery.of(context).size.width,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 16),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Breaking News',
          //               style: TextStyle(
          //                 fontSize: 20,
          //                 fontWeight: FontWeight.w600,
          //                 fontFamily: 'inter',
          //               ),
          //             ),
          //             ElevatedButton(
          //               onPressed: () {
          //                 Navigator.of(context)
          //                     .push(SlidePageRoute(child: BreakingNewsPage()));
          //               },
          //               child: Text(
          //                 'view more',
          //                 style: TextStyle(
          //                     color: Colors.black, fontWeight: FontWeight.w400),
          //               ),
          //               style: ElevatedButton.styleFrom(
          //                 primary: Colors.transparent,
          //                 shadowColor: Colors.transparent,
          //                 onPrimary: Colors.grey,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Container(
          //         height: 200,
          //         margin: EdgeInsets.only(top: 6),
          //         child: ListView.separated(
          //           scrollDirection: Axis.horizontal,
          //           shrinkWrap: true,
          //           padding: EdgeInsets.symmetric(horizontal: 16),
          //           itemCount: breakingNewsData.length,
          //           physics: BouncingScrollPhysics(),
          //           separatorBuilder: (context, index) {
          //             return SizedBox(
          //               width: 13,
          //             );
          //           },
          //           itemBuilder: (context, index) {
          //             return BreakingNewsCard(
          //               data: breakingNewsData[index],
          //             );
          //           },
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // ###################################################################
          // section 3 - Based on Your Reading History
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    'Your daily read',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<QuerySnapshot>(
                    future: news.get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }

                      // List<Map<String, dynamic>> data =
                      //     snapshot.data.docs as List<Map<String, dynamic>>;

                      List<News> data = [];
                      snapshot.data.docs.forEach((a) => data.add(
                            (News(
                                title: a['title'],
                                description: a['description'],
                                photo: a['photo'],
                                author: a['author'],
                                date: a['date'],
                                trending: a['trending'])),
                          ));

                      // data.forEach((n) {
                      //   print(n.title);
                      // });

                      return ListView.separated(
                        shrinkWrap: true,
                        // itemCount: recomendationNewsData.length,
                        itemCount: data.length,
                        // physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16);
                        },
                        itemBuilder: (context, index) {
                          return NewsTile(
                            data: data[index],
                            // data: recomendationNewsData[index],
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
