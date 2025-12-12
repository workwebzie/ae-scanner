import 'package:ae_scanner_app/api/api_manager.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  static final api = ApiClient();

  Future<Response> markAttendance() async {
    try {
      final response = await api.post("/api/attendance/scan", data: {
        "rfid": "RFID005",
        "subjectId": "SUB001",
        "teacherId": "TCH001",
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
