import 'package:flutter/material.dart';
import 'package:job_look/models/response/bookmarks/all_bookmarks.dart';
import 'package:job_look/services/helpers/book_helper.dart';

class BookmarkNotifier extends ChangeNotifier {
  bool _isBookmarked = false;
  bool get isBookmarked {
    return _isBookmarked;
  }

  late Future<List<AllBookMarks>> bookmarks;

  set isBookmarked(bool newState) {
    if (_isBookmarked != newState) {
      _isBookmarked = newState;
      notifyListeners();
    }
  }

  String _bookmarkId = '';
  String get bookmarkId => _bookmarkId;
  set bookmarkId(String newState) {
    _bookmarkId = newState;
    notifyListeners();
  }

  addBookmark(String model) {
    BookMarkHelper.addBookMark(model).then(
      (bookmark) => {isBookmarked = true, bookmarkId = bookmark.bookmarkId},
    );
  }

  deleteBookmark(String bookmarkId, BuildContext context) {
    debugPrint('Bookmark : starting to delete for id : $bookmarkId');
    BookMarkHelper.deleteBookmark(bookmarkId).then(
      (boolean) => {
        print('delete krdiya kya : $boolean'),
        if (boolean == true)
          {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Bookmark has been deleted',
                  selectionColor: Colors.white,
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            ),
            isBookmarked = false,
          },
      },
    );
  }

  Future<List<AllBookMarks>> getEveryBookmark() async {
    try {
      return await BookMarkHelper.getAllBookmarks();
    } catch (e) {
      // Handle error or rethrow with more context
      print("Error  sdvbsvjrsh bookmarks: $e");
      rethrow;
    }
  }

  getBookmark(String jobId) {
    var bookmark = BookMarkHelper.getBookmark(jobId);
    bookmark.then(
      (value) => {
        if (value == null)
          {isBookmarked = false, bookmarkId = ''}
        else
          {isBookmarked = true, bookmarkId = value.bookmarkId},
      },
    );
  }
}
