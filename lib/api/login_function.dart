import 'package:ae_scanner_app/api/api_helper.dart';
import 'package:ae_scanner_app/api/api_manager.dart';
import 'package:ae_scanner_app/api/login_repository.dart';
import 'package:ae_scanner_app/api/show_snackBar.dart';
import 'package:ae_scanner_app/colors.dart';
import 'package:ae_scanner_app/loginControler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';


class LoginFunctions {
  static final api = ApiClient();

  static Future<bool> handleLogin({
    required String userId,
    required String password,
    required bool rememberMe,
  }) async {
    final LoginController loginController = Get.find();
    LoginRepository loginRepo = LoginRepository();

    try {
      // 🔹 Call login API
      dio.Response res = await loginRepo.fnlogin(userId, password);

      // 🔹 Check response success status
      final data = res.data;
      final bool success = data["success"] ?? false;

      print(success);

      if (success) {
        // ✅ Login successful
        loginController.loggined.value = true;
        // 🔹 Extract token (adjust key if your API returns differently)
        final userData = data["data"]["user"];
        final token = userData["token"];

        if (token != null) {
          // Store token globally for all future requests
          api.setToken(token);
          print("✅ Login successful. Token saved!");
        } else {
          print("⚠️ Login response missing token: ${data}");
        }
        // loginController.loggedUser.value = UserModel.fromMap(userData);

        // Save credentials if Remember Me is checked
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setBool("rememberMe", true);
          await prefs.setString("userId", userId);
          await prefs.setString("password", password);
        } else {
          await prefs.remove("rememberMe");
          await prefs.remove("userId");
          await prefs.remove("password");
        }
        showSnackBar("Login Successful",null,ThemeColors.primarygreen);
        // ApiHelper.showSuccess("Login Successful", "Welcome back!");
        loginController.loggined.value = false;
        return true;
      } else {
        // ❌ Login failed – show reason if available
        final message = data["message"] ?? "Invalid credentials";
        ApiHelper.showError("Login Failed", message);
        
        loginController.loggined.value = false;
        return false;
      }
    } on dio.DioException catch (e) {
      // ❌ Network or API error
      final message = e.response?.data["message"] ?? "Network error occurred";
      Get.snackbar("Error", message,
          maxWidth: Get.width / 2,
          snackPosition: SnackPosition.BOTTOM,
          // backgroundColor: const Color(0xFFE53935),
          colorText: const Color(0xFFE53935),
          margin: EdgeInsets.only(bottom: 30));
      loginController.loggined.value = false;
      return false;
    } catch (e) {
      // ❌ Unexpected error
      Get.snackbar(
        "Unexpected Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      loginController.loggined.value = false;
      return false;
    }
  }
}