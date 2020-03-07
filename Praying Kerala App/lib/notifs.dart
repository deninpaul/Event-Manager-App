import 'package:flutter/material.dart';
import 'package:pr_official/model.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => new _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  bool isLoaded = false;
  DatabaseHelperNotif databasehelper = DatabaseHelperNotif();
  List<NotifClass> notifs;

  @override
  void initState() {
    super.initState();
    _updater();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isLoaded
            ? CircularProgressIndicator()
            : Stack(
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 50),
                      child: Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Text("Notifications",
                            style: TextStyle(
                              fontFamily: 'raleway',
                              color: Colors.redAccent,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            )),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DraggableScrollableSheet(
                      maxChildSize: 0.95,
                      initialChildSize: 0.7,
                      minChildSize: 0.7,
                      builder: (context, scrollController) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Container(
                            child: ListView.builder(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  notifs.length == null ? 0 : notifs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(top: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: ListTile(
                                        leading: Container(
                                            width: 50,
                                            child: Center(
                                                child: SizedBox(
                                              height: 100,
                                              width: 3,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.redAccent),
                                              ),
                                            ))),
                                        title: Text(
                                          '${notifs[index].notifTitle}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'raleway',
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          "${notifs[index].notifBody}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,

                              /// To set radius of top left and top right
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    spreadRadius: 2)
                              ]),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }

  _updater() async {
    if (notifs == null) {
      notifs = List<NotifClass>();
      final Future<Database> dbFuture = databasehelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<NotifClass>> notifListFuture = databasehelper.getNoteList();
        notifListFuture.then((notifList) {
          setState(() {
            this.notifs = notifList;
            isLoaded = true;
          });
        });
      });
    }
  }



}
