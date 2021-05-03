import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../Utills/Loading.dart';

class Update extends StatefulWidget {
  final String Id;
  final Phone phones;

  const Update({
    Key key,
    this.Id,
    this.phones,
  }) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final formKey = GlobalKey<FormState>();
  String _title;
  int _price;
  String _description;
  String _phoneNO;
  bool updationcheck = false;
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
    _os = widget.phones.Os;
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
              title: Text('Rifresko Celularin'),
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
                        updationcheck == true ? buildGridView() : Buildgrid(),
                        RaisedButton(
                            child: Text("Ngarko Fotot"),
                            color: Color(0xFF00a651),
                            onPressed: () {
                              setState(() {
                                updationcheck = true;
                                widget.phones.Urls.length = 0;
                              });

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
                          onChanged: (value) {
                            setState(() {
                              widget.phones.Model = value;
                            });
                          },
                          initialValue: widget.phones.Model,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.title),
                              labelText: 'Modeli'),
                          validator: (input) =>
                              input == '' ? 'Vendose Modelin' : null,
                          onSaved: (input) => _title = input,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              widget.phones.Price = int.parse(value);
                            });
                          },
                          initialValue: widget.phones.Price.toString(),
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
                          onChanged: (value) {
                            setState(() {
                              widget.phones.Des = value;
                            });
                          },
                          initialValue: widget.phones.Des,
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
                          onChanged: (value) {
                            setState(() {
                              widget.phones.phone = value;
                            });
                          },
                          initialValue: widget.phones.phone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Numri Kontaktues'),
                          validator: (input) =>
                              input == '' ? 'Vendose Numrin kontaktues' : null,
                          onSaved: (input) => _phoneNO = input,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              widget.phones.Location = value;
                            });
                          },
                          initialValue: widget.phones.Location,
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
                                    if (images.length == 0 &&
                                        widget.phones.Urls.length == 0) {
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
                                    } else if (images.length == 0 &&
                                        widget.phones.Urls.length != 0) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      formKey.currentState.save();

                                      print('Only firestore Updation');
                                      _databaseProvider.UpdateFirestore(
                                          widget.phones.Docid,
                                          _title,
                                          _price,
                                          _description,
                                          _phoneNO,
                                          _location,
                                          _os);

                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      print("whole updation");
                                      formKey.currentState.save();
                                      Fluttertoast.showToast(
                                          msg: "Please Wait",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                      String res = '';
                                      _databaseProvider
                                          .deletefirestore(widget.phones.Docid);
                                      _databaseProvider
                                          .deleteStorage(widget.phones.Urls);
                                      res = await _databaseProvider.UpdateData(
                                          images,
                                          _title,
                                          _price,
                                          _description,
                                          _phoneNO,
                                          _location,
                                          _os,
                                          widget.Id);
                                      if (res == 'Phone Updated') {
                                        Navigator.pop(context);
                                      }

                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Rifresko',
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

  Widget Buildgrid() {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(8),
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: widget.phones.Urls
          .map(
            (ingredient) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: Stack(children: [
                Center(
                  child: CupertinoActivityIndicator(),
                ),
                Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(ingredient),
                            fit: BoxFit.cover)))
              ]),
            ),
          )
          .toList(),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        //  print(asset.getByteData(quality: 100));
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
        maxImages: 3,
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
