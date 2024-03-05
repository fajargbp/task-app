import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? docId;
  String? name;
  String? desc;
  String? status;

  TaskModel(this.docId, this.name, this.desc, this.status);

  TaskModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    name = data["name"];
    desc = data["desc"];
    status = data["status"];
  }
}
