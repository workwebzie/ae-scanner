import 'package:ae_scanner_app/modules/modules/module_controller.dart';
import 'package:ae_scanner_app/modules/modules/module_model.dart';
import 'package:ae_scanner_app/modules/modules/module_repository.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../api/api_helper.dart';

class ModuleFunction {
  static ModuleRepository moduleRepo = ModuleRepository();

  static Future<void> fnGetAllModules() async {
    final ModuleController moduleController = Get.put(ModuleController());

    try {
      dio.Response res = await moduleRepo.fnGetAllModules();

      final data = res.data;
      final bool success = data["success"] ?? false;

      if (success) {
        final modulesData = data["data"]["modules"]; // Adjust key if needed

        final modulesList =
            (modulesData as List).map((e) => ModuleModel.fromMap(e)).toList();

        moduleController.modules.assignAll(modulesList);
      } else {
        final message = data["message"] ?? "Failed to fetch modules";
        ApiHelper.showError("Error", message);
      }
    } on dio.DioException catch (e) {
      final message = e.response?.data["message"] ?? "Network error occurred";
      ApiHelper.showError("Error", message);
    } catch (e) {
      ApiHelper.showError("Error", "Unexpected Error: $e");
    }
  }

  static Future<void> fnGetModulesByTeacher(String teacherId) async {
    final ModuleController moduleController = Get.find<ModuleController>();
    moduleController.modules.clear(); // Clear previous modules

    try {
      print("Fetching modules for teacher: $teacherId");
      dio.Response res = await moduleRepo.fnGetModulesByTeacher(teacherId);
      print("Response status: ${res.statusCode}");
      print("Response data: ${res.data}");

      final data = res.data;
      final bool success = data["success"] ?? false;

      if (success) {
        final programmes = data["data"]["programmes"] as List?;
        print("Programmes found: ${programmes?.length}");
        final allModules = <ModuleModel>[];

        if (programmes != null) {
          for (var prog in programmes) {
            print("Processing programme: ${prog['name']}");
            final modules = prog["modules"] as List?;
            if (modules != null) {
              print("Modules in programme: ${modules.length}");
              for (var m in modules) {
                 try {
                    allModules.add(ModuleModel.fromMap(m));
                 } catch (e) {
                   print("Error parsing module: $m, Error: $e");
                 }
              }
            }
          }
        }
        
        print("Total modules parsed: ${allModules.length}");
        moduleController.modules.assignAll(allModules);
      } else {
        final message = data["message"] ?? "Failed to fetch modules";
        ApiHelper.showError("Error", message);
      }
    } on dio.DioException catch (e) {
      print("DioError: ${e.message}");
      final message = e.response?.data["message"] ?? "Network error occurred";
      ApiHelper.showError("Error", message);
    } catch (e) {
      print("Unexpected Error in fnGetModulesByTeacher: $e");
      ApiHelper.showError("Error", "Unexpected Error: $e");
    }
  }
}
