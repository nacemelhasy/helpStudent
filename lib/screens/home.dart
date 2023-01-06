import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/main.dart';
import 'package:loginsignup/screens/signin.dart';
import 'package:loginsignup/screens/topics.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import '../notification.dart';

final Map topicses = {
  "القسم العام": 'general',
  "قسم الحاسوب": "computer",
  "قسم الكهرباء": "electrical",
  "قسم المدني": "civil",
  "قسم الميكانيكا": "mic",
  "قسم الطاقات المتجددة": "newP",
  "قسم علم المواد": "olm",
  "قسم كيمياء": "chima",
  "قسم المعماري": "tssss",
};

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    
    super.initState();
    new FirebaseNotifications().setUpFirebase();
  }
  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "القسم العام",
      "قسم الحاسوب",
      "قسم الكهرباء",
      "قسم المدني",
      "قسم الميكانيكا",
      "قسم الطاقات المتجددة",
      "قسم علم المواد",
      "قسم كيمياء",
      "قسم المعماري",
    ];

    final List<Widget> images = titles
        .map(
          (title) => Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: defaultC.withOpacity(.8),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      spreadRadius: 3,
                      color: Colors.grey)
                ]),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultC,
        title: Text('أٌقسام الكلية'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.offAll(() => Signin());
                pref.remove('data');
                pref.remove('login');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: VerticalCardPager(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  titles: titles,
                  images: images,
                  align: ALIGN.CENTER,
                  onSelectedItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TopicsScreen(),
                          settings: RouteSettings(arguments: titles[index])),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
