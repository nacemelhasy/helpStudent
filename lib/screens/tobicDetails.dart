import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loginsignup/main.dart';
import 'package:loginsignup/utils/constants.dart';

import '../widgets/comp.dart';

class TobicDetails extends StatefulWidget {
  String title;
  String top_title;
  String name;
  String id;
  String date;
  String desc;
  TobicDetails(
      {Key? key,
      required this.title,
      required this.name,
      required this.date,
      required this.desc,
      required this.id,
      required this.top_title})
      : super(key: key);

  @override
  State<TobicDetails> createState() => _TobicDetailsState();
}

class _TobicDetailsState extends State<TobicDetails> {
  TextEditingController? controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            height: height(context) * 0.08,
            color: defaultC,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height(context)*0.08,
                      width: width(context) * .84,
                      child: cFormFiled(context,
maxLines: 1,
                          hintText: "إدراج تعليق", controller: controller)),
                  IconButton(
                      onPressed: () {
                        if (controller!.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('helpPostes')
                              .doc(widget.title)
                              .collection('helpPosts')
                              .doc(widget.id)
                              .collection('comments')
                              .add({
                            'name': jsonDecode(
                                pref.getString('data').toString())['USER_NAME'],
                            "comment": controller!.text.trim()
                          }).then((value) {
                        controller!.clear();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ))
                ]),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.navigate_next_sharp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopicContainer(
                    context: context,
                    title: widget.top_title,
                    name: widget.name,
                    date: widget.date,
                    desc: widget.desc),
                Padding(
                  padding: EdgeInsets.only(
                      top: height(context) * 0.02,
                      right: height(context) * 0.01),
                  child: Text(
                    'التعليقات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: defaultC,
                  endIndent: 10,
                  indent: 10,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('helpPostes')
                      .doc(widget.title)
                      .collection('helpPosts')
                      .doc(widget.id)
                      .collection('comments')
                      .snapshots(),
                  builder: ((context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data!.docs.length);
                      return snapshot.data!.docs.length > 0
                          ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: ((context, index) {
                                return comWid(context,
                                comment: snapshot.data!.docs[index].data()['comment'],
                                name: snapshot.data!.docs[index].data()['name'],
                                );
                              }))
                          : Center(
                              child: SizedBox(
                              height: height(context) * 0.5,
                              width: width(context) * 0.5,
                              child: Column(
                                children: [
                                  Icon(Icons.comments_disabled_outlined),
                                  Text('لا يوجد أي تعليق  ')
                                ],
                              ),
                            ));
                    }

                    return indicator();
                  }),
                ),
              ],
            ),
          )),
    );
  }
}

Widget _buildTopicContainer({
  required BuildContext context,
  required String title,
  required String name,
  required String date,
  required String desc,
}) {
  return InkWell(
    onTap: () {},
    child: constrainedBox(
      maxHeight: height(context) * 0.18,
      minHeight: height(context) * 0.17,
      maxWidth: double.infinity,
      minWidth: 0.0,
      child: Card(
        elevation: 0.5,
        shadowColor: Colors.black,
        color: Color.fromARGB(255, 85, 100, 145),
        child: SizedBox(
          width: width(context),

          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width(context) * 0.05),
                      child: SizedBox(
                        width: width(context) * 0.8,
                        child: Text(
                          title,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: width(context) * 0.05,
                          top: height(context) * 0.01,bottom: height(context)*0.01),
                      child: Text(
                        desc,
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: width(context) * 0.96,
                      child: Divider(
                        color: Color.fromARGB(255, 255, 255, 255),
                        thickness: 1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: width(context) * 0.96,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(date, style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), //Padding
        ), //SizedBox
      ),
    ),
  );
}


Widget comWid(context,{
  required String name,
  required String comment,
}){
  return Container(

    child: Card(
margin: EdgeInsets.only(right: 10,left: 10,bottom: 10),
      color: Colors.white60,
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Text(comment)
          ],
        ),
      ),
    )

  );
}