import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:pressfame_new/Screens/createPost.dart';
import 'package:pressfame_new/constant/global.dart';


// ignore: must_be_immutable
class FilterScreen extends StatefulWidget {
  File image;
  FilterScreen({this.image});
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<FilterScreen> {
  String fileName;
  List<Filter> filters = presetFiltersList;
  // File imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.image != null) getImage(context);
  }

  Future getImage(context) async {
    //  imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(widget.image.path);
    var image = imageLib.decodeImage(widget.image.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => Container(
          child: new PhotoFilterSelector(
            title: Text(
              "Photo Customization",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            image: image,
            filters: presetFiltersList,
            filename: fileName,
            loader: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey[400]))),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        widget.image = imagefile['image_filtered'];
      });
      print(widget.image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: appColorWhite,
        elevation: 0,
        title: Text(
          "Photo Customization",
          style: TextStyle(
              fontSize: 18, color: appColorBlack, fontWeight: FontWeight.bold),
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
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePost(image: widget.image)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Text(
                'Done',
                style: TextStyle(
                    color: appColorBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: new Container(
          child: widget.image == null
              ? Center(
                  child: new Text('No image selected.'),
                )
              : Image.file(widget.image),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: appColorBlack,
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: new Icon(
          Icons.center_focus_strong,
        ),
      ),
    );
  }
}
