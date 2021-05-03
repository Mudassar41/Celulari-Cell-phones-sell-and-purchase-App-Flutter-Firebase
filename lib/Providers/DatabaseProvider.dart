import 'dart:convert';

import 'package:celulari/Models/Order.dart';
import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Models/UserModel.dart';
import 'package:celulari/Models/Views.dart';
import 'package:celulari/Utills/CustomToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/src/asset.dart';
import 'package:http/http.dart' as http;

class DatabaseProvider extends ChangeNotifier {
  Future<String> AddDataToDatabase(
      List imag,
      String title,
      int price,
      String description,
      String phoneNO,
      String location,
      String os,
      String Uid) async {
    String res = '';
    print(imag);
    Fluttertoast.showToast(
        msg: "Ju lutem prisni….",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    List imageUrls = [];
    print(imag.length);
    for (int i = 0; i < imag.length; i++) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Phone/$fileName');
      StorageUploadTask uploadTask =
          reference.putData((await imag[i].getByteData()).buffer.asUint8List());
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String urls = await storageTaskSnapshot.ref.getDownloadURL();

      imageUrls.add(urls);
    }
    if (imageUrls != null) {
      print('$imageUrls  URLS ARE BELW');
      Timestamp time = Timestamp.now();
      String collectionRef = 'PhoneData';
      String docId =
          Firestore.instance.collection(collectionRef).document().documentID;
      var docRef = Firestore.instance.collection(collectionRef).document(docId);
      await docRef.set({
        'Model': title,
        'Docid': docId,
        "Time": time,
        'Price': price,
        'Phone': phoneNO,
        'Location': location,
        'Os': os,
        'Urls': imageUrls,
        'Uid': Uid,
        'Des': description
      }, SetOptions(merge: true)).then((value) {
        Fluttertoast.showToast(
            msg: "Celulari u Shpall",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        res = 'Celulari u Shpall';
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: "Unable to Add Phone",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        res = 'Unable to Add Phone';
      });

      notifyListeners();
      return res;
    }

    print(imageUrls);
  }

  Future<List<Phone>> GetAllPhones() async {
    List<Phone> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection('PhoneData')
        .orderBy("Time", descending: true)
        .getDocuments();
    snapshot.documents.forEach((document) {
      Phone phone = Phone.fromMap(document.data());
      list.add(phone);
    });
    //   print(list.length);
    return list;
  }

  Future<List<Phone>> GetSearch(Phone phone) async {
    if (phone.Model == '' || phone.Model == null) {
      phone.Model = null;
    }
    print('Model is ${phone.Model}');
    print('Price From ${phone.priceFrom}');
    print('Price To ${phone.Priceto}');
    print('OS is ${phone.Os}');

    String os = phone.Os;
    List<Phone> list = [];
    if (phone.Model != null &&
        phone.Os == null &&
        phone.priceFrom == null &&
        phone.Priceto == null &&
        phone.Os == null) {
      print("1=> Models is runing");
      String incomingText = phone.Model;

      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        String txt = document.data()['Model'];

        if (txt.toLowerCase().contains(incomingText.toLowerCase())) {
          list.add(phone);
        }
      });
    }

    //END OF FIRST CASE

    else if (phone.priceFrom != null &&
        phone.Priceto != null &&
        phone.Model == null &&
        phone.Os == null) {
      print("2=> price is runing");
      int x = phone.priceFrom;
      int y = phone.Priceto;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        if (Price >= x && Price <= y) {
          list.add(phone);
        }
      });
      //END OF 2ND CASE
    } else if (phone.Os != null &&
        phone.priceFrom == null &&
        phone.Priceto == null &&
        phone.Model == null) {
      print("3=> Os is runing ");
      String OsText = phone.Os;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .where("Os", isEqualTo: OsText)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        list.add(phone);
      });
    }
    //END OF 3RD  CASE
    else if (phone.priceFrom != null &&
        phone.Priceto == null &&
        phone.Model == null &&
        phone.Os == null) {
      int x = phone.priceFrom;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        if (Price >= x) {
          list.add(phone);
        }
      });
    }
    //END OF 4th Case
    else if (phone.priceFrom == null &&
        phone.Priceto != null &&
        phone.Model == null &&
        phone.Os == null) {
      int x = phone.Priceto;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        if (Price <= x) {
          list.add(phone);
        }
      });
    }
