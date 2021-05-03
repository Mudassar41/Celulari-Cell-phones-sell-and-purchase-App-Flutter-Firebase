import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  Timestamp orderDate;
  String orderId;
  String buyerId;
  String buyerName;
  String buyerCity;
  String buyerPhone;
  String phoneId;
  String buyerStreet;
  String sellerId;
  String purchasedCheck;
  String returnedCheck;
  String confirmCheck;
  String orderImage;
  String modelName;
  int modelPrice;
  String sellerNotification;
  String buyerNotification;

  Order();

  Order.fromMap(Map<String, dynamic> data) {
    orderDate=data['orderDate'];
    orderId = data['orderId'];
    buyerId = data['buyerId'];
    buyerName = data['buyerName'];
    buyerCity = data['buyerCity'];
    buyerPhone = data['buyerPhone'];
    phoneId = data['phoneId'];
    buyerStreet = data['buyerStreet'];
    sellerId = data['sellerId'];
    returnedCheck = data['returnedCheck'];
    confirmCheck = data['confirmCheck'];
    orderImage = data['orderImage'];
    modelName = data['modelName'];
    modelPrice = data['modelPrice'];
    sellerNotification=data['sellerNotification'];
    buyerNotification=data['buyerNotification'];
  }
}
