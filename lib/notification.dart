// send notifactaion
import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'widgets/comp.dart';

sendNotification(title, body, tobic, context) async {

  var serverToken =
      'AAAAJVcbOxU:APA91bH43M9g4MUYvEsOHqM7_i-zLDs51vXpAz7tgXDv4ntLig5wH9RYMVpMmbt0yUWYEbnDArRuhyNBfC9XCr9YbfVpRn1OAQXmlni2wNYPtFUP-XICXEcI7NiplXp5ADAYBc9topud';
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body.toString(),
          'title': title.toString()
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': '/topics/$tobic',
      },
    ),
  );
 

}


class FirebaseNotifications {
  late FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessaging_Listeners();

  }

  void firebaseCloudMessaging_Listeners() {
    

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    
  }

}