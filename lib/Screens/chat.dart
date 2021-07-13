import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pressfame_new/Notification/notification.dart';
import 'package:pressfame_new/Screens/chatPost.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'color_utils.dart';
import 'package:pressfame_new/constant/global.dart';

class Chat extends StatefulWidget {
  final String peerID;
  final String peerUrl;
  final String peerName;

  Chat({
    @required this.peerID,
    this.peerUrl,
    @required this.peerName,
  });

  @override
  _ChatState createState() =>
      _ChatState(peerID: peerID, peerUrl: peerUrl, peerName: peerName);
}

class _ChatState extends State<Chat> {
  final String peerID;
  final String peerUrl;
  final String peerName;

  _ChatState({@required this.peerID, this.peerUrl, @required this.peerName});

  String groupChatId;
  var listMessage;
  File imageFile;
  bool isLoading;
  String imageUrl;
  int limit = 20;
  String peerToken;
  String peerCode;

  final TextEditingController textEditingController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  TextEditingController reviewCode = TextEditingController();
  TextEditingController reviewText = TextEditingController();
  // ignore: unused_field
  GiphyGif _gif;
  final textFieldFocusNode = FocusNode();

  @override
  void initState() {
    getPeerToken();
    super.initState();

    groupChatId = '';
    isLoading = false;

    imageUrl = '';

    readLocal();
    removeBadge();
    setState(() {});
  }

