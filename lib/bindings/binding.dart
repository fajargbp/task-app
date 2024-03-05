import 'package:get/get.dart';
import 'package:task_app/controllers/task_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TaskController>(TaskController());
  }
}
