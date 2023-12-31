import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/pages/my_likes_page.dart';
import 'package:insta_clone/pages/my_profile_page.dart';
import 'package:insta_clone/pages/my_search_page.dart';
import 'package:insta_clone/pages/my_upload_page.dart';

import 'my_feed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static final String id = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _pageController;
  int _currentTap = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          MyFeedPage(pageController: _pageController,),
          MySearchPage(),
          MyUploadPage(pageController: _pageController,),
          MyLikesPage(),
          MyProfilePage(),
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index){
          setState(() {
            _currentTap = index;
            _pageController!.animateToPage(index, duration: Duration(microseconds: 200), curve: Curves.easeIn);
          });
          },
        currentIndex: _currentTap,
        activeColor: Color.fromRGBO(247, 119, 55, 1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32,
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 32,
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 32,
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32,
            )
          ),
        ],
      ),
    );
  }
}
