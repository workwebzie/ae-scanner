import 'package:ae_scanner_app/modules/teacher/teacherRepository.dart';
import 'package:ae_scanner_app/modules/teacher/teacher_controller.dart';
import 'package:ae_scanner_app/modules/teacher/teacher_model.dart';
import 'package:ae_scanner_app/modules/teacher/teacher_timetable_model.dart';
import 'package:ae_scanner_app/modules/modules/module_controller.dart';
import 'package:ae_scanner_app/modules/modules/module_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../api/api_config.dart'; // Assuming ApiHelper is here or api_helper.dart
import '../../api/api_helper.dart';


class TeacherFunction {


  // static final api = ApiClient(); // Not used directly here
  static TeachersRepository teachersRepo = TeachersRepository();


  
   static Future<void> fnGetAllTeachers() async {
    final TeachersController teachersController = Get.put(TeachersController());
    // TeachersRepository teachersRepo = TeachersRepository();

    try {
      dio.Response res = await teachersRepo.fnGetAllteachers();

      final data = res.data;
      final bool success = data["success"] ?? false;

      if (success) {
        final teachersData = data["data"]["teachers"];

        final teachersList =
            (teachersData as List).map((e) => TeacherModel.fromMap(e)).toList();

        teachersController.teachers.assignAll(teachersList);
      } else {
        final message = data["message"] ?? "Invalid credentials";
        ApiHelper.showError("Error", message);
      }
    } on dio.DioException catch (e) {
      final message = e.response?.data["message"] ?? "Network error occurred";
      ApiHelper.showError("Error", message);
    } catch (e) {
      ApiHelper.showError("Error", "Unexpected Error: $e");
    }
  }
  static Future<void> fnGetTeacherTimetable(String teacherId) async {
    final TeachersController teachersController = Get.put(TeachersController());

    try {
      dio.Response res = await teachersRepo.fnGetTeacherTimetable(teacherId);

      final data = res.data;
      final bool success = data["success"] ?? false;

      if (success) {
        final timetableData = data["data"];
        final timetableModel = TeacherTimeTableModel.fromMap(timetableData);
        teachersController.teacherTimetable.value = timetableModel;

        // Extract modules from timetable
        final ModuleController moduleController = Get.find<ModuleController>();
        moduleController.modules.clear();

        final Map<String, ModuleModel> uniqueModules = {};

        if (timetableModel.timetableByDay != null) {
          timetableModel.timetableByDay!.forEach((day, sessions) {
            for (var session in sessions) {
              if (session.mscode != null && session.mscode!.isNotEmpty) {
                // Use mscode as key to ensure uniqueness
                uniqueModules[session.mscode!] = ModuleModel(
                  id: session.mscode, // Using mscode as ID to match dropdown expectation
                  name: session.moduleName, // Use moduleName if available
                  code: session.mscode,
                  programmeName: session.programmeName,
                );
              }
            }
          });
        }
        
        // Convert map values to list
        moduleController.modules.assignAll(uniqueModules.values.toList());

      } else {
        final message = data["message"] ?? "Failed to fetch timetable";
        ApiHelper.showError("Error", message);
      }
    } on dio.DioException catch (e) {
      final message = e.response?.data["message"] ?? "Network error occurred";
      ApiHelper.showError("Error", message);
    } catch (e) {
      ApiHelper.showError("Error", "Unexpected Error: $e");
    }
  }
}