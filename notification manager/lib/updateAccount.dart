import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Update extends StatefulWidget {
  final idUser;
  Update({Key key, this.idUser}) : super(key: key);
  @override
  _UpdateState createState() => new _UpdateState();
}

class _UpdateState extends State<Update> {
  var _isLoading = false;
  var data;
  var _notiftitle = "";
  var _notifbody = "";
  var _notiftime = "";
  var _notiftitleController = new TextEditingController();
  var _notifbodyController = new TextEditingController();
  TimeOfDay _time = new TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

  Future<String> _showDialog(String msg) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: new Text('Info'),
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AllNotifs()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _editData() async {
    setState(() {
      _isLoading = false;
    });

    var url = "https://prayingkeralaevent.000webhostapp.com/NotifModifyProfile.php";

    var response = await http.post(url, body: {
      "id": widget.idUser,
      "notifTitle": _notiftitleController.text,
      "notifBody": _notifbodyController.text,
      "notifTime": _notiftime,
    });

    if (response.statusCode == 200) {
      _showDialog("Updated Successfully");
    } else {
      _showDialog("Updated Failer");
    }

    //onEditedAccount();
    //print(_adresseController.text);
  }

  _fetchData() async {
    final url =
        "https://prayingkeralaevent.000webhostapp.com/NotifConsultProfile.php?id=${widget.idUser}";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final videosMap = map["result"];

      setState(() {
        _isLoading = true;
        this.data = videosMap;
        _notiftitle = data[0]['notifTitle'];
        _notifbody = data[0]['notifBody'];
        _notiftime = data[0]['notifTime'];
        print(data);
        _time = TimeOfDay(
            hour: int.parse(_notiftime.split(":")[0]),
            minute: int.parse(_notiftime.split(":")[1]));
        _notiftitleController.text = _notiftitle;
        _notifbodyController.text = _notifbody;
      });
    }
  }

  void initState() {
    super.initState();
    _fetchData();
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
              title: Text("Update Notification",
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
        body: Center(
          child: !_isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                )
              : Container(
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                        "Update",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'raleway',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _editData();
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                    ),
                                  ),
                                ),
                              ]))
                    ],
                  )),
        ));
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
        _notiftime = (_time.hour < 10)
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
                ? '${time.hour}:0${time.minute}am'
                : '${time.hour}:${time.minute}am')
            : (time.minute < 10
                ? '${time.hour + 12}:0${time.minute}am'
                : '${time.hour + 12}:${time.minute}am');
  }
}
