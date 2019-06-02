import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CartPage extends StatefulWidget {
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> testList = [];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setHeight(500),
              child: ListView.builder(
                itemCount: testList.length,
                itemBuilder: (context,index){
                    return ListTile(
                      title: Text(testList[index]),
                    );
                },
              ),
            ),
            RaisedButton(
              onPressed: (){
                  _add();
              },
              child: Text("增加"),
            ),
            RaisedButton(
              onPressed: (){
                  _clear();
              },
              child: Text("清空"),
            )
          ],
        ),


    );
  }

  //增加方法
  void _add() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String temp = "技术胖最胖！！";
    testList.add(temp);
    sp.setStringList("testinfo", testList);
    _show();
  }

  void _show() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getStringList("testinfo") != null) {
      setState(() {
        testList = sp.getStringList("testinfo");
      });
    }
  }

  void _clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //sp.clear();
    sp.remove("testinfo");
    setState(() {
      testList = [];
    });
  }
}
