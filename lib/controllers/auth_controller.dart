import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/main.dart';
import 'package:loginsignup/screens/home.dart';
import 'package:loginsignup/screens/signin.dart';
import 'package:loginsignup/screens/signup.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:loginsignup/widgets/comp.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(firebaseAuth.currentUser);
    firebaseUser.bindStream(firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const SignUp());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  Future<bool> register(String email, password, context, ID, username) async {
    awesome(
      context,
      dialogType: DialogType.noHeader,
      body: Padding(padding: const EdgeInsets.all(15.0), child: indicator()),
    );
  
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(ID).set({
        'ID': ID,
        'USER_NAME': username,
        'PASSWORD': password,
        'EMAIL': email
      });

    
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (c) => Signin()));
      awesome(
        context,
        dialogType: DialogType.success,

        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                textNW(context, 'تم التسجيل بنجاح قم بتسجيل الدخول', size: 20)),
      );
       Future.delayed(Duration(seconds: 2),()=>Get.back());
      return true;
    });
    return false;
  }

  void login(String email, String password, context) async {
    awesome(
      context,
      dialogType: DialogType.noHeader,
      body: Padding(padding: const EdgeInsets.all(15.0), child: indicator()),
    );
    try {
      firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        pref.setBool('login', true);
        //this code for retrive data for studesnt and save it in local db
        FirebaseFirestore.instance.collection('users').get().then((value) {
          value.docs.forEach((element) {
            if (element.data()['EMAIL'] == email) {
              Map<String, dynamic> data = element.data();
              String enCodeData = jsonEncode(data);
              pref.setString('data', enCodeData);
                     
              
                }
          });
        });

        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => HomeScreen()));
      });
    } catch (firebaseAuthException) {
      awesome(
        context,
        dialogType: DialogType.error,
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: textNW(context, 'تحقق من بياناتك', size: 20)),
      );
    }
  }
}
