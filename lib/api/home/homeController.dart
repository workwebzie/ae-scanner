import 'package:ae_scanner_app/clockedStudentModel.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  // Rx<ClockedStudentModel?> studentData =<ClockedStudentModel>().obs 
  Rxn<ClockedStudentModel> studentData = Rxn<ClockedStudentModel>();

}