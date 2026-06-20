import 'dart:convert';
import 'package:octane_mobile/shared/client/api.client.dart';
import '../model/expense.dart';

class ExpenseService {
  // Create expense for a user (old endpoint, kept for backward compatibility)
  Future<Expense> createExpenseForUser(int userId, Map<String, dynamic> expenseData) async {
    final response = await ApiClient.post('expense/$userId', body: expenseData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Expense.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create expense: ${response.statusCode} - ${response.body}');
    }
  }

  // Create expense for an owner (new endpoint)
  Future<Expense> createExpenseForOwner(int ownerId, Map<String, dynamic> expenseData) async {
    final response = await ApiClient.post('expense/owner/$ownerId', body: expenseData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Expense.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create expense: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    final response = await ApiClient.get('expense');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Expense.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch expenses: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Expense> getExpenseById(int expenseId) async {
    final response = await ApiClient.get('expense/$expenseId');

    if (response.statusCode == 200) {
      return Expense.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch expense: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    final response = await ApiClient.delete('expense/$expenseId');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete expense: ${response.statusCode} - ${response.body}');
    }
  }
}

