import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import 'package:flutter_shop/constants/constants.dart';
import 'package:flutter_shop/events/ThemeEvent.dart';
import 'package:flutter_shop/models/channel.dart';
import 'package:flutter_shop/widgets/newsListWidget.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';
  //首页面所有数据的容器
  List<dynamic> newsData;
  //初始化频道数据的容器
  List<Channel> channels;
  TabController _tabController;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
//    getHomePageContent().then((val) {
//      setState(() {
//        homePageContent = val.toString();
//      });
//    });
    // TODO: implement initState
    super.initState();
    initChannelData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  // 加载json数据
  initChannelData() {
    print(" --- 数据初始化 --- ");
    channels = List<Channel>();
    Future<String> data =
    DefaultAssetBundle.of(context).loadString("assets/config/channel.json");
    data.then((String value) {
      setState(() {
        List<dynamic> data = json.decode(value);
        _tabController = TabController(
          vsync: this,
          length: data.length,
        );
        data.forEach((tmp) {
          channels.add(Channel.fromJson(tmp));
        });
      });
    });
  }

  // 初始化标题指示条
  Widget initChannelTitle() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.blue[100],
      tabs: channels.map((Channel channel) {
        return Tab(
          text: channel.channelName,
        );
      }).toList(),
    );
  }

  //初始化列表内容
  Widget initChannelList() {
    return TabBarView(
      controller: _tabController,
      children: channels.map((Channel channel) {
        return NewsListWidget(channel: channel);
      }).toList(),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: channels.length,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.title),
            title: Text(Strings.appTitle, style: TextStyle(color: Colors.white),),
            bottom: initChannelTitle(),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.assignment),
                onPressed: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                }),
              ),
              IconButton(
                  icon: Icon(Icons.autorenew),
                  onPressed: (() {
                    Constants.eventBus.fire(
                        Constants.currentTheme == Constants.dayTheme
                            ? ThemeEvent(Constants.nightTheme)
                            : ThemeEvent(Constants.dayTheme));
                  }))
            ],
          ),
          body: initChannelList(),
        )
    );
  }
}