  removeBadge() async {
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(globalID)
        .collection(globalID)
        .doc(peerID)
        .get()
        .then((doc) async {
      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(globalID)
            .collection(globalID)
            .doc(peerID)
            .update({'badge': '0'});
      }
    });
  }

  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
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
    setState(() {
      isLoading = false;
      limit = limit + 20;
    });
  }

  readLocal() {
    if (globalID.hashCode <= peerID.hashCode) {
      groupChatId = '$globalID-$peerID';
    } else {
      groupChatId = '$peerID-$globalID';
    }

    // Firestore.instance
    //     .collection('users')
    //     .document(widget.currentuser)
    //     .updateData({'chattingWith': peerID});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    listScrollController = new ScrollController()..addListener(_scrollListener);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Material(
            elevation: 1,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: appColorWhite),
                  width: MediaQuery.of(context).size.width,
                  height: SizeConfig.blockSizeVertical * 12,
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => GroupInfo(
                          //           groupName: widget.peerName,
                          //           groupKey: widget.peerID,
                          //           ids: groupUsersId,
                          //           imageMedia: imageMedia,
                          //           videoMedia: videoMedia,
                          //           docsMedia: docsMedia)),
                          // );
                        },
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: appColorBlue,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            peerUrl.length > 0
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      foregroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          new NetworkImage(peerUrl),
                                    ),
                                  )
                                : Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        "assets/images/groupuser.png",
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                    )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      peerName,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "MontserratBold",
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 15,
                            ),
                            Container(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  // image: DecorationImage(
                  //   image: AssetImage(
                  //     "assets/images/img.png",
                  //   ),
                  //   fit: BoxFit.fill,
                  //   alignment: Alignment.topCenter,
                  //   colorFilter: new ColorFilter.mode(
                  //       Colors.grey.withOpacity(0.7), BlendMode.dstATop),
                  // ),
                ),
                child: Column(
                  children: <Widget>[
                    // List of messages

                    buildListMessage(),

                    // Input content
                    buildInput(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: isLoading
                  ? Container(
                      padding: EdgeInsets.all(5),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey[200])))
                  : Container(),
            ),
          ],
        ));
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(appColor)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(appColor)));
                } else {
                  listMessage = snapshot.data.docs;
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0), //(x,y)
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data.docs[index]),
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        controller: listScrollController,
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  Future getImage() async {
    File _image;

    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
        _image = File(imageFile.path);
      });
      final dir = await getTemporaryDirectory();
      final targetPath = dir.absolute.path +
          "/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

      await FlutterImageCompress.compressAndGetFile(
        _image.absolute.path,
        targetPath,
        quality: 20,
      ).then((value) async {
        print("Compressed");
        UploadTask task = await uploadFile2(value);

        TaskSnapshot storageTaskSnapshot = await task;

        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          imageUrl = downloadUrl;
          setState(() {
            isLoading = false;
            onSendMessage(imageUrl, 1);
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
        });
      });
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == globalID) {
      // Right (my message)
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              document['type'] == 0
                  // Text
                  ? Container(
                      child: Text(
                        document['content'],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 20.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                          color: HexColor("#e1cbe7"),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                          right: 10.0),
                    )
                  : document['type'] == 2
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                              height: SizeConfig.blockSizeHorizontal * 95,
                              width: SizeConfig.blockSizeHorizontal * 70,
                              child: ChatPost(
                                id: document['content'],
                              )),
                        )
                      : Container(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(appColor),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Text("Not Avilable"),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document['content'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              imagePreview(
                                document['content'],
                              );
                            },
                            padding: EdgeInsets.all(0),
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          isLastMessageRight(index)
              ? Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(document['timestamp']))),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal),
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                )
              : Container()
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 13),
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 15.0, 20.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: HexColor("#c4d1ec"),
                            // border: Border.all(color: Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document['type'] == 2
                        ? Padding(
                            padding: const EdgeInsets.only(),
                            child: Container(
                                height: SizeConfig.blockSizeHorizontal * 95,
                                width: SizeConfig.blockSizeHorizontal * 70,
                                child: ChatPost(
                                  id: document['content'],
                                )),
                          )
                        : Container(
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          appColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Text("Not Avilable"),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                imagePreview(document['content']);
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontStyle: FontStyle.normal),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == globalID) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != globalID) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    int badgeCount = 0;
    print(content);
    print(content.trim());
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': globalID,
            'idTo': peerID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
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
          'content': content,
          'badge': '0',
          'profileImage': peerUrl,
          'type': type
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
                  'content': content,
                  'badge': '${badgeCount + 1}',
                  'profileImage': globalImage,
                  'type': type
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
              'content': content,
              'badge': '${badgeCount + 1}',
              'profileImage': globalImage,
              'type': type
            });
            print(e);
          }
        });
      });

      sendNotification(peerToken, content);
    } else {}
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        margin: safeQueries(context) ? EdgeInsets.only(bottom: 25) : null,
        child: Row(
          children: <Widget>[
            // Button send image
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 1.0),
                child: new IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    getImage();
                  },
                  // color: primaryColor,
                ),
              ),
              color: Colors.white,
            ),

            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  focusNode: textFieldFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        setState(() {
                          textFieldFocusNode.unfocus();
                          textFieldFocusNode.canRequestFocus = false;
                        });

                        GiphyGif gif = await GiphyGet.getGif(
                          context: context,
                          apiKey:
                              "5O0S0RL6CRLQj3Ch8wnTFctv7lswZt0G", //YOUR API KEY HERE
                          lang: GiphyLanguage.spanish,
                        );

                        if (gif != null) {
                          setState(() {
                            _gif = gif;

                            onSendMessage(gif.images.original.url, 1);
                            print(gif.images.original.url);
                          });
                        }
                      },
                      child: Container(
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.fitHeight,
                          child: IconTheme(
                            data: IconThemeData(),
                            child: Icon(
                              Icons.gif,
                              color: appColorBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),

                  // focusNode: focusNode,
                ),
              ),
            ),

            // Button send message
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: new IconButton(
                  icon: new Icon(
                    Icons.send,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    onSendMessage(textEditingController.text, 0);
                  },
                  // color: primaryColor,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
        decoration: new BoxDecoration(
            border:
                new Border(top: new BorderSide(color: Colors.grey, width: 0.7)),
            color: Colors.white),
      ),
    );
  }

  imagePreview(String url) {
    return showDialog(
      context: context,
      builder: (_) => Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 10, right: 10, bottom: 100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: PhotoView(
                  imageProvider: NetworkImage(url),
                ),
              ),
            ),
          ),
          //buildFilterCloseButton(context),
        ],
      ),
    );
  }

  Widget buildFilterCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.black.withOpacity(0.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  getPeerToken() async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(peerID)
        .get()
        .then((peerData) {
      if (peerData.exists) {
        if (mounted)
          setState(() {
            peerToken = peerData['name'];
          });
      }
    });
  }
}
