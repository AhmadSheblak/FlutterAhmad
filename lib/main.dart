import 'package:flutter/material.dart';
import './ui/Home.dart';
/*
 Programmed by Ahmad Al Sheblak on 14-08-2020, 1:46 am
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Todo App",
    home: Home(),
  ));
}

