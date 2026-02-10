import 'dart:convert';

class ModuleModel {
  final String? id;
  final String? name;
  final String? code;
  final String? programmeName;

  ModuleModel({
    this.id,
    this.name,
    this.code,
    this.programmeName,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'programme_name': programmeName,
    };
  }

  factory ModuleModel.fromMap(Map<String, dynamic> map) {
    return ModuleModel(
      id: map['_id'],
      name: map['name'],
      code: map['mscode'] ?? map['code'], // Handle mscode from API
      programmeName: map['programme_name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModuleModel.fromJson(String source) =>
      ModuleModel.fromMap(json.decode(source));
}
