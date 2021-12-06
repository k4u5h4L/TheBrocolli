import 'package:flutter/material.dart';
import 'package:thebrocolli/view/screens/upload_page.dart';
import 'package:thebrocolli/view/screens/home_page.dart';
import 'package:thebrocolli/view/screens/discover_page.dart';
import 'package:thebrocolli/view/widgets/custom_bottom_navigation_bar.dart';
import 'package:thebrocolli/view/widgets/custom_side_bar.dart';

class PageSwitch extends StatefulWidget {
  @override
  _PageSwitchState createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePage(),
        DiscoverPage(),
        UploadPage(),
      ][_selectedIndex],
      drawer: CustomSideBar(),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
