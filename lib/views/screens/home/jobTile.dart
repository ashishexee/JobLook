import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/bookmark_provider.dart';
import 'package:job_look/models/response/jobs/jobs_response.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:provider/provider.dart';

class Jobtiles extends StatefulWidget {
  final void Function()? onTap;
  final JobsResponse job;
  const Jobtiles({super.key, this.onTap, required this.job});

  @override
  State<Jobtiles> createState() => _JobtilesState();
}

class _JobtilesState extends State<Jobtiles> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkNotifier>(
      builder: (context, bookmarkNotifier, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              height: hieght * 0.32, // Increased height to accommodate button
              width: width * 0.7,
              decoration: BoxDecoration(
                color: Color(kLightGrey.value),
                borderRadius: BorderRadius.circular(30.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.w),
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          'assets/images/jobs.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child:
                                        widget.job.imageUrl.isNotEmpty
                                            ? Image.network(
                                              widget.job.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                // This runs when the image fails to load
                                                return _buildDefaultCompanyIcon();
                                              },
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                // Show a loading indicator while the image loads
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                    strokeWidth: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                );
                                              },
                                            )
                                            : _buildDefaultCompanyIcon(),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                ReusableText(
                                  text: widget.job.company,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        ReusableText(
                          text: widget.job.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.sp,
                          ),
                        ),

                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 6.w),
                            ReusableText(
                              text: widget.job.location,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Color(kDarkGrey.value),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: Colors.grey.withOpacity(0.3)),
                        SizedBox(height: 8.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ReusableText(
                                  text: widget.job.salary,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 18.sp,
                                  color: Color(kDarkGrey.value),
                                ),
                                SizedBox(width: 4.w),
                                ReusableText(
                                  text:
                                      widget.job.period.length > 10
                                          ? "${widget.job.period.substring(0, 10)}..."
                                          : widget.job.period,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(kDarkGrey.value),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(kDarkGrey.value),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.visibility, size: 18.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'See more details',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  bool isImageGood(String imageUrl) {
    return imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
  }

  Widget _buildDefaultCompanyIcon() {
    return Container(
      color: Color(kLightGrey.value),
      child: Center(
        child: Icon(Icons.business, size: 22.r, color: Color(kDarkGrey.value)),
      ),
    );
  }
}
