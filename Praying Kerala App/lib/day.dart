import 'package:flutter/material.dart';
import 'package:pr_official/model.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class DayPage extends StatefulWidget {
  DayPage({Key key, @required this.day}) : super(key: key);
  final int day;

  @override
  _DayPageState createState() => new _DayPageState(day: day);
}

class _DayPageState extends State<DayPage> {
  _DayPageState({Key key, @required this.day});
  final int day;
  bool isLoaded = false;
  DatabaseHelper databasehelper = DatabaseHelper();
  List<EventClass> events;

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
        body: Center(
      child: !isLoaded
          ? CircularProgressIndicator()
          : Stack(
              children: <Widget>[
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                        alignment: AlignmentDirectional.topCenter,
                        child: Text("Day 0$day",
                            style: TextStyle(
                              fontFamily: 'raleway',
                              color: Colors.redAccent,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            )))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DraggableScrollableSheet(
                    maxChildSize: 0.95,
                    initialChildSize: 0.7,
                    minChildSize: 0.7,
                    builder: (context, scrollController) {
                      return Container(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: ListView.builder(
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                events.length == null ? 0 : events.length,
                            itemBuilder: (BuildContext context, int i) {
                              if (events[i].eventDay == day) {
                                return Card(
                                  elevation: 2,
                                  margin: EdgeInsets.only(top: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                                            '${events[i].eventName}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'raleway',
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            selectedTime(
                                                "${events[i].eventTime}"),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black),
                                          ),
                                        )),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            title:
                                                Center(
                                                  child: Text("${events[i].eventName}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .redAccent,
                                                                fontFamily:
                                                                    'raleway',
                                                                fontSize: 24)),
                                                ),
                                                elevation: 2,
                                            content: Container(
                                              height: 275,
                                              width: 275,
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                          "Time: ${selectedTime(events[i].eventTime)}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black,
                                                              fontFamily:
                                                                  'raleway',
                                                              fontSize: 18)),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2),
                                                      ),
                                                      Text(
                                                          "${events[i].eventInfo}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontFamily:
                                                                  'raleway',
                                                              fontSize: 18)),
                                                    ],
                                                  )),
                                            ),
                                          ));
                                    },
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 0,
                                );
                              }
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
            ),
    ));
  }

  _updater() async {
    if (events == null) {
      events = List<EventClass>();
      final Future<Database> dbFuture = databasehelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<EventClass>> eventListFuture = databasehelper.getNoteList();
        eventListFuture.then((eventList) {
          setState(() {
            this.events = eventList;
            isLoaded = true;
          });
        });
      });
    }
  }

  String selectedTime(String timeString) {
    TimeOfDay time;

    time = TimeOfDay(
        hour: int.parse(timeString.split(":")[0]),
        minute: int.parse(timeString.split(":")[1]));

    return time.hour >= 12
        ? time.hour == 12
            ? (time.minute < 10
                ? '${time.hour}:0${time.minute} pm'
                : '${time.hour}:${time.minute} pm')
            : (time.minute < 10
                ? '${time.hour - 12}:0${time.minute} pm'
                : '${time.hour - 12}:${time.minute} pm')
        : time.hour != 0
            ? (time.minute < 10
                ? '${time.hour}:0${time.minute} am'
                : '${time.hour}:${time.minute} am')
            : (time.minute < 10
                ? '${time.hour + 12}:0${time.minute} am'
                : '${time.hour + 12}:${time.minute} am');
  }
}
