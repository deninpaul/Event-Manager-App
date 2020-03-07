import 'package:event/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => new _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  var _eventnameController = new TextEditingController();
  var _eventinfoController = new TextEditingController();
  TimeOfDay _time = new TimeOfDay.now();
  String eventTime;
  final _formKey = GlobalKey<FormState>();
  String eventDay = '1';

  void onCreatedAccount() {
    var alert = new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: new Text('Info'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('You have created a new Event'),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Ok'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AllUsers()),(Route<dynamic> route)=> false);
          },
        ),
      ],
    );
    showDialog(context: context, child: alert);
  }

  void _addData() {
    var url = "https://prayingkeralaevent.000webhostapp.com/NewUser.php";

    http.post(url, body: {
      "eventName": _eventnameController.text,
      "eventInfo": _eventinfoController.text,
      "eventTime": eventTime,
      "eventDay": eventDay,
    });

    onCreatedAccount();
    //print(_adresseController.text);
  }

  void initState() {
    super.initState();
    eventTime = "${_time.hour}:${_time.minute}";
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
              title: Text("New Event",
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
                          Padding(padding: EdgeInsets.all(6),),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Event Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 3))),
                            keyboardType: TextInputType.text,
                            controller: _eventnameController,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'raleway',
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value.length < 3)
                                return "Event Name should have more than 2 charecters";
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
                                labelText: "Event Description",
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
                            controller: _eventinfoController,
                            validator: (value) {
                              if (value.length < 1)
                                return "Event Description should not be blank";
                              else
                                return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 24, 12, 12),
                            child: Text("Time:",
                                style: TextStyle(
                                    fontFamily: 'raleway',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(selectedTime(_time),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'raleway')),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: OutlineButton(
                                      onPressed: () => selectTime(context),
                                      color: Colors.redAccent,
                                      child: Text(
                                        "Change Time",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'raleway'),
                                      ),
                                      borderSide: BorderSide(width: 3, color: Colors.redAccent),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                    ),
                                    height: 40,
                                    margin: EdgeInsets.only(left: 5),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Day:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'raleway',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: eventDay,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'raleway',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  underline: Container(
                                      height: 2, color: Colors.redAccent),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      eventDay = newValue;
                                    });
                                  },
                                  items: <String>['1', '2', '3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: TextStyle(
                                              fontFamily: 'raleway',
                                            )));
                                  }).toList(),
                                ),
                              ],
                            ),
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
                                  if(_formKey.currentState.validate()){
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
        eventTime = (_time.hour < 10)
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
