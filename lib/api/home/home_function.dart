import 'package:ae_scanner_app/api/api_helper.dart';
import 'package:ae_scanner_app/api/home/homeController.dart';
import 'package:ae_scanner_app/api/home/home_repository.dart';
import 'package:ae_scanner_app/clockedStudentModel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class HomeFunction {
  static HomeRepository homeRepo = HomeRepository();
  static HomeController homeController= Get.find();

  static Future<void> markAttendance(String tagId) async {
    try {
      dio.Response res = await homeRepo.markAttendance(tagId);

      final data = res.data;
      final bool success = data["success"] ?? false;

      if (success) {
        final scannedStudentData = data["data"];
        final student = ClockedStudentModel.fromJson(scannedStudentData);
        homeController.studentData.value = student;
         
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
