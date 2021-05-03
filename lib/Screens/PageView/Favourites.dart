import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Services/SqliteService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:provider/provider.dart';

import '../PhoneDetail.dart';
class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  SqliteService _sqliteService;

  @override
  Widget build(BuildContext context) {
    _sqliteService = Provider.of<SqliteService>(
      context,
    );
    return FutureBuilder(
      future:_sqliteService.Getdata(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ),
            );
          }

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
                                          image:snapshot
                                              .data[index].Urls[0]==null?AssetImage('assets/logo.png'): NetworkImage(snapshot
                                              .data[index].Urls[0]),
                                          fit: BoxFit.cover))),

                                   Positioned(
                                top: 5,
                                left: 5,
                                child: InkWell(
                                  onTap: () {
                                    //deletion from sqlite
                                    _sqliteService.DeletePhoto(
                                        snapshot.data[index].Docid);
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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
                                ),
                              ),


                               Positioned(
                                bottom: 5,
                                left: 5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneDetail(
                                                  Name: snapshot
                                                      .data[index]
                                                      .Model,
                                                  Des: snapshot
                                                      .data[index]
                                                      .Des,
                                                  Price: snapshot
                                                      .data[index]
                                                      .Price,
                                                  Images: snapshot
                                                      .data[index]
                                                      .Urls,
                                                  Phone: snapshot
                                                      .data[index]
                                                      .phone,
                                                  Time: snapshot
                                                      .data[index]
                                                      .Time,
                                                  Os: snapshot
                                                      .data[index]
                                                      .Os,
                                                  Location:
                                                  snapshot
                                                      .data[
                                                  index]
                                                      .Location,
                                                  Uid: snapshot
                                                      .data[index]
                                                      .Uid,
                                                  Docid: snapshot
                                                      .data[index]
                                                      .Docid)),
                                    );
                                    // go to detail
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.green,
                                    ),
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
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data[index].Model==null?'':snapshot.data[index].Model,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text({snapshot.data[index].Price}==null?'':'\€ ${snapshot.data[index].Price}',
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
          child:CupertinoActivityIndicator()
        );
      },
    );
  }
}
