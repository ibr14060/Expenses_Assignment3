import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import './FirstPage.dart';
import './ExpenseProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider(),
      child: MaterialApp(
        title: 'Flutter Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
