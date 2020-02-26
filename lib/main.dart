import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'events/ThemeEvent.dart';
import 'constants/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constants.eventBus.on<ThemeEvent>().listen((event) {
      setState(() {
        //TODO 应该添加至SP中持久化，待下次进入时使用
        Constants.currentTheme = event.themeModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Constants.currentTheme == Constants.dayTheme
        ? ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        accentColor: Colors.pink)
        : ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.pink);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: IndexPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

