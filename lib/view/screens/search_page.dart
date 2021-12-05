import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thebrocolli/model/core/category.dart';
import 'package:thebrocolli/model/core/news.dart';
import 'package:thebrocolli/model/helper/category_helper.dart';
import 'package:thebrocolli/model/helper/news_helper.dart';
import 'package:thebrocolli/view/widgets/news_tile.dart';
import 'package:thebrocolli/view/widgets/search_app_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchInputController = TextEditingController();
  List<Category> category = CategoryHelper.categoryData;
  List<News> searchData = NewsHelper.searchNews;

  CollectionReference db = FirebaseFirestore.instance.collection('news');
  List<News> _news = [];

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(searchInputController.text);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: SearchAppBar(
          searchInputController: searchInputController,
          // searchPressed: () async {
          searchChanged: (value) async {
            String query = searchInputController.text;

            var raw = await db.get();

            List<News> data = [];

            raw.docs.forEach((a) => {
                  if (a['title'].toLowerCase().contains(query.toLowerCase()))
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

            setState(() {
              _news = data;
            });
          },
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            // Container(
            //   alignment: Alignment.center,
            //   height: 60,
            //   color: Colors.black,
            //   child: ListView.separated(
            //     padding: EdgeInsets.only(left: 16),
            //     scrollDirection: Axis.horizontal,
            //     physics: BouncingScrollPhysics(),
            //     itemCount: category.length,
            //     separatorBuilder: (context, index) {
            //       return SizedBox(width: 16);
            //     },
            //     itemBuilder: (context, index) {
            //       return Container(
            //         alignment: Alignment.topCenter,
            //         child: OutlinedButton(
            //           onPressed: () {
            //             setState(() {
            //               searchInputController.text = category[index].name;
            //             });
            //           },
            //           child: Text(
            //             category[index].name,
            //             style: TextStyle(
            //                 color: Colors.white.withOpacity(0.7),
            //                 fontWeight: FontWeight.w400),
            //           ),
            //           style: OutlinedButton.styleFrom(
            //             side: BorderSide(color: Color(0xFF313131), width: 1),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemCount: searchData.length,
                itemCount: _news.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16);
                },
                itemBuilder: (context, index) {
                  return NewsTile(data: _news[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
