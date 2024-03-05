import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/controllers/task_controller.dart';
import 'package:task_app/pages/login.dart';
import 'package:task_app/pages/task_detail.dart';

class TaskListPage extends StatefulWidget {
  final String title;
  final String infoText;
  final IconData icon;
  final data;
  const TaskListPage(
      {Key? key,
      required this.title,
      required this.data,
      required this.infoText,
      required this.icon})
      : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskController taskController = Get.put(TaskController());
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              _getStorage.erase();
              Get.off(LoginPage());
              print("Logout menu is selected.");
            }
          }),
        ],
      ),
      body: Obx(() => Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: (widget.data.isEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child:
                            Icon(widget.icon, color: Colors.white, size: 120.0),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(child: Text(widget.infoText)),
                    ],
                  )
                : GetX<TaskController>(
                    init: Get.put<TaskController>(TaskController()),
                    builder: (TaskController taskController) {
                      return ListView.builder(
                          itemCount: widget.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Color.fromARGB(255, 199, 208, 236),
                              child: ListTile(
                                title: Text(widget.data[index].name!),
                                subtitle: Text(widget.data[index].desc!),
                                onTap: () {
                                  taskController.selectedName.value =
                                      widget.data[index].name!;
                                  taskController.selectedDesc.value =
                                      widget.data[index].desc!;
                                  taskController.selectedId.value =
                                      widget.data[index].docId!;
                                  Get.to(() => TaskDetailPage(
                                        data: widget.data[index],
                                      ));
                                  // _buildAddTaskView(
                                  //     text: 'UPDATE', docId: controller.tasks[index].docId!);
                                },
                              ),
                            );
                          });
                    }),
          )),
    );
  }
}
