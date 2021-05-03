import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Models/SqliteModel.dart';
import 'package:flutter/cupertino.dart';

class LikeProvider extends ChangeNotifier {
  List<SqliteModel> _likedPhones = [];
  bool _like;


  bool getLike() => _like;

  setLike(bool value) {
    _like = value;
    notifyListeners();
  }

  Future<List<SqliteModel>> getLikedPhones() async => _likedPhones;

  setLikedPhones(List<SqliteModel> value) {
    _likedPhones = value;
    notifyListeners();
  }
}
