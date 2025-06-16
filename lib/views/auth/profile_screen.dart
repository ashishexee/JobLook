import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/controllers/zoom_provider.dart';
import 'package:job_look/models/response/auth/profile_model.dart';
import 'package:job_look/services/helpers/auth_helper.dart';
import 'package:job_look/views/common/BackBtn.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/custom_outline_btn.dart';
import 'package:job_look/views/auth/drawer/drawer_widget.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/common/styled_container.dart';
import 'package:job_look/views/screens/auth/skills/skills_widget.dart';
import 'package:job_look/views/screens/guest_screen.dart';
import 'package:job_look/views/screens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool drawer;
  const ProfileScreen({super.key, required this.drawer});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<ProfileRes>? userProfile;
  String? username = '';
  bool isLoading = true;

  Future<void> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    setState(() {
      isLoading = false;
    });
    if (widget.drawer == true && pref.getBool('loggedIn') == true) {
      userProfile = AuthHelper.getProfile();
    } else if (widget.drawer == false && pref.getBool('loggedIn') == true) {
      userProfile = AuthHelper.getProfile();
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.drawer);
    if (isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return loginNotifier.isLoggedIn == false || loginNotifier.isLoggedIn == null
        ? GuestScreen(drawer: widget.drawer == true ? true : false)
        : Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(50, 50),
            child: CustomAppBar(
              text: username,
              child: InkWell(
                onTap: () {
                  widget.drawer == true
                      ? ZoomDrawer.of(context)!.toggle()
                      : Navigator.pop(context);
                },
                child:
                    widget.drawer == true
                        ? DrawerWidget(color: Color(kDark.value))
                        : BackBtn(),
              ),
            ),
          ),
          body: FutureBuilder(
            future: userProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildWaitingState();
              }
              if (snapshot.connectionState == ConnectionState.none) {
                return _buildEmptyState();
              } else {
                var profile = snapshot.data;
                return buildStyleContainer(
                  context,
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, const Color(0xFFF5F9FF)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            CircularAva(image: profile!.profile),
                            SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.username,
                                    style: appStyle(
                                      14,
                                      Colors.black87,
                                      FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    profile.email,
                                    style: appStyle(
                                      10,
                                      Colors.black54,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3D7FFF),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                                icon: Icon(Icons.edit, size: 16),
                                onPressed: () {},
                                label: Text(
                                  'Edit',
                                  style: appStyle(
                                    12,
                                    Colors.white,
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SkillsWidget(),
                      SizedBox(height: 20),
                      Center(
                        child: ReusableText(
                          text: 'Hold on a skill to delete it',
                          style: appStyle(
                            12,
                            Colors.blueAccent,
                            FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      profile.isAgent == true
                          ? Column(
                            children: [
                              Text(
                                'Agents Section',
                                style: appStyle(
                                  16,
                                  Colors.black,
                                  FontWeight.normal,
                                ),
                              ),
                              CustomOutlineBtn(
                                onTap: () {
                                  loginNotifier.logout();
                                  zoomNotifier.currentIndex = 0;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Mainscreen(),
                                    ),
                                  );
                                },
                                text: 'Upload a Job',
                                color: Colors.blue,
                                width: 250.w,
                                hieght: 60,
                              ),
                              SizedBox(height: 30),
                              CustomOutlineBtn(
                                onTap: () {
                                  loginNotifier.logout();
                                  zoomNotifier.currentIndex = 0;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Mainscreen(),
                                    ),
                                  );
                                },
                                text: 'Update the Information',
                                color: Colors.blue,
                                width: 250.w,
                                hieght: 60,
                              ),
                            ],
                          )
                          : CustomOutlineBtn(
                            onTap: () {
                              loginNotifier.logout();
                              zoomNotifier.currentIndex = 0;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Mainscreen(),
                                ),
                              );
                            },
                            text: 'Want to become an Agent? Click Here',
                            color: Colors.blue,
                            width: 250.w,
                            hieght: 60,
                          ),
                      SizedBox(height: 30),
                      CustomOutlineBtn(
                        onTap: () {
                          loginNotifier.logout();
                          zoomNotifier.currentIndex = 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Mainscreen(),
                            ),
                          );
                        },
                        text: 'Click here to Logout',
                        color: Colors.black,
                        width: 250.w,
                        hieght: 60,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
  }

  Widget _buildEmptyState() {
    return Text('Empty hai guru');
  }

  Widget _buildWaitingState() {
    return Center(child: CircularProgressIndicator());
  }
}

class CircularAva extends StatefulWidget {
  final String image;
  const CircularAva({super.key, required this.image});

  @override
  State<CircularAva> createState() => _CircularAvaState();
}

class _CircularAvaState extends State<CircularAva> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade300, Colors.blue.shade500],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(3.0), // Creates border effect
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 40.0,
              backgroundImage: CachedNetworkImageProvider(widget.image),
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.green, // Online status
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
        ),
      ],
    );
  }
}
