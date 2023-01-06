import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/main.dart';
import 'package:loginsignup/notification.dart';
import 'package:loginsignup/screens/tobicDetails.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:loginsignup/widgets/comp.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import 'home.dart';

class TopicsScreen extends StatefulWidget {
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  

  String? tob_title, decs;
  GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    String title = ModalRoute.of(context)!.settings.arguments as String;
    bool isNotified = pref.containsKey("isNotified${topicses[title]}");
    print(isNotified);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            awesome(context,
                dialogType: DialogType.NO_HEADER,
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            Text(
                              "إضافة طلب إستعانة",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: height(context) * 0.02,
                            ),
                            cFormFiled(
                              context,
                              save: (val) {
                                tob_title = val.toString();
                              },
                              colorSideBorder: defaultC,
                              labelText: 'العنوان',
                            ),
                            SizedBox(
                              height: height(context) * 0.01,
                            ),
                            cFormFiled(context, save: (val) {
                              decs = val.toString();
                            },
                                colorSideBorder: defaultC,
                                labelText: 'وصف طلب الاستعانة',
                                maxLines: 3),
                            SizedBox(
                              height: height(context) * 0.02,
                            ),
                            defaultButton(
                                onPressed: () {
                                  _key.currentState!.save();
                                  if (tob_title!.isNotEmpty &&
                                      decs!.isNotEmpty) {
                                    Get.back();
                                    awesome(
                                      context,
                                      dialogType: DialogType.noHeader,
                                      body: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: indicator()),
                                    );
                                    FirebaseFirestore.instance
                                        .collection('helpPostes')
                                        .doc(title)
                                        .collection('helpPosts')
                                        .add({
                                      'name': jsonDecode(pref
                                          .getString('data')
                                          .toString())['USER_NAME'],
                                      'title': tob_title,
                                      'desc': decs,
                                      'date':
                                          '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}'
                                    }).then((value) {
                        sendNotification(tob_title, decs,
                                            topicses[title], context);
                                      Get.back();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      "الرجاء تعبئة كافة الحقول",
                                      textAlign: TextAlign.center,
                                    )));
                                  }
                                },
                                child: Text(
                                  "إضافة",
                                  style: TextStyle(color: Colors.white),
                                )),
                            SizedBox(
                              height: height(context) * 0.02,
                            ),
                          ],
                        )),
                  ),
                ));
          },
          backgroundColor: Colors.white,
          child: Icon(
            Icons.send,
            color: defaultC,
          )),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (!isNotified) {
                FirebaseMessaging.instance.subscribeToTopic(topicses[title]);
                setState(() {
                  isNotified = !isNotified;
                });
                pref.setBool("isNotified${topicses[title]}", isNotified);
              } else {
                FirebaseMessaging.instance
                    .unsubscribeFromTopic(topicses[title]);
                setState(() {
                  isNotified = !isNotified;
                });
                pref.remove("isNotified${topicses[title]}");
              }

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                isNotified ? "تم الاشتراك بنجاح" : "تم الغاء الاشتراك",
                textAlign: TextAlign.center,
              )));
            },
            icon: Icon(
              isNotified
                  ? Icons.notifications_active
                  : Icons.notification_add_outlined,
              color: isNotified ? defaultC : Colors.black,
            ),
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('helpPostes')
              .doc(title)
              .collection('helpPosts')
              .snapshots(),
          builder: ((context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data!.docs.length);
              return snapshot.data!.docs.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return _buildTopicContainer(
                            context: context,
                            top_title:
                                snapshot.data!.docs[index].data()['title'],
                            id: snapshot.data!.docs[index].id,
                            date: snapshot.data!.docs[index].data()['date'],
                            title: title,
                            desc: snapshot.data!.docs[index].data()['desc'],
                            name: snapshot.data!.docs[index].data()['name']);
                      }))
                  : Center(
                      child: SizedBox(
                      height: height(context) * 0.5,
                      width: width(context) * 0.5,
                      child: Column(
                        children: [
                          Icon(Icons.edit_note_sharp),
                          Text('لا يوجد أي طلب استعانة ')
                        ],
                      ),
                    ));
            }

            return indicator();
          }),
        ),
      ),
    );
  }

  Widget _buildTopicContainer({
    required BuildContext context,
    required String title,
    required String name,
    required String id,
    required String date,
    required String desc,
    required String top_title,
  }) {
    return InkWell(
      onTap: () {
        Get.to(() => TobicDetails(
              date: date,
              desc: desc,
              id: id,
              name: name,
              title: title,
              top_title: top_title,
            ));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        color: Color.fromARGB(255, 85, 100, 145),
        child: SizedBox(
          width: width(context),
          height: height(context) * .15,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.green[500],
                    radius: 35,

                    child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 100,
                    ), //CircleAvatar
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width(context) * .6,
                      child: Text(
                        top_title,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.white38,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ],
                ),
                Icon(
                  Icons.navigate_next_sharp,
                  size: 30,
                )
              ],
            ),
          ), //Padding
        ), //SizedBox
      ),
    );
  }
}
