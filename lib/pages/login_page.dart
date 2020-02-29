import 'package:flutter/material.dart';
import 'register_page.dart';
import 'member_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static final _formKey = GlobalKey<FormState>();
  FocusNode _passwordFocusNode;
  String username = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  //提交数据
  void _submit() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MemberPage()),
    );
//    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MemberPage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => username = value,
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        hintText: '用户名、手机或邮箱',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '请输入用户名';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      onSaved: (value) => password = value,
                      onFieldSubmitted: (value) => _submit(),
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: '密码',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '请输入密码';
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        onPressed: _submit,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          '登录',
                          style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 32
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '还没有账号？',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  '注册一个',
                  style: TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

