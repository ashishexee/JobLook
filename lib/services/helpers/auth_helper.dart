import 'package:http/http.dart' as https;
import 'package:job_look/models/response/auth/login_res_model.dart';
import 'package:job_look/models/response/auth/profile_model.dart';
import 'package:job_look/models/response/auth/skills.dart';
import 'package:job_look/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static var client = https.Client();
  static Future<bool> signUp(String model) async {
    Map<String, String> responseHeader = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(Config.apiUrl + Config.signupUrl);
      var response = await client.post(
        url,
        body: model,
        headers: responseHeader,
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<bool> login(String model) async {
    try {
      var url = Uri.parse(Config.apiUrl + Config.loginUrl);

      Map<String, String> responseHeader = {'Content-Type': 'application/json'};
      var response = await client.post(
        url,
        body: model,
        headers: responseHeader,
      );
      var user = loginResponseModelFromJson(response.body);
      if (response.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('username', user.username);
        await pref.setString('token', user.userToken);
        await pref.setString(
          'userId',
          user.id,
        ); // this id is from our mongoose database
        await pref.setString('profile', user.profile);
        await pref.setBool('loggedIn', true);
        await pref.setString(
          'uid',
          user.uid,
        ); // uid is basically our firebase UID

        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<ProfileRes> getProfile() async {
    print('i am inside authhelper getProfile');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> responseHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };
    var url = Uri.parse(Config.apiUrl + Config.profileUrl);
    var response = await client.get(url, headers: responseHeader);
    if (response.statusCode == 200) {
      ProfileRes profile = profileResFromJson(response.body);
      return profile;
    } else {
      throw Exception('COuld not get user profile');
    }
  }

  static Future<List<Skills>> getSkills() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Map<String, String> responseHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    try {
      var url = Uri.parse(Config.apiUrl + Config.skillsurl);
      var response = await client.get(url, headers: responseHeaders);
      if (response.statusCode == 200) {
        List<Skills> skills = skillsFromJson(response.body);
        return skills;
      } else {
        throw Exception('could not get skills');
      }
    } catch (error) {
      throw Exception('could not get skills');
    }
  }

  static Future<bool> addSkill(String model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Map<String, String> responseHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    try {
      var url = Uri.parse("${Config.apiUrl}${Config.skillsurl}");
      var response = await client.post(
        url,
        body: model,
        headers: responseHeaders,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('could not add skills');
      }
    } catch (error) {
      throw Exception('could not add skills');
    }
  }

  static Future<bool> deleteSkill(String id) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Map<String, String> responseHeaders = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    try {
      var url = Uri.parse("${Config.apiUrl}${Config.skillsurl}/$id");
      var response = await client.delete(url, headers: responseHeaders);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('could not delete skills');
      }
    } catch (error) {
      throw Exception('could not delete skills');
    }
  }
}
