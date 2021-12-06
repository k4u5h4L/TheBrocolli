import 'package:flutter/material.dart';
import 'package:thebrocolli/view/screens/upload_page.dart';
import 'package:thebrocolli/view/screens/home_page.dart';
import 'package:thebrocolli/view/screens/discover_page.dart';
import 'package:thebrocolli/view/widgets/custom_bottom_navigation_bar.dart';

class PageSwitchWithAnimation extends StatefulWidget {
  @override
  _PageSwitchWithAnimationState createState() =>
      _PageSwitchWithAnimationState();
}

class _PageSwitchWithAnimationState extends State<PageSwitchWithAnimation> {
  int _selectedIndex = 0;
  PageController _pageSwitchController;

  @override
  void initState() {
    super.initState();
    _pageSwitchController = PageController();
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageSwitchController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageSwitchController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomePage(),
          DiscoverPage(),
          UploadPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
