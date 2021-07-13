import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<FollowingScreen> {
  TextEditingController controller = new TextEditingController();

  final node = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorWhite,
          elevation: 0,
          title: Text(
            "Supporting",
            style: TextStyle(
                fontSize: 20,
                color: appColorBlack,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: appColorBlack,
              )),
        ),
        body: _bodyWidget());
  }

  Widget _searchTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: Container(
          height: SizeConfig.blockSizeVertical * 5,
          child: Center(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                if (value != null) {
                  setState(() {});
                }
              },
              style: TextStyle(color: Colors.black),
              focusNode: node,
              decoration: new InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20),
                filled: false,
                hintStyle: new TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                hintText: "Search",
                fillColor: appColorGrey,
                prefixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.search,
                      color: appColorGrey,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: appColorBlack, width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: appColorBlack, width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _searchTextfield(context),
          Container(height: 10),
          ListView.builder(
            itemCount: globalrFollowing.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, int index) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc(globalrFollowing[index])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return controller.text.isNotEmpty &&
                            snapshot.data["name"]
                                .toLowerCase()
                                .contains(controller.text.toLowerCase())
                        ? dataWidget(snapshot.data)
                        : controller.text.isEmpty
                            ? dataWidget(snapshot.data)
                            : Container();
                  }
                  return Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CupertinoActivityIndicator(),
                        ]),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget dataWidget(lists) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
          child: Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: appColorWhite,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  node.unfocus();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PublicProfile(
                            peerId: lists["userId"],
                          )),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 20, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          lists["img"].length > 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey[600], width: 0),
                                      shape: BoxShape.circle),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(lists["img"]),
                                    radius: 26,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Image.asset(
                                      "assets/images/name.png",
                                      height: 22,
                                      color: appColorWhite,
                                    ),
                                  ),
                                ),
                          Container(width: 20),
                          Text(
                            lists["name"],
                            style: TextStyle(
                                color: appColorBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // globalrFollowing.contains(lists["userId"])
                    //     ? Container(
                    //         height: 33,
                    //         child: CustomOutLineButtom(
                    //           color: appColorWhite,
                    //           borderRadius: BorderRadius.circular(30),
                    //           title: 'Following',
                    //           fontColor: appColorPurple,
                    //           fontSize: 13,
                    //           fontWeight: FontWeight.bold,
                    //           onPressed: () {
                    //             unFollowFunction(lists["userId"]);
                    //           },
                    //         ),
                    //       )
                    //     : Container(
                    //         height: 33,
                    //         width: 85,
                    //         child: CustomButtom(
                    //           color: appColorPurple,
                    //           borderRadius: BorderRadius.circular(30),
                    //           title: 'Follow',
                    //           fontColor: appColorWhite,
                    //           fontSize: 13,
                    //           fontWeight: FontWeight.bold,
                    //           onPressed: () {
                    //             followFunction(lists["userId"]);
                    //           },
                    //         ),
                    //       )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            height: 1,
            color: Colors.grey[400],
          ),
        )
      ],
    );
  }

  followFunction(peerId) {
    setState(() {
      var ids = globalrFollowing;
      ids.add(peerId);
      globalrFollowing = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "following": FieldValue.arrayUnion([peerId])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection("user").doc(peerId).set({
        "followers": FieldValue.arrayUnion([globalID])
      }, SetOptions(merge: true));
    });
  }

  unFollowFunction(peerId) {
    setState(() {
      var ids = globalrFollowing;
      ids.remove(peerId);
      globalrFollowing = ids.toSet().toList();
    });

    FirebaseFirestore.instance.collection("user").doc(globalID).set({
      "following": FieldValue.arrayRemove([peerId])
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance.collection("user").doc(peerId).set({
        "followers": FieldValue.arrayRemove([globalID])
      }, SetOptions(merge: true));
    });
  }
}
