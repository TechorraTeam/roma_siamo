import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  ReportModel(
      {this.reportById,
      this.reportByName,
      this.reportByPic,
      this.postRef,
      this.reportTime,
      this.status,
      this.postByName,
      this.postById,
      this.postByPic,
      this.orderNo,
      this.refrence});

  String reportById;
  String reportByName;
  String reportByPic;
  DocumentReference postRef;
  int reportTime;
  String status;
  String postByName;
  String postById;
  String postByPic;
  DocumentReference refrence;
  int orderNo = 1;

  factory ReportModel.fromDocumentSnapShot(DocumentSnapshot doc) => ReportModel(
      reportById: doc["ReportById"],
      reportByName: doc["ReportByName"],
      reportByPic: doc["ReportByPic"],
      postRef: doc["PostRef"],
      reportTime: doc["ReportTime"],
      status: doc["Status"],
      postByName: doc["PostByName"],
      postById: doc["PostByRef"],
      postByPic: doc["PostByPic"],
      orderNo: doc["OrderNo"],
      refrence: doc.reference);

  Map<String, dynamic> toMap() => {
        "ReportById": reportById,
        "ReportByName": reportByName,
        "ReportByPic": reportByPic,
        "PostRef": postRef,
        "ReportTime": reportTime,
        "Status": status,
        "PostByName": postByName,
        "PostByRef": postById,
        "PostByPic": postByPic,
        "OrderNo": orderNo
      };
}
