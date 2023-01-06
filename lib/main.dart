import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginsignup/controllers/auth_controller.dart';
import 'package:loginsignup/screens/home.dart';
import 'package:loginsignup/screens/onbording.dart';
import 'package:loginsignup/screens/signin.dart';
import 'package:loginsignup/screens/signup.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:onboarding_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((value) => {
        Get.put(AuthController()),
      });
  pref = await SharedPreferences.getInstance();
  FirebaseMessaging.onMessage.listen((e){
 
  });
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

PageController controller = PageController();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: pref.containsKey('onBor')?(pref.containsKey('login')?HomeScreen():Signin()) : onboarding(),
    );
  }
}
