import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';
import 'package:pressfame_new/Screens/editprofile1.dart';
import 'package:pressfame_new/Screens/followersScreen.dart';
import 'package:pressfame_new/Screens/followingScreen.dart';
import 'package:pressfame_new/Screens/viewPublicPost.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  bool back;
  Profile({this.back});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  List newProjectList = [];

  bool isInView = false;
  List<Widget> myTabs = [];
  String totalPost = '0';
  @override
  void initState() {
    getTotalPost();
    myTabs = [
      Tab(text: 'Posts'),
      Tab(text: 'Projects'),
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getTotalPost() {
    cloud.FirebaseFirestore.instance
        .collection('post')
        .where("idFrom", isEqualTo: globalID)
        .get()
        .then((sanp) {
      if (mounted)
        setState(() {
          totalPost = sanp.docs.length.toString();
        });
    });
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
            "",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: widget.back != null
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: appColorBlack,
                  ))
              : Container(),
        ),
        body: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[600], width: 1),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: CircleAvatar(
                            backgroundImage: globalImage.length > 0
                                ? NetworkImage(globalImage)
                                : NetworkImage(
                                    "${"https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png"}"),
                            radius: 45,
                          ),
                        ),
                      ),
                      _buildCategory("Posts", totalPost),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowingScreen()),
                            );
                          },
                          child: _buildCategory(
                              "Following", globalrFollowing.length.toString())),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FollowersScreen()),
                          );
                        },
                        child: _buildCategory(
                            "Followers", globalrFollowers.length.toString()),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    globalName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appColorBlack),
                  ),
                ),
                SizedBox(height: 3),
                globalBio.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          globalBio,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: appColorBlack),
                        ),
                      )
                    : Container(),
                globalWeb.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Linkable(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 16),
                          text: globalWeb,
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfile()));
                          },
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[600]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Text(
                                "Edit Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: appColorBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: "Poppins-Medium"),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(child: _userInfo()),
          ],
        ));
  }

  Widget _userInfo() {
    return myPost();
  }

  Widget _buildCategory(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: appColorBlack),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
              color: appColorBlack, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget myPost() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: StreamBuilder(
          stream: cloud.FirebaseFirestore.instance
              .collection('post')
              .where("idFrom", isEqualTo: globalID)
              //.orderBy('timestamp', descending: true)
              //.limit(limit)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(appColor)));
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: GridView.builder(
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  padding: EdgeInsets.all(5),
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 200 / 200,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewPublicPost(
                                      id: snapshot.data.docs[index]
                                          ['timestamp'])),
                            );
                          },
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
                            imageUrl:
                                snapshot.data.docs[index]['videoUrl'].length > 0
                                    ? snapshot.data.docs[index]['videoUrl']
                                    : snapshot.data.docs[index]['content'],
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
