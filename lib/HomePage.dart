import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
        fetchExpenses(); // Refresh expenses after deleting one
      } else {
        print('Failed to delete expense: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting expense: $error');
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title, required this.username})
      : super(key: key);

  final String title;
  final String username;

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 66, 191, 196),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              TextEditingController _titleController = TextEditingController();
              TextEditingController _amountController = TextEditingController();
              DateTime? selectedDate = DateTime.now();

              await showModalBottomSheet(
                context: context,
                isScrollControlled:
                    true, // Ensure the bottom sheet occupies full height
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Add Expense", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 8),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Expense Title',
                            ),
                          ),
                          TextField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              hintText: 'Expense Amount',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101),
                              );
                              selectedDate = pickedDate;
                              print(selectedDate);
                            },
                            child: Text(
                              selectedDate != null
                                  ? 'Selected Date: ${selectedDate.toString()}'
                                  : 'Select Date',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _amountController.text.isNotEmpty &&
                                  selectedDate != null) {
                                expenseProvider.addExpense(
                                  _titleController.text,
                                  double.parse(_amountController.text),
                                  selectedDate!,
                                );
                                _titleController.clear();
                                _amountController.clear();
                                selectedDate = DateTime.now();
                                print('Expense added');
                                Navigator.pop(context);
                              } else {
                                print('All fields are required');
                              }
                            },
                            child: Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, _) {
          double totalExpenses = 0.0;
          for (var expense in expenseProvider.expensesData) {
            totalExpenses += expense['amount'] as num;
          }

          return Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('EGP ${totalExpenses.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 66, 191, 196)),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: expenseProvider.expensesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: FittedBox(
                              child: Text(
                                  'EGP ${expenseProvider.expensesData[index]['amount']}'),
                            ),
                          ),
                        ),
                        title: Text(
                          expenseProvider.expensesData[index]['title']
                              .toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          expenseProvider.expensesData[index]['date']
                              .toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            expenseProvider.deleteExpense(
                                expenseProvider.expensesData[index]['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 66, 191, 196),
        tooltip: 'Increment',
        onPressed: () async {
          TextEditingController _titleController = TextEditingController();
          TextEditingController _amountController = TextEditingController();
          DateTime? selectedDate = DateTime.now();

          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Add Expense", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Expense Title',
                        ),
                      ),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: 'Expense Amount',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );
                          selectedDate = pickedDate;
                          print(selectedDate);
                        },
                        child: Text(
                          selectedDate != null
                              ? 'Selected Date: ${selectedDate.toString()}'
                              : 'Select Date',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_titleController.text.isNotEmpty &&
                              _amountController.text.isNotEmpty &&
                              selectedDate != null) {
                            expenseProvider.addExpense(
                              _titleController.text,
                              double.parse(_amountController.text),
                              selectedDate!,
                            );
                            _titleController.clear();
                            _amountController.clear();
                            selectedDate = DateTime.now();
                            print('Expense added');
                            Navigator.pop(context);
                          } else {
                            print('All fields are required');
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
