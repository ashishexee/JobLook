// ignore: file_names

import 'package:flutter/material.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

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
            Image.asset('assets/images/page3.png'),
            SizedBox(height: 30),
            Text(
              'Join to JobLook',
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
            SizedBox(height: 40),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.setBool('entrypoint', true);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Mainscreen()),
                    (route) => false,
                  );
                },
                child: const Text('Continue as a Guest'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
