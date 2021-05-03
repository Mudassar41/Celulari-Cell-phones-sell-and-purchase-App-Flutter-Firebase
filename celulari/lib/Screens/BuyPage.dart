import 'package:celulari/Models/Icons.dart';
import 'package:celulari/Models/Order.dart';
import 'package:celulari/Providers/DatabaseProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Screens/AccountInfo.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:celulari/Utills/CustomToast.dart';
import 'package:celulari/Utills/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BuyPage extends StatefulWidget {
  final int Price;
  final String Model;
  final String Docid;
  final String PhoneUserId;
  final String CurrentUserId;
  final String orderImage;

  const BuyPage(
      {Key key,
      this.Price,
      this.Model,
      this.Docid,
      this.PhoneUserId,
      this.CurrentUserId,
      this.orderImage})
      : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final formKey = GlobalKey<FormState>();
  Order _order = Order();
  bool loading = false;
  bool _autoValidate = false;
  DatabaseProvider databaseProvider;

  @override
  Widget build(BuildContext context) {
    databaseProvider = Provider.of<DatabaseProvider>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF00a651),
              title: Text('Arkë'),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Adresa juaj",
                              style: TextStyle(
                                  fontFamily: 'Libre Baskerville',
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenSize.textMultiplier * 3,
                                  color: Color(0xFF00a651)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                autovalidate: _autoValidate,
                                key: formKey,
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              labelText: 'Emri',
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onSaved: (txt) {
                                            _order.buyerName = txt;
                                          },
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Vendose Emrin';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                labelText: 'Qyteti',
                                                labelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onSaved: (txt) {
                                              _order.buyerCity = txt;
                                            },
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Vendose Qytetin';
                                              } else {
                                                return null;
                                              }
                                            }),
                                        TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                labelText: 'Rruga',
                                                labelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onSaved: (txt) {
                                              _order.buyerStreet = txt;
                                            },
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Vendose Rrugën';
                                              } else {
                                                return null;
                                              }
                                            }),
                                        TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText: 'Tel',
                                                labelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onSaved: (txt) {
                                              _order.buyerPhone = txt;
                                            },
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Vendose Kontaktin';
                                              } else {
                                                return null;
                                              }
                                            }),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      shadowColor: Colors.green,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: [
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
                                          fontSize:
                                              ScreenSize.textMultiplier * 2),
                                    ),
                                    Text(
                                      widget.Model,
                                      style: TextStyle(
                                          fontFamily: 'Libre Baskerville',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize:
                                              ScreenSize.textMultiplier * 2.5),
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
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Qmimi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              ScreenSize.textMultiplier * 2.5),
                                    ),
                                    Text(
                                      ' ${widget.Price} \€ ',
                                      style: TextStyle(
                                          fontFamily: 'Libre Baskerville',
                                          color: Colors.green,
                                          fontSize:
                                              ScreenSize.textMultiplier * 3.5,
                                          fontWeight: FontWeight.bold),
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
                                    MyIcons.delivery_truck,
                                    color: Color(0xFF00a651),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dërgesa Brenda 24h ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              ScreenSize.textMultiplier * 2.5),
                                    ),
                                    Text(
                                      ' : Falas',
                                      style: TextStyle(
                                          fontFamily: 'Libre Baskerville',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      shadowColor: Colors.green,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Pasi ta keni pranuar këtë Celular, ju keni kohë 3 dite për ta kthyer.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .6,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () async {
                          String res;
                          // ID OF BUYER
                          _order.buyerId = widget.CurrentUserId;
                          //ID OF SELLER
                          _order.sellerId = widget.PhoneUserId;
                          //PHONE RECORD ID
                          _order.phoneId = widget.Docid;
                          //PHONE IMAGE
                          _order.orderImage = widget.orderImage;
                          //MODEL NAME
                          _order.modelName = widget.Model;
                          //MODEL PRICE
                          _order.modelPrice = widget.Price;

                          //SELLER NOTIFICATION
                          _order.buyerNotification = widget.CurrentUserId;
                          //BUYER NOTIFICATION

                          _order.sellerNotification = widget.PhoneUserId;

                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            setState(() {
                              loading = true;
                            });
                            res = await databaseProvider.AddOredr(_order);
                            if (res == 'Order Added') {
                              // databaseProvider
                              //     .sendNotificationToSeller(_order.sellerId);
                              // databaseProvider.sendNotificationToAdmin();
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 12,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      content: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            height:
                                                ScreenSize.imageSizeMultiplier *
                                                    20,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Porosia u krye me sukses",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AccountInfo()));
                                                      },
                                                      child: Text(
                                                        "ok",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      color: Color(0xFF00a651),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    );
                                  });
                            } else {
                              CustomToast.showToastMessage(res);
                              setState(() {
                                loading = false;
                              });
                            }
                          } else {
                            setState(() {
                              _autoValidate = true;
                            });
                          }
                        },
                        child: Text(
                          'BLEJ TANI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
