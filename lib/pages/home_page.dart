import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/routers/application.dart';

import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//第四步
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String hompageContent = "正在获取数据";

  int page = 1;
  List<Map> hotGoods = [];
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(5),
    child: Text("火爆专区"),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
  );

  Widget _wrapList() {
    if (hotGoods.length > 0) {
      List<Widget> listw = hotGoods.map((f) {
        return InkWell(
          onTap: () {
//            Fluttertoast.showToast(
//                msg: "点击了火爆商品", toastLength: Toast.LENGTH_SHORT);
            Application.router.navigateTo(context, "/detail?id=${f['goodsId']}");
          },
          child: Container(
            width: ScreenUtil.instance.setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: <Widget>[
                Image.network(
                  f["image"],
                  width: ScreenUtil.instance.setWidth(375),
                ),
                Text(
                  f["name"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: ScreenUtil.instance.setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text("￥${f["mallPrice"]}"),
                    Text(
                      "￥${f["price"]}",
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listw,
      );
    } else {
      return Text(' ');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _getHotGoods();
    super.initState();
  }

  void _getHotGoods() {
    var fromPage = {"page": page};
    request('homePageBelowConten', formData: fromPage, type: 1).then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("百姓生活+"),
        ),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, jsondata) {
            if (jsondata.hasData) {
              var dt = json.decode(jsondata.data.toString());
              var data = dt["data"];
              List<Map> picdata = (data["slides"] as List).cast();
              List<Map> navs = (data["category"] as List).cast();
              String imageUrl = data["advertesPicture"]["PICTURE_ADDRESS"];
              String image = data["shopInfo"]["leaderImage"];
              String phone = data["shopInfo"]["leaderPhone"];
              List<Map> recommData = (data["recommend"] as List).cast();
              return EasyRefresh(
                  loadMore: () async {
                    var fromPage = {"page": page};
                    await request("homePageBelowConten",
                            formData: fromPage, type: 1)
                        .then((val) {
                      var data = json.decode(val.toString());
                      List<Map> newGoods = (data["data"] as List).cast();
                      setState(() {
                        hotGoods.addAll(newGoods);
                        page++;
                      });
                    });
                  },
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: "",
                    moreInfo: "加载中",
                    loadReadyText: "上啦加载",
                  ),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(picdata),
                      TopNavi(navs),
                      OneImage(imageUrl),
                      callPhone(image, phone),
                      Recommond(recommData),
                      FloorData(recommData),
                      _hotGoods()
                    ],
                  ));
            } else {
              return Center(
                child: Text("加载中"),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SwiperDiy extends StatelessWidget {
  List picDataList;

  SwiperDiy(this.picDataList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.instance.setWidth(300),
      child: Swiper(
        onTap: (index){
          Application.router.navigateTo(context,"/detail?id=${picDataList[index]['goodsId']}");
        },
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${picDataList[index]["image"]}",
            fit: BoxFit.fill,
          );
        },
        itemCount: picDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavi extends StatelessWidget {
  final List navig;

  TopNavi(this.navig);

  @override
  Widget build(BuildContext context) {
    if (navig.length > 10) {
      navig.removeRange(10, navig.length);
    }
    return Container(
      height: ScreenUtil.instance.setWidth(320),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4),
        children: navig.map((f) {
          return _gridviewItem(context, f);
        }).toList(),
      ),
    );
  }

  Widget _gridviewItem(BuildContext context, item) {
    return InkWell(
      onTap: () {
        Fluttertoast.showToast(
            msg: item["mallCategoryName"], toastLength: Toast.LENGTH_SHORT);
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item["image"],
            width: ScreenUtil.instance.setWidth(95),
          ),
          Text(item["mallCategoryName"])
        ],
      ),
    );
  }
}

class OneImage extends StatelessWidget {
  final String _imageUrl;

  OneImage(this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(_imageUrl),
    );
  }
}

class callPhone extends StatelessWidget {
  final String _callImage;
  final String _callPhone;

  callPhone(this._callImage, this._callPhone);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _call();
        },
        child: Image.network(_callImage),
      ),
    );
  }

  void _call() async {
    String url = "tel:" + _callPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "拨打失败", toastLength: Toast.LENGTH_SHORT);
    }
  }
}

class Recommond extends StatelessWidget {
  final List _recommData;

  Recommond(this._recommData);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[_getTitle(), _reCommList()],
      ),
    );
  }

  Widget _getTitle() {
    return Container(
      //此属性会导致子组件match
      alignment: Alignment.centerLeft,
      child: Text(
        "推荐商品",
        style: TextStyle(color: Colors.pink),
      ),
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
    );
  }

  Widget _reCommList() {
    return  Container(
        height: ScreenUtil.instance.setHeight(350),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _recommData.length,
          itemBuilder: (context, index) {
            return _getItem(index);
          },
        ),
    );
  }

  Widget _getItem(int index) {
    return Container(
      width: ScreenUtil.instance.setWidth(250),
      height: ScreenUtil.instance.setHeight(350),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 0.5, color: Colors.black12))),
      child: Column(
        children: <Widget>[
          Image.network(_recommData[index]["image"]),
          Text("￥${_recommData[index]['mallPrice']}"),
          Text(
            "￥${_recommData[index]['price']}",
            style: TextStyle(
                decoration: TextDecoration.lineThrough, color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class FloorData extends StatelessWidget {
  final List floorData;

  FloorData(this.floorData);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: ScreenUtil.instance.setWidth(750),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[getOne(), getOne()],
          ),
          Column(
            children: <Widget>[getTwo(), getTwo(), getTwo()],
          ),
        ],
      ),
    );
  }

//第一列

  Widget getOne() {
    return Container(
      width: ScreenUtil.instance.setWidth(375),
      height: ScreenUtil.instance.setHeight(350),
      decoration: BoxDecoration(color: Colors.red),
      child: Column(
        children: <Widget>[
          LeftText("你是一个不能飞的猪", 20, Colors.blueAccent),
          LeftText("要找风口才能飞起来的猪", 20, Colors.black),
          Image.network(
              "https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png")
        ],
      ),
    );
  }

//第二列

  Widget getTwo() {
    return Container(
      alignment: Alignment.topLeft,
      width: ScreenUtil.instance.setWidth(375),
      height: ScreenUtil.instance.setWidth(240),
      decoration: BoxDecoration(color: Colors.red),
      child: Column(
        children: <Widget>[
          LeftText("汉江（经典汉江）51", 20, Colors.blueAccent),
          getNPP()
        ],
      ),
    );
  }

  //名字价格图片
  Widget getNPP() {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              LeftText(
                "汉江（经典汉江）51",
                20,
                Colors.blueAccent,
                width: 250,
              ),
              LeftText(
                "汉江（经典汉江）51",
                20,
                Colors.blueAccent,
                width: 250,
              ),
            ],
          ),
          Image.network(
            "https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png",
            width: ScreenUtil.instance.setWidth(100),
          )
        ],
      ),
    );
  }
}

class LeftText extends StatelessWidget {
  final String data;
  final double textSize;
  final Color color;
  final Color bgColor;
  final int width;

  LeftText(this.data, this.textSize, this.color,
      {this.bgColor = Colors.white, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width != null && width > 0)
          ? ScreenUtil.instance.setWidth(width)
          : null,
      alignment: Alignment.centerLeft,
      child: Text(
        data,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: textSize,
          height: 1,
          background: Paint()..color = bgColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
