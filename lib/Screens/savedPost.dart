import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/viewPublicPost.dart';
import 'package:pressfame_new/constant/global.dart';

class SavedPost extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<SavedPost> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorWhite,
          elevation: 2,
          title: Text(
            "Saved",
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
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
          child: dataWidget(),
        ));
  }

  Widget dataWidget() {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(0),
      itemCount: globalrBookmarkList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 200,
      ),
      itemBuilder: (BuildContext context, int index) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("post")
              .doc(globalrBookmarkList[index])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.exists)
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPublicPost(
                                  id: snapshot.data['timestamp'])),
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
                        imageUrl: snapshot.data['videoUrl'].length > 0
                            ? snapshot.data['videoUrl']
                            : snapshot.data['content'],
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                      )),
                );
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
    );
  }
}
