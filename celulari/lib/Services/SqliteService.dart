import 'package:celulari/Models/PhoneModel.dart';
import 'package:celulari/Models/SqliteModel.dart';
import 'package:celulari/Providers/LikeProvider.dart';
import 'package:celulari/Utills/CustomToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class SqliteService extends ChangeNotifier {
  bool chek;

  Future<Database> openDb() async {
    Database _database = await openDatabase(
      join(await getDatabasesPath(), 'Phone.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE LikedMobiles(phone_id TEXT PRIMARY KEY)",
        );
      },
      version: 1,
    );
    return _database;
  }

  Future<void> AddPhoto(SqliteModel sqliteModel) async {
    final Database db = await openDb();
    var result = await db.query("LikedMobiles",
        where: "phone_id=?", whereArgs: [sqliteModel.phone_id]);

    if (result.length == 0) {
      await db.insert(
        'LikedMobiles',
        sqliteModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await CustomToast.showToastMessage('Shtuar në listen e favoritev');
    } else {
      //Show Message
      CustomToast.showToastMessage('Tashmë në listen e favoritev');
    }
  }

  Future<bool> Likedonly(String Id) async {
    bool onlyLike;
    final Database db = await openDb();
    var result =
        await db.query("LikedMobiles", where: "phone_id=?", whereArgs: [Id]);
    if (result.length > 0) {
      onlyLike = true;
    } else {
      onlyLike = false;
    }
    notifyListeners();
    return onlyLike;
  }

  Future<List<Phone>> Getdata() async {
    List<SqliteModel> dataList = [];
    List<Phone> list = [];

    final Database db = await openDb();
    var Values = await db.query('LikedMobiles');
    Phone phone;
    QuerySnapshot snapshot = await Firestore.instance
        .collection('PhoneData')
        .orderBy("Time", descending: true)
        .getDocuments();
    snapshot.documents.forEach((document) {
      phone = Phone.fromMap(document.data());
      Values.forEach((i) {
        SqliteModel cart = SqliteModel.data(i['phone_id']);
        if (i['phone_id'] == document.data()['Docid']) {
          list.add(phone);
        }
      });
    });
    // notifyListeners();
    return list;
  }

  Future<void> DeletePhoto(String id) async {
    CustomToast.showToastMessage('Duke u fshirë');

    final Database db = await openDb();
    await db.delete(
      'LikedMobiles',
      where: "phone_id = ?",
      whereArgs: [id],
    );
    notifyListeners();
  }
}
