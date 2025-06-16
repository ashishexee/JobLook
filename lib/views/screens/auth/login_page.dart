import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/controllers/zoom_provider.dart';
import 'package:job_look/models/request/auth/login_model.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/custom_textfield.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/common/styled_container.dart';
import 'package:job_look/views/screens/auth/register_page.dart';
import 'package:job_look/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'Login',
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Mainscreen()),
                (router) => false,
              );
            },
            child: const Icon(AntDesign.leftcircleo),
          ),
        ),
      ),
      body: Consumer<LoginNotifier>(
        builder: (context, loginNotifier, child) {
          return buildStyleContainer(
            context,
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    SizedBox(height: 30.h),

                    // Welcome Text
                    ReusableText(
                      text: "Welcome Back",
                      style: appStyle(32, Color(kDark.value), FontWeight.w600),
                    ),

                    SizedBox(height: 12.h),

                    ReusableText(
                      text: "Fill in your details to access your account",
                      style: appStyle(
                        16,
                        Color(kDarkGrey.value),
                        FontWeight.normal,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Email",
                            style: appStyle(
                              14,
                              Color(kDark.value),
                              FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomTextField(
                              controller: emailController,
                              hintText: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(kDarkGrey.value),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Password Field
                          ReusableText(
                            text: "Password",
                            style: appStyle(
                              14,
                              Color(kDark.value),
                              FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomTextField(
                              obscureText: loginNotifier.obscurePassword,
                              controller: passwordController,
                              hintText: 'Enter your password',
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: Color(kDarkGrey.value),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  loginNotifier.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(kDarkGrey.value),
                                ),
                                onPressed: () {
                                  loginNotifier.togglePasswordVisibility();
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Remember Me and Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Remember Me
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: Checkbox(
                                      value: loginNotifier.rememberme,
                                      onChanged: (value) {
                                        loginNotifier.remebermepressed(true);
                                      },
                                      activeColor: Color(kDark.value),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  ReusableText(
                                    text: "Remember me",
                                    style: appStyle(
                                      14,
                                      Color(kDarkGrey.value),
                                      FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),

                              // Forgot Password
                              GestureDetector(
                                onTap: () {
                                  // Navigate to forgot password
                                  // TODO either remove this or impletement this
                                },
                                child: ReusableText(
                                  text: "Forgot Password?",
                                  style: appStyle(
                                    14,
                                    Color(kDark.value),
                                    FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 32.h),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: ElevatedButton(
                              onPressed: () {
                                // Login logic
                                loginNotifier.setIsLoggedIn(true);
                                LoginModel model = LoginModel(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );

                                String finalModel = loginModelToJson(model);
                                loginNotifier.loginIn(
                                  context,
                                  finalModel,
                                  ZoomNotifier(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(kDark.value),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Log In',
                                style: appStyle(
                                  16,
                                  Colors.white,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 30.h),

                          // Or continue with
                          SizedBox(height: 150.h),

                          SizedBox(height: 30.h),

                          // Don't have account
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ReusableText(
                                  text: "Don't have an account? ",
                                  style: appStyle(
                                    14,
                                    Color(kDarkGrey.value),
                                    FontWeight.normal,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to register
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: ReusableText(
                                    text: "Register",
                                    style: appStyle(
                                      25,
                                      Color(kDark.value),
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
