// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:job_look/services/helpers/auth_helper.dart';
import 'package:job_look/views/screens/auth/login_page.dart';

class SignUpNotifier extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;

  void togglePassword() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  bool _confirmText = true;
  bool get confirmText => _confirmText;

  void toggleConfirmText() {
    _confirmText = !_confirmText;
    notifyListeners();
  }

  bool _agreetoterms = false;
  bool get agreetoterms {
    return _agreetoterms;
  }

  void yestoterms() {
    _agreetoterms = !_agreetoterms;
    notifyListeners();
  }

  bool _isloading = false;
  bool get isloading {
    return _isloading;
  }

  void setLoading(bool loading) {
    _isloading = loading;
    notifyListeners();
  }

  signUp(BuildContext context, String model) {
    AuthHelper.signUp(model).then((response) {
      if (response == true) {
        _isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Logged In'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
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
}
