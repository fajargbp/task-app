import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/components/customFullScreenDialog.dart';
import 'package:task_app/components/customSnackBar.dart';
import 'package:task_app/models/task.dart';

class TaskController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController, descController;

  final GetStorage _getStorage = GetStorage();

  // Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<TaskModel> tasks = RxList<TaskModel>([]);
  RxList<TaskModel> pendingTask = RxList<TaskModel>([]);
  RxList<TaskModel> inProgressTask = RxList<TaskModel>([]);
  RxList<TaskModel> completedTask = RxList<TaskModel>([]);

  RxString selectedName = ''.obs;
  RxString selectedDesc = ''.obs;
  RxString selectedStatus = ''.obs;
  RxString selectedId = ''.obs;

  String? userId = '';

  @override
  void onInit() {
    userId = _getStorage.read("userId");
    super.onInit();
    nameController = TextEditingController();
    descController = TextEditingController();
    collectionReference =
        firebaseFirestore.collection("task").doc(userId).collection("tasks");
    tasks.bindStream(getAllTask());
    completedTask.bindStream(getCompletedTask());
    inProgressTask.bindStream(getProgressTask());
    pendingTask.bindStream(getPendingTask());
    // fetchData();
    // getData();
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  void addTask(String name, String desc, String docId) {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    print('Sucess Add');
    formKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    collectionReference.add(
        {'name': name, 'desc': desc, 'status': 'pending'}).whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      clearEditingControllers();
      Get.back();
      print('Sucess Add');
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Task Added",
          message: "Task added successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      print('Error Add ' + error);
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red);
    });
  }

  void editTask(String name, String desc, String status, String docId) {
//update
    CustomFullScreenDialog.showDialog();
    collectionReference.doc(docId).update(
        {'name': name, 'desc': desc, 'status': status}).whenComplete(() {
      print('Sucess Edit');
      selectedName.value = name;
      selectedDesc.value = desc;
      CustomFullScreenDialog.cancelDialog();
      clearEditingControllers();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Task Updated",
          message: "Task updated successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      print('Error Edit ' + error);
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red);
    });
  }

  void deleteData(String docId) {
    CustomFullScreenDialog.showDialog();
    collectionReference.doc(docId).delete().whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Task Deleted",
          message: "Task deleted successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red);
    });
  }

  @override
  void onReady() {
    super.onReady();
    // getData();
    // fetchData();
    print('ready');
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
  }

  void clearEditingControllers() {
    nameController.clear();
    descController.clear();
  }

  Stream<List<TaskModel>> getAllTask() => collectionReference.snapshots().map(
      (query) => query.docs.map((item) => TaskModel.fromMap(item)).toList());

  Stream<List<TaskModel>> getCompletedTask() => collectionReference
      .where('status', isEqualTo: 'completed')
      .snapshots()
      .map((query) =>
          query.docs.map((item) => TaskModel.fromMap(item)).toList());

  Stream<List<TaskModel>> getProgressTask() => collectionReference
      .where('status', isEqualTo: 'progress')
      .snapshots()
      .map((query) =>
          query.docs.map((item) => TaskModel.fromMap(item)).toList());

  Stream<List<TaskModel>> getPendingTask() => collectionReference
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((query) =>
          query.docs.map((item) => TaskModel.fromMap(item)).toList());

  // Future<void> getData() async {
  //   try {
  //     print('masuk');
  //     QuerySnapshot tasks =
  //         await FirebaseFirestore.instance.collection('task').get();
  //     for (var task in tasks.docs) {
  //       // if (task['status'] == 'pending') {
  //       //   pendingTask.add(
  //       //       TaskModel(task.id, task['name'], task['desc'], task['status']));
  //       // } else if (task['status'] == 'progress') {
  //       //   inProgressTask.add(
  //       //       TaskModel(task.id, task['name'], task['desc'], task['status']));
  //       // } else if (task['status'] == 'completed') {
  //       //   completedTask.add(
  //       //       TaskModel(task.id, task['name'], task['desc'], task['status']));
  //       // }
  //     }
  //   } catch (e) {
  //     print('error');
  //     Get.snackbar('Error', '${e.toString()}');
  //   }
  // }

  // Future fetchData() async {
  //   print("fetch data");
  //   try {
  //     CollectionReference users = FirebaseFirestore.instance.collection('task');
  //     final snapshot = await users.get();
  //     print(snapshot);
  //     for (var task in snapshot.docs) {
  //       final data = task.data() as Map<TaskModel, dynamic>;
  //       if (data['status'] == 'pending') {
  //         pendingTask.add(TaskModel(
  //             data['docId'], data['name'], data['desc'], data['status']));
  //       }
  //     }
  //     print(pendingTask);
  //   } catch (e) {
  //     return 'Error fetching user';
  //   }
  // }
}
