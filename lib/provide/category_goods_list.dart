import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier {
  List<Data2> goodsList = [];

  // 点击大类时更换商品列表
  getGoodsList(List<Data2> list) {
    goodsList = list;
    print("CategoryGoodsListProvide${goodsList.length}");
    notifyListeners();
  }

  getMoreList(List<Data2> list) {
    goodsList.addAll(list);
    notifyListeners();
  }
}
