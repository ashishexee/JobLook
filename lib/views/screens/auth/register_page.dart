import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/signup_provider.dart';
import 'package:job_look/models/request/auth/signup_model.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/custom_textfield.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/common/styled_container.dart';
import 'package:job_look/views/screens/auth/login_page.dart';
import 'package:job_look/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'Create Account',
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
      body: Consumer<SignUpNotifier>(
        builder: (context, signUpNotifier, child) {
          // Show loading screen or content based on loading state
          return signUpNotifier.isloading
              ? _buildLoadingScreen()
              : _buildRegisterContent(signUpNotifier, context);
        },
      ),
    );
  }

  // Loading screen widget
  Widget _buildLoadingScreen() {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/jobLoader.gif',
            fit: BoxFit.contain, // Ensures the whole image appears
          ),
        ),
      ),
    );
  }

  // Main content widget
  Widget _buildRegisterContent(
    SignUpNotifier signUpNotifier,
    BuildContext context,
  ) {
    return buildStyleContainer(
      context,
      SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                // Welcome Text
                ReusableText(
                  text: "Get Started",
                  style: appStyle(32, Color(kDark.value), FontWeight.w600),
                ),
                SizedBox(height: 12.h),

                ReusableText(
                  text: "Create an account to find your dream job",
                  style: appStyle(
                    16,
                    Color(kDarkGrey.value),
                    FontWeight.normal,
                  ),
                ),

                SizedBox(height: 30.h),

                // Name Field
                _buildFormField(
                  title: "Full Name",
                  controller: nameController,
                  hintText: "Enter your full name",
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    if (value.length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                // Email Field
                _buildFormField(
                  title: "Email Address",
                  controller: emailController,
                  hintText: "Enter your email address",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                // Password Field
                _buildFormField(
                  title: "Password",
                  controller: passwordController,
                  hintText: "Create a password",
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: signUpNotifier.obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      signUpNotifier.obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(kDarkGrey.value),
                    ),
                    onPressed: () {
                      signUpNotifier.togglePassword();
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                _buildFormField(
                  title: "Confirm Password",
                  controller: confirmPasswordController,
                  hintText: "Confirm your password",
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: signUpNotifier.confirmText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      signUpNotifier.confirmText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Color(kDarkGrey.value),
                    ),
                    onPressed: () {
                      signUpNotifier.toggleConfirmText();
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                Row(
                  children: [
                    SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: Checkbox(
                        value: signUpNotifier.agreetoterms,
                        onChanged: (value) {
                          signUpNotifier.yestoterms();
                        },
                        activeColor: Color(kDark.value),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: appStyle(
                            14,
                            Color(kDarkGrey.value),
                            FontWeight.normal,
                          ),
                          children: [
                            TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: appStyle(
                                14,
                                Color(kDark.value),
                                FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: appStyle(
                                14,
                                Color(kDark.value),
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed:
                        signUpNotifier.agreetoterms
                            ? () async {
                              if (_formKey.currentState!.validate()) {
                                // Show loading state
                                signUpNotifier.setLoading(true);
                              }
                              SignupModel model = SignupModel(
                                username: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              String finalModel = signupModelToJson(model);
                              signUpNotifier.signUp(context, finalModel);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(kDark.value),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Color(
                        kDarkGrey.value,
                      ).withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: appStyle(16, Colors.white, FontWeight.w600),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                SizedBox(height: 24.h),

                SizedBox(height: 30.h),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableText(
                        text: "Already have an account? ",
                        style: appStyle(
                          14,
                          Color(kDarkGrey.value),
                          FontWeight.normal,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: ReusableText(
                          text: "Log In",
                          style: appStyle(
                            25,
                            Color(kDark.value),
                            FontWeight.w600,
                          ).copyWith(decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String title,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: title,
          style: appStyle(14, Color(kDark.value), FontWeight.w500),
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
            controller: controller,
            hintText: hintText,
            obscureText: obscureText,
            keyboardType: keyboardType,
            prefixIcon: Icon(prefixIcon, color: Color(kDarkGrey.value)),
            suffixIcon: suffixIcon,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
