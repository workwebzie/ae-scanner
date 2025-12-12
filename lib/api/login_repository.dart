 
import 'package:ae_scanner_app/api/api_manager.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  ////////api functions /////////////////////

  final api = ApiClient();
  
  Future<Response> fnlogin(String email, String password) async {
    try {
      // 🔹 API call
      final response = await api.post("/api/auth/login", data: {
        "email": email,
        "password": password,
      });

      // ✅ Return response to caller
      return response;
    } on DioException catch (e) {
      // ❌ Handle Dio (network/API) errors gracefully
      if (e.response != null) {
        print("❌ Login failed: ${e.response?.data}");
        return e.response!; // Return the server response for handling
      } else {
        print("❌ Network error: ${e.message}");
        return Response(
          requestOptions: RequestOptions(path: "/auth/login"),
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
        requestOptions: RequestOptions(path: "/auth/login"),
        data: {
          "success": false,
          "message": "Unexpected error: $e",
        },
        statusCode: 500,
      );
    }
  }
}
