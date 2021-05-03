import 'dart:io';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Utills/Loading.dart';

class AddMobiles extends StatefulWidget {
  final String ID;

  //final Phone todo = ModalRoute.of(context).settings.arguments;
  const AddMobiles({Key key, this.ID}) : super(key: key);

  @override
  _AddMobilesState createState() => _AddMobilesState();
}

class _AddMobilesState extends State<AddMobiles> {
  final formKey = GlobalKey<FormState>();
  String _title;
  int _price;
  String _description;
  String _phoneNO;
  String urlImage;
  String _location;
  List<Asset> images = List<Asset>();
  List<Asset> imagesUrl = [];
  String _error = 'No Error Dectected';
  DatabaseProvider _databaseProvider;

  List imageUrls = [];
  String _os;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _databaseProvider = Provider.of<DatabaseProvider>(context);
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF00a651),
              title: Text('Shto një Celularë'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildGridView(),
                        RaisedButton(
                            child: Text("Ngarko Fotot"),
                            color: Color(0xFF00a651),
                            onPressed: () {
                              getImage();
                            }),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        Text(
                          'Minimumi tre Foto',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        // Title
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.title),
                              labelText: 'Modeli'),
                          validator: (input) =>
                              input == '' ? 'Vendose Modelin' : null,
                          onSaved: (input) => _title = input,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.attach_money),
                              labelText: 'Qmimi'),
                          validator: (input) =>
                              input == '' ? 'Vendose Qmimin' : null,
                          onSaved: (input) => _price = int.parse(input),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 6,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.description),
                              labelText: 'Përshkrimi'),
                          validator: (input) =>
                              input == '' ? 'Vendose Përshkrimin' : null,
                          onSaved: (input) => _description = input,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Numri Kontaktues'),
                          validator: (input) =>
                              input == '' ? 'Vendose Numrin kontaktues' : null,
                          onSaved: (input) => _phoneNO = input,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              labelText: 'Lokacioni'),
                          validator: (input) =>
                              input == '' ? 'Vendose Lokacionin' : null,
                          onSaved: (input) => _location = input,
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.devices),
                                labelText: 'OS'),
                            value: _os,
                            items: [
                              DropdownMenuItem(
                                child: Text("Android"),
                                value: "Android",
                              ),
                              DropdownMenuItem(
                                  child: Text("IOS"), value: "IOS"),
                            ],
                            validator: (input) =>
                                input == '' ? 'Please enter a os' : null,
                            onSaved: (input) => _os = input,
                            onChanged: (value) {
                              setState(() {
                                _os = value;
                              });
                            }),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 305.0,
                              height: 72.0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: RaisedButton(
                                  color: Color(0xFF00a651),
                                  disabledColor: Colors.grey[250],
                                  splashColor: Colors.black87,
                                  onPressed: () async {
                                    if (images.length == 0) {
                                      Fluttertoast.showToast(
                                          msg: "Ju lutem ngarkoni Fotot",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else if (!formKey.currentState
                                        .validate()) {
                                      return;
                                    } else {
                                      formKey.currentState.save();
                                      Fluttertoast.showToast(
                                          msg: "Please Wait",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      setState(() {
                                        isLoading = true;
                                      });
                                      String res = '';
                                      res = await _databaseProvider
                                          .AddDataToDatabase(
                                              images,
                                              _title,
                                              _price,
                                              _description,
                                              _phoneNO,
                                              _location,
                                              _os,
                                              widget.ID);

                                      if (res != null) {
                                        setState(() {
                                          isLoading = false;
                                          images = [];
                                        });
                                        Navigator.pop(context);
                                      } else if (res == null) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      Fluttertoast.showToast(
                                          msg: res,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Text(
                                    'Shto',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future getImage() async {
    var status = await Permission.photos.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
    }
    print(status);

    var image = await MultiImagePicker.pickImages(
        maxImages: 7, enableCamera: true, selectedAssets: images);
    setState(() {
      images = image;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 7,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
}
