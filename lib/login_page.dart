import 'package:ae_scanner_app/api/login_function.dart';
import 'package:ae_scanner_app/colors.dart';
import 'package:ae_scanner_app/api/home/home_page.dart';
import 'package:ae_scanner_app/loginControler.dart';
import 'package:ae_scanner_app/primary_field.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  bool _rememberMe = false;
  @override
  void initState() {
    getStoredData();
    super.initState();
  }

  getStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool("rememberMe") ?? false;
      if (_rememberMe == true) {
        _idController.text = prefs.getString("userId") ?? "";
        _passwordController.text = prefs.getString("password") ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffFDFDFD),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Get.size.height / 10),
                child: Container(
                  width: Get.width,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ThemeColors.primaryBlue.withOpacity(0.03)),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 200,
                  ),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login in to Attendease ClassRoom",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    Text(
                      "Enter your User ID and Password to log in",
                      style:
                          GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 16.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: Get.size.width / 6,
                          maxWidth: Get.size.width / 4),
                      child: Column(
                        children: [
                          PrimaryInputField(
                            label: "User ID",
                            txtController: _idController,
                            hintText: "Enter your user ID",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "User ID cannot be empty";
                              }
                              return null;
                            },
                          ),
                          PrimaryInputField(
                            isObscure: true,
                            label: "Password",
                            txtController: _passwordController,
                            hintText: "Enter your Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password cannot be empty";
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: ThemeColors.primaryBlue,
                                value: _rememberMe,
                                onChanged: (val) async {
                                  setState(() {
                                    _rememberMe = val!;
                                  });
                                },
                              ),
                              Text('Remember Me',
                                  style: GoogleFonts.poppins(fontSize: 11)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ),

              SizedBox(
                width: Get.width / 6,
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onTap: () async {
                    loginController.loggined.value = true;
                    if (_formKey.currentState!.validate()) {
                      LoginFunctions.handleLogin(
                        userId: _idController.text,
                        password: _passwordController.text,
                        rememberMe: _rememberMe,
                      ).then((sts) {
                        if (sts) {
                          Get.to(() => RfidListenerScreen());
                        }
                      });
                    } else {
                      loginController.loggined.value = false;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ThemeColors.primaryBlue,
                        borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Obx(() => !loginController.loggined.value
                            ? Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            : const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
