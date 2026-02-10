import 'package:get/get.dart';
import 'package:ae_scanner_app/modules/modules/module_model.dart';

class ModuleController extends GetxController {
  RxList<ModuleModel> modules = <ModuleModel>[].obs;
  Rx<String?> selectedModuleID = Rx<String?>(null);
}
