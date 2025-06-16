import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/jobs_provider.dart';
import 'package:job_look/views/screens/home/job_details.dart';
import 'package:provider/provider.dart';

class RecentJobs extends StatefulWidget {
  const RecentJobs({super.key});

  @override
  State<RecentJobs> createState() => _RecentJobsState();
}

class _RecentJobsState extends State<RecentJobs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350.h,
      child: Consumer<JobsNotifier>(
        builder: (context, jobsNotifier, child) {
          // Loading state
          if (jobsNotifier.isLoadingRecent) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(kDarkGrey.value)),
                  SizedBox(height: 12.h),
                  Text(
                    'Loading recent jobs...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(kDarkGrey.value),
                    ),
                  ),
                ],
              ),
            );
          }

          // Error state
          if (jobsNotifier.recentError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
                  SizedBox(height: 12.h),
                  Text(
                    'Error loading recent jobs',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      jobsNotifier.recentError!,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () => jobsNotifier.refreshRecentJobs(),
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(kDarkGrey.value),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Empty state
          final jobs = jobsNotifier.recentJobs;
          if (jobs == null || jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off, size: 40.sp, color: Colors.grey),
                  SizedBox(height: 12.h),
                  Text(
                    'No recent jobs available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () => jobsNotifier.refreshRecentJobs(),
                    icon: Icon(Icons.refresh),
                    label: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(kDarkGrey.value),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Success state - jobs available with ListTiles
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: jobs.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              var job = jobs[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetails(job: job),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      // Company Logo
                      Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child:
                              job.imageUrl.isNotEmpty
                                  ? Image.network(
                                    job.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // This runs when the image fails to load
                                      return _buildDefaultCompanyIcon();
                                    },
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
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
                      SizedBox(width: 16.w),

                      // Job Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Job Title
                            Text(
                              job.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 6.h),

                            // Company Name
                            Text(
                              job.company,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(kDarkGrey.value),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 6.h),

                            // Location Row
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.sp,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    job.location,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Salary and Arrow
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Salary
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Text(
                              job.salary,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Type
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              job.period,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDefaultCompanyIcon() {
    return Container(
      color: Color(kLightGrey.value),
      child: Center(
        child: Icon(Icons.business, size: 25.r, color: Color(kDarkGrey.value)),
      ),
    );
  }
}