//END OF 5TH CASE

    else if (phone.Model != null &&
        phone.Priceto != null &&
        phone.priceFrom != null &&
        phone.Os == null) {
      int x = phone.priceFrom;
      int y = phone.Priceto;
      String Model = phone.Model;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        String model = document.data()['Model'];
        if (model.toLowerCase().contains(Model.toLowerCase()) &&
            Price >= x &&
            Price <= y) {
          list.add(phone);
        }
      });
    }
    //END OF 6TH CASE

    else if (phone.Model != null &&
        phone.priceFrom != null &&
        phone.Os == null &&
        phone.Priceto == null) {
      String Model = phone.Model;
      int x = phone.priceFrom;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        String model = document.data()['Model'];
        if (model.toLowerCase().contains(Model.toLowerCase()) && Price >= x) {
          list.add(phone);
        }
      });
    }
//END OF 7TH CASE
    else if (phone.Model != null &&
        phone.priceFrom == null &&
        phone.Os == null &&
        phone.Priceto != null) {
      String Model = phone.Model;
      int x = phone.Priceto;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        String model = document.data()['Model'];
        if (model.toLowerCase().contains(Model.toLowerCase()) && Price <= x) {
          list.add(phone);
        }
      });
    }
    //END OF 8TH CASE

    else if (phone.Model != null &&
        phone.priceFrom == null &&
        phone.Os != null &&
        phone.Priceto == null) {
      String Model = phone.Model;
      String Os = phone.Os;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        String os = document.data()['Os'];
        String model = document.data()['Model'];
        if (model.toLowerCase().contains(Model.toLowerCase()) && Os == os) {
          list.add(phone);
        }
      });
    }
    //END OF 9TH CASE
    else if (phone.Model == null &&
        phone.priceFrom != null &&
        phone.Priceto != null &&
        phone.Os != null) {
      int x = phone.priceFrom;
      int y = phone.Priceto;
      String OS = phone.Os;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int Price = document.data()['Price'];
        String os = document.data()['Os'];
        if (OS == os && Price >= x && Price <= y) {
          list.add(phone);
        }
      });
    }

    //END OF 10TH CASE
    else if (phone.priceFrom != null &&
        phone.Os != null &&
        phone.Model == null &&
        phone.Priceto == null) {
      String Os = phone.Os;
      int x = phone.priceFrom;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int os = document.data()['Os'];
        int Price = document.data()['Price'];
        if (Os == os && Price >= x) {
          list.add(phone);
        }
      });
    }
