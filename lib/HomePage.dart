import 'dart:convert';
import 'package:flutter/material.dart';

//import 'PostPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.username});

  final String title;
  final String username;
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to the Home Page',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Username: ${widget.username}',
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/post');
            },
            child: Text('Post Page'),
          ),
        ],
      )),
    );
  }
}
