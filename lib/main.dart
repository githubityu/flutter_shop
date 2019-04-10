import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/counter.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provide/provide.dart';

import './pages/index_page.dart';

import 'routers/routes.dart';
import 'routers/application.dart';

void main() {
  final counter = Counter();
  final cc = ChildCategory();
  final categoryGoodsListProvide = CategoryGoodsListProvide();
  final deProvide = DetailsInfoProvide();
  final provides = Providers();
  provides
    ..provide(Provider.value(counter))
    ..provide(Provider.value(categoryGoodsListProvide))
    ..provide(Provider.value(cc))..provide(Provider.value(deProvide));
  runApp(ProviderNode(child: MyApp(), providers: provides));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
