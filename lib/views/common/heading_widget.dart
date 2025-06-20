import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/reusable_text.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({super.key, required this.text, this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReusableText(text: text,
         style: appStyle(18, Color(kDark.value), FontWeight.w600)),

         GestureDetector(
          onTap: onTap,
          child: Icon(AntDesign.appstore_o, color: Colors.grey.shade800)
         )
      ],
    );
  }
}