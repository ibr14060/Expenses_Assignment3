import 'dart:convert';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> expenses = [
    {
      'id': '1',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '2',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    },
    {
      'id': '3',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '4',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    },
    {
      'id': '5',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '6',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    },
    {
      'id': '7',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '8',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    },
    {
      'id': '9',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '10',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    },
    {
      'id': '11',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '12',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    },
    {
      'id': '13',
      'title': 'New Shoes',
      'amount': 69.99,
      'date': DateTime.now(),
    },
    {
      'id': '14',
      'title': 'Weekly Groceries',
      'amount': 16.53,
      'date': DateTime.now(),
    }
  ];
  double totalExpenses = 0.0;
  void loopAndSet() {
    setState(() {
      totalExpenses = 0; // Reset total before calculating
      for (Map<String, dynamic> expense in expenses) {
        totalExpenses += expense['amount'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loopAndSet();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
      ),
      body: Column(
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
                          color: const Color.fromRGBO(82, 170, 94, 1.0)),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text('EGP ${expenses[index]['amount']}'),
                        ),
                      ),
                    ),
                    title: Text(
                      expenses[index]['title'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      expenses[index]['date'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          expenses.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Increment',
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
