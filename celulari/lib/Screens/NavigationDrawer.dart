import 'dart:io';

import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Models/SqliteModel.dart';
import 'package:celulari/Providers/AuthProvider.dart';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:celulari/Providers/LikeProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Services/SqliteService.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:provider/provider.dart';
import 'AutologinCheck.dart';
import 'PhoneDetail.dart';

class NavigationDrawerPage extends StatefulWidget {
  @override
  _NavigationDrawerPageState createState() => _NavigationDrawerPageState();
}

class _NavigationDrawerPageState extends State<NavigationDrawerPage> {
  AuthProvider authProvider;
  DatabaseProvider databaseProvider;
  var height, width;
  final formKey = GlobalKey<FormState>();
  String osSelected = "Gjithat";
  String _showSearch = 'No';
  Phone _phone = new Phone();
  Future<List<Phone>> tasks;
  User user;
  SqliteService _sqliteService = SqliteService();
  SqliteModel _sqliteModel = SqliteModel();
  LikeProvider _likeProvider;
  dynamic onlyLike;
  FirebaseAuth auth;
  String Id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Id = null;
        print('User is currently signed out!');
      } else {
        auth = FirebaseAuth.instance;
        user = auth.currentUser;
        Id = user.uid;
        print(Id);
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);
    _likeProvider = Provider.of<LikeProvider>(context);
    // _sqliteService.Getdata(_likeProvider);
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                " Filterat",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Libre Baskerville'),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFF00a651),
              elevation: 0,
            ),
            body: SafeArea(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search), labelText: 'kërko'),
                        onSaved: (String input) => _phone.Model = input,
                        initialValue:
                            (_phone.Model != null && _phone.Model != '')
                                ? _phone.Model
                                : null,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(
                        "Qmimi",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00a651)),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: 'Prej'),
                                initialValue: (_phone.priceFrom != null &&
                                        _phone.priceFrom != 0)
                                    ? _phone.priceFrom.toString()
                                    : null,
                                onSaved: (input) {
                                  (input != null && input != '')
                                      ? _phone.priceFrom = int.parse(input)
                                      : _phone.priceFrom = null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: 'Deri '),
                                initialValue: (_phone.Priceto != null &&
                                        _phone.Priceto != 0)
                                    ? _phone.Priceto.toString()
                                    : null,
                                onSaved: (input) {
                                  (input != null && input != '')
                                      ? _phone.Priceto = int.parse(input)
                                      : _phone.Priceto = null;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(
                        "OS",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff34ba4e)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  osSelected = "Gjithat";
                                  _phone.Os = null;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: osSelected == "Gjithat"
                                        ? Colors.grey
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                child: Center(
                                    child: Text(
                                  "Gjithat",
                                  style: TextStyle(
                                    color: osSelected == "Gjithat"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  osSelected = "Android";
                                  _phone.Os = osSelected;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: osSelected == "Android"
                                        ? Colors.grey
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                child: Center(
                                    child: Text(
                                  "Android",
                                  style: TextStyle(
                                    color: osSelected == "Android"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  osSelected = "IOS";
                                  _phone.Os = osSelected;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: osSelected == "IOS"
                                        ? Colors.grey
                                        : Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                child: Center(
                                    child: Text(
                                  "IOS",
                                  style: TextStyle(
                                    color: osSelected == "IOS"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton.icon(
                            color: Color(0xFF00a651),
                            textColor: Colors.white,
                            label: Text("Kërko"),
                            icon: Icon(Icons.search),
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                setState(() {
                                  _showSearch = 'Yes';
                                });
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF00a651),
        title: Text(
          'Celulari',
          style: TextStyle(
            fontFamily: 'Libre Baskerville',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () async {
              User user = await authProvider.getCurrentUser();

              print('$user current user');

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AutologinCheck()),
              );
              // Navigator.of(context).pushNamed('Login');
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: _showSearch == 'No'
                ? databaseProvider.GetAllPhones()
                : databaseProvider.GetSearch(_phone),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.length == 0
                    ? Center(
                        child: Icon(
                          Icons.error,
                          size: ScreenSize.imageSizeMultiplier * 8,
                          color: Colors.red,
                        ),
                      )
                    : GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        gridDelegate: XSliverGridDelegate(
                          crossAxisCount: 2,
                          smallCellExtent: ScreenSize.heightMultiplier * 35,
                          bigCellExtent: ScreenSize.heightMultiplier * 35,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            shadowColor: CustomColors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 5,
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhoneDetail(
                                          Name: snapshot.data[index].Model,
                                          Des: snapshot.data[index].Des,
                                          Price: snapshot.data[index].Price,
                                          Images: snapshot.data[index].Urls,
                                          Phone: snapshot.data[index].phone,
                                          Time: snapshot.data[index].Time,
                                          Os: snapshot.data[index].Os,
                                          Location:
                                              snapshot.data[index].Location,
                                          Uid: Id,
                                          PhoneUid: snapshot.data[index].Uid,
                                          Docid: snapshot.data[index].Docid)),
                                );

                                databaseProvider.CountnoOfViews(
                                    snapshot.data[index].Docid);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: ScreenSize.imageSizeMultiplier * 25,
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: [
                                        Center(
                                            child:
                                                CupertinoActivityIndicator()),
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                                image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                        .data[index].Urls[0]),
                                                    fit: BoxFit.cover))),
                                        Positioned(
                                          left: 5,
                                          top: 5,
                                          child: Id == null
                                              ? Text("")
                                              : FutureBuilder<bool>(
                                                  future:
                                                      _sqliteService.Likedonly(
                                                          snapshot.data[index]
                                                              .Docid),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<bool>
                                                              snapshot) {
                                                    return snapshot.data == true
                                                        ? Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white54,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  CustomColors
                                                                      .red,
                                                            ),
                                                          )
                                                        : Container();
                                                  }),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data[index].Model,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FutureBuilder<bool>(
                                    future: databaseProvider.getSoldOutOnly(
                                        snapshot.data[index].Docid),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> snapshots) {
                                      return snapshots.data == true
                                          ? Text('E Shitur',
                                              style: TextStyle(
                                                  color: Color(0xffce3846),
                                                  fontWeight: FontWeight.bold))
                                          : Text(
                                              '\€ ${snapshot.data[index].Price}',
                                              style: TextStyle(
                                                  color: Color(0xFF00a651),
                                                  fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
