import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/views/auth/profile_screen.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/search.dart';
import 'package:job_look/views/screens/home/all_jobs.dart';
import 'package:job_look/views/screens/home/popular_jobs.dart';
import 'package:job_look/views/screens/home/recent_jobs.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String imageUrl =
      "https://media.istockphoto.com/id/1664876848/photo/happy-crossed-arms-and-portrait-of-asian-man-in-studio-smile-for-career-work-and-job.jpg?s=612x612&w=0&k=20&c=2vYaOMnlmzMEmB441bTWHUyeFXRIh56wE79QAhVWYBk=";

  @override
  void initState() {
    super.initState();
    // Initialize login state when home screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginNotifier>(context, listen: false).initLoginState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    print(loginNotifier.isLoggedIn);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(drawer: false),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 20.w,
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 20.w,
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ],
          child: InkWell(
            onTap: () {
              ZoomDrawer.of(context)!.toggle();
            },
            child: Icon(Icons.menu_rounded),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 7.h),
              Text(
                'Search',
                style: appStyle(42.sp, Color(kDark.value), FontWeight.bold),
              ),
              Text(
                'Find & Apply',
                style: appStyle(42.sp, Color(kDark.value), FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Discover your dream job today',
                style: appStyle(16.sp, Colors.grey[600]!, FontWeight.w400),
              ),
              SizedBox(height: 20.h),
              // Search Widget
              SearchWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllJobs()),
                  );
                },
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Popular Jobs',
                            style: appStyle(
                              20.sp,
                              Color(kDark.value),
                              FontWeight.w600,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllJobs(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.grid_view_rounded,
                              color: Color(kDark.value),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      PopularJobs(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Recently Uploaded Jobs',
                            style: appStyle(
                              20.sp,
                              Color(kDark.value),
                              FontWeight.w600,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllJobs(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.grid_view_rounded,
                              color: Color(kDark.value),
                            ),
                          ),
                        ],
                      ),
                      RecentJobs(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
