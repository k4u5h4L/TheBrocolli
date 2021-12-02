import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:thebrocolli/route/slide_page_route.dart';
import 'package:thebrocolli/view/screens/page_switch.dart';
import 'package:thebrocolli/view/widgets/custom_text_field.dart';
import 'package:thebrocolli/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        // title: SvgPicture.asset('assets/icons/appname.svg'),
        title: Text(
          'TheBrocolli',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1 - Welcome Title
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 40),
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Hello ! Register to get started 😁',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    height: 150 / 100,
                    fontFamily: 'inter'),
              ),
            ),
            // Section 2 - Form
            Container(
              margin: EdgeInsets.only(bottom: 24),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CustomTextField(
                  //   labelText: 'Full Name',
                  //   hintText: 'Your Name',
                  // ),
                  CustomTextField(
                    hintText: 'youremail@email.com',
                    labelText: 'Email',
                    controller: emailController,
                  ),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: '********',
                    obsecureText: true,
                    controller: passwordController,
                  ),
                  CustomTextField(
                    labelText: 'Confirm Password',
                    obsecureText: true,
                    hintText: '********',
                    controller: confirmPasswordController,
                  ),
                ],
              ),
            ),
            // Section 3 - Register Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text != "" &&
                      passwordController.text != "" &&
                      confirmPasswordController.text != "" &&
                      passwordController.text ==
                          confirmPasswordController.text) {
                    String res =
                        await context.read<AuthenticationService>().signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                    if (res == "signed up") {
                      emailController.text = "";
                      passwordController.text = "";

                      Navigator.of(context).push(
                        SlidePageRoute(
                          child: PageSwitch(),
                        ),
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(res),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );

                      emailController.text = "";
                      passwordController.text = "";
                      confirmPasswordController.text = "";
                    }
                  } else {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text("The passwords do not match!"),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('Please fill in the required details!'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter,
              child: TextButton(
                onPressed: () {},
                child: Text('Already have an account? Login'),
                style: TextButton.styleFrom(
                  primary: Colors.white.withOpacity(0.65),
                  textStyle: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
