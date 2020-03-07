import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'newAccount.dart';
import 'updateAccount.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.redAccent, primarySwatch: Colors.red),
        title: 'Notif List',
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => AllNotifs(),
          '/NewNotif': (context) => Newnotif(),
        });
  }
}

class AllNotifs extends StatefulWidget {
  @override
  _AllNotifsState createState() => new _AllNotifsState();
}

class _AllNotifsState extends State<AllNotifs> {
  var _isLoading = false;
  var items;
  var tof, name, ps, adress, phone;

  Future<String> _showDialog(String msg) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: new Text('Info '),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getData() async {
    final url =
        "https://prayingkeralaevent.000webhostapp.com/NotifSelectAllUsers.php";
    final response = await http.get(url);
    http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final events = map["result"];

      setState(() {
        _isLoading = true;
        this.items = events;
        print(items);
      });
    }
  }

  void _deletUser(var id) async {
    setState(() {
      _isLoading = false;
    });
    var url =
        "https://prayingkeralaevent.000webhostapp.com/NotifDeleteUser.php";

    var response = await http.post(url, body: {"id": id});
    if (response.statusCode == 200) {
      _showDialog("Deleted");
    } else {
      _showDialog("Not Deleted");
    }
    _getData();
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          child: AppBar(
            centerTitle: true,
            elevation: 2,
            title: Text("Notifications",
                style: TextStyle(
                    fontFamily: 'raleway',
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 22)),
            backgroundColor: Colors.white,
          ),
        ),
        preferredSize: Size.fromHeight(64),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/NewNotif');
        },
        elevation: 5,
        backgroundColor: Colors.redAccent,
        child: FittedBox(
            child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Container(
            height: 56,
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: 28,
                      ),
                      color: Colors.redAccent,
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                          _getData();
                        });
                      },
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        size: 28,
                      ),
                      color: Colors.redAccent,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: Center(
          child: !_isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                )
              : ListView.builder(
                  itemCount: this.items != null ? this.items.length : 0,
                  itemBuilder: (context, i) {
                    final item = this.items[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.all(20),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ListTile(
                            title: Text(item["notifTitle"],
                                style: TextStyle(
                                    fontFamily: 'raleway',
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              item["notifBody"],
                              maxLines: 1,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                _deletUser(item["id"]);
                              },
                            ),
                            leading: Container(
                                width: 50,
                                child: Center(
                                    child: SizedBox(
                                  height: 74,
                                  width: 3,
                                  child: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.redAccent),
                                  ),
                                ))),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Update(idUser: item["id"])));
                        },
                      ),
                    );
                  },
                )),
    );
  }

}
