import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:provider/provider.dart';

import '../Update.dart';

class Uploads extends StatefulWidget {
  @override
  _UploadsState createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> {
  DatabaseProvider databaseProvider;
  FirebaseAuth auth;
  User user;
  String Id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    Id = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    databaseProvider = Provider.of<DatabaseProvider>(
      context,
    );
    return FutureBuilder(
      future: databaseProvider.GetMemberPhones(Id),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length == 0
              ? Center(
                  child: Text(
                  "Nuk ka të dhëna",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: XSliverGridDelegate(
                        crossAxisCount: 2,
                        smallCellExtent: ScreenSize.heightMultiplier * 30,
                        bigCellExtent: ScreenSize.heightMultiplier * 30,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Column(
                            children: [
                              Container(
                                height: ScreenSize.imageSizeMultiplier * 20,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    Center(child: CupertinoActivityIndicator()),
                                    Container(
                                        decoration: BoxDecoration(

                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                    .data[index].Urls[0]),
                                                fit: BoxFit.cover))),
                                     Positioned(
                                            top: 5,
                                            left: 3,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Update(
                                                            Id: Id,
                                                            phones: snapshot
                                                                .data[index],
                                                          )),
                                                );
                                              },
                                              child: Container(
                                                child: Icon(Icons.edit),
                                                height: ScreenSize
                                                        .imageSizeMultiplier +
                                                    30,
                                                width: ScreenSize
                                                        .imageSizeMultiplier +
                                                    30,
                                                decoration: BoxDecoration(
                                                    color: Colors.white30,
                                                    shape: BoxShape.circle),
                                              ),
                                            ))
                                    ,
                                     Positioned(
                                            bottom: 5,
                                            left: 3,
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        elevation: 12,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Container(
                                                              height: ScreenSize
                                                                      .imageSizeMultiplier *
                                                                  20,
                                                              child: Column(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .warning,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Vërtet dëshironi të fshini?",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: FittedBox(
                                                                        child: Row(
                                                                      children: [
                                                                        RaisedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Text(
                                                                              'Anulo',
                                                                              style: TextStyle(color: Colors.white)),
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              ScreenSize.imageSizeMultiplier * 2,
                                                                        ),
                                                                        RaisedButton(
                                                                          onPressed:
                                                                              () {
                                                                            String
                                                                                Id =
                                                                                snapshot.data[index].Docid;
                                                                            databaseProvider.Deldata(Id,
                                                                                snapshot.data[index].Urls);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Po",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          color:
                                                                              Color(0xFF00a651),
                                                                        )
                                                                      ],
                                                                    )),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                child: Icon(Icons.delete),
                                                height: ScreenSize
                                                        .imageSizeMultiplier +
                                                    30,
                                                width: ScreenSize
                                                        .imageSizeMultiplier +
                                                    30,
                                                decoration: BoxDecoration(
                                                    color: Colors.white30,
                                                    shape: BoxShape.circle),
                                              ),
                                            ))

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data[index].Model,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text('\€ ${snapshot.data[index].Price}',
                                  style: TextStyle(
                                      color: Color(0xFF00a651),
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        );
                      }),
                );
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ),
        );
      },
    );
  }
}
