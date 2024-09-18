import 'package:equatable/equatable.dart';
import '../../../../models/task.dart';

abstract class TaskState { }

class TaskInitialState extends TaskState {}


class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {

}
class TaskRefresh extends TaskState {

}
class AddingTask extends TaskState {}

class TaskAdded extends TaskState {

}
class UpdatingTask extends TaskState {}

class TaskUpdated extends TaskState {

}
class TaskImageLoading extends TaskState {}

class TaskImageLoaded extends TaskState {

}

class TaskOnDelete extends TaskState {}

class TaskDeleted extends TaskState {

}

class TaskError extends TaskState {}
