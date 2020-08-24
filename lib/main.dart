import 'package:flutter/material.dart';
import 'package:blog/Blogs.dart';
import 'package:blog/BlogPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Blogs.tag: (context) => Blogs(),
    BlogPage.tag: (context) => BlogPage(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Demo',
      theme: ThemeData(
		primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),
      home: Blogs(title:'Blogs'),
      routes: routes,
    );
  }
}




























/*
import 'package:flutter/material.dart';
import 'package:blog/list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lazy List'),
        ),
        body: ListScreen(),
      ),
    );
  }
}
*/
