import 'package:http/http.dart' as https;
import 'package:job_look/models/response/bookmarks/all_bookmarks.dart';
import 'package:job_look/models/response/bookmarks/bookmark.dart';
import 'package:job_look/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkHelper {
  static var client = https.Client();
  static Future<BookMark> addBookMark(String model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    Map<String, String> responseHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };
    var url = Uri.parse(Config.apiUrl + Config.bookmarkUrl);
    var response = await client.post(url, body: model, headers: responseHeader);
    if (response.statusCode == 200) {
      var bookmark = bookMarkFromJson(response.body);
      return bookmark;
    } else {
      throw Exception('Unable to create a bookmark');
    }
  }

  static Future<List<AllBookMarks>> getAllBookmarks() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Map<String, String> responseHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };
    var url = Uri.parse(Config.apiUrl + Config.bookmarkUrl);
    var response = await client.get(url, headers: responseHeader);
    if (response.statusCode == 200) {
      List<AllBookMarks> bookmarks = allBookMarksFromJson(response.body);
      return bookmarks;
    } else {
      throw Exception('Could not get all Bookmarks');
    }
  }

  static Future<BookMark?> getBookmark(String jobId) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    Map<String, String> responseHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };
    try {
      var url = Uri.parse("${Config.apiUrl}${Config.singleBookmarkUrl}$jobId");
      var response = await client.get(url, headers: responseHeader);
      if (response.statusCode == 200) {
        var bookmark = bookMarkFromJson(response.body);
        return bookmark;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  // for deleting a bookmark
  static Future<bool> deleteBookmark(String bookmarkId) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    Map<String, String> responseHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };
    try {
      var url = Uri.parse("${Config.apiUrl}${Config.bookmarkUrl}/$bookmarkId");
      var response = await client.delete(url, headers: responseHeader);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
