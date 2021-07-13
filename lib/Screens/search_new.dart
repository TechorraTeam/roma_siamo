import 'dart:async';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/Screens/viewPublicPost.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SerchFeed extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<SerchFeed>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = new TextEditingController();
  bool isLoading = false;
  int limit = 10;
  ScrollController listScrollController = ScrollController();
  FocusNode focus = new FocusNode();
  RegExp exp = new RegExp(r"\B#\w\w+");
  List allList;
  TabController tabController;

  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    print("Focus: " + focus.hasFocus.toString());
  }

  void _onTap() {
    setState(() {
      focus.hasFocus;
      print("Ontap: " + focus.hasFocus.toString());
    });
    FocusScope.of(context).requestFocus(focus);
  }

  @override
  void dispose() {
    focus.dispose();
    tabController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    if (mounted)
      setState(() {
        isLoading = true;
        fetchData();
      });
  }

  fetchData() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, onResponse);
  }

  void onResponse() {
    if (mounted)
      setState(() {
        isLoading = false;
        limit = limit + 2;
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColorWhite,
        elevation: 0,
        title: _searchTextfield(context),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          focus.hasFocus == true
              ? Container(
                  width: 80,
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          _searchResult.clear();
                          controller.clear();
                          focus.unfocus();
                        });
                      },
                      icon: Text(
                        "Cancel",
                        maxLines: 1,
                        style: TextStyle(
                            color: appColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )),
                )
              : Container(),
              // Container(
              //     width: 80,
              //     child: IconButton(
              //         padding: const EdgeInsets.all(0),
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => Search()),
              //           );
              //         },
              //         icon: Text(
              //           "Accounts",
              //           maxLines: 1,
              //           style: TextStyle(
              //               color: appColorBlack,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 14),
              //         )),
              //   ),
          Container(width: 10),
        ],
      ),
      body: focus.hasFocus == true
          ? NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: TabBar(
                      controller: tabController,
                      labelColor: appColorBlack,
                      // indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: appColorBlack,
                      tabs: [
                        Tab(icon: Text("Tags")),
                        Tab(icon: Text("Accounts")),
                      ],
                    ),
                  ),
                ];
              },
              body: Container(
                child: TabBarView(
                  controller: tabController,
                  children: <Widget>[_userInfo(), _serachuser()],
                ),
              ),
            )
          : _userInfo(),
    );
  }

  Widget _userInfo() {
    listScrollController = new ScrollController()..addListener(_scrollListener);
    return Stack(
      children: [
        SingleChildScrollView(
            controller: listScrollController,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: allPost()),
        isLoading
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColorBlack,
                    ),
                    child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(appColorWhite))),
              )
            : Container(),
      ],
    );
  }

  Widget _searchTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.green,
              borderRadius: new BorderRadius.all(
                Radius.circular(15.0),
              )),
          height: 40,
          child: InkWell(
            onTap: _onTap,
            child: Container(
              color: appColorWhite,
              child: IgnorePointer(
                child: TextField(
                  controller: controller,
                  onChanged: onSearchTextChanged,
                  focusNode: focus,
                  style: TextStyle(color: Colors.grey),
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey[200]),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey[200]),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey[200]),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    filled: true,
                    hintStyle:
                        new TextStyle(color: Colors.grey[600], fontSize: 14),
                    hintText: "Search",
                    contentPadding: EdgeInsets.only(top: 10.0),
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 25.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget allPost() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .orderBy('timestamp', descending: true)
              .limit(limit)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(appColor)));
            } else {
              allList = snapshot.data.docs;
              return _searchResult.length != 0 ||
                      controller.text.trim().toLowerCase().isNotEmpty
                  ? StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: _searchResult.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 3 : 2),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (BuildContext context, int index) =>
                          details(_searchResult[index]))
                  : focus.hasFocus == true
                      ? Container()
                      : StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) =>
                              details(snapshot.data.docs[index]));
            }
          },
        ));
  }

  Widget details(DocumentSnapshot document) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewPublicPost(id: document['timestamp'])),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CupertinoActivityIndicator(),
                    width: 35.0,
                    height: 35.0,
                    padding: EdgeInsets.all(10.0),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['videoUrl'].length > 0
                      ? document['videoUrl']
                      : document['content'],
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
              )),
        ));
  }

  Widget _serachuser() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
          padding: const EdgeInsets.only(left: 22, top: 0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("user").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                userList = snapshot.data.docs;
                return _searchUserResult.length > 0
                    ? ListView.builder(
                        itemCount: _searchUserResult.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          return allUserWidget(_searchUserResult, index);
                        },
                      )
                    : Container();
              }
            },
          )),
    );
  }

  Widget allUserWidget(lists, index) {
    return lists[index]["userId"] == globalID
        ? Container()
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PublicProfile(peerId: lists[index]["userId"])),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            lists[index]["img"].length > 0
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(lists[index]["img"]),
                                    radius: 28,
                                  )
                                : Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.asset(
                                        "assets/images/name.png",
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                    )),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  lists[index]["name"],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: appColorBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                          ],
                        ),
                        Container(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.work,
                                color: Colors.grey[600],
                                size: 22,
                              ),
                              Container(width: 5),
                              Expanded(
                                child: Text(
                                  lists[index]["bio"],
                                  style: TextStyle(
                                    color: appColorBlack,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[600],
                                size: 22,
                              ),
                              Container(width: 3),
                              Expanded(
                                child: Text(
                                  lists[index]["city"] +
                                      ", " +
                                      lists[index]["state"] +
                                      ", " +
                                      lists[index]["country"],
                                  style: TextStyle(
                                    color: appColorBlack,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 20, top: 5, bottom: 5),
                          child: Container(
                            height: 1,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    _searchUserResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    allList.forEach((postDetail) {
      // if (userDetail['projectTitle']
      //     .toLowerCase()
      //     .contains(text.toLowerCase())) {
      //   _searchResult.add(userDetail);
      // }
      exp.allMatches(postDetail['caption'].toLowerCase()).forEach((match) {
        print(match.group(0));

        if (match.group(0).contains(text.toLowerCase())) {
          var newResult = [];
          newResult.add(postDetail);
          _searchResult = newResult.toSet().toList();
        }
      });
    });

    userList.forEach((userListNew) {
      if (userListNew['name'].toLowerCase().contains(text.toLowerCase())) {
        _searchUserResult.add(userListNew);
      }
    });

    setState(() {});
  }
}

List _searchResult = [];

List _searchUserResult = [];
