import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ZoomDrawer.of(context)!.toggle();
      },
      child: SvgPicture.asset(
        "assets/icons/me.svg",
        width: 24.w,
        height: 24.h,
        color: color,
        placeholderBuilder:
            (context) => Container(
              padding: EdgeInsets.all(6.w),
              child: Icon(Icons.menu, size: 27.w, color: color),
            ),
      ),
    );
  }
}
