import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class CategoryPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CategoryPage> with AutomaticKeepAliveClientMixin  {
  @override
  void initState() {
    // TODO: implement initState

    print("CategoryPage==initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品分类"),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          LeftCategoryNav(),
          Column(
            children: <Widget>[
              RightCategoryNav(), //右侧上面的选项列表
              CategoryGoods(), //商品列表
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<Data> list = [];
  var listIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getCategory();
    _getGoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.instance.setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
//            return Text('$index');
            return _lefgLnkWel(index);
          }),
    );
  }

  Widget _lefgLnkWel(int index) {
    bool isClick = index == listIndex;
    return InkWell(
      onTap: () {
//        Fluttertoast.showToast(
//            msg: list[index].mallCategoryName, toastLength: Toast.LENGTH_SHORT);
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;

        Provide.value<ChildCategory>(context)
            .getChildCategory(childList, categoryId);
        _getGoodList(categoryId: categoryId);
        print("_lefgLnkWel=$categoryId");
      },
      child: Container(
        height: ScreenUtil.instance.setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil.instance.setSp(28)),
        ),
      ),
    );
  }

  void _getCategory() async {
    await request("getCategory", type: 1).then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  void _getGoodList({String categoryId}) async {
    var data = {
      "categoryId": categoryId == null ? '4' : categoryId,
      "categorySubId": "",
      "page": 1
    };
    await request("getMallGoods", formData: data, type: 1).then((val) {
      var data = json.decode(val);
      CategoryGoodsListModel model = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(model.data == null ? [] : model.data);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    //      return Container(child:
//        Text('我是内容'));
    return Provide<ChildCategory>(builder: (context, child, pro) {
      return Container(
          height: ScreenUtil.instance.setHeight(80),
          width: ScreenUtil.instance.setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pro.childData.length,
            //itemCount: 10,
            itemBuilder: (context, index) {
              // return Text('$index');
              return _rightInkWell(index, pro.childData[index]);
            },
          ));
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    isCheck = (index == Provide.value<ChildCategory>(context).childIndex);
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil.instance.setSp(28),
              color: isCheck ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  void _getGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods', formData: data, type: 1).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(goodsList.data == null ? [] : goodsList.data);
    });
  }
}

class CategoryGoods extends StatefulWidget {
  @override
  _CategoryGoodsState createState() => _CategoryGoodsState();
}

class _CategoryGoodsState extends State<CategoryGoods> {
  List<Data2> list = [];
  var _footerKey = GlobalKey<RefreshFooterState>();
  var scrollCon = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            scrollCon.jumpTo(0);
            print("scrollCon.jumpTo");
          }
        } catch (e) {
          print("进入页面第一次初始化$e");
        }

        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil.instance.setWidth(570),
//       child: Text("商品列表"),
              child: EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText:
                        Provide.value<ChildCategory>(context).noMoreText,
                    moreInfo: "加载中...",
                    loadReadyText: "上拉加载",
                  ),
                  loadMore: () async {
                    _getMoreList();
                  },
                  child: ListView.builder(
                      controller: scrollCon,
                      itemCount: data.goodsList.length,
                      itemBuilder: (context, index) {
                        return _ListWidget(data.goodsList, index);
                      })),
            ),
          );
        } else {
          return Text("暂时没有数据");
        }
      },
    );
  }

  void _getGoodList(String categoryId) async {
    var data = {
      "categoryId": categoryId == null ? '4' : categoryId,
      "categorySubId": "",
      "page": 1
    };
    await request("getMallGoods", formData: data, type: 1).then((val) {
      var data = json.decode(val);
      CategoryGoodsListModel model = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context)
          .getGoodsList(model.data == null ? [] : model.data);
    });
  }

  Widget _goodImage(List newList, int index) {
    return Container(
      width: ScreenUtil.instance.setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil.instance.setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil.instance.setSp(28)),
      ),
    );
  }

  Widget _goodPrice(List newList, index) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil.instance.setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            "价格：￥${newList[index].presentPrice}",
            style: TextStyle(
                color: Colors.pink, fontSize: ScreenUtil.instance.setSp(30)),
          ),
          Text(
            "￥${newList[index].oriPrice}",
            style: TextStyle(
                color: Colors.black12, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _ListWidget(List newList, index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodImage(newList, index),
            Column(
              children: <Widget>[
                _goodName(newList, index),
                _goodPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }

  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    request("getMallGoods", formData: data, type: 1).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsListModel =
          CategoryGoodsListModel.fromJson(data);
      if (goodsListModel.data == null) {
        Provide.value<ChildCategory>(context).changeNoMore("没有更多了");
      } else {
        Provide.value<CategoryGoodsListProvide>(context)
            .getMoreList(goodsListModel.data);
      }
    });
  }
}
