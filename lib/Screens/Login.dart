import 'package:celulari/Providers/AuthProvider.dart';
import 'package:celulari/Responsiveness/ScreenSize.dart';
import 'package:celulari/Utills/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Utills/Loading.dart';
import 'ForgotPassword.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static String username;
  AuthProvider authProvider;
  Users _user = Users();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible;
  bool loading = false;

  @override
  void initState() {
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black87, //change your color here
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: new Center(
                  child: SingleChildScrollView(
                      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: ScreenSize.textMultiplier * 40,
                        height: ScreenSize.textMultiplier * 25,
                        decoration: BoxDecoration(
                            color: Color(0xFF00a651),
                            border:
                                Border.all(color: Color(0xFF00a651), width: 3),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            'Celulari',
                            style: TextStyle(
                                fontSize: ScreenSize.textMultiplier * 5.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFffffff)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Kyquni ose Krijo Llogarine',
                        style: TextStyle(
                            fontSize: ScreenSize.textMultiplier * 3.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenSize.heightMultiplier + 2,
                                left: ScreenSize.heightMultiplier * 4,
                                right: ScreenSize.heightMultiplier * 4,
                                bottom: ScreenSize.heightMultiplier + 2),
                            child: TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: false,
                              decoration: InputDecoration(
                                  enabledBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Color(0xFF00a651))),
                                  focusedBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Color(0xFF00a651))),
                                  hintText: 'Email ID',
                                  prefixIcon: new Icon(Icons.email,
                                      color: Color(0xFF00a651)),
                                  hintStyle:
                                      TextStyle(color: Color(0xFF00a651))),
                              style: TextStyle(
                                color: Color(0xFF00a651),
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenSize.heightMultiplier + 2,
                                left: ScreenSize.heightMultiplier * 4,
                                right: ScreenSize.heightMultiplier * 4,
                                bottom: ScreenSize.heightMultiplier + 2),
                            child: TextFormField(
                              maxLines: 1,
                              autofocus: false,
                              obscureText: passwordVisible,
                              decoration: InputDecoration(
                                enabledBorder: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFF00a651))),
                                focusedBorder: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFF00a651))),
                                hintText: 'Password',
                                prefixIcon: new Icon(
                                    Icons.phonelink_lock_outlined,
                                    color: Color(0xFF00a651)),
                                hintStyle: TextStyle(color: Color(0xFF00a651)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFF00a651),
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
                                color: Color(0xFF00a651),
                              ),
                              controller: passwordController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Vendose Fjalëkalimin';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _user.password = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenSize.heightMultiplier + 2,
                                left: ScreenSize.heightMultiplier * 4,
                                right: ScreenSize.heightMultiplier * 4,
                                bottom: ScreenSize.heightMultiplier + 2),
                            child: Container(
                              width: double.infinity,
                              height: 50.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0)),
                                onPressed: () async {
                                  String res = '';
                                  String username = usernameController.text;
                                  String password = passwordController.text;

                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }

                                  _formKey.currentState.save();
                                  setState(() {
                                    loading = true;
                                  });
                                  res = await authProvider.signIn(_user);

                                  if (res == 'Login Success!') {
                                    Fluttertoast.showToast(
                                        msg: 'Kyqja me sukses',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        textColor: Colors.white,
                                        fontSize: 20.0);
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    if (res == null) {
                                      res = 'Sorry!..';
                                    }
                                    Fluttertoast.showToast(
                                        msg: res,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        textColor: Colors.white,
                                        fontSize: 20.0);
                                    print(res);

                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                                child: Text(
                                  'Kyquni',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                color: Color(0xFF00a651),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: ScreenSize.heightMultiplier + 4,
                            left: ScreenSize.heightMultiplier * 4,
                            right: ScreenSize.heightMultiplier * 4,
                            bottom: ScreenSize.heightMultiplier + 4),
                        child: Text(
                          'Harruar Fjalëkalimin!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenSize.heightMultiplier + 2,
                          left: ScreenSize.heightMultiplier * 4,
                          right: ScreenSize.heightMultiplier * 4,
                          bottom: ScreenSize.heightMultiplier + 2),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        child: OutlineButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6.0)),
                          borderSide: BorderSide(color: Color(0xFF00a651)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          },
                          child: Text(
                            'Krijo Llogarinë',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF00a651),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ))),
            ),
          );
  }
}
