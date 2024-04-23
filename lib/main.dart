import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'HomePage.dart'; // Assuming ExpenseProvider is defined in HomePage.dart
import './FirstPage.dart';
import './ExpenseProvider.dart'; // Import ExpenseProvider

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ExpenseProvider(), // Provide an instance of ExpenseProvider
      child: MaterialApp(
        title: 'Flutter Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: LoginScreenapp(),
        initialRoute: '/',
        routes: {
          '/': (context) => FirstPage(),
          '/Home': (context) => HomePage(
                title: 'Home Page',
                username:
                    '_usernameController', // Make sure to pass correct username value
              ),
        },
      ),
    );
  }
}
