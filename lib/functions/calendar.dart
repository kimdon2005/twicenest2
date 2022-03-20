import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:device_calendar/device_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

// As an example, our default timezone is UTC.
tz.Location _currentLocation = tz.getLocation('Etc/UTC');

Future setCurentLocation(pageurl) async {
  String timezone = 'Etc/UTC';

  try {
    timezone = await FlutterNativeTimezone.getLocalTimezone();
  } catch (e) {
    print('Could not get the local timezone');
  }

  _currentLocation = tz.getLocation(timezone);
  tz.setLocalLocation(_currentLocation);
  final response = await http.get(Uri.parse(pageurl));
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    final scheduleid =
        document.getElementsByClassName('schedule_view schedule_bottom');
    for (int i = 0; i < scheduleid.length; i++) {
      final scheduleName = scheduleid[i].text;
      String id =
          scheduleid[i].parent!.parent!.parent!.id.toString().substring(23);
      List<int> split = id.split('-').map(int.parse).toList();
      final datetime = DateTime(split[0], split[1], split[2]);
      final datetime1 = DateTime(split[0], split[1], split[2], 1);
      final starttime = tz.TZDateTime.from(datetime, _currentLocation);
      final endtime = tz.TZDateTime.from(datetime1, _currentLocation);
      addcalendar(scheduleName, starttime, endtime, _currentLocation);
    }
  }
}

Future<void> addcalendar(scheduleName, starttime, endtime, location) async {
  final status = await Permission.calendar.request();
  if (status.isGranted) {
    DeviceCalendarPlugin devicecalenar = DeviceCalendarPlugin();
    final pref = await SharedPreferences.getInstance();
    var calendarid = pref.getString('calendarid');
    if (calendarid == null) {
      var id = await devicecalenar.createCalendar('트둥닷컴',
          calendarColor: Colors.black, localAccountName: '');
      pref.setString('calendarid', id.data as String);
      final device = Event(id.data);
      device.title = scheduleName;
      device.allDay = true;
      device.start = starttime;
      device.end = endtime;
      devicecalenar.createOrUpdateEvent(device);
    }
    final device = Event(calendarid);
    device.title = scheduleName;
    device.allDay = false;
    device.start = starttime;
    device.end = endtime;
    devicecalenar.createOrUpdateEvent(device);
  }
}
