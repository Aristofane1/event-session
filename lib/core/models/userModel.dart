import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? photo;
  final String? email;

  const UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.photo,
    this.email,
  });
  @override
  List<Object> get props => [id!];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      photo: json['photo'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['photo'] = photo;
    data['email'] = email;
    return data;
  }
}

UserModel user = UserModel.fromJson({
  "id": 3,
  "firstname": "Aristofane",
  "lastname": "LOKO",
  "photo":
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80",
  "email": "aristofane@example.com",
});
