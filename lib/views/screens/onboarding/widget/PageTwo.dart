// ignore: file_names

import 'package:flutter/material.dart';
import 'package:job_look/constants/app_constants.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

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
            Image.asset('assets/images/page2.png'),
            SizedBox(height: 30),
            Text(
              'Stable Yourself',
              style: TextStyle(fontSize: 34, color: Colors.white),
            ),
            Text(
              'With Your Skills',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(height: 10),
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
