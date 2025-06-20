
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/common/width_spacer.dart';

class NoSearchResults extends StatelessWidget {
  const NoSearchResults({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image.asset("assets/images/optimized_search.png"),
           const WidthSpacer(width: 20),
           ReusableText(
                text: text,
                style: appStyle(18, Color(kDark.value), FontWeight.w500))
          ],
        ));
  }
}