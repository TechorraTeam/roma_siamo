import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pressfame_new/Screens/createProfile.dart';
import 'package:pressfame_new/Screens/tabbar.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/Screens/signup.dart';
import 'package:pressfame_new/helper/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:pressfame_new/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'forgotpass.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                // const Color(0xFFC7A4D5),
                // const Color(0xFFB5B7E0),
                Colors.white,
                Colors.white,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: LayoutBuilder(builder: (context, constraint) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      // Padding(
                                      //   padding: const EdgeInsets.only(top: 100),
                                      //   child: Center(child: _appIcon()),
                                      // ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 100),
                                        child: Center(
                                            child: Text(
                                          "Roma Siamo Voi",
                                          style: GoogleFonts.pacifico(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 5,
                                      ),
                                      _emailTextfield(context),
                                      _passwordTextfield(context),
                                      _forgotPassword(),
                                      _loginButton(context),
                                      // _dontHaveAnAccount(context),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            horizontalLine(),
                                            Text("or".tr,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily:
                                                        "Poppins-Medium",
                                                    fontWeight: FontWeight.bold,
                                                    color: fontColorGrey)),
                                            horizontalLine(),
                                          ],
                                        ),
                                      ),
                                      //numberButton(),
                                      if (GetPlatform.isIOS) appleButton(),
                                      googleButton(),
                                      facebookButton(),
                                    ],
                                  ),
                                  isLoading == true
                                      ? Center(child: loader())
                                      : Container(),
                                ],
                              ),
                            )),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    _dontHaveAnAccount(context),
                  ],
                );
              })),
        ),
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          focusNode: emailNode,
          textInputAction: TextInputAction.next,
          controller: emailController,
          hintText: 'enter_email'.tr,
          prefixIcon: Icon(
            Icons.person,
            color: iconColor,
            size: 30.0,
          ),
        ));
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: CustomtextField(
          focusNode: passwordNode,
          maxLines: 1,
          controller: passwordController,
          obscureText: !_obscureText,
          hintText: 'enter_password'.tr,
          prefixIcon: Icon(
            Icons.lock,
            color: iconColor,
            size: 30.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: appColorGrey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ));
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            setState(() {
              emailNode.unfocus();
              passwordNode.unfocus();
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPass()),
            );
          },
          child: Text.rich(
            TextSpan(
              text: 'forgot_your_password'.tr,
              style: TextStyle(
                fontSize: 14,
                color: fontColorBlue,
                fontWeight: FontWeight.normal,
                fontFamily: "Poppins-Medium",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 0, left: 20),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.screenWidth,
          child: CustomButtom(
            title: 'log_in'.tr,
            color: buttonColorBlue,
            onPressed: () {
              if (emailController.text != '' && passwordController.text != '') {
                setState(() {
                  emailNode.unfocus();
                  passwordNode.unfocus();
                  isLoading = true;
                });

                _signInWithEmailAndPassword();
              } else {
                setState(() {
                  emailNode.unfocus();
                  passwordNode.unfocus();
                });
                toast("error".tr, "email_password_required".tr, context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SignUp(),
          ),
        );
      },
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, top: 10, left: 20, bottom: 10),
        child: Text.rich(
          TextSpan(
            text: "dont_have_account".tr,
            style: TextStyle(
              fontSize: 14,
              color: appColorGrey,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'sign_up'.tr,
                style: TextStyle(
                  fontSize: 14,
                  // decoration: TextDecoration.underline,
                  color: fontColorBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
            width: SizeConfig.blockSizeHorizontal * 30,
            height: 2.0,
            color: Colors.grey[300]),
      );

  Widget googleButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
          width: SizeConfig.blockSizeHorizontal * 70,
          margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          child: InkWell(
            onTap: () {
              _signInWithGoogle();
            },
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('assets/images/google.png',
                    height: SizeConfig.blockSizeVertical * 4),
                new Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new Text(
                      "sign_in_google".tr,
                      style: TextStyle(
                          color: fontColorBlue, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )),
    );
  }

  Widget appleButton() {
    return SignInWithAppleButton(
        style: SignInWithAppleButtonStyle.white, onPressed: loginWithApple);
  }

  Widget facebookButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
          width: SizeConfig.blockSizeHorizontal * 70,
          margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          child: InkWell(
            onTap: () {
              loginWithFacebook();
            },
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('assets/images/facebook.png',
                    height: SizeConfig.blockSizeVertical * 4),
                new Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new Text(
                      "sign_in_facebook".tr,
                      style: TextStyle(
                          color: fontColorBlue, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      final User user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      ))
          .user;
      if (user != null) {
        dataEntry(user.uid, user.email);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      toast("error".tr, e.toString(), context);
    }
  }

  dataEntry(userId, email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences
        .setString(SharedPreferencesKey.LOGGED_IN_USERRDATA, userId)
        .then((value) {
      FirebaseMessaging.instance.getToken().then((token) {
        FirebaseFirestore.instance.collection("user").doc(userId).update({
          "token": token,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(userId)
              .get()
              .then((peerData) {
            if (peerData.exists) {
              setState(() {
                isLoading = false;
              });
              if (peerData['bio'].length > 0 && peerData['age'].length > 0) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => PagesWidget(currentTab: 0),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateProfile(userId: userId),
                  ),
                );
              }
            } else {
              setState(() {
                isLoading = false;
              });
              toast("error".tr, 'failed_google'.tr, context);
            }
          });
          //     setState(() {
          //       globalID=userId;
          //       isLoading = false;
          //     });
          //    Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => CreateProfile(userId: userId),
          //   ),
          // );
          // toast("Success", '$email signed in', context);
        });
      });
    });
  }

  // apple login
  loginWithApple() async {
    try {
      setState(() {
        emailNode.unfocus();
        passwordNode.unfocus();
      });
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );
      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;
      if (user.uid != null) {
        checkUserExists(user.uid, user.email ?? '', user.displayName ?? '',
            user.photoURL ?? '');
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => SignUp(),
        //   ),
        // );
      }
    } catch (error) {
      print(error);
      toast("error".tr, 'failed_facebook'.tr, context);
    }
  }

  //Facebook Login
  loginWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    try {
      setState(() {
        emailNode.unfocus();
        passwordNode.unfocus();
      });
      FacebookLoginResult facebookLoginResult =
          await facebookLogin.logIn(['email', 'public_profile']);
      print(facebookLoginResult.errorMessage);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final token = facebookLoginResult.accessToken.token;
          await http.get(Uri.parse(
              'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token'));
          UserCredential userCredential = await _auth.signInWithCredential(
              FacebookAuthProvider.credential(
                  facebookLoginResult.accessToken.token));
          final user = userCredential.user;
          if (user.uid != null) {
            checkUserExists(
                user.uid, user.email, user.displayName, user.photoURL);
          }
          break;

        case FacebookLoginStatus.cancelledByUser:
          return null;
          break;

        case FacebookLoginStatus.error:
          return null;
          break;

        default:
          return null;
          break;
      }
    } catch (e) {
      print(e);
      toast("error".tr, 'failed_facebook'.tr, context);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        emailNode.unfocus();
        passwordNode.unfocus();
        isLoading = true;
      });
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      if (user.uid != null) {
        checkUserExists(user.uid, user.email, user.displayName, user.photoURL);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      toast("error".tr, 'failed_google'.tr, context);
    }
  }

  checkUserExists(userId, email, name, image) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get()
        .then((peerData) {
      if (peerData.exists) {
        dataEntry(userId, email);
      } else {
        dataEntryGoogle(userId, email, name, image);
      }
    });
  }

  dataEntryGoogle(userId, email, name, image) {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection('user').doc(userId).set({
      "name": name,
      "email": email,
      "mobile": '',
      "userId": userId,
      "img": image,
      "token": '',
      "age": '',
      "gender": '',
      "location": '',
      "bio": '',
      "website": '',
      "status": '',
      "privacy": false,
      "followers": [],
      "following": [],
      "bookmark": [],
      "requested": [],
      "bday": '',
      'city': '',
      'country': '',
      'state': '',
    }, SetOptions(merge: true)).then((value) {
      dataEntry(userId, email);
    });
  }
}
