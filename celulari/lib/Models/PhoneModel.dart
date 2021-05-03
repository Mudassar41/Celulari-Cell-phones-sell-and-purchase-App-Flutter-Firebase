import 'package:cloud_firestore/cloud_firestore.dart';

class Phone {
  String Docid;
  String Model;
  int Price;
  String Des;
  Timestamp Time;
  String phone;
  List Urls;
  String Uid;
  String Location;
  String Os;
  int priceFrom;
  int Priceto;

  // Phone(this.Urls);
  Phone();

  Phone.fromMap(Map<String, dynamic> data) {
    Docid = data['Docid'];
    Location = data['Location'];
    Model = data['Model'];
    Os = data['Os'];
    phone = data['Phone'];
    Price = data['Price'];
    Time = data['Time'];
    Uid = data['Uid'];
    Urls = data['Urls'];
    Des = data['Des'];
  }
}
