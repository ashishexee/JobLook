import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/bookmark_provider.dart';
import 'package:job_look/controllers/image_provider.dart';
import 'package:job_look/controllers/jobs_provider.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/controllers/onboarding_provider.dart';
import 'package:job_look/controllers/profile_provider.dart';
import 'package:job_look/controllers/signup_provider.dart';
import 'package:job_look/controllers/zoom_provider.dart';
import 'package:job_look/views/screens/auth/skills/skills_provider.dart';
import 'package:job_look/views/screens/jobs/uploadJobs_provider.dart';
import 'package:job_look/views/screens/mainscreen.dart';
import 'package:job_look/views/screens/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget defaultHome = const OnboardingScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loginNotifier = LoginNotifier();
  await loginNotifier.initLoginState(); // Initialize login state
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool entrypoint = pref.getBool('entrypoint') ?? false;
  if (entrypoint == true) {
    defaultHome = const Mainscreen();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnBoardNotifier()),
        ChangeNotifierProvider(create: (context) => loginNotifier),
        ChangeNotifierProvider(create: (context) => ZoomNotifier()),
        ChangeNotifierProvider(create: (context) => SignUpNotifier()),
        ChangeNotifierProvider(create: (context) => JobsNotifier()),
        ChangeNotifierProvider(create: (context) => ImageUpoader()),
        ChangeNotifierProvider(create: (context) => ProfileNotifier()),
        ChangeNotifierProvider(create: (context) => BookmarkNotifier()),
        ChangeNotifierProvider(create: (context) => SkillsNotifier()),
        ChangeNotifierProvider(create: (context) => UploadNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Job Look',
          theme: ThemeData(
            scaffoldBackgroundColor: Color(kLight.value),
            iconTheme: IconThemeData(color: Color(kDark.value)),
            primarySwatch: Colors.grey,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            cardTheme: CardTheme(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.black38,
            ),
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              headlineLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(kDark.value),
              ),
              headlineMedium: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(kDark.value),
              ),
              titleLarge: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(kDark.value),
              ),
              bodyLarge: TextStyle(color: Color(kDark.value).withOpacity(0.8)),
            ),
          ),
          home: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 2500)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSplashScreen();
              }
              return defaultHome;
            },
          ),
        );
      },
    );
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(Color.fromARGB(255, 18, 144, 255).value),
              Color(Color.fromARGB(255, 1, 124, 218).value).withBlue(180),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/launcher_icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
              SizedBox(height: 20),
              Text(
                'Job Look',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
