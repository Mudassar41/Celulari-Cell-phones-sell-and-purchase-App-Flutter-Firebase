import 'package:cloud_firestore/cloud_firestore.dart';

class Views{


  Timestamp Time;
  String DocID;

  Views(this.Time, this.DocID);

  Views.fromMap(Map<String, dynamic> data) {
    Time = data['Time'];
    DocID=data['DocID'];}
}