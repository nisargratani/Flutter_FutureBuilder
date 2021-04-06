import 'package:demo_futurebuilder/user.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<User>> getUsers() async {
    var dio = Dio();
    List<User> allUsers = [];
    await Future.delayed(
      const Duration(seconds: 3),
    );
    Response response = await dio.get('https://api.github.com/users');
    print(response.data);
    for (var i in response.data) {
      var user = User();
      user.name = i['login'];
      user.id = i['id'];
      user.avatarUrl = i['avatar_url'];
      allUsers.add(user);
    }
    return allUsers;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(accentColor: Colors.lightGreen),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          leading: Icon(Icons.person),
        ),
        body: FutureBuilder(
            future: getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].avatarUrl),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].id.toString()),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
