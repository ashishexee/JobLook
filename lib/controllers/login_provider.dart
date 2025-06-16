import 'package:flutter/material.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/zoom_provider.dart';
import 'package:job_look/services/helpers/auth_helper.dart';
import 'package:job_look/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _rememberme = false;
  bool get rememberme {
    return _rememberme;
  }

  bool _isloading = false;
  bool get isloading {
    return _isloading;
  }

  void showLoading(bool loading) {
    _isloading = loading;
    notifyListeners();
  }

  void remebermepressed(bool value) {
    _rememberme = value;
    notifyListeners();
  }

  loginIn(BuildContext context, String model, ZoomNotifier zoomNotifier) {
    AuthHelper.login(model).then((response) {
      if (response == true) {
        _isloading = false;
        setIsLoggedIn(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Logged In'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mainscreen()),
        );
        zoomNotifier.currentIndex = 0;
      } else {
        _isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to SignUp'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  bool? _entrypoint;
  bool? get entrypoint {
    return _entrypoint;
  }

  void getEntryPoint(bool? newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool? _isLoggedIn;
  bool? get isLoggedIn {
    return _isLoggedIn;
  }

  void setIsLoggedIn(bool? newState) async {
    _isLoggedIn = newState;
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (newState != null) {
      await prefs.setBool('loggedIn', newState);
    } else {
      await prefs.remove('loggedIn');
    }
    notifyListeners();
  }

  // Add this method to initialize the login state
  Future<void> initLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('loggedIn');
    notifyListeners();
  }

  getPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    getEntryPoint(pref.getBool('entrypoint'));
    setIsLoggedIn(pref.getBool('loggedIn'));
    username = pref.getString('username') ?? '';
    profile = pref.getString('profile') ?? '';
    userId = pref.getString('uid') ?? '';
  }

  logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
    await pref.setBool('loggedIn', false);
    setIsLoggedIn(false);
    notifyListeners();
  }
}
