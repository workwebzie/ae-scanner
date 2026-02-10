import 'package:ae_scanner_app/api/api_manager.dart';
import 'package:dio/dio.dart';

class ModuleRepository {
  static final api = ApiClient();
  Future<Response> fnGetAllModules() async {
    try {
      // 🔹 API call
      final response = await api.get("/api/modules", queryParams: {});

      // ✅ Return response to caller
      return response;
    } on DioException catch (e) {
      // ❌ Handle Dio (network/API) errors gracefully
      if (e.response != null) {
        print("❌ Fetching modules list failed: ${e.response?.data}");
        return e.response!; // Return the server response for handling
      } else {
        print("❌ Network error: ${e.message}");
        return Response(
          requestOptions: RequestOptions(path: "/api/modules"),
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
        requestOptions: RequestOptions(path: "/api/modules"),
        data: {
          "success": false,
          "message": "Unexpected error: $e",
        },
        statusCode: 500,
      );
    }
  }
  Future<Response> fnGetModulesByTeacher(String teacherId) async {
    try {
      // 🔹 API call
      final response = await api.get("/api/programmes/teacher/$teacherId", queryParams: {});

      // ✅ Return response to caller
      return response;
    } on DioException catch (e) {
      // ❌ Handle Dio (network/API) errors gracefully
      if (e.response != null) {
        print("❌ Fetching modules list failed: ${e.response?.data}");
        return e.response!; // Return the server response for handling
      } else {
        print("❌ Network error: ${e.message}");
        return Response(
          requestOptions: RequestOptions(path: "/api/programmes/teacher/$teacherId"),
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
        requestOptions: RequestOptions(path: "/api/programmes/teacher/$teacherId"),
        data: {
          "success": false,
          "message": "Unexpected error: $e",
        },
        statusCode: 500,
      );
    }
  }
}
 