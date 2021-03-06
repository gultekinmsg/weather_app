// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
   HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller;
  String _reversedText;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title:  Text('Flutter Widget Testing'),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration:  InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter text"),
            ),
             SizedBox(height: 10.0),
            if (_reversedText != null) ...[
              Text(
                _reversedText,
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
               SizedBox(height: 10.0),
            ],
            RaisedButton(
              color: Colors.blueGrey,
              child:  Text("Reverse Text"),
              onPressed: () {
                if (_controller.text.isEmpty) return;
                setState(() {
                  _reversedText = reverseText(_controller.text);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

String reverseText(String initial) {
  return initial.split('').reversed.join();
}