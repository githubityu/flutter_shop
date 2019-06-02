import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/details_page/details_bottom.dart';
import 'package:flutter_shop/pages/details_page/details_explain.dart';
import 'package:flutter_shop/pages/details_page/details_tabbar.dart';
import 'package:flutter_shop/pages/details_page/details_top_area.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provide/provide.dart';
import 'detail_web.dart';


class DetailPage extends StatelessWidget {
  final String goodsId;

  DetailPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              print("返回上一页");
              Navigator.pop(context);
            }),
        title: Text("商品详情页"),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context,snap){
          if(snap.hasData){
            return  Stack(
              children: <Widget>[
                  Container(
                      child: ListView(
                        children: <Widget>[
                          DetailsTopArea(),
                          DetailsExplain(),
                          DetailsTabbar(),
                          DetailWeb(),
                        ],
                      ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(),
                )
              ],
            );
          }else{
            return Text("加载...");
          }
        },
      ),
    );
  }
  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '加载完成............';
  }
}



