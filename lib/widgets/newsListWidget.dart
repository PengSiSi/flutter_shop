import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/service/Apis.dart';
import 'package:flutter_shop/events/BeanEvent.dart';
import 'package:flutter_shop/constants/constants.dart';
import 'package:flutter_shop/models/channel.dart';
import 'package:flutter_shop/models/newList.dart';
import 'package:flutter_shop/pages/newsDetail_page.dart';

class NewsListWidget extends StatefulWidget {
  final Channel channel;
  NewsListWidget({Key key, this.channel}) : super(key: key);

  @override
  _NewsListWidgetState createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> with AutomaticKeepAliveClientMixin {
  // 当前页
  int page = 0;
  //网络请求接口
  API$Neteast _api;
  //该频道下的所有新闻数据
  List<News> _datas;
  ScrollController _listController;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _api = API$Neteast();
    _datas = List<News>();
    _listController = ScrollController();
    _listController.addListener(() {
      var maxScroll = _listController.position.maxScrollExtent;
      var pixels = _listController.position.pixels;
      if (maxScroll == pixels) {
        page += 20;
        getNewsList();
      }
    });

    Constants.eventBus.on<BeanEvent<NewsList>>().listen((event) {
      debugPrint("widget.channel.channelId ${widget.channel.channelId}");
      debugPrint("event.id ${event.id}");
      if (widget.channel.channelId == event.id) {
        setState(() {
          NewsList data = event.data;
          _datas.addAll(data.datas);
        });
      }
    });
    getNewsList();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    _listController.dispose();
    super.dispose();
  }

  getNewsList() {
    _api.getNewsList(widget.channel.channelType, widget.channel.channelId, page);
  }

  Future<Null> pullToRefresh() async {
    page = 0;
    _datas.clear();
    getNewsList();
    return null;
  }

  Widget renderRow(int position) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    News data = _datas[index];

    return Card(
      color: Colors.grey[250],
      elevation: 5.0,
      child: InkWell(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(data.imgsrc, fit: BoxFit.fitWidth),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                data.title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: data.digest.isEmpty
                  ? const EdgeInsets.all(0.0)
                  : const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(
                data.digest,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                '时间：${data.ptime}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(
                '来源：${data.source}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            )
          ],
        ),
        onTap: () {
          onClickItem(index, data);
        },
      ),
    );
  }

  onClickItem(int position, News data) {
    if (data.url == null || data.url.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: new Text('缺少新闻链接'),
        duration: Duration(seconds: 1),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => NewsDetailPage(
            postId: data.postid,
            url: data.url,
            title: "",
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("datas -- ${_datas.toString()}");
    if(_datas == null || _datas.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      Widget listView = ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: _datas.length * 2,
        itemBuilder: (context, i) => renderRow(i),
        controller: _listController,
      );
      return RefreshIndicator(child: listView, onRefresh: pullToRefresh);
    }
  }
}
