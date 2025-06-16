import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/bookmark_provider.dart';
import 'package:job_look/controllers/login_provider.dart';
import 'package:job_look/models/response/bookmarks/book_res.dart';
import 'package:job_look/models/response/jobs/jobs_response.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/screens/auth/login_page.dart';
import 'package:provider/provider.dart';

class JobDetails extends StatefulWidget {
  final JobsResponse job;
  const JobDetails({super.key, required this.job});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    print(loginNotifier.isLoggedIn);
    return Consumer<BookmarkNotifier>(
      builder: (context, bookmarkNotifier, child) {
        bookmarkNotifier.getBookmark(widget.job.id);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 120.h,
                  pinned: true,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.only(left: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        if (bookmarkNotifier.isBookmarked == true) {
                          print('delete krr rha hu bhai');
                          bookmarkNotifier.deleteBookmark(
                            bookmarkNotifier.bookmarkId,
                            context,
                          );
                        } else {
                          print('krr rha hu add bhai');
                          BookMarkReqRes model = BookMarkReqRes(
                            job: widget.job.id,
                          );
                          String stringModel = bookMarkReqResToJson(model);
                          bookmarkNotifier.addBookmark(stringModel);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.w),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          bookmarkNotifier.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color:
                              bookmarkNotifier.isBookmarked
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Share functionality
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.w),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.share, color: Colors.black),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 60.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(widget.job.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text: widget.job.company,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16.sp,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4.w),
                                      ReusableText(
                                        text: widget.job.location,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Job Title and Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          text: widget.job.title,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Key details cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDetailCard(
                              title: "Salary",
                              value: widget.job.salary,
                              icon: Icons.attach_money,
                              color: Colors.green,
                            ),
                            _buildDetailCard(
                              title: "Job Type",
                              value: widget.job.period,
                              icon: Icons.access_time,
                              color: Colors.blue,
                            ),
                            _buildDetailCard(
                              title: "Level",
                              value: "Mid-Level", // Assuming this field
                              icon: Icons.stairs,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),

                        _buildSectionTitle("Job Details"),
                        SizedBox(height: 12.h),
                        _buildParagraph(widget.job.description),

                        SizedBox(height: 25.h),
                        _buildSectionTitle("Job Requirements"),
                        SizedBox(height: 12.h),
                        ...widget.job.requirements.map(
                          (requirement) => _buildBulletPoint(requirement),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Application logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loginNotifier.isLoggedIn == false
                      ? Icon(Icons.work, size: 18.sp, color: Colors.white)
                      : Icon(
                        Icons.login_rounded,
                        size: 18.sp,
                        color: Colors.white,
                      ),

                  SizedBox(width: 10.w),
                  loginNotifier.isLoggedIn == true
                      ? Text(
                        'Apply Here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Please Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: width * 0.28,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.grey.shade700,
        height: 1.5,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5.h),
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
