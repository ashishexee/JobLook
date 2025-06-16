import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/views/auth/drawer/drawer_widget.dart';
import 'package:job_look/views/common/BackBtn.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/custom_outline_btn.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/screens/auth/login_page.dart';

class GuestScreen extends StatelessWidget {
  final bool drawer;
  const GuestScreen({super.key, required this.drawer});

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://media.istockphoto.com/id/1664876848/photo/happy-crossed-arms-and-portrait-of-asian-man-in-studio-smile-for-career-work-and-job.jpg?s=612x612&w=0&k=20&c=2vYaOMnlmzMEmB441bTWHUyeFXRIh56wE79QAhVWYBk=";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          text: 'Guest',
          child:
              drawer == true
                  ? DrawerWidget(color: Color(kDark.value))
                  : BackBtn(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80.r),
              child: SizedBox(
                width: 160.w,
                height: 160.w,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Icon(Icons.person, size: 80.sp),
                ),
              ),
            ),

            SizedBox(height: 30.h),
            ReusableText(
              text: "Guest Mode",
              style: appStyle(24, Colors.black, FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ReusableText(
                text: "You're currently using JobLook in guest",
                style: appStyle(16, Color(kDarkGrey.value), FontWeight.normal),
              ),
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: CustomOutlineBtn(
                text: 'Click here to LOGIN',
                color: Colors.black,
                width: 250.w,
                hieght: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
