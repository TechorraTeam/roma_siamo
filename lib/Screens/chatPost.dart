import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/Screens/viewPublicPost.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

// ignore: must_be_immutable
class ChatPost extends StatefulWidget {
  String id;
  ChatPost({this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ChatPost> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child:
          Scaffold(backgroundColor: Colors.transparent, body: allPost(context)),
    );
  }

  Widget allPost(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('post')
          .doc(widget.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(appColor)));
        } else {
          return postDetails(snapshot.data);
        }
      },
    );
  }

  Widget postDetails(DocumentSnapshot document) {
    return GestureDetector(
      onTap: () {
        if (document['idFrom'] != globalID)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PublicProfile(peerId: document['idFrom'])),
          );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
          borderRadius: BorderRadius.all(
              Radius.circular(25.0) //                 <--- border radius here
              ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: document['userImage'].length > 0
                        ? NetworkImage(document['userImage'])
                        : NetworkImage(
                            "https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png"),
                    radius: 20,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 4,
                  ),
                  Expanded(
                    child: Text(
                      document['userName'],
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          fontFamily: "Poppins-Medium",
                          color: appColorGreen),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.grey[500],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 2,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewPublicPost(id: document['timestamp'])),
                );
              },
              child: Stack(
                children: <Widget>[
                  Container(
                      height: SizeConfig.blockSizeVertical * 35,
                      width: SizeConfig.screenWidth,
                      child: Image.network(
                        document['videoUrl'].length > 0
                            ? document['videoUrl']
                            : document['content'],
                        fit: BoxFit.cover,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 5, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: document['userName'],
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontStyle: FontStyle.normal,
                                  color: appColorGreen,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: " " + document["caption"],
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 3.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
