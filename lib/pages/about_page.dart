import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shop/constants/constants.dart';
import 'package:flutter_shop/main.dart';
import 'package:flutter_shop/pages/newsDetail_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(
              size: 55.0,
            ),
            Container(
              padding: EdgeInsets.all(5.0),
            ),
            Text(
              '作者：${Strings.author}',
              style: TextStyle(fontSize: 18.8, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
            ),
            Text(Strings.des),
            Container(
              padding: EdgeInsets.all(5.0),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => NewsDetailPage(
                      url: Strings.github ,
                      title: '思思的Github',
                    )));
              },
              child: Text(
                'Github: ${Strings.github}',
                style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.combine([TextDecoration.underline])
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
