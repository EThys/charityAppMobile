// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String ? firstName;
  String ? lastName;
  String ? email;
  String ? phone;
  String ? address;
  String ? city;
  String ? genre;
  String ? country;
  int ? userId;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.genre,
    this.country,
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    city: json["city"],
    genre: json["genre"],
    country: json["country"],
    userId: json["UserId"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "address": address,
    "genre":genre,
    "city": city,
    "country": country,
    "UserId": userId,
  };
}
