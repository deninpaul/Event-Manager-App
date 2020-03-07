import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Newnotif extends StatefulWidget {
  @override
  _NewnotifState createState() => new _NewnotifState();
}

class _NewnotifState extends State<Newnotif> {
  var _notiftitleController = new TextEditingController();
  var _notifbodyController = new TextEditingController();
  TimeOfDay _time = new TimeOfDay.now();
  String notifTime;
  final _formKey = GlobalKey<FormState>();
  String notifDay = '1';

  void onCreatedAccount() {
    var alert = new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: new Text('Info'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('You have created a new notification'),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AllNotifs()),
                (Route<dynamic> route) => false);
          },
        ),
      ],
    );
    showDialog(context: context, child: alert);
  }

  void _addData() {
    var url = "https://prayingkeralaevent.000webhostapp.com/NotifNewUser.php";
print(_notiftitleController.text);

    http.post(url, body: {
      "notifTitle": _notiftitleController.text,
      "notifBody": _notifbodyController.text,
      "notifTime": notifTime,
    });

    onCreatedAccount();
  }

  void initState() {
    super.initState();
    setState(() {
      notifTime =  (_time.hour < 10)
            ? "0${_time.hour}:${_time.minute}"
            : "${_time.hour}:${_time.minute}";
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: Container(
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20,
                color: Colors.redAccent,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              elevation: 2,
              title: Text("New Notification",
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
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.all(30),
            child: ListView(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(6),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Notification Title",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 3))),
                            keyboardType: TextInputType.text,
                            controller: _notiftitleController,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'raleway',
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value.length < 3)
                                return "Notification Title should have more than 2 charecters";
                              else
                                return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                          ),
                          TextFormField(
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: "Notification Description",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 3))),
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'raleway',
                              fontWeight: FontWeight.w500,
                            ),
                            controller: _notifbodyController,
                            validator: (value) {
                              if (value.length < 1)
                                return "Notification Description should not be blank";
                              else
                                return null;
                            },
                          ),
                          Padding(padding: EdgeInsets.all(12)),
                          Center(
                            child: Container(
                              height: 50,
                              width: 200,
                              child: RaisedButton(
                                elevation: 2,
                                color: Colors.redAccent,
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'raleway',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _addData();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                          ),
                        ]))
              ],
            )));
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null) {
      print('Time Selected: ${_time.toString()}');
      setState(() {
        _time = picked;
        notifTime = (_time.hour < 10)
            ? "0${_time.hour}:${_time.minute}"
            : "${_time.hour}:${_time.minute}";
      });
    }
  }

  String selectedTime(TimeOfDay time) {
    return time.hour >= 12
        ? time.hour == 12
            ? (time.minute < 10
                ? '${time.hour}:0${time.minute}pm'
                : '${time.hour}:${time.minute}pm')
            : (time.minute < 10
                ? '${time.hour - 12}:0${time.minute}pm'
                : '${time.hour - 12}:${time.minute}pm')
        : time.hour != 0
            ? (time.minute < 10
                ? '${_time.hour}:0${time.minute}am'
                : '${_time.hour}:${time.minute}am')
            : (time.minute < 10
                ? '${time.hour + 12}:0${time.minute}am'
                : '${time.hour + 12}:${time.minute}am');
  }
}
