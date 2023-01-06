import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/controllers/auth_controller.dart';
import 'package:loginsignup/styles/app_colors.dart';
import 'package:loginsignup/screens/signin.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:loginsignup/widgets/comp.dart';
import 'package:loginsignup/widgets/custom_button.dart';
import 'package:loginsignup/widgets/custom_formfield.dart';
import 'package:loginsignup/widgets/custom_header.dart';
import 'package:loginsignup/widgets/custom_richtext.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ID = TextEditingController();

  String get userName => _userName.text.trim();
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  String get ID => _ID.text.trim();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: defaultC,
            ),
            CustomHeader(
                text: 'تسجيل',
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Signin()));
                }),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColors.whiteshade,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.asset("assets/images/login.png"),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "اسم المستخدم",
                        hintText: "ادخل هنا",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: _userName,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "البريد الالكتروني",
                        hintText: "ادخل هنا",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: _passwordController,
                        headingText: "كلمة المرور",
                        hintText: "على الاقل ثماني كلمات مرور",
                        obsecureText: false,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {}),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: _ID,
                        headingText: "رقمك الدراسي",
                        hintText: "20180010 / 20194090 مثال",
                        obsecureText: false,
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.numbers), onPressed: () {}),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthButton(
                        onTap: () {
                          if (ID.isNotEmpty &&
                              password.isNotEmpty &&
                              email.isNotEmpty &&
                              userName.isNotEmpty
                              &&password.length>=8
                              ) {
                           authController.register(email, password,context,ID,userName);
                

                          } else {
                            awesome(
                              context,
                              dialogType: DialogType.error,
                              body: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: textNW(context, 'تحقق من بياناتك',size: 20)
                              ),
                            );
                          }
                        },
                        text: 'تسجيل',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CustomRichText(
                          discription: 'هل لديك بالفعل حساب? ',
                          text: 'سجل الدخول من هنا',
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signin()));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
