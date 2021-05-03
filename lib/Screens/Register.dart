import 'package:celulari/Providers/AuthProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthProvider authProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  FocusNode myFocusNode;
  bool passwordVisible;
  Users _user = Users();

  @override
  void initState() {
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xFF00a651),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFF00a651),
      body: SafeArea(
          child: new Center(
              child: SingleChildScrollView(
                  child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Text(
                'Celulari',
                style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                textAlign: TextAlign.center,
              )),
          SizedBox(
            height: 50,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Container(
                      width: 155.0,
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.white,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          decoration: InputDecoration(
                              enabledBorder: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              focusedBorder: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              hintText: 'Emri',
                              prefixIcon: new Icon(Icons.account_circle,
                                  color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white)),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: firstnameController,
                          onChanged: (value) {
                            setState(() {
                              value = _user.fname;
                            });
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Vendose Emrin';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _user.fname = value;
                          }),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Container(
                      width: 155.0,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.white,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Vendose Mbiemrin';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _user.lastname = value;
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                            focusedBorder: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                            prefixIcon: new Icon(Icons.account_circle,
                                color: Colors.white),
                            hintText: 'Mbiemri',
                            hintStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: lastnameController,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Container(
                    width: 315.0,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.white,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: InputDecoration(
                          enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          focusedBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          hintText: 'Email ID',
                          prefixIcon:
                              new Icon(Icons.email, color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: usernameController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Vendose Email-in';
                        }

                        return null;
                      },
                      onSaved: (String value) {
                        _user.email = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Container(
                    width: 315.0,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.white,
                      maxLines: 1,
                      autofocus: false,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white)),
                        focusedBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white)),
                        hintText: 'Fjalekalimi',
                        prefixIcon: new Icon(Icons.lock, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: passwordController1,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Vendose Fjalekalimin';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _user.password = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Container(
                    width: 315.0,
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.white,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          focusedBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          hintText: 'Konfirmo Fjalekalimi',
                          prefixIcon: new Icon(Icons.lock, color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: passwordController2,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Vendose Fjalekalimin';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _user.password = value;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenSize.heightMultiplier + 6,
                  left: ScreenSize.heightMultiplier * 2,
                  right: ScreenSize.heightMultiplier * 2,
                  bottom: ScreenSize.heightMultiplier + 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(6.0)),
                  onPressed: () async {
                    String username = usernameController.text;
                    String firstname = firstnameController.text;
                    String lastname = lastnameController.text;
                    String password = passwordController1.text;
                    if (passwordController1.text == passwordController2.text) {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
//                          } else if (!RegExp(
//                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
//                              .hasMatch(_user.email)) {
//                            Fluttertoast.showToast(
//                                msg: "Enter Valid Email",
//                                toastLength: Toast.LENGTH_SHORT,
//                                gravity: ToastGravity.CENTER,
//                                timeInSecForIosWeb: 1,
//                                backgroundColor: Colors.red,
//                                textColor: Colors.white,
//                                fontSize: 16.0);
//                          }
                      else {
                        _formKey.currentState.save();

                        String res = await authProvider.signUp(_user);
                        if (res == 'User Successfully Added') {
                          print(res);
                          Fluttertoast.showToast(
                              msg: 'Llogaria u krijua me sukses',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Theme.of(context).accentColor,
                              textColor: Colors.white,
                              fontSize: 20.0);
                          usernameController.clear();
                          firstnameController.clear();
                          lastnameController.clear();
                          passwordController1.clear();
                          passwordController2.clear();
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: res,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Theme.of(context).accentColor,
                              textColor: Colors.white,
                              fontSize: 20.0);
                          print(res);
                        }
                      }

                      //  _formKey.currentState.reset();

                    } else if (passwordController2.text !=
                        passwordController1.text) {
                      Fluttertoast.showToast(
                          msg: "Fjalëkalimet nuk përputhen",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Text(
                    'Regjistrohu',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00a651)),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.white,
                ),
              )),
          SizedBox(
            height: 20,
          ),
        ]),
      )))),
    );
  }
}
