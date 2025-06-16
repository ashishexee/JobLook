import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/bookmark_provider.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/models/response/bookmarks/all_bookmarks.dart';
import 'package:job_look/models/response/jobs/jobs_response.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/screens/guest_screen.dart';
import 'package:job_look/views/screens/home/job_details.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late Future<List<AllBookMarks>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    _bookmarksFuture =
        Provider.of<BookmarkNotifier>(
          context,
          listen: false,
        ).getEveryBookmark();
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return loginNotifier.isLoggedIn == true
        ? Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: 'Bookmarks',
              child: IconButton(
                onPressed: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                icon: Icon(Icons.menu),
              ),
            ),
          ),
          body: Consumer<BookmarkNotifier>(
            builder: (context, bookmarkNotifier, child) {
              return FutureBuilder<List<AllBookMarks>>(
                future: _bookmarksFuture, // Use the stored future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerLoadingState();
                  } else if (snapshot.hasError) {
                    return _buildErrorState(
                      snapshot.error?.toString() ?? "Unknown error",
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    final bookmarks = snapshot.data!;
                    return _buildBookmarksList(bookmarks, snapshot);
                  }
                },
              );
            },
          ),
        )
        : GuestScreen(drawer: true);
  }

  Widget _buildShimmerLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 14.h,
              width: 120.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              padding: EdgeInsets.only(top: 4.h),
              itemBuilder: (context, index) {
                return _buildShimmerCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 14.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 12.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Job details placeholder
            Container(
              height: 36.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.h),
          ReusableText(
            text: "Failed to load bookmarks",
            style: appStyle(16, Color(kDark.value), FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ReusableText(
              text: error,
              style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(kDarkPurple.value),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 80.sp,
            color: Color(kDarkGrey.value).withOpacity(0.3),
          ),
          SizedBox(height: 24.h),
          ReusableText(
            text: "No bookmarks yet",
            style: appStyle(18, Color(kDark.value), FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: ReusableText(
              text: "Save jobs you're interested in to view them later",
              style: appStyle(14, Color(kDarkGrey.value), FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList(List<AllBookMarks> bookmarks, snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          ReusableText(
            text:
                "${bookmarks.length} Saved ${bookmarks.length == 1 ? 'Job' : 'Jobs'}",
            style: appStyle(14, Color(kDarkGrey.value), FontWeight.w500),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              itemCount: bookmarks.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return Dismissible(
                  key: Key(bookmark.id),
                  background: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 28.sp,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          title: Text("Remove Bookmark"),
                          content: Text(
                            "Are you sure you want to remove this job from your bookmarks?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Color(kDarkGrey.value)),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                "Remove",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    final bookmarkId = bookmark.id;

                    setState(() {
                      final currentBookmarks = snapshot.data!;
                      currentBookmarks.removeWhere(
                        (item) => item.id == bookmark.id,
                      );

                      _bookmarksFuture = Future.value(currentBookmarks);
                    });

                    Provider.of<BookmarkNotifier>(
                      context,
                      listen: false,
                    ).deleteBookmark(bookmarkId, context);
                  },
                  child: _buildJobCard(bookmark, snapshot),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(AllBookMarks bookmark, snapshot) {
    final job = bookmark.job;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Color(kDarkPurple.value).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFCFCFF)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => JobDetails(
                      job: JobsResponse(
                        id: job.id,
                        title: job.title,
                        location: job.location,
                        agentName: job.agentName,
                        company: job.company,
                        hiring: 'Active',
                        description: 'Hiring for a ${job.title}',
                        salary: job.salary,
                        period: job.period,
                        contact: job.contract,
                        requirements: requirements,
                        imageUrl: job.imageUrl,
                        agentId: job.agentId,
                      ),
                    ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'company_logo_${job.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Color(kLightGrey.value).withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: CachedNetworkImage(
                            imageUrl: job.imageUrl,
                            height: 75.h,
                            width: 75.w,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey.shade100,
                                  highlightColor: Colors.grey.shade50,
                                  child: Container(
                                    height: 75.h,
                                    width: 75.w,
                                    color: Colors.white,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 75.h,
                                  width: 75.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(
                                          kDarkPurple.value,
                                        ).withOpacity(0.7),
                                        Color(kDarkPurple.value),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      job.company.isNotEmpty
                                          ? job.company[0].toUpperCase()
                                          : "C",
                                      style: appStyle(
                                        32,
                                        Colors.white,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 18.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: appStyle(
                              18,
                              Color(kDark.value),
                              FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: 16.sp,
                                color: Color(kDarkPurple.value),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  job.company,
                                  style: appStyle(
                                    14,
                                    Color(kDarkGrey.value),
                                    FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 16.sp,
                                color: Color(
                                  kDarkPurple.value,
                                ).withOpacity(0.8),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  job.location,
                                  style: appStyle(
                                    13,
                                    Color(kDarkGrey.value),
                                    FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(kDarkPurple.value).withOpacity(0.15),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Provider.of<BookmarkNotifier>(
                            context,
                            listen: false,
                          ).deleteBookmark(bookmark.id, context);
                          setState(() {
                            final currentBookmarks = snapshot.data!;
                            currentBookmarks.removeWhere(
                              (item) => item.id == bookmark.id,
                            );

                            _bookmarksFuture = Future.value(currentBookmarks);
                          });
                        },
                        borderRadius: BorderRadius.circular(30.r),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(kDarkPurple.value).withOpacity(0.9),
                                Color(kDarkPurple.value),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.bookmark_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(kDarkPurple.value).withOpacity(0.05),
                        Color(kDarkPurple.value).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Color(kDarkPurple.value).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildJobDetail(
                        Icons.attach_money_rounded,
                        job.salary,
                        Colors.green.shade600,
                      ),
                      Container(
                        height: 28.h,
                        width: 1,
                        color: Color(kDarkGrey.value).withOpacity(0.15),
                      ),
                      _buildJobDetail(
                        Icons.access_time_rounded,
                        job.period,
                        Color(kDarkPurple.value),
                      ),
                      Container(
                        height: 28.h,
                        width: 1,
                        color: Color(kDarkGrey.value).withOpacity(0.15),
                      ),
                      _buildJobDetail(
                        Icons.description_outlined,
                        job.contract,
                        Colors.blue.shade600,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                if (job.hiring)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade50, Colors.green.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.green.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green.shade600,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Actively hiring",
                          style: appStyle(
                            13,
                            Colors.green.shade700,
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetail(IconData icon, String text, Color iconColor) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              text,
              style: appStyle(13, Color(kDark.value), FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
