import 'dart:io';

class Task {
  String id;
  String title;
  String description;
  String dueDate;
  String priority;
  String status;
  String path;
  File? imageFile;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.path,
    this.imageFile,
    required this.id,
  });

}
