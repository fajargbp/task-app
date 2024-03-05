import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/controllers/task_controller.dart';
import 'package:task_app/pages/login.dart';

class TaskDetailPage extends StatefulWidget {
  final data;
  const TaskDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TaskController taskController = Get.put(TaskController());
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Detail"),
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
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: [
            Padding(
              padding: (MediaQuery.of(context).size.width < 768)
                  ? const EdgeInsets.only(left: 6.5, right: 6.5)
                  : const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 199, 208, 236),
                    borderRadius: BorderRadius.circular(14.0)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(taskController.selectedName.value,
                        style: GoogleFonts.notoSans(
                            fontSize: 25.0, fontWeight: FontWeight.bold))),
                    (widget.data.desc != '')
                        ? const SizedBox(height: 5.0)
                        : const SizedBox(),
                    Visibility(
                        visible: widget.data.desc == '' ? false : true,
                        child: primaryDivider),
                    const SizedBox(height: 5.0),
                    Visibility(
                        visible: widget.data.desc == '' ? false : true,
                        child: Obx(() => Text(taskController.selectedDesc.value,
                            style: GoogleFonts.notoSans(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            )))),
                    primaryDivider,
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text('Status: ${widget.data.status}',
                          style: GoogleFonts.notoSans(
                            fontSize: 20.0,
                          )),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: widget.data.status == 'completed' ? false : true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    taskController.editTask(widget.data.name, widget.data.desc,
                        'completed', widget.data.docId!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  child: const Text(
                    'Mark as Completed',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () async {
                  taskController.deleteData(widget.data.docId!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                child: const Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskController.nameController.text =
              taskController.selectedName.value;
          taskController.descController.text =
              taskController.selectedDesc.value;
          taskController.selectedStatus.value =
              taskController.selectedStatus.value;
          taskController.selectedId.value = widget.data.docId!;
          _buildEditTaskView(
              text: 'UPDATE',
              name: widget.data.name,
              desc: widget.data.desc,
              docId: widget.data.docId!);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Divider primaryDivider = const Divider(
    color: Color(0xFF707070),
    thickness: 1.0,
  );

  _buildEditTaskView(
      {String? text, String? name, String? desc, String? docId}) {
    print(name);
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
            key: taskController.formKey,
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
                    controller: taskController.nameController,
                    validator: (value) {
                      return taskController.validateName(value!);
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
                    controller: taskController.descController,
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
                        taskController.editTask(
                            taskController.nameController.text,
                            taskController.descController.text,
                            taskController.selectedStatus.value,
                            docId!);
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
