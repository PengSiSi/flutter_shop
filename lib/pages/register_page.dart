import 'package:flutter/material.dart';
import 'member_page.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
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
  String userName;
  String password;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => MemberPage()),
//    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberPage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => userName = value,
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      decoration: InputDecoration(
                        labelText: '用户名',
                        hintText: '2-20 个中英文字符',
                      ),
                      validator: (value) {
                        if (value.length < 2 || value.length > 20) {
                          return '长度不符合要求';
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
                        labelText: '密码',
                        hintText: '6-20 个字符',
                      ),
                      validator: (value) {
                        if (value.length < 6 || value.length > 20) {
                          return '长度不符合要求';
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4.0),
                      child: RaisedButton(
                        padding: EdgeInsets.all(
                            8.0),
                        onPressed: _submit,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          '注册',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .button
                              .copyWith(
                            fontSize: 16,
                            letterSpacing: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

