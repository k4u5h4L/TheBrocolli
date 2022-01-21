import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:thebrocolli/auth/auth_service.dart';
import 'package:thebrocolli/route/slide_page_route.dart';
import 'package:thebrocolli/view/screens/page_switch.dart';
import 'package:thebrocolli/view/screens/welcome_page.dart';
import 'package:thebrocolli/view/widgets/custom_app_bar.dart';
import 'package:thebrocolli/view/widgets/profile_info_card.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressedLeading: () {
          Navigator.of(context).pop();
        },
        title: Text(
          'Profile Info',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          //  Section 1 = Profile Info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: MediaQuery.of(context).size.width,
            height: 110,
            color: Colors.black,
            alignment: Alignment.topCenter,
            child: ProfileInfoCard(
              username: firebaseUser != null ? firebaseUser.email : '',
              subscriptionStatus: '',
            ),
          ),
          // Section 2 - Banner
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFE5E5E5)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      firebaseUser != null
                          ? 'Not ${firebaseUser.email}?\nLogout and login again!'
                          : 'Logout',
                      style: TextStyle(
                        height: 150 / 100,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();

                      print('logged out');
                      Navigator.of(context).push(
                        SlidePageRoute(
                          child: WelcomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF252525),
                      padding: EdgeInsets.only(
                          left: 14, top: 7, bottom: 7, right: 8),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('Logout'),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
