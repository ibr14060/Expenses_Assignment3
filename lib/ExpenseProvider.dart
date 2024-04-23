import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _expensesData = [];

  List<Map<String, dynamic>> get expensesData => _expensesData;

  Future<void> fetchExpenses() async {
    try {
      final response = await http.get(Uri.parse(
          'https://expenses-assignment-default-rtdb.firebaseio.com/Expenses.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        _expensesData.clear();
        jsonData.forEach((key, value) {
          _expensesData.add({
            'id': key,
            'title': value['title'],
            'amount': value['amount'],
            'date': value['date'],
          });
        });
        notifyListeners();
      } else {
        print('Failed to fetch expenses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching expenses: $error');
    }
  }

  // Method to add a new expense
  Future<void> addExpense(String title, double amount, DateTime date) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://expenses-assignment-default-rtdb.firebaseio.com/Expenses.json'),
        body: json.encode({
          'title': title,
          'amount': amount,
          'date': date.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print('Expense added successfully');
        fetchExpenses(); // Refresh expenses after adding a new one
      } else {
        print('Failed to add expense: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding expense: $error');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://expenses-assignment-default-rtdb.firebaseio.com/Expenses/$id.json'),
      );

      if (response.statusCode == 200) {
        print('Expense deleted successfully');
        fetchExpenses();
      } else {
        print('Failed to delete expense: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting expense: $error');
    }
  }
}
