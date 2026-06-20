import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octane_mobile/assignments/bloc/assignment_event.dart';
import 'package:octane_mobile/assignments/bloc/asssigment_state.dart';
import 'package:octane_mobile/assignments/services/assingment_service.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentService assignmentService;

  AssignmentBloc({required this.assignmentService}) : super(AssignmentInitial()) {
    on<FetchAssignmentsByMechanicIdAndStatusEvent>(_onFetchAssignmentsByMechanicIdAndStatus);
  }

  Future<void> _onFetchAssignmentsByMechanicIdAndStatus(
    FetchAssignmentsByMechanicIdAndStatusEvent event,
    Emitter<AssignmentState> emit,
  ) async {
    emit(AssignmentLoading());
    try {
      final assignments = await assignmentService.getAssignmentsByMechanicIdAndStatus(
        event.mechanicId,
        event.status,
      );
      emit(AssignmentsLoaded(assignments));
    } catch (e) {
      emit(AssignmentError('Failed to fetch assignments: $e'));
    }
  }
}

