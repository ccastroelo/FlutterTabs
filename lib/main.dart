import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyTabs(),
    );
  }
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  final String url = "https://jsonplaceholder.typicode.com/todos";
  List<Post> specials =[];
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 3);

    this.getSpecials().then((jsonSpecials) {
      setState(() {
        specials = jsonSpecials.map((j)=>Post.fromJson(j)).toList();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<List> getSpecials() async {
    var response = await http.get(Uri.encodeFull(url),
        headers: {"Accept": "application/json"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons
              .dehaze), //there's an "action" option for menus and stuff. "leading" for show
          title: specials == null
              ? Text("LOCAL HOUR")
              : Text("Now with more special"),
          backgroundColor: Colors.green,
          bottom: TabBar(
            controller: controller,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Today", style: TextStyle(fontSize: 15.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Tomorrow", style: TextStyle(fontSize: 15.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Next Day", style: TextStyle(fontSize: 15.0)),
              ),
            ],
          )),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          SecondPage(specials: specials),
          SecondPage(specials: specials),
          SecondPage(specials: specials),
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  final List<Post> specials;

  SecondPage({this.specials, Key key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.specials.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(widget.specials[index].title));
      },
    );
  }
}

class Post {
  int userId;
  int id;
  String title;
  bool completed;

  Post({this.userId, this.id, this.title, this.completed});

  Post.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['completed'] = this.completed;
    return data;
  }
}
