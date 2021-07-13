import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

// ignore: must_be_immutable
class SharePostScrren extends StatefulWidget {
  DocumentSnapshot document;
  SharePostScrren({this.document});
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<SharePostScrren> {
  TextEditingController controller = new TextEditingController();
  bool isLoading = false;
  final node = FocusNode();
  var getUserList = [];

  //selected user data
  var _isSelectedPeerID = [];
  var _isSelectedPeerName = [];
  var _isSelectedPeerUrl = [];
  var _isSelectedPeerToken = [];

  @override
  void initState() {
    getUserList.addAll(globalrFollowing);
    getUserList.addAll(globalrFollowers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Send Post",
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
          actions: [
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                if (_isSelectedPeerID.isNotEmpty) {
                  prepareMessage();
                }
              },
              icon: Text(
                "Send",
                style: TextStyle(
                    color: appColorBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(width: 15)
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(child: _bodyWidget()),
            isLoading == true ? Center(child: loader()) : Container()
          ],
        ));
  }

  Widget _textfield(BuildContext context) {
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
    return Column(
      children: [
        _textfield(context),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: getUserList.toSet().toList().length,
          itemBuilder: (BuildContext context, int index) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .doc(getUserList.toSet().toList()[index])
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
                return Container();
              },
            );
          },
        )
      ],
    );
  }

  Widget dataWidget(lists) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              if (_isSelectedPeerID.contains(lists["userId"])) {
                _isSelectedPeerID.remove(lists["userId"]);
                _isSelectedPeerName.remove(lists["name"]);
                _isSelectedPeerUrl.remove(lists["img"]);
                _isSelectedPeerToken.remove(lists["token"]);
              } else {
                _isSelectedPeerID.add(lists["userId"]);
                _isSelectedPeerName.add(lists["name"]);
                _isSelectedPeerUrl.add(lists["img"]);
                _isSelectedPeerToken.add(lists["token"]);
              }
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10),
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
                _isSelectedPeerID.contains(lists["userId"])
                    ? Icon(
                        Icons.check_circle,
                        color: appColorBlack,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        color: appColorGrey,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  prepareMessage() {
    for (var i = 0; i < _isSelectedPeerID.length; i++) {
      onSendMessage(_isSelectedPeerID[i], _isSelectedPeerName[i],
          _isSelectedPeerUrl[i], _isSelectedPeerToken[i], widget.document);
    }

    setState(() {
      isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PagesWidget()),
    );
  }
}

Future<void> onSendMessage(String peerID, String peerName, String peerUrl,
    String peerToken, DocumentSnapshot document) async {
  String groupChatId = '';
  int badgeCount = 0;
  var dareTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();

  if (globalID.hashCode <= peerID.hashCode) {
    groupChatId = '$globalID-$peerID';
  } else {
    groupChatId = '$peerID-$globalID';
  }

  var documentReference = FirebaseFirestore.instance
      .collection('messages')
      .doc(groupChatId)
      .collection(groupChatId)
      .doc(dareTimeStamp);

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(
      documentReference,
      {
        'idFrom': globalID,
        'idTo': peerID,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': document['timestamp'],
        'type': 2
      },
    );
  }).then((onValue) async {
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(globalID)
        .collection(globalID)
        .doc(peerID)
        .set({
      'id': peerID,
      'name': peerName,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': 'Sent a post',
      'badge': '0',
      'profileImage': peerUrl,
      'type': 2,
    }).then((onValue) async {
      try {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(peerID)
            .collection(peerID)
            .doc(globalID)
            .get()
            .then((doc) async {
          debugPrint(doc["badge"]);
          if (doc["badge"] != null) {
            badgeCount = int.parse(doc["badge"]);
            await FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerID)
                .collection(peerID)
                .doc(globalID)
                .set({
              'id': globalID,
              'name': globalName,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': 'Sent a post',
              'badge': '${badgeCount + 1}',
              'profileImage': globalImage,
              'type': 2,
            });
          }
        });
      } catch (e) {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(peerID)
            .collection(peerID)
            .doc(globalID)
            .set({
          'id': globalID,
          'name': globalName,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': 'Sent a post',
          'badge': '${badgeCount + 1}',
          'profileImage': globalImage,
          'type': 2,
        });
        print(e);
      }
    });
  });
}
