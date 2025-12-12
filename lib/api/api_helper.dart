import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 

class ApiHelper {
  // 🔹 Unified success snackbar
  static void showSuccess(String title, String message) {

    
    Get.snackbar(
      title,
      message,
      maxWidth: Get.width / 2,
      snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
      colorText: const Color(0xFF4CAF50),
      margin: const EdgeInsets.only(bottom: 30),
    );
  }

  // 🔹 Unified error snackbar
  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      maxWidth: Get.width / 2,
      snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: const Color(0xFFE53935).withOpacity(0.1),
      colorText: const Color(0xFFE53935),
      margin: const EdgeInsets.only(bottom: 30),
    );
  }


  // 🔹 Global exception handler
  static bool handleException(dynamic e) {
    if (e is dio.DioException) {
      final message = e.response?.data["message"] ?? "Network error occurred";
      showError("Network Error", message);
    } else {
      showError("Unexpected Error", e.toString());
    }
    return false;
  }
}
