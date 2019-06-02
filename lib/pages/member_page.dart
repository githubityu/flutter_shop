import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("会员中心"),
        ),
        body: ListView(
          children: <Widget>[_topHeader(), _orderTitle(), _orderType(),_actionList()],
        ),
      ),
    );
  }

  Widget _topHeader() {
    return Container(
      width: ScreenUtil.instance.setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ClipOval(
              child: Image.network(
                  "http://blogimages.jspang.com/blogtouxiang1.jpg"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text("技术胖",
                style: TextStyle(
                    fontSize: ScreenUtil.instance.setSp(36),
                    color: Colors.black54)),
          )
        ],
      ),
    );
  }

  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text("我的订单"),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil.instance.setWidth(750),
      height: ScreenUtil.instance.setHeight(150),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil.instance.setWidth(187),
            child: Column(
              children: <Widget>[Icon(Icons.party_mode, size: 20), Text("待付款")],
            ),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.query_builder, size: 20),
                Text("待发货")
              ],
            ),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.directions_car, size: 20),
                Text("待收货")
              ],
            ),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(Icons.content_paste, size: 20),
                Text("待评价")
              ],
            ),
          )
        ],
      ),
    );
  }

//通过listtitle

  Widget _myListTitle(String title) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
              width: 1,
              color: Colors.black12,
          ))),
          child: ListTile(
            leading: Icon(Icons.blur_circular),
            title: Text(title),
            trailing: Icon(Icons.arrow_right),
          ),
    );
  }

  Widget _actionList(){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTitle("领取优惠券"),
          _myListTitle("已领取优惠券"),
          _myListTitle("地址管理"),
          _myListTitle("客服电话"),
          _myListTitle("关于我们"),
        ],
      ),
    );
  }
}
