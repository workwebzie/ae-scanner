import 'package:ae_scanner_app/api/api_helper.dart';
import 'package:ae_scanner_app/api/home/faculty_controller.dart';
import 'package:ae_scanner_app/api/home/faculty_repository.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
 

class FacultyFunction {
  static final FacultyController facultyController = Get.find();



    static Future<void> fnGetDepartments() async {
    // final FacultyController facultyController = Get.find();
    FacultyRepository facultyRepository = FacultyRepository();

    try {
      dio.Response res = await facultyRepository.fnGetAllDepartment();

      final data = res.data;
      final bool success = data["success"] ?? false;
      print(success);
      if (success) {
        final facultyData = data["data"]["faculties"];

        final facultyList = (facultyData as List)
            .map((e) => DepartmentModel.fromMap(e))
            .toList();

        facultyController.faculties.assignAll(facultyList);
      } else {
        final message = data["message"] ?? "Invalid credentials";
        ApiHelper.showError("Error", message);
      }
    } on dio.DioException catch (e) {
      final message = e.response?.data["message"] ?? "Network error occurred";
      ApiHelper.showError("Error", message);
    } catch (e) {
      ApiHelper.showError("Error", "Unexpected Error");
    }
  }




}