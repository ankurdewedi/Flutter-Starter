import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:blog/BlogPage.dart';

//SO_REUSEPORT unavailable on compiling system

class Blogs extends StatefulWidget {
  static String tag = 'blog';	

  Blogs({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BlogsState createState() => _BlogsState();

}

class _BlogsState extends State<Blogs> {
	
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  
  Future<List<User>> _users;
  final _itemFetcher = _ItemFetcher();
  List<User> _list;
  bool _isLoading = false;
  bool _hasMore = true;
  
  Future<List<User>> _getUsers() async {
    var data = await http.get("http://10.0.2.2:8000/blogs/get/all");
    if (data.statusCode == 200) {
        print('Status Code 200: Ok!');
        var jsonData = json.decode(data.body);
        List<User> users = [];
        for (var u in jsonData["data"]["blogs"]) {
          User user = User(u["id"], u["slug"], u["heading"], u["content"], u["created_at"]);
          users.add(user);
        }
        return users;
    } else {
      throw Exception('Failed to load json');
    }
  }


  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  _getMoreData() async {
	  if (!_isLoading) {
		  await Future.delayed(Duration(seconds: 2), () {
    _isLoading = true;
    _itemFetcher._getUsers().then((List<User> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          //_hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _list.addAll(fetchedList);
          //_hasMore = false;
        });
      }
    });
});
}
  }


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
		_isLoading = false;
		if(_list != null){
			_list.clear();
		}
      _users = _getUsers();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: FutureBuilder(

            future: _users,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){

                return Center(
                  child: CircularProgressIndicator(),
                );

              } else {
				  
				if((_list == null) || (_list.length == 0)){
				_list = snapshot.data.toList();
				}
                return ListView.builder(
                itemCount: _isLoading ? _list.length + 1 : _list.length,
                itemBuilder: (BuildContext context, int id){
				if (id >= _list.length) {
				  if (!_isLoading) {
					  print(_isLoading);
					 // _list.add(User(454, "source", "desc", "link", "title", "img", "pubdate"));
					//_loadMore();
					
				  }
				  return new Padding(
					  padding: const EdgeInsets.all(8.0),
					  child: new Center(
						child: new Opacity(
						  opacity: 1.0,//_isLoading ? 1.0 : 0.0,
						  child: new CircularProgressIndicator(),
						),
					  ),
					);
				}

                return InkWell(
				  onTap: () {
					Navigator.of(context).pushNamed(BlogPage.tag, arguments:_list[id].slug);  
				  },
				  child: ListTile(

                  leading: CircleAvatar(
                    child: Text(
                       "A"
                    ),
                  ),

                  title: Text(_list[id].heading),
                  subtitle: Column(
                    children: <Widget>[
                      Row(
                          children: [
                          Text(
                            "__",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Spacer(),
                          Text(_list[id].created_at),
                          ],
                      ),
                    ],
                  )
                ));
                },
                controller: _scrollController,
                );

              }

            },

        ),
        onRefresh: refreshList,
      ),

    );
  }
  
}

class User {

  final int id;
  final String slug;
  final String heading;
  final String content;
  final String created_at;

  User(this.id, this.slug, this.heading, this.content, this.created_at);


}

class _ItemFetcher {
  final _count = 30;
  final _itemsPerPage = 5;
  int _currentPage = 0;

  Future<List<User>> _getUsers() async {
    var data = await http.get("http://10.0.2.2:8000/blogs/get/all");
    if (data.statusCode == 200) {
        print('Status Code 200: Ok!');
        var jsonData = json.decode(data.body);
        List<User> users = [];
        for (var u in jsonData) {
          //print(u["pubdate"]);
          User user = User(u["id"], u["slug"], u["heading"], u["content"], u["created_at"]);
          users.add(user);
        }
        return users;
    } else {
      throw Exception('Failed to load json');
    }
  }
  
}

