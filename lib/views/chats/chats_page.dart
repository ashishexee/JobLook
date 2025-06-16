import 'package:flutter/material.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/views/screens/guest_screen.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);

    return loginNotifier.isLoggedIn == false
        ? GuestScreen(drawer: true)
        : Scaffold();
  }
}
