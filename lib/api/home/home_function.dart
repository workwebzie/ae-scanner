import 'package:ae_scanner_app/api/api_helper.dart';
import 'package:ae_scanner_app/api/home/home_repository.dart';
import 'package:dio/dio.dart' as dio;

class HomeFunction {
  static HomeRepository homeRepo = HomeRepository();

  static Future<void> gnGetTimeTableByDate(DateTime date) async {
    try {
      dio.Response res = await homeRepo.markAttendance();

      final data = res.data;
      final bool success = data["success"] ?? false;

      if (success) {
        // final todayTimeTableData = data["data"];
        // final timeTableList = TodayTimeTableModel.fromMap(todayTimeTableData);
        // timeTableController.todaySession.value = timeTableList;
        // timeTableController.update();
        // print(timeTableList);
        // print(timeTableList);
        // _mapTimetablesToEvents(timeTableList);
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
