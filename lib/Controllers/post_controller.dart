import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pressfame_new/constant/global.dart';

class PostController extends GetxController {
  List blockedUsers = [];
  List allImagesList = [];
  bool blockedUserFetched = false;

  getBlockUser() async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) async {
      if (value != null) {
        print(value.data());
        blockedUsers = value.get('blockedUsers');
      }
    });
    blockedUserFetched = true;
    update();
  }

  getPostImages() async {
    QuerySnapshot snapshots =
        await FirebaseFirestore.instance.collection('post').get();
    allImagesList.clear();
    snapshots.docs.forEach((element) {
      if (blockedUserFetched &&
          !element["hideBy"].contains(globalID) &&
          !blockedUsers.contains(element["idFrom"])) {
        allImagesList.add(element);
      }
    });
    update();
  }
}
