import 'dart:convert';

// To parse this JSON data, do
//
//     final roleModel = roleModelFromJson(jsonString);

RoleModel roleModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String roleModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
  int? id;
  String? name;
  String? description;

  RoleModel({
    this.id,
    this.name,
    this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  @override
  String toString() {
    return name ?? 'Unknown Role';
  }
}
