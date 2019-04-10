import 'package:flutter/material.dart';
import 'package:flutter_shop/model/details.dart';

import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodInfo;
  bool isLeft = true;
  bool isRight =false;
  getGoodsInfo(String id) async {
    var formData = {"goodId": id};
     await request("getGoodDetailById", formData: formData, type: 1).then((value) {
      var data = json.decode(value.toString());
      print("DetailsInfoProvide==${value.toString()}");
      goodInfo = DetailsModel.fromJson(data);
      notifyListeners();
    });
  }

  changeLeftAndRight(String changeState){
     isLeft = "left"==changeState;
     isRight = !isLeft;
     print("$isLeft===$isRight");
     notifyListeners();
  }
}
