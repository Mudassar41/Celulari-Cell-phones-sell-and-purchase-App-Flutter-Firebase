import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Providers/AuthProvider.dart';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:celulari/Providers/LikeProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Screens/Notification.dart';
import 'package:celulari/Services/SqliteService.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:provider/provider.dart';

import 'AddMobiles.dart';
import 'PageView/Favourites.dart';
import 'PageView/Uploads.dart';
import 'PhoneDetail.dart';
import 'Update.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo>
    with TickerProviderStateMixin {
  String Id;

  AuthProvider authProvider;
  DatabaseProvider databaseProvider;
  FirebaseAuth auth;
  User user;
  Phone phone;
  bool update = true;
  List<String> _buttons = ['Shpalljet', 'Favoritet'];
  int _selectedIndex = 0;
  LikeProvider _likeProvider;
  SqliteService _sqliteService;
  bool isLoading;
  PageController pageController = PageController();
  int _selectedPageIndex = 0;
  List<Widget> _widgets = <Widget>[Uploads(), Favourites()];

  void _onPageChanged(int index) {
    setState(() {
      //  _selectedIndex = index;
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    Id = user.uid;
    print(' Current Id $Id');
   // Updatetoken(Id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(
      context,
    );
    _sqliteService = Provider.of<SqliteService>(
      context,
    );
    databaseProvider = Provider.of<DatabaseProvider>(
      context,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Celulari Profile",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Libre Baskerville',
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xFF00a651),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<int>(
                future: databaseProvider.GetNotifications(Id),
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data != 0
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                " ${snapshot.data} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        : Center(child: Text(""));
                  }
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                },
                // child: Text(
                //   "45",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                },
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              )
            ],
          ),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Shkyqu'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF00a651),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMobiles(ID: Id)),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: databaseProvider.GetMembersData(Id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Center(
                                        child: Text(
                                      snapshot.data[index].firstname[0],
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    height: ScreenSize.heightMultiplier * 14,
                                    width: ScreenSize.heightMultiplier * 14,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00a651),
                                        border: Border.all(
                                            color: Color(0xFF00a651), width: 2),
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "${snapshot.data[index].firstname[0].toUpperCase()}${snapshot.data[index].firstname.substring(1).toLowerCase()}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                  "${snapshot.data[index].lastname[0].toUpperCase()}${snapshot.data[index].lastname.substring(1).toLowerCase()}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(snapshot.data[index].email),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return CupertinoActivityIndicator();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: _buttons.map((e) {
                  int index = _buttons.indexOf(e);
                  return Flexible(
                    child: Card(
                      color: _selectedIndex == index
                          ? Color(0xFF00a651)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // isLoading = true;
                            _selectedIndex = index;
                            _onItemTapped(index);
                            //  _selectedPageIndex=index;
                          });
                        },
                        child: Container(
                          height: 45,
                          child: Center(
                              child: Text(
                            e,
                            style: TextStyle(
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Color(0xFF00a651)),
                          )),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: _onPageChanged,
                  children: _widgets),
            ),
          ],
        ),
      ),
    );
  }

  void handleClick(String value) {
    if (value == 'Shkyqu') {
      print("logout");
      authProvider.signOutUser();
    }
  }

  // void Updatetoken(String currentId) async {
  //   String token = await _fcm.getToken();
  //   String docId;
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) => {
  //             querySnapshot.docs.forEach((doc) async {
  //               if (doc.data().containsKey('Uid')) {
  //                 if (doc["Uid"] == currentId) {
  //                   print('DOCUMENT ID IS => ${doc.id}');
  //                   docId = doc.id;
  //                   if (doc.data().containsKey('token')) {
  //                     print("Updating token");
  //                     CollectionReference foodRef =
  //                         Firestore.instance.collection('Users');
  //                     await foodRef
  //                         .document(docId)
  //                         .update({'token': token})
  //                         .then((value) {})
  //                         .catchError((error) {});
  //                   } else {
  //                     print("Adding token");
  //                     CollectionReference foodRef =
  //                         Firestore.instance.collection('Users');
  //                     await foodRef
  //                         .document(docId)
  //                         .set({'token': token}, SetOptions(merge: true))
  //                         .then((value) {})
  //                         .catchError((error) {});
  //                   }
  //                 }
  //               }
  //             })
  //           });
  //
  //   // QuerySnapshot snapshot =
  //   //     await Firestore.instance.collection('Users').getDocuments();
  //   // snapshot.documents.forEach((document) async {
  //   //   String getDocumentId = document.id;
  //   //   print(getDocumentId);
  //   //   if (document.data()['Uid'] == currentId) {
  //   //
  //   //
  //   //     if(!document.data().containsKey('token')){
  //   //
  //   //       print("Adding token to document");
  //   //     }
  //   //     else{
  //   //
  //   //       print("Updating token");
  //   //       CollectionReference foodRef = Firestore.instance.collection('Users');
  //   //       await foodRef.document(getDocumentId).update({
  //   //         'token': token,
  //   //       }).then((value) {
  //   //         print("Token is updated");
  //   //       }).catchError((error) {});
  //   //
  //   //     }
  //   //
  //   //
  //   //
  //   //   }
  //   // });
  // }
}
