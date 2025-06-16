import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/zoom_provider.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/common/width_spacer.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  final ValueSetter indexSetter;
  const DrawerScreen({super.key, required this.indexSetter});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ZoomNotifier>(
      builder: (context, zoomNotifier, child) {
        return Scaffold(
          backgroundColor: Color(kLightBlue.value),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 320),
              // Menu items
              drawerItem(
                AntDesign.home,
                "Home",
                0,
                zoomNotifier.currentIndex == 0
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
              ),
              drawerItem(
                Ionicons.chatbubble_outline,
                "Chat",
                1,
                zoomNotifier.currentIndex == 1
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
              ),
              drawerItem(
                Fontisto.bookmark,
                "Bookmarks",
                2,
                zoomNotifier.currentIndex == 2
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
              ),
              drawerItem(
                Ionicons.ios_file_tray_full_outline,
                "Applications",
                3,
                zoomNotifier.currentIndex == 3
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
              ),

              drawerItem(
                FontAwesome5Regular.user_circle,
                "Profile",
                4,
                zoomNotifier.currentIndex == 4
                    ? Color(kLight.value)
                    : Color(kLightGrey.value),
              ),

              // Add this GestureDetector to make the whole screen area clickable
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to current index when tapping anywhere else
                    widget.indexSetter(zoomNotifier.currentIndex);
                    // Close drawer
                    ZoomDrawer.of(context)!.close();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget drawerItem(IconData icon, String text, int index, Color color) {
    return GestureDetector(
      onTap: () {
        // Set page index
        widget.indexSetter(index);
        // Close drawer after selecting an item
        ZoomDrawer.of(context)!.close();
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.w, bottom: 40.h),
        child: Row(
          children: [
            Icon(icon, color: color),
            const WidthSpacer(width: 12),
            ReusableText(
              text: text,
              style: appStyle(15, color, FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
