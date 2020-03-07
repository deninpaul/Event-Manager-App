import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'model.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'eventdb.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE eventTable (id INTEGER PRIMARY KEY AUTOINCREMENT, eventName TEXT, eventInfo TEXT, eventTime TEXT, eventDay INT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.query('eventTable', orderBy: 'eventTime ASC');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<EventClass>> getNoteList() async {
    var eventMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        eventMapList.length; // Count the number of map entries in db table

    List<EventClass> eventList = List<EventClass>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      eventList.add(EventClass.fromMapObject(eventMapList[i]));
    }
    return eventList;
  }

  Future<int> insertNote(EventClass event) async {
    Database db = await this.database;
    var result = await db.insert('eventTable', event.toMap());
    return result;
  }
}


class DatabaseHelperNotif {
  static DatabaseHelperNotif _databaseHelper;
  static Database _database;

  DatabaseHelperNotif._createInstance();

  factory DatabaseHelperNotif() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelperNotif._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notifdb.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE notifTable (id INTEGER PRIMARY KEY AUTOINCREMENT, notifTitle TEXT, notifBody TEXT, notifTime TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.query('notifTable', orderBy: 'notifTime DESC');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<NotifClass>> getNoteList() async {
    var eventMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        eventMapList.length; // Count the number of map entries in db table

    List<NotifClass> eventList = List<NotifClass>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      eventList.add(NotifClass.fromMapObject(eventMapList[i]));
    }
    return eventList;
  }

  Future<int> insertNote(NotifClass notif) async {
    Database db = await this.database;
    var result = await db.insert('notifTable', notif.toMap());
    return result;
  }
}



Future<Null> getData() async {
  int result;
  bool connected = true;
  DatabaseHelper helper = DatabaseHelper();

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    print('not connected');
    connected = false;
  }

  if (connected) {
    final url =
        "https://prayingkeralaevent.000webhostapp.com/SelectAllUsers.php";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      {
        final map = json.decode(response.body);
        final events = map["result"];
        int count = events.length;

        //deleting existing data and replacing with new
        Database db = await helper.database;
        var deleteresult = await db.delete('eventTable');
        debugPrint('Delete Result: $deleteresult');

        //entering
        for (int i = 0; i < count; i++) {
          EventClass eventList = new EventClass();
          eventList.eventName = events[i]['eventName'];
          eventList.eventInfo = events[i]['eventInfo'];
          eventList.eventTime = events[i]['eventTime'];
          eventList.eventDay = int.parse(events[i]['eventDay']);
          result = await helper.insertNote(eventList);
          print(eventList.eventDay);
        }
      }

      if (result != 0) {
        debugPrint("Successfully added to eventTable");
      } else {
        debugPrint("Add failed to eventTable");
      }
    }
    {
      DatabaseHelperNotif helpernotif = DatabaseHelperNotif();
      final url =
          "https://prayingkeralaevent.000webhostapp.com/NotifSelectAllUsers.php";
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        final notifs = map["result"];
        int count = notifs.length;

        Database db = await helpernotif.database;
        var deleteresult = await db.delete('notifTable');
        debugPrint('Delete Result: $deleteresult');

        print(notifs.length);
        //entering
        for (int i = 0; i < count; i++) {
          NotifClass notifList = new NotifClass();
          notifList.notifTitle = notifs[i]['notifTitle'];
          notifList.notifBody = notifs[i]['notifBody'];
          notifList.notifTime = notifs[i]['notifTime'];
          result = await helpernotif.insertNote(notifList);
          print(notifList.notifTitle);
        }
      }

      if (result != 0) {
        debugPrint("Successfully added to noyifTable");
      } else {
        debugPrint("Add failed to notifTable");
      }
    }
  }
}
