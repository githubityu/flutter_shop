import 'package:flutter/material.dart';

/// 1.定义一个class with ChangeNotifier
/// 2.定义属性
/// 3.定义修改属性的方法，修改完要调用notifyListeners方法
/// 4.要把定义的class 在runApp之前放到Providers中去
/// 5.启动runApp的时候要加上providers这个参数
///
class Counter  with ChangeNotifier{
  int value = 0;

  increment(int index){
    value = index;
    notifyListeners();
  }
}