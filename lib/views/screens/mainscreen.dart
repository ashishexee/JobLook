import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/zoom_provider.dart';
import 'package:job_look/views/applications/applied_jobs.dart';
import 'package:job_look/views/auth/profile_screen.dart';
import 'package:job_look/views/bookmarks/bookmarks_page.dart';
import 'package:job_look/views/chats/chats_page.dart';
import 'package:job_look/views/auth/drawer/drawerScreen.dart';
import 'package:job_look/views/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ZoomNotifier>(
      builder: (context, zoomNotifier, child) {
        return Scaffold(
          body: ZoomDrawer(
            menuScreen: DrawerScreen(
              indexSetter: (index) {
                zoomNotifier.currentIndex = index;
              },
            ),
            mainScreen: currentScreen(),
            menuBackgroundColor: Color(kLightBlue.value),
            angle: 0,
            slideWidth: 259,
          ),
        );
      },
    );
  }

  Widget currentScreen() {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    switch (zoomNotifier.currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return ChatsPage();
      case 2:
        return BookmarksPage();
      case 3:
        return AppliedJobs();
      case 4:
        return ProfileScreen(drawer: true);
      default:
        return HomeScreen();
    }
  }
}
