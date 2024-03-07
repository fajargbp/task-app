import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/controllers/task_controller.dart';
import 'package:task_app/pages/login.dart';
import 'package:task_app/pages/task_detail.dart';
import 'package:task_app/pages/task_list.dart';

class HomePage extends GetView<TaskController> {
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task"),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  filteredWidget(context, 'All', 'No tasks', controller.tasks,
                      Icons.schedule),
                  filteredWidget(context, 'Pending', 'No pending tasks',
                      controller.pendingTask, Icons.pending),
                  filteredWidget(context, 'Completed', 'No completed tasks',
                      controller.completedTask, Icons.check),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Pending Task",
                      style: GoogleFonts.notoSans(
                          fontSize: 20.0, color: Colors.black))),
              const SizedBox(
                height: 30.0,
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: GetX<TaskController>(
                        init: Get.put<TaskController>(TaskController()),
                        builder: (TaskController taskController) {
                          return (taskController.pendingTask.isEmpty)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Icon(Icons.list,
                                          color: Colors.white, size: 90.0),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Center(child: Text('No Pending Task!')),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: controller.pendingTask.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Color.fromARGB(255, 199, 208, 236),
                                      child: ListTile(
                                        title: Text(controller
                                            .pendingTask[index].name!),
                                        subtitle: Text(controller
                                            .pendingTask[index].desc!),
                                        onTap: () {
                                          controller.selectedName.value =
                                              controller
                                                  .pendingTask[index].name!;
                                          controller.selectedDesc.value =
                                              controller
                                                  .pendingTask[index].desc!;
                                          controller.selectedId.value =
                                              controller
                                                  .pendingTask[index].docId!;
                                          Get.to(() => TaskDetailPage(
                                                data: controller
                                                    .pendingTask[index],
                                              ));
                                          // _buildAddTaskView(
                                          //     text: 'UPDATE', docId: controller.tasks[index].docId!);
                                        },
                                      ),
                                    );
                                  });
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buildAddTaskView(text: 'ADD');
          print('pressed');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  GestureDetector filteredWidget(context, title, infoText, data, icon) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TaskListPage(
              title: title,
              data: data,
              infoText: infoText,
              icon: icon,
            ));
      },
      child: Container(
        width: (MediaQuery.of(context).size.width < 768)
            ? MediaQuery.of(context).size.width * 0.30
            : MediaQuery.of(context).size.width * 0.27,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 199, 208, 236),
            borderRadius: BorderRadius.circular(14.0)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Obx(
                  () => Text(
                    '${data.length}',
                    style: GoogleFonts.notoSans(
                        fontSize: 40.0, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  title,
                  style:
                      GoogleFonts.notoSans(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ]),
      ),
    );
  }

  _buildAddTaskView({String? text, String? docId}) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          color: Color.fromARGB(255, 216, 223, 246),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${text} Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.nameController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.descController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: Get.context!.width, height: 45),
                    child: ElevatedButton(
                      child: Text(
                        text!,
                        // style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: () {
                        controller.addTask(controller.nameController.text,
                            controller.descController.text, '');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
