import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childData = [];

  int childIndex = 0;
  String categoryId = "4";
  String subId = "";
  int page = 1;
  String noMoreText = "";

  getChildCategory(List<BxMallSubDto> list, String id) {

    page = 1;
    noMoreText = "";
    childIndex = 0;
    categoryId = id;
    var all = BxMallSubDto();
    all.mallCategoryId="00";
    all.mallSubId ="";
    all.mallSubName = "全部";
    all.comments = null;
     childData=[all];
    // childData.add(d);
     childData.addAll(list);
//    childData=list;
    notifyListeners();
  }

  changeChildIndex(index,String id){
    page = 1;
    noMoreText = "";
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  addPage(){
    page++;
  }
  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }


}
