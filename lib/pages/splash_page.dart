import 'dart:ui';

import 'package:flutter/material.dart';


class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: FadeInImage.assetNetwork(
                  placeholder: "images/ic_splash.webp",
                  image:
                  "https://p0.ssl.qhimgs1.com/sdr/200_200_/t0144f3791b24151a6c.jpg",
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  fit: BoxFit.cover)
          ),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 8,
                    sigmaY: 8
                ),
                child: Opacity(
                  opacity: 0.6,
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Text("张三"),
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
