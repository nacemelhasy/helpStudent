
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:loginsignup/main.dart';
import 'package:loginsignup/screens/signin.dart';
import 'package:loginsignup/screens/signup.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:loginsignup/widgets/comp.dart';


class onboarding extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      
      finishButtonText: 'التسجيل',
      onFinish: () {
         pref.setBool('onBor', true);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SignUp(),
          ),
        );
      },
      finishButtonColor: defaultC,
      skipTextButton: Text(
        'تخطي',
        style: TextStyle(
          fontSize: 16,
          color: defaultC,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'تسجيل دخول',
        style: TextStyle(
          fontSize: 16,
          color: defaultC,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        pref.setBool('onBor', true);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Signin(),
          ),
        );
      },
      controllerColor: defaultC,
      totalPage: 3,
      imageHorizontalOffset: height(context)*0.08,
      imageVerticalOffset:height(context)*0.08, 
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Center(
          child: Image.asset(
            'assets/images/help.png',
            height: height(context)*0.3,
          ),
        ),
        Image.asset(
          'assets/images/idea.png',
          height: height(context)*0.3,
        ),
        SizedBox(
     
          child: Image.asset(
            'assets/images/ringing.png',
            height: height(context)*0.3,
          ),
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'لما نحتاج طلب استعانة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: defaultC,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'توفير وقت والجهد ونشر روح التعاون بين الطلاب' ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'هدف التطبيق',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: defaultC,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'الحصول على افضل اجابة في اسرع وقت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'ابدأ الان',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: defaultC,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'انطلق وارسل اول اشعار خاص بك واحصل على افضل اجابة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}