import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:celulari/Models/Order.dart';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}



class _NotificationsState extends State<Notifications> {
  DatabaseProvider _databaseProvider;

  FirebaseAuth auth;
  User user;
  String currentUserId;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        currentUserId = null;
        print('User is currently signed out!');
      } else {
        auth = FirebaseAuth.instance;
        user = auth.currentUser;
        currentUserId = user.uid;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _databaseProvider = Provider.of<DatabaseProvider>(
      context,
    );
    return WillPopScope(
      onWillPop: () {
        print("some function will execute");
        updateNotification();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Color(0xFF00a651),
          title: Text(
            "Njoftimet",
            style:
                TextStyle(fontFamily: 'Libre Baskerville', color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: _databaseProvider.GetOrder(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data[index].buyerId == currentUserId &&
                        snapshot.data[index].confirmCheck == null &&
                        snapshot.data[index].returnedCheck == null) {
                      return Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: ScreenSize.imageSizeMultiplier * 16,
                                  width: ScreenSize.imageSizeMultiplier * 16,
                                  child: Stack(children: [
                                    Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    Container(
                                        decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0)),
                                      image: new DecorationImage(
                                        image: new NetworkImage(
                                            snapshot.data[index].orderImage),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                  ]),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Modeli",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                          Flexible(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              snapshot.data[index].modelName
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Qmimi",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                          Flexible(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '${snapshot.data[index].modelPrice}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          )),
                                          Icon(
                                            Icons.euro,
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  //
                                                  _databaseProvider.Confirm(
                                                      snapshot
                                                          .data[index].orderId,
                                                      snapshot.data[index]
                                                          .sellerId);
                                                },
                                                child: Text(
                                                  'Prano',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  //
                                                  _databaseProvider.Return(
                                                      snapshot
                                                          .data[index].orderId,
                                                      snapshot.data[index]
                                                          .sellerId);
                                                },
                                                child: Text(
                                                  'Kthe',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ));
                    } else if (snapshot.data[index].sellerId == currentUserId &&
                        snapshot.data[index].confirmCheck == null &&
                        snapshot.data[index].returnedCheck == null) {
                      return Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    child: Center(
                                        child: Icon(
                                      Icons.notifications,
                                      color: CustomColors.red,
                                    )),
                                    height: ScreenSize.heightMultiplier * 5,
                                    width: ScreenSize.heightMultiplier * 5,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00a651),
                                        border: Border.all(
                                            color: Color(0xFF00a651), width: 2),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                            text: "Celulari i juaj ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      ' ${snapshot.data[index].modelName} ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontFamily:
                                                          'Libre Baskerville')),
                                              TextSpan(
                                                  text:
                                                      'ëshë shitur, mirëpo blerësi ka kohë 3 ditë për ta kthyer tek ju.'),
                                            ])),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    } else if (snapshot.data[index].buyerId == currentUserId &&
                        snapshot.data[index].confirmCheck == 'yes' &&
                        snapshot.data[index].returnedCheck == null) {
                      return Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: ScreenSize.imageSizeMultiplier * 16,
                                  width: ScreenSize.imageSizeMultiplier * 16,
                                  child: Stack(children: [
                                    Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    Container(
                                        decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0)),
                                      image: new DecorationImage(
                                        image: new NetworkImage(
                                            snapshot.data[index].orderImage),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                  ]),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Modeli",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                          Flexible(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              snapshot.data[index].modelName
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Qmimi",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                          Flexible(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '${snapshot.data[index].modelPrice}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          )),
                                          Icon(
                                            Icons.euro,
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                      OutlineButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Kryer ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ));
                    } else if (snapshot.data[index].buyerId == currentUserId &&
                        snapshot.data[index].confirmCheck == null &&
                        snapshot.data[index].returnedCheck == 'yes') {
                      return Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: ScreenSize.imageSizeMultiplier * 16,
                                  width: ScreenSize.imageSizeMultiplier * 16,
                                  child: Stack(children: [
                                    Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    Container(
                                        decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0.0)),
                                      image: new DecorationImage(
                                        image: new NetworkImage(
                                            snapshot.data[index].orderImage),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                  ]),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Modeli",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                          Flexible(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              snapshot.data[index].modelName
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Qmimi",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                          Flexible(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '${snapshot.data[index].modelPrice}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          )),
                                          Icon(
                                            Icons.euro,
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                      OutlineButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Kthyer',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ));
                    } else if (snapshot.data[index].sellerId == currentUserId &&
                        snapshot.data[index].confirmCheck == 'yes' &&
                        snapshot.data[index].returnedCheck == null) {
                      return Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    child: Center(
                                        child: Icon(
                                      Icons.notifications,
                                      color: CustomColors.red,
                                    )),
                                    height: ScreenSize.heightMultiplier * 5,
                                    width: ScreenSize.heightMultiplier * 5,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00a651),
                                        border: Border.all(
                                            color: Color(0xFF00a651), width: 2),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                            text: "Urime ! ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            children: [
                                              TextSpan(
                                                text: 'Celualri juaj ',
                                              ),
                                              TextSpan(
                                                  text:
                                                      ' ${snapshot.data[index].modelName} ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontFamily:
                                                          'Libre Baskerville')),
                                              TextSpan(text: 'u shit'),
                                            ])),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    } else if (snapshot.data[index].sellerId == currentUserId &&
                        snapshot.data[index].confirmCheck == null &&
                        snapshot.data[index].returnedCheck == 'yes') {
                      return Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    child: Center(
                                        child: Icon(
                                      Icons.notifications,
                                      color: CustomColors.red,
                                    )),
                                    height: ScreenSize.heightMultiplier * 5,
                                    width: ScreenSize.heightMultiplier * 5,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00a651),
                                        border: Border.all(
                                            color: Color(0xFF00a651), width: 2),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                          text:
                                              "${snapshot.data[index].buyerName.toUpperCase()} ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                          children: [
                                            TextSpan(
                                              text: 'dëshiron te kthej',
                                            ),
                                            TextSpan(
                                                text:
                                                    ' ${snapshot.data[index].modelName} ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    fontFamily:
                                                        'Libre Baskerville')),
                                            TextSpan(text: 'tek ju'),
                                          ])),
                                ),
                              ],
                            ),
                          ));
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error);
              }
              return Center(child: CupertinoActivityIndicator());
            },
          ),
        ),
      ),
    );
  }

  // getTokenz() async {
  //   String token = await _fcm.getToken();
  //   print('token is $token');
  // }
  //
  // Future _showNotification(Map<String, dynamic> message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     'channel id',
  //     'channel name',
  //     'channel desc',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   var platformChannelSpecifics =
  //       new NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'new message arived',
  //     'i want ${message['notification']['title']} for ${message['notification']['body']}',
  //     platformChannelSpecifics,
  //     payload: 'Default_Sound',
  //   );
  // }
  //
  // Future selectNotification(String payload) async {
  //   await flutterLocalNotificationsPlugin.cancelAll();
  // }

  void updateNotification() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('Orders').getDocuments();
    snapshot.documents.forEach((document) async {
      if (document.data()['sellerNotification'] == currentUserId) {
        String orderId = document.data()['orderId'];
        CollectionReference foodRef = Firestore.instance.collection('Orders');
        await foodRef
            .document(orderId)
            .update({
              'sellerNotification': 'delete',
            })
            .then((value) {})
            .catchError((error) {});
      }
    });
  }
}
