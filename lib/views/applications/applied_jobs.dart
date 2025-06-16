import 'package:flutter/material.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/views/screens/guest_screen.dart';
import 'package:provider/provider.dart';

class AppliedJobs extends StatefulWidget {
  const AppliedJobs({super.key});

  @override
  State<AppliedJobs> createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return loginNotifier.isLoggedIn == false ? GuestScreen(drawer: true,) : Scaffold();
  }
}
