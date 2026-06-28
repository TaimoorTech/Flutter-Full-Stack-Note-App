import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? uid;
  final String? username;
  final String? email;
  final String? password;

  const UserModel({this.uid = "", this.username, this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["_id"],
      username: json["username"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "password": password,
    };
  }

  @override
  List<Object?> get props => [uid, username, email, password];
}
