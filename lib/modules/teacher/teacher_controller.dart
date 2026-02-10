import 'package:get/get.dart';
import 'package:ae_scanner_app/modules/teacher/teacher_model.dart';
import 'package:ae_scanner_app/modules/teacher/teacher_timetable_model.dart';

class TeachersController extends GetxController {
  RxList<TeacherModel> teachers = <TeacherModel>[].obs;
  Rx<String?> selectedTeacherID = Rx<String?>(null);
  Rxn<TeacherTimeTableModel> teacherTimetable = Rxn<TeacherTimeTableModel>();
}
