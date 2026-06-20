import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octane_mobile/maintenance_and_operations/bloc/expense/expense_event.dart';
import 'package:octane_mobile/maintenance_and_operations/bloc/expense/expense_state.dart';
import 'package:octane_mobile/maintenance_and_operations/services/expense_service.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseService expenseService;

  ExpenseBloc({required this.expenseService}) : super(ExpenseInitial()) {
    on<CreateExpenseEvent>(_onCreateExpense);
    on<CreateExpenseForOwnerEvent>(_onCreateExpenseForOwner);
    on<FetchAllExpensesEvent>(_onFetchAllExpenses);
    on<FetchExpenseByIdEvent>(_onFetchExpenseById);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onCreateExpense(
    CreateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expense = await expenseService.createExpenseForUser(
        event.userId,
        event.expenseData,
      );
      emit(ExpenseCreated(expense));
    } catch (e) {
      emit(ExpenseError('Failed to create expense: $e'));
    }
  }

  Future<void> _onCreateExpenseForOwner(
    CreateExpenseForOwnerEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expense = await expenseService.createExpenseForOwner(
        event.ownerId,
        event.expenseData,
      );
      emit(ExpenseCreated(expense));
    } catch (e) {
      emit(ExpenseError('Failed to create expense: $e'));
    }
  }

  Future<void> _onFetchAllExpenses(
    FetchAllExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await expenseService.getAllExpenses();
      emit(ExpensesLoaded(expenses));
    } catch (e) {
      emit(ExpenseError('Failed to fetch expenses: $e'));
    }
  }

  Future<void> _onFetchExpenseById(
    FetchExpenseByIdEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expense = await expenseService.getExpenseById(event.expenseId);
      emit(ExpenseLoaded(expense));
    } catch (e) {
      emit(ExpenseError('Failed to fetch expense: $e'));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await expenseService.deleteExpense(event.expenseId);
      emit(ExpenseDeleted());
    } catch (e) {
      emit(ExpenseError('Failed to delete expense: $e'));
    }
  }
}

