import 'package:flutter/material.dart';

import '/HomePage.dart';
import './FirstPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //  home: LoginScreenapp(),
        initialRoute: '/',
        routes: {
          '/': (dummyCtx) => FirstPage(),
          '/Home': (dummyCtx) => HomePage(
                title: 'Home Page',
                username: '_usernameController',
              )
        });
  }
}
