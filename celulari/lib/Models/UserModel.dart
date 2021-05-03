class UserModel {
  String firstname;
  String lastname;
  String email;
  String uid;
  String token;

  UserModel({this.firstname, this.lastname, this.uid, this.email});

  UserModel.fromMap(Map<String, dynamic> data) {
    firstname = data['First Name'];
    lastname = data['Last Name'];
    email = data['Email'];
    uid = data['Uid'];

  }

  UserModel.fromMapwithToken(Map<String, dynamic> data) {
    firstname = data['First Name'];
    lastname = data['Last Name'];
    email = data['Email'];
    uid = data['Uid'];
    token=data['token'];

  }

}
