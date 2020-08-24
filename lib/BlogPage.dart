
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogPage extends StatefulWidget {
  static String tag = 'blog-page';	

  @override
  _BlogPageState createState() => _BlogPageState();

}

class _BlogPageState extends State<BlogPage> {
  //Funcao para buscar as noticias
  
  ScrollController _scrollController = new ScrollController();
  
  Future<Blog> _getUsers(slug) async {
    var data = await http.get("http://10.0.2.2:8000/blog/get/"+slug);
    if (data.statusCode == 200) {
        print('Status Code 200: Ok!');
        var jsonData = json.decode(data.body);
        Blog user = Blog(jsonData["data"]["blog"]["id"], jsonData["data"]["blog"]["heading"], jsonData["data"]["blog"]["content"]);
        return user;
    } else {
      throw Exception('Failed to load json');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

	var slug = ModalRoute.of(context).settings.arguments;
	

    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Page'),
      ),
      body: FutureBuilder(

            future: _getUsers(slug),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){

                return Center(
                  child: CircularProgressIndicator(),
                );

              } else {
                return Container(
					child:Column(
						children: <Widget>[
							Text(snapshot.data.heading),
							const SizedBox(height: 16.0),
							Text(snapshot.data.content),
						],
					),
                );

              }

            },

        )

    );
  }
  

  
}

class Blog {

  final int id;
  final String heading;
  final String content;

  Blog(this.id, this.heading, this.content);

}



