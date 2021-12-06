import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:thebrocolli/view/widgets/custom_text_field.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with TickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  CollectionReference db = FirebaseFirestore.instance.collection('news');
  final user = FirebaseAuth.instance.currentUser;

  _submitArticle(String userEmail) async {
    String newsTitle = titleController.text.trim();
    String newsPhoto = photoController.text.trim();
    String newsDesc = descController.text.trim();
    bool newsTrending = false;
    String newsAuthor = userEmail.split("@")[0];

    final now = DateTime.now();
    String newsDate = DateFormat.yMMMMd('en_US').format(now);

    return db.add({
      'title': newsTitle,
      'photo': newsPhoto,
      'description': newsDesc,
      'trending': newsTrending,
      'author': newsAuthor,
      'date': newsDate
    }).then((value) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success!'),
            content: Text('Your article was successfully saved!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      titleController.text = "";
      photoController.text = "";
      descController.text = "";
    }).catchError((error) async => {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('${error}'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          )
        });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'TheBrocolli',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1 - Welcome Title
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 40),
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Upload your own article!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    height: 150 / 100,
                    fontFamily: 'inter'),
              ),
            ),
            // Section 2 - Form
            Container(
              margin: EdgeInsets.only(bottom: 24),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Article title',
                    hintText: 'Covid 19 ...',
                    controller: titleController,
                  ),
                  CustomTextField(
                    hintText: 'Image URL',
                    labelText: 'https://example.com/image.jpg',
                    controller: photoController,
                  ),
                  CustomTextField(
                    labelText: 'Description',
                    hintText: 'The quick brown fox jumps over the lazy dog',
                    controller: descController,
                  ),
                ],
              ),
            ),
            // Section 3 - Register Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  if (firebaseUser != null) {
                    _submitArticle(user.email);
                  } else {
                    _submitArticle("Anonymous");
                  }
                },
                child: Text(
                  'Upload',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
