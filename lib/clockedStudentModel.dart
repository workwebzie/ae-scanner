import 'dart:convert';

ClockedStudentModel clockedStudentModelFromJson(String str) =>
    ClockedStudentModel.fromJson(json.decode(str));

class ClockedStudentModel {
  final bool? success;
  final String? action;
  final Attendance? attendance;

  ClockedStudentModel({
    this.success,
    this.action,
    this.attendance,
  });

  factory ClockedStudentModel.fromJson(Map<String, dynamic> json) =>
      ClockedStudentModel(
        success: json["success"],
        action: json["action"],
        attendance: json["attendance"] == null
            ? null
            : Attendance.fromJson(json["attendance"]),
      );
}

class Attendance {
  final String? studentId;
  final String? subjectId;
  final String? teacherId;
  final String? date;
  final List<DateTime>? clockIn;
  final List<dynamic>? clockOut;
  final bool? isClockedIn;
  final bool? isPresent;
  final int? totalTime;
  final String? remark;
  final String? faculty;
  final bool? isLate;
  final int? lateByMinutes;
  final String? id;
  final String? academicYear;
  final String? createdAt;
  final String? updatedAt;

  final String? studentName;

  Attendance({
    this.studentId,
    this.subjectId,
    this.teacherId,
    this.date,
    this.clockIn,
    this.clockOut,
    this.isClockedIn,
    this.isPresent,
    this.totalTime,
    this.remark,
    this.faculty,
    this.isLate,
    this.lateByMinutes,
    this.id,
    this.academicYear,
    this.createdAt,
    this.updatedAt,
    this.studentName,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        studentId: json["studentId"],
        subjectId: json["subjectId"],
        teacherId: json["teacherId"],
        date: json["date"] == null ? json["date"] : "",
        clockIn: json["clockIn"] == null
            ? []
            : List<DateTime>.from(
                json["clockIn"]!.map((x) => DateTime.parse(x))),
        clockOut: json["clockOut"] == null
            ? []
            : List<dynamic>.from(json["clockOut"]!.map((x) => x)),
        isClockedIn: json["isClockedIn"],
        isPresent: json["isPresent"],
        totalTime: json["totalTime"],
        remark: json["remark"],
        faculty: json["faculty"],
        isLate: json["isLate"],
        lateByMinutes: json["lateByMinutes"],
        id: json["_id"],
        academicYear: json["academicYear"],
        createdAt: json["createdAt"] == null ? json["createdAt"] : "",
        updatedAt: json["updatedAt"] == null ? json["updatedAt"] : "",
        studentName: json["studentName"],
      );
}
