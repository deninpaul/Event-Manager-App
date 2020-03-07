class EventClass{
  int id;
  String eventName;
  String eventInfo;
  String eventTime;
  int eventDay;

  EventClass({this.id, this.eventName, this.eventInfo, this.eventTime, this.eventDay});

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'eventInfo': eventInfo,
      'eventTime': eventTime,
      'eventDay': eventDay
    };
  }

  // Extract a Note object from a Map object
  EventClass.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.eventName = map['eventName'];
    this.eventInfo= map['eventInfo'];
    this.eventTime = map['eventTime'];
    this.eventDay = map['eventDay'];
  }
}

class NotifClass{
  int id;
  String notifTitle;
  String notifBody;
  String notifTime;
  NotifClass({this.id, this.notifTitle, this.notifBody, this.notifTime});

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notifTitle': notifTitle,
      'notifBody': notifBody,
      'notifTime': notifTime,
    };
  }

  // Extract a Note object from a Map object
  NotifClass.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.notifTitle = map['notifTitle'];
    this.notifBody= map['notifBody'];
    this.notifTime = map['notifTime'];
  }
}