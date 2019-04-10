import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DetailWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodDetail = Provide.value<DetailsInfoProvide>(context)
      .goodInfo.data.goodInfo.goodsDetail;
    return Provide<DetailsInfoProvide>(
      builder: (context,child,value){
        var isLeft = value.isLeft;
        if(isLeft){
          return Container(
            child: Html(data: goodDetail),
          );
        }else{
          return Container(
              width: ScreenUtil.instance.setWidth(750),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text("暂时没有数据"),
          );
        }

      },
    );
  }
}
