import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class AuthProvider with ChangeNotifier {
  Future<User> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    print(user);
    return user;
  }

  Future<String> signIn(Users user) async {
    String res = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email, password: user.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return res = 'Nuk ka përdorues me këtë Email';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return res = 'Fjalëkalimi i Gabuar!';
      }
    } catch (e) {
      return res = 'Sometghing went wrong!Please Check Internet Connection';
    }
    notifyListeners();
    return res = 'Kyqja me sukses!';
  }

  Future<String> signUp(Users user) async {
    String res = '';

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return res = 'The password provided is too weak.';
        //   print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return res = 'The account already exists for that email.';
        // print('The account already exists for that email.');
      }
    } catch (e) {
      res = 'Sometghing went wrong!Please Check Internet Connection';
      return res;
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user1 = auth.currentUser;
    String Id = user1.uid;
    AddUserTofirestore(
        user.fname, user.lastname, user.email, user.password, Id);
    notifyListeners();
    return res = 'User Successfully Added';
  }

// SIGNOUT USER

  Future<void> signOutUser() async {
    //  await Firebase.initializeApp();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> AddUserTofirestore(String fnmae, String lname, String email,
      String password, String Uid) async {
    try {
      //   await Firebase.initializeApp();
      Timestamp time = Timestamp.now();
      String _token;
      FirebaseMessaging fcm = FirebaseMessaging();
      _token = await fcm.getToken();

      String collectionRef = 'Users';
      String docId =
          Firestore.instance.collection(collectionRef).document().documentID;
      var docRef = Firestore.instance.collection(collectionRef).document(docId);
      await docRef.set({
        'First Name': fnmae,
        'Last Name': lname,
        'Email': email,
        'Time': time,
        "Uid": Uid,
        'token': _token
      }, SetOptions(merge: true));
      notifyListeners();
    } catch (err) {
      print("Error");
    }
  }
}

class Users {
  String fname;
  String lastname;
  String email;
  String password;
  String Uid;

  Users();
}
