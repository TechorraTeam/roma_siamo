import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/publicProfile.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = new TextEditingController();

  bool isSearch = false;
  bool isSearchData = false;
  bool clearData = false;
  String countryValue;
  String stateValue;
  String gender;
  var gender1 = [
    "Male",
    "Female",
    "Other",
  ];

  String profession;
  var profession1 = [
    "Actor",
    "Singer",
    "Model",
    "Musician",
    "Dancer",
    "Artist",
    "Filmmaker",
    "Writer",
    "Photographer",
    "Producer",
    "Film Crew",
    "Composer",
    "Influencer",
    "Hair and Makeup",
    "Stylist",
    "Animator",
    "Editor",
    "Present"
  ];

  double startAge = 18;
  double endAge = 99;
  RangeValues _age = RangeValues(18, 99);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
          backgroundColor: appColorWhite,
          appBar: AppBar(
            backgroundColor: appColorWhite,
            elevation: 1,
            title: Text(
              "Accounts",
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
          body: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: <Widget>[
                  Container(child: filterWidget(context)),
                  Expanded(
                      child: isSearch == true
                          ? CupertinoActivityIndicator()
                          : _serachuser()),
                ],
              );
            },
          )),
    );
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
                return _searchResult.length > 0 && isSearchData == true
                    ? ListView.builder(
                        itemCount: _searchResult.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          return allUserWidget(_searchResult, index);
                        },
                      )
                    : isSearchData == false
                        ? ListView.builder(
                            itemCount: userList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return allUserWidget(userList, index);
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Center(
                              child: Text("No search found"),
                            ),
                          );
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

  Widget filterWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 43,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 14.0),
                                  contentPadding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 10, right: 15),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: profession,
                                    isDense: true,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Profession',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                      ),
                                    ),
                                    icon: Container(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        profession = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: profession1.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          item,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13),
                                        ),
                                        value: item,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(width: 5),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Age:  ${startAge.round().toString()}-${endAge.round().toString()}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                          showValueIndicator: ShowValueIndicator.always),
                      child: RangeSlider(
                        values: _age,
                        min: 18,
                        max: 99,
                        labels: RangeLabels('${_age.start.round()}' + " yrs",
                            '${_age.end.round()}' + " yrs"),
                        inactiveColor: Colors.grey,
                        activeColor: Colors.green,
                        onChanged: (RangeValues values) {
                          setState(() {
                            _age = values;
                            startAge = _age.start;
                            endAge = _age.end;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 43,
                  child: TextField(
                    controller: controller,
                    //onChanged: onSearchTextChanged,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      filled: false,
                      hintStyle:
                          new TextStyle(color: appColorGrey, fontSize: 13),
                      hintText: "Search by Name",
                      fillColor: Colors.grey[300],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 10),
              Expanded(
                child: Container(
                  height: 43,
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 14.0),
                                  contentPadding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 10, right: 15),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: gender,
                                    isDense: true,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: Text(
                                        'Gender',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                      ),
                                    ),
                                    icon: Container(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        gender = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: gender1.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          item,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13),
                                        ),
                                        value: item,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(height: 5),
          clearData == false
              ? CSCPicker(
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  showCities: false,
                  showStates: true,
                  dropdownItemStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  dropdownHeadingStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  selectedItemStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: appColorWhite,
                      border: Border.all(color: Colors.grey, width: 1)),
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: appColorWhite,
                      border: Border.all(color: Colors.grey, width: 1)),
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      // cityValue = value;
                    });
                  },
                )
              : Container(
                  height: 43,
                  child: Center(child: const CupertinoActivityIndicator()),
                ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 43,
                  child: CustomButtom(
                    title: 'SEARCH',
                    color: Colors.black45,
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                        isSearchData = true;
                      });
                      onSearchTextChanged();
                    },
                  ),
                ),
              ),
              Container(width: 10),
              Expanded(
                child: SizedBox(
                  height: 43,
                  child: CustomButtom(
                    title: 'CLEAR FILTERS',
                    color: Colors.black45,
                    onPressed: () {
                      setState(() {
                        clearData = true;
                        isSearchData = false;
                        _searchResult.clear();
                        isSearch = true;
                        _age = RangeValues(18, 99);
                        profession = null;
                        startAge = 18;
                        endAge = 99;
                        controller.clear();
                        gender = null;
                        countryValue = null;
                        stateValue = null;
                      });
                      startTime();
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 20, top: 10, bottom: 5),
            child: Container(
              height: 1,
              color: Colors.grey[400],
            ),
          )
        ],
      ),
    );
  }

  onSearchTextChanged() async {
    setState(() {
      _searchResult.clear();
    });
    startTime();

    userList.forEach((userDetail) {
      if (userDetail['name'] != null) if (userDetail['name']
              .toLowerCase()
              .contains(controller.text.toLowerCase()) &&
          userDetail['gender'].contains(gender != null ? gender : "") &&
          userDetail['bio'].contains(profession != null ? profession : "") &&
          userDetail['country']
              .contains(countryValue != null ? countryValue : "") &&
          userDetail['state'].contains(stateValue != null ? stateValue : "") &&
          startAge <= double.parse(userDetail['age']) &&
          double.parse(userDetail['age']) <= endAge)
        _searchResult.add(userDetail);
    });

    setState(() {
      print(_searchResult);
    });
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    setState(() {
      isSearch = false;
      clearData = false;
    });
  }
}

List _searchResult = [];
