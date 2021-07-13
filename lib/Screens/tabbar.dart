import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/chat_list.dart';
import 'package:pressfame_new/Screens/home.dart';
import 'package:pressfame_new/Screens/photo.dart';
import 'package:pressfame_new/Screens/profile.dart';
import 'package:pressfame_new/Screens/search_new.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  Widget currentPage = Home();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    currentTab = 0;
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    _selectTab(widget.currentTab);

    super.initState();
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = Home();
          break;
        case 1:
          widget.currentPage = SerchFeed();
          break;
        case 2:
          widget.currentPage = PhotoScreen();
          break;
        case 3:
          widget.currentPage = ChatList();
          break;
        case 4:
          widget.currentPage = Profile();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: widget.scaffoldKey,
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: appColorBlack,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: appColorGrey,
          currentIndex: widget.currentTab,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.house,
                size: 25,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.search,
                size: 25,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeVertical * 5,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    //  color: Color(0xFFFFC7A4D5),
                    borderRadius: BorderRadius.circular(100.0),
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/PressfameSmall.png'),
                    //   fit: BoxFit.fitWidth,
                    // ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                        'assets/images/insta.png',
                        height: 25,
                        width: 25,
                      ))
                    ],
                  ),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: msgIcon(context),
              // new Icon(
              //   CupertinoIcons.bell,
              //   size: 25,
              // ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: globalImage != null && globalImage.length > 0
                  ? Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 4.5,
                        width: SizeConfig.blockSizeVertical * 4.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          image: DecorationImage(
                            image: NetworkImage(globalImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      CupertinoIcons.person_crop_circle,
                      size: 30,
                    ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
