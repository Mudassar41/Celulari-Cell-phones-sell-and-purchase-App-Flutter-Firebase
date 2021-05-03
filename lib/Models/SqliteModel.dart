class SqliteModel {
  String phone_id;

  SqliteModel.data(this.phone_id);

  SqliteModel();

  Map<String, dynamic> toMap() {
    return {
      'phone_id': phone_id,
    };
  }
}
