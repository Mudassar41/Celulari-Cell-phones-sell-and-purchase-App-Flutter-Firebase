import 'package:celulari/Providers/AuthProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utills/Loading.dart';
import 'AccountInfo.dart';
import 'Login.dart';

class AutologinCheck extends StatefulWidget {
  @override
  _AutologinCheckState createState() => _AutologinCheckState();
}

class _AutologinCheckState extends State<AutologinCheck> {
  AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder<User>(
        future: authProvider.getCurrentUser(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.data == null ? Login() : AccountInfo();
          return CircularProgressIndicator(
            strokeWidth: 12,
          );
        });
  }
}
