import 'dart:convert';

class TeacherModel {
  final String? id;
  final String? teacherId;
  final String? name;
  final String? email;

  TeacherModel({
    this.id,
    this.teacherId,
    this.name,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'teacher_id': teacherId,
      'name': name,
      'email': email,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['_id'],
      teacherId: map['teacher_id'],
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherModel.fromJson(String source) =>
      TeacherModel.fromMap(json.decode(source));
}
