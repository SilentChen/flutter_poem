import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_poem/page/homePage.dart';
import 'package:flutter_poem/page/searchPage.dart';
import 'package:flutter_poem/page/minePage.dart';

class PoemRouter extends StatefulWidget {
  const PoemRouter({Key? key}) : super(key: key);

  @override
  State<PoemRouter> createState() => _PoemRouterState();
}

class _PoemRouterState extends State<PoemRouter> {
  
  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home')
    , const BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search')
    , const BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), label: 'Me')
  ];
  
  final bottomNavBarItemBodies = [
    const HomePage()
    ,SearchPage()
    ,MinePage()
  ];
  
  int currentPageIndex = 0;
  // ignore: prefer_typing_uninitialized_variables
  var currentPageObj;

  @override
  void initState() {
    currentPageObj = bottomNavBarItemBodies[currentPageIndex];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 245, 245, 1.0)
      , bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed
        , currentIndex: currentPageIndex
        , items: bottomNavBarItems
        , onTap: (index) {
          setState(() {
            currentPageIndex = index;
            currentPageObj   = bottomNavBarItemBodies[currentPageIndex];
          });
        }
      )
      , body: currentPageObj
    );
  }
}