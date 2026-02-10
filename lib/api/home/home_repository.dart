import 'package:ae_scanner_app/api/api_manager.dart';
import 'package:ae_scanner_app/api/home/faculty_controller.dart';
import 'package:ae_scanner_app/modules/modules/module_controller.dart';
import 'package:ae_scanner_app/modules/teacher/teacher_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
 

class HomeRepository {
  static final api = ApiClient();
  TeachersController teacherController = Get.find();
  ModuleController moduleController = Get.find();


  Future<Response> markAttendance(tagId) async {
    try {
      final response = await api.post("/api/attendance/scan", data: {
        "rfid":tagId  ,
        "mscode":moduleController.selectedModuleID.value,
        "teacherId": teacherController.selectedTeacherID.value,
        
      });

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        print("❌ Network error: ${e.message}");
        return Response(
          requestOptions: RequestOptions(path: "/api/attendance/scan"),
          data: {
            "success": false,
            "message": "Network error: ${e.message}",
          },
          statusCode: 500,
        );
      }
    } catch (e) {
      print("⚠️ Unexpected error: $e");
      return Response(
        requestOptions: RequestOptions(path: "/api/attendance/scan"),
        data: {
          "success": false,
          "message": "Unexpected error: $e",
        },
        statusCode: 500,
      );
    }
  }
}
