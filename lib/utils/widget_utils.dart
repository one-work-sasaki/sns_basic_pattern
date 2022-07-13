import 'package:flutter/material.dart';

class WidgetUtils{
  static AppBar createAppBar(String title){
    return AppBar(
      title: Text(title,style: TextStyle(color: Colors.black),),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}