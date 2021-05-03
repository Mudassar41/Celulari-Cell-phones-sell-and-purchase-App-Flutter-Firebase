import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00a651),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFF00a651),
      body: SafeArea(
          child: new Center(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Text(
                  'Kam harruar Fjalëkalimin',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: Container(
                width: 300.0,
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)),
                      focusedBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)),
                      hintText: 'Email ID',
                      prefixIcon: new Icon(Icons.email, color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: usernameController,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 50.0),
                child: Container(
                  width: 300.0,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () async {
                      String username = usernameController.text;
                      if (username == null || username == '') {
                      } else {
                        resetPassword(username);
                        showCorrectInfoFlushbar(context);
                      }
                    },
                    child: Text(
                      'Dergo në E-mail ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00a651),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: Colors.white,
                  ),
                )),
          ])))),
    );
  }

  void showCorrectInfoFlushbar(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Recovery email sent to your mailbox!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).accentColor,
        textColor: Colors.white,
        fontSize: 20.0);

    setState(() {});
  }

  Future<void> resetPassword(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
  }
}
