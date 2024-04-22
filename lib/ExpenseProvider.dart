import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _expensesData = [];

  // Getter for accessing expenses data
  List<Map<String, dynamic>> get expensesData => _expensesData;

  // Method to fetch expenses from a remote server
  Future<void> fetchExpenses() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _expensesData = jsonData.cast<Map<String, dynamic>>();
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
      // Implement logic to add expense to the remote server
      // Update the local data if successful
      notifyListeners();
    } catch (error) {
      print('Error adding expense: $error');
    }
  }

  // Method to delete an existing expense
  Future<void> deleteExpense(String id) async {
    try {
      // Implement logic to delete expense from the remote server
      // Update the local data if successful
      notifyListeners();
    } catch (error) {
      print('Error deleting expense: $error');
    }
  }
}
