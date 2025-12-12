
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar(text, [icon,color]) {
  SnackBar snackBar = SnackBar(
    duration: Duration(milliseconds: 1500),
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon??Icon(Icons.check,color: Colors.white,),
        SizedBox(width: 10,),
        Text(text,style: TextStyle(
          color: Colors.white
        ),)
        
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}