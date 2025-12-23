import 'package:get/get.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FacultyController extends GetxController {


  RxList<DepartmentModel> faculties = <DepartmentModel>[].obs;
  Rx<String?> selectedFacultyID = Rx<String?>(null);

}




class DepartmentModel {
    final String? id;
    final String? facultyId;
    final String? facultyName;

    DepartmentModel({
        this.id,
        this.facultyId,
        this.facultyName,
    });

 

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      facultyId: map['faculty_id'] != null ? map['faculty_id'] as String : null,
      facultyName: map['faculty_name'] != null ? map['faculty_name'] as String : null,
    );
  }

 

  factory DepartmentModel.fromJson(String source) => DepartmentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
