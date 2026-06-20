import 'package:octane_mobile/maintenance_and_operations/presentation/views/expense_detail.dart';
import 'package:flutter/material.dart';

/// Navigation helper class for maintenance and operations features
class MaintenanceNavigationHelper {
  /// Navigate to expense detail page
  ///
  /// This can be called from any page (maintenance, expense list, etc.)
  ///
  /// Example:
  /// ```dart
  /// MaintenanceNavigationHelper.navigateToExpenseDetail(
  ///   context,
  ///   expenseId: 123,
  /// );
  /// ```
  static Future<void> navigateToExpenseDetail(
    BuildContext context, {
    required int expenseId,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetail(expenseId: expenseId),
      ),
    );
  }
}

