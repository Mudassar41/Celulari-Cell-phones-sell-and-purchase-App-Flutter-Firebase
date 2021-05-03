import 'package:celulari/Models/Icons.dart';
import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Models/SqliteModel.dart';
import 'package:celulari/Providers/AuthProvider.dart';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:celulari/Providers/LikeProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Screens/PhotosDetail.dart';
import 'package:celulari/Services/SqliteService.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:celulari/Utills/CustomToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'BuyPage.dart';

class PhoneDetail extends StatefulWidget {
  final String Name;
  final String Des;
  final int Price;
  final List Images;
  final String Phone;
  final Timestamp Time;
  final String Os;
  final String Location;
  final String Uid;
  final String PhoneUid;
  final String Docid;

  PhoneDetail(
      {Key key,
      this.Name,
      this.Des,
      this.Price,
      this.Images,
      this.Phone,
      this.Time,
      this.Os,
      this.Location,
      this.Uid,
      this.Docid,
      this.PhoneUid})
      : super(key: key);

  @override
  _PhoneDetailState createState() => _PhoneDetailState();
}

class _PhoneDetailState extends State<PhoneDetail> {
  int _selectedindex = 0;
  PageController pageController = PageController();
  SqliteService _sqliteService = SqliteService();
  SqliteModel _sqliteModel = SqliteModel();
  LikeProvider _likeProvider;
  DatabaseProvider _databaseProvider;
  FirebaseAuth auth;
  User user;
  String Id;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Id = null;
        print('User is currently signed out!');
      } else {
        auth = FirebaseAuth.instance;
        user = auth.currentUser;
        Id = user.uid;
        //  print(Id);
        // print('User is signed in!');
        //   checkAutoStartManager(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _likeProvider = Provider.of<LikeProvider>(context);
    _databaseProvider = Provider.of<DatabaseProvider>(context);
    //  _sqliteService.isQuoteisLiked(widget.Docid, _likeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Të Dhënat'),
        backgroundColor: Color(0xFF00a651),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Card(
            elevation: 5,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: ScreenSize.imageSizeMultiplier * 40,
                    child: PageView(
                      physics: BouncingScrollPhysics(),
                      onPageChanged: (val) {
                        setState(() {
                          _selectedindex = val;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      children: [
                        for (int i = 0; i < widget.Images.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhotosDetail(
                                            Image: widget.Images[i])));
                              },
                              child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.green, width: 2),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  elevation: 5,
                                  child: Stack(children: [
                                    Center(child: CupertinoActivityIndicator()),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            ScreenSize.imageSizeMultiplier * 40,
                                        child: Image.network(
                                          "${widget.Images[i]}",
                                          fit: BoxFit.cover,
                                        ))
                                  ])),
                            ),
                          )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: _selectedindex == index
                                ? ScreenSize.heightMultiplier + 6
                                : ScreenSize.heightMultiplier + 2,
                            width: _selectedindex == index
                                ? ScreenSize.heightMultiplier + 6
                                : ScreenSize.heightMultiplier + 2,
                            decoration: BoxDecoration(
                                color: _selectedindex == index
                                    ? CustomColors.green
                                    : Colors.grey,
                                shape: BoxShape.circle),
                          ),
                        );
                      },
                      itemCount: widget.Images.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.green),
                                shape: BoxShape.rectangle),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder<int>(
                                    future: _databaseProvider.Getcounter(
                                        widget.Docid),
                                    builder:
                                        (context, AsyncSnapshot<int> snapshot) {
                                      if (snapshot.hasData) {
                                        return snapshot.data != null
                                            ? Text(
                                                "${snapshot.data} ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text("0 ");
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
                                  Text("Shikime/"),
                                  Text(
                                    "24h",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 2,
                          child: widget.Uid == null
                              ? Text("")
                              : FutureBuilder<bool>(
                                  future: _databaseProvider
                                      .getSoldOutOnly(widget.Docid),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshots) {
                                    return snapshots.data == true
                                        ? Text('')
                                        : InkWell(
                                            splashColor: Colors.white,
                                            onTap: () {
                                              _sqliteModel.phone_id =
                                                  widget.Docid;
                                              print(_sqliteModel.phone_id);
                                              _sqliteService.AddPhoto(
                                                  _sqliteModel);
                                            },
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: Colors.green),
                                                  shape: BoxShape.rectangle),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Text("Like"),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Container(
                                                          color: Colors.green,
                                                          child: Center(
                                                            child: FutureBuilder<
                                                                    bool>(
                                                                future: _sqliteService
                                                                    .Likedonly(
                                                                        widget
                                                                            .Docid),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            bool>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return snapshot.data ==
                                                                            true
                                                                        ? Icon(
                                                                            Icons.favorite,
                                                                            color:
                                                                                CustomColors.red,
                                                                          )
                                                                        : Icon(
                                                                            Icons.favorite,
                                                                            color:
                                                                                Colors.white,
                                                                          );
                                                                  }
                                                                  return CupertinoActivityIndicator();
                                                                }),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                  widget.PhoneUid == Id
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : FutureBuilder<bool>(
                          future:
                              _databaseProvider.getSoldOutOnly(widget.Docid),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshots) {
                            return snapshots.data == true
                                ? Text("")
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 50,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        color: Color(0xFF00a651),
                                        onPressed: () {
                                          if (Id != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BuyPage(
                                                            orderImage: widget
                                                                .Images[0],
                                                            CurrentUserId: Id,
                                                            PhoneUserId:
                                                                widget.PhoneUid,
                                                            Model: widget.Name,
                                                            Price: widget.Price,
                                                            Docid:
                                                                widget.Docid)));
                                          } else {
                                            CustomToast.showToastMessage(
                                                "Ju duhet të krijoni një llogari për ta kryer këtë veprim");
                                          }
                                        },
                                        child: Text(
                                          'BLEJ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.phone_android,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modeli',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenSize.textMultiplier * 2),
                            ),
                            Text(
                              widget.Name == null ? "" : widget.Name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: ScreenSize.textMultiplier * 2.5),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.euro_sharp,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Qmimi',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenSize.textMultiplier * 2.5),
                            ),
                            Text(
                              widget.Price == null ? "" : '\€ ${widget.Price}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.description,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Përshkrimi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(widget.Des),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.phone,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Numri kontaktues',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.Phone == null ? "" : widget.Phone,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: ScreenSize.textMultiplier * 2.5),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.location_city,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'lokacioni',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                widget.Location == null ? "" : widget.Location),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.map,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sistemi Operativ ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(widget.Os == null ? '' : widget.Os),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 20, left: 8, bottom: 8),
                          child: Icon(
                            Icons.chrome_reader_mode,
                            color: Color(0xFF00a651),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data e Publikimit     ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '${widget.Time.toDate().month}-${widget.Time.toDate().day}-${widget.Time.toDate().year}'),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
