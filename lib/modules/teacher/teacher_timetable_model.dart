import 'dart:convert';

class TeacherTimeTableModel {
  final String? teacherId;
  final String? teacherName;
  final String? faculty;
  final int? totalClasses;
  final Map<String, List<ClassSession>>? timetableByDay;

  TeacherTimeTableModel({
    this.teacherId,
    this.teacherName,
    this.faculty,
    this.totalClasses,
    this.timetableByDay,
  });

  factory TeacherTimeTableModel.fromMap(Map<String, dynamic> map) {
    return TeacherTimeTableModel(
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      faculty: map['faculty'],
      totalClasses: map['totalClasses'],
      timetableByDay: map['timetableByDay'] != null
          ? Map.from(map['timetableByDay']).map((k, v) => MapEntry<String, List<ClassSession>>(
              k,
              (v as List).map((e) => ClassSession.fromMap(e)).toList(),
            ))
          : null,
    );
  }

  factory TeacherTimeTableModel.fromJson(String source) => TeacherTimeTableModel.fromMap(json.decode(source));
}

class ClassSession {
  final String? mscode;
  final String? teacherId;
  final String? startTime;
  final String? endTime;
  final int? period;
  final String? academicYear;
  final List<String>? students;

  final String? moduleName;
  final String? programmeName;

  ClassSession({
    this.mscode,
    this.teacherId,
    this.startTime,
    this.endTime,
    this.period,
    this.academicYear,
    this.students,
    this.moduleName,
    this.programmeName,
  });

  factory ClassSession.fromMap(Map<String, dynamic> map) {
    return ClassSession(
      mscode: map['mscode'],
      teacherId: map['teacherId'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      period: map['period'],
      academicYear: map['academicYear'],
      students: map['students'] != null ? List<String>.from(map['students']) : null,
      moduleName: map['moduleName'],
      programmeName: map['programmeName'],
    );
  }

  factory ClassSession.fromJson(String source) => ClassSession.fromMap(json.decode(source));
}
