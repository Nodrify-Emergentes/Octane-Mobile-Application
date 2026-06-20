import 'package:octane_mobile/maintenance_and_operations/model/expense.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseCreated extends ExpenseState {
  final Expense expense;

  ExpenseCreated(this.expense);
}

class ExpenseLoaded extends ExpenseState {
  final Expense expense;

  ExpenseLoaded(this.expense);
}

class ExpensesLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpensesLoaded(this.expenses);
}

class ExpenseDeleted extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}

