// ignore: file_names

import 'package:flutter/material.dart';
import 'package:job_look/constants/app_constants.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kDarkPurple.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70),
            Image.asset('assets/images/page1.png'),
            SizedBox(height: 30),
            Text(
              'Find your Dream Job',
              style: TextStyle(fontSize: 33, color: Colors.white),
            ),
            SizedBox(width: 20),
            Text(
              'We Help you find your dream job according',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Text(
              'to your skillset, location and preference to',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Text(
              'build your career',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
