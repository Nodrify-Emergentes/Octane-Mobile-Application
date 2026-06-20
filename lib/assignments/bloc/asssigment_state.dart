import 'package:octane_mobile/assignments/model/assignment.dart';

abstract class AssignmentState {}

class AssignmentInitial extends AssignmentState {}

class AssignmentLoading extends AssignmentState {}

class AssignmentsLoaded extends AssignmentState {
  final List<Assignment> assignments;

  AssignmentsLoaded(this.assignments);
}

class AssignmentError extends AssignmentState {
  final String message;

  AssignmentError(this.message);
}

