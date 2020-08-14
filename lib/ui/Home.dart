import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Todo_Screen.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        backgroundColor: Colors.deepOrange,
      ),
      body: TodoScr(),
    );
  }

}