//END OF 11CASE
    else if (phone.priceFrom == null &&
        phone.Os != null &&
        phone.Model == null &&
        phone.Priceto != null) {
      String Os = phone.Os;
      int x = phone.Priceto;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        int os = document.data()['Os'];
        int Price = document.data()['Price'];
        if (Os == os && Price <= x) {
          list.add(phone);
        }
      });
    }
    //END OF 12CASE

    else if (phone.Model != null &&
        phone.priceFrom != null &&
        phone.Priceto != null &&
        phone.Os == null) {
      String Model = phone.Model;
      int x = phone.priceFrom;
      int y = phone.Priceto;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        String model = document.data()['Model'];
        int Price = document.data()['Price'];
        if (model.toLowerCase().contains(Model.toLowerCase()) &&
            Price >= x &&
            Price <= y) {
          list.add(phone);
        }
      });
    }
    //END OF 13CASE
    else if (phone.Model != null &&
        phone.priceFrom != null &&
        phone.Priceto != null &&
        phone.Os != null) {
      String Model = phone.Model;
      int x = phone.priceFrom;
      int y = phone.Priceto;
      String Os = phone.Os;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        String model = document.data()['Model'];
        String os = document.data()['Os'];
        int Price = document.data()['Price'];
        if (model.toLowerCase().contains(Model.toLowerCase()) &&
            Price >= x &&
            Price <= y &&
            Os == os) {
          list.add(phone);
        }
      });
    }
    //
    else if (phone.Model != null &&
        phone.priceFrom != null &&
        phone.Priceto == null &&
        phone.Os != null) {
      String Model = phone.Model;
      int x = phone.priceFrom;
      int y = phone.Priceto;
      String Os = phone.Os;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        String model = document.data()['Model'];
        String os = document.data()['Os'];
        int Price = document.data()['Price'];
        if (model.toLowerCase().contains(Model.toLowerCase()) &&
            Price >= x &&
            Os == os) {
          list.add(phone);
        }
      });
    } else if (phone.Model != null &&
        phone.priceFrom == null &&
        phone.Priceto != null &&
        phone.Os != null) {
      String Model = phone.Model;
      int x = phone.priceFrom;
      int y = phone.Priceto;
      String Os = phone.Os;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Price", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());
        String model = document.data()['Model'];
        String os = document.data()['Os'];
        int Price = document.data()['Price'];
        if (model.toLowerCase().contains(Model.toLowerCase()) &&
            Price <= y &&
            Os == os) {
          list.add(phone);
        }
      });
    } else if (phone.Os == null &&
        phone.Model == null &&
        phone.priceFrom == null &&
        phone.Priceto == null) {
      QuerySnapshot snapshot = await Firestore.instance
          .collection('PhoneData')
          .orderBy("Time", descending: true)
          .getDocuments();
      snapshot.documents.forEach((document) {
        Phone phone = Phone.fromMap(document.data());

        list.add(phone);
      });
    }

    return list;
  }

  Future<List<UserModel>> GetMembersData(String Id) async {
    //print(Id);
    List<UserModel> UserList = [];

    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc.data().containsKey('Uid')) {
                  if (doc['Uid'] == Id) {
                    print("USER ID IS MATCHED ${doc['Uid']}");
                    UserModel Userdata = UserModel.fromMap(doc.data());
                    UserList.add(Userdata);
                  }
                }
              })
            });

    // QuerySnapshot snapshot =
    //     await Firestore.instance.collection('Users').getDocuments();
    // List<UserModel> UserList = [];
    // snapshot.documents.forEach((document) {
    //   UserModel Userdata = UserModel.fromMap(document.data());
    //
    //   if (document.data().containsKey('token') ||
    //       document.data().containsKey('Uid')) {
    //     print("yes");
    //     // print(Id);
    //    // print(document.data()['Uid']);
    //     if (document.data()['Uid'] == Id) {
    //       print('YES HERE IS ${document.data()['Uid']}');
    //       UserList.add(Userdata);
    //     }
    //   }
    // });
    // //   print(UserList.length);
    return UserList;
  }

  Future<List<Phone>> GetMemberPhones(String id) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('PhoneData')
        .orderBy("Time", descending: true)
        .getDocuments();

    List<Phone> UserList = [];

    snapshot.documents.forEach((document) {
      Phone Userdata = Phone.fromMap(document.data());
      if (document.data()['Uid'] == id) {
        UserList.add(Userdata);
      }
    });
    // print(UserList.length);
    return UserList;
  }

  Future<void> Deldata(String id, List urls) async {
    CustomToast.showToastMessage("Ju lutem prisni….");

    await Firestore.instance.collection('PhoneData').document(id).delete();
    for (int i = 0; i < urls.length; i++) {
      StorageReference storageReference =
          await FirebaseStorage.instance.getReferenceFromUrl(urls[i]);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
    notifyListeners();
  }

  Future<String> UpdateData(
      List<Asset> images,
      String title,
      int price,
      String description,
      String phoneNO,
      String location,
      String os,
      String id) async {
    String res = '';
    CustomToast.showToastMessage("Ju lutem prisni….");

    List imageUrls = [];
    //  print(imag.length);
    for (int i = 0; i < images.length; i++) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Phone/$fileName');
      StorageUploadTask uploadTask = reference
          .putData((await images[i].getByteData()).buffer.asUint8List());
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String urls = await storageTaskSnapshot.ref.getDownloadURL();

      imageUrls.add(urls);
    }
    if (imageUrls != null) {
      print('$imageUrls  URLS ARE BELW');
      Timestamp time = Timestamp.now();
      String collectionRef = 'PhoneData';
      String docId =
          Firestore.instance.collection(collectionRef).document().documentID;
      var docRef = Firestore.instance.collection(collectionRef).document(docId);
      await docRef.set({
        'Model': title,
        'Docid': docId,
        "Time": time,
        'Price': price,
        'Phone': phoneNO,
        'Location': location,
        'Os': os,
        'Urls': imageUrls,
        'Uid': id,
        'Des': description
      }, SetOptions(merge: true)).then((value) {
        CustomToast.showToastMessage("Phone Updated");

        res = 'Phone Updated';
      }).catchError((error) {
        CustomToast.showToastMessage("Unable to Update Phone");

        res = 'Unable to Update Phone';
      });
      notifyListeners();
      return res;
    }
  }

  Future<void> deleteStorage(List urls) async {
    for (int i = 0; i < urls.length; i++) {
      StorageReference storageReference =
          await FirebaseStorage.instance.getReferenceFromUrl(urls[i]);

      print(storageReference.path);

      await storageReference.delete();

      print('image deleted');
    }
  }

  Future<void> deletefirestore(String docid) async {
    await Firestore.instance.collection('PhoneData').document(docid).delete();
  }

  Future<void> UpdateFirestore(
      String id,
      String _title,
      int _price,
      String _description,
      String _phoneNO,
      String _location,
      String _os) async {
    Timestamp _updatedtime = Timestamp.now();
    CollectionReference foodRef = Firestore.instance.collection('PhoneData');
    await foodRef.document(id).update({
      'Model': _title,
      'Price': _price,
      'Phone': _phoneNO,
      'Location': _location,
      'Os': _os,
      'Des': _description,
      'Time': _updatedtime
    }).then((value) {
      CustomToast.showToastMessage('Phone Updated');
    }).catchError((error) {
      CustomToast.showToastMessage('Unable to Update Phone');
    });

    notifyListeners();
  }

  Future<void> CountnoOfViews(String DocID) async {
    Timestamp time = Timestamp.now();
    String collectionRef = 'Views';
    String docId = await Firestore.instance
        .collection(collectionRef)
        .document()
        .documentID;
    var docRef = Firestore.instance.collection(collectionRef).document(docId);
    docRef.set({
      'DocId': DocID,
      'Time': time,
    });
    notifyListeners();
  }

  Future<int> Getcounter(String DocId) async {
    Timestamp time;
    DateTime currentTime = DateTime.now();

    List<Views> list = [];
    QuerySnapshot snapshot =
        await Firestore.instance.collection('Views').getDocuments();
    snapshot.documents.forEach((document) {
      Views phone = Views.fromMap(document.data());
      if (document.data()['DocId'] == DocId) {
        time = document.data()['Time'];
        if (currentTime.difference(time.toDate()).inHours <= 24) {
          list.add(phone);
        }
      }
    });
    return list.length;
  }

  Future<String> AddOredr(Order order) async {
    String res = '';

    CustomToast.showToastMessage("Ju lutem prisni….");

    Timestamp time = Timestamp.now();
    String collectionRef = 'Orders';
    String docId =
        Firestore.instance.collection(collectionRef).document().documentID;
    var docRef = Firestore.instance.collection(collectionRef).document(docId);

    order.orderId = docId;
    order.orderDate = time;
    await docRef.set({
      'orderDate': order.orderDate,
      'orderId': order.orderId,
      'buyerId': order.buyerId,
      'buyerName': order.buyerName,
      "buyerCity": order.buyerCity,
      'buyerStreet': order.buyerStreet,
      'buyerPhone': order.buyerPhone,
      'phoneId': order.phoneId,
      'sellerId': order.sellerId,
      'returnedCheck': order.returnedCheck,
      'confirmCheck': order.confirmCheck,
      'orderImage': order.orderImage,
      'modelName': order.modelName,
      'modelPrice': order.modelPrice,
      'sellerNotification': order.sellerNotification,
      'buyerNotification': order.buyerNotification,
    }, SetOptions(merge: true)).then((value) {
      res = 'Order Added';
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Unable to Add Phone",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      res = 'Unable to Add Phone';
    });

    // notifyListeners();
    return res;
  }

  Future<List<Order>> GetOrder(String currentUserId) async {
    // print('user id is $currentUserId');
    List<Order> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection('Orders')
        .orderBy('orderDate', descending: true)
        .getDocuments();
    snapshot.documents.forEach((document) async {
      Order phone = Order.fromMap(document.data());
      list.add(phone);
    });
    notifyListeners();
    return list;
  }

  Future<void> Confirm(String DocId, String sellerId) async {
    Timestamp time = Timestamp.now();
    CollectionReference foodRef = Firestore.instance.collection('Orders');
    await foodRef.document(DocId).update({
      'confirmCheck': 'yes',
      'orderDate': time,
      'sellerNotification': sellerId
    }).then((value) {
      CustomToast.showToastMessage('ju keni konfirmuaj porosinë tuaj');
      sendNotificationToSeller(sellerId);
      //ALSO SEND TO ADMIN//
      //CODE HERE//
      sendNotificationToAdmin();
    }).catchError((error) {
      CustomToast.showToastMessage('Error Please try again');
    });

    //notifyListeners();
  }

  Future<void> Return(String DocId, String sellerId) async {
    Timestamp time = Timestamp.now();
    CollectionReference foodRef = Firestore.instance.collection('Orders');
    await foodRef.document(DocId).update({
      'orderDate': time,
      'returnedCheck': 'yes',
      'sellerNotification': sellerId
    }).then((value) {
      CustomToast.showToastMessage('ju keni konfirmuaj porosinë tuaj');
      sendNotificationToSeller(sellerId);
      //ALSO SEND TO ADMIN//
      //CODE HERE//
      sendNotificationToAdmin();
    }).catchError((error) {
      CustomToast.showToastMessage('Error Please try again');
    });

    //  notifyListeners();
  }

  Future<bool> getSoldOutOnly(String DocID) async {
    // print(DocID);
    bool orderPlacedCheck;
    await FirebaseFirestore.instance
        .collection('Orders')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                // print(doc["phoneId"]);
                String PhoneDocid = doc["phoneId"];
                String returnedCheck = doc['returnedCheck'];
                if (PhoneDocid == DocID && returnedCheck == null) {
                  orderPlacedCheck = true;
                  notifyListeners();
                }
              })
            });

    return orderPlacedCheck;
  }

  Future<void> sendNotificationToSeller(String sellerId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                //  String Uid = doc["Uid"];
                if (doc.data().containsKey('Uid')) {
                  if (sellerId == doc["Uid"]) {
                    if (doc['token'] != null) {
                      print("Sending Notification to token=>  ${doc['token']}");

                      String userDeviceToken = doc['token'];
                      sendNotificationtoTken(userDeviceToken);
                    }
                  }
                }
              })
            });
  }

  Future<void> sendNotificationtoTken(receiver) async {
    var postUrl = "https://fcm.googleapis.com/fcm/send";
    final data = {
      "notification": {
        "body": "view on Notification's screen",
        "title": "New Notification"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$receiver"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAjYvTaOg:APA91bH2YrFdwGruoRCHBrurbtJZtgUD-gcHde6p-Htzu2kpDxcZsc9xnZksXutdyyM4gcZeSX35-J_eSdpGpnUYJp9H5NT_AYRTM297rUTUkB4Da6zT54gVskI8hlkuzbs8JJLr4mCa'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);
      if (response.statusCode == 200) {
        print("sent");
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print('exception $e');
    }
  }

  Future<int> GetNotifications(String currentUserId) async {
    int x = 0;
    await FirebaseFirestore.instance
        .collection('Orders')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc["sellerNotification"] == currentUserId) {
                  x++;
                }
              })
            });

    // QuerySnapshot snapshot =
    // await Firestore.instance.collection('Orders').getDocuments();
    // snapshot.documents.forEach((document) async {
    //   Order phone = Order.fromMap(document.data());
    //   if (document.data()['sellerNotification'] == currentUserId) {
    //     x++;
    //   }
    // });
    notifyListeners();
    return x;
  }

  Future<void> sendNotificationToAdmin() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc["Email"] == "admin@gmail.com") {
                  if (doc['token'] != null) {
                    print("Sending Notification to Admin=>  ${doc['token']}");

                    String userDeviceToken = doc['token'];
                    sendNotificationtoTkenAdmin(userDeviceToken);
                  }
                }
              })
            });
  }

  Future<void> sendNotificationtoTkenAdmin(String userDeviceToken) async {
    var postUrl = "https://fcm.googleapis.com/fcm/send";
    final data = {
      "notification": {
        "body": "view on Notification's screen",
        "title": "Admin Notification"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$userDeviceToken"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAjYvTaOg:APA91bH2YrFdwGruoRCHBrurbtJZtgUD-gcHde6p-Htzu2kpDxcZsc9xnZksXutdyyM4gcZeSX35-J_eSdpGpnUYJp9H5NT_AYRTM297rUTUkB4Da6zT54gVskI8hlkuzbs8JJLr4mCa'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);
      if (response.statusCode == 200) {
        print("sent");
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print('exception $e');
    }
  }
}
