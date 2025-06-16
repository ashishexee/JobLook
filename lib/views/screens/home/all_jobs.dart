import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_look/constants/app_constants.dart';
import 'package:job_look/controllers/jobs_provider.dart';
import 'package:job_look/models/response/jobs/jobs_response.dart';
import 'package:job_look/views/common/BackBtn.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/screens/home/job_details.dart';
import 'package:provider/provider.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Future<List<JobsResponse>>? searchResults;

  void performSearch(JobsNotifier jobsNotifier, String query) {
    setState(() {
      searchQuery = query;
      searchResults = jobsNotifier.getSearchJob(query);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jobsNotifier = Provider.of<JobsNotifier>(context, listen: false);
      performSearch(jobsNotifier, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: const CustomAppBar(text: 'All Jobs', child: BackBtn()),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Consumer<JobsNotifier>(
              builder: (context, jobsNotifier, _) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs by title or company...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(kDarkGrey.value),
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                performSearch(jobsNotifier, '');
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: Color(kLightGrey.value).withOpacity(0.5),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: Color(kDarkGrey.value),
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) => performSearch(jobsNotifier, value),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => performSearch(jobsNotifier, value),
                );
              },
            ),
          ),

          // Job Listings
          Expanded(
            child: Consumer<JobsNotifier>(
              builder: (context, jobsNotifier, child) {
                // Show loading when jobs are initially loading
                if (searchResults == null || jobsNotifier.isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(kDarkGrey.value),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Loading jobs...',
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
                if (jobsNotifier.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 40.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Error loading jobs',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            jobsNotifier.error!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            jobsNotifier.refreshJobs();
                            performSearch(jobsNotifier, searchQuery);
                          },
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

                // Handle async search results
                return FutureBuilder<List<JobsResponse>>(
                  future: searchResults,
                  builder: (context, snapshot) {
                    // Handle loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(kDarkGrey.value),
                        ),
                      );
                    }

                    // Handle error state
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 40.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Error searching jobs',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                snapshot.error.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              onPressed:
                                  () =>
                                      performSearch(jobsNotifier, searchQuery),
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

                    final jobs = snapshot.data ?? [];

                    // Empty state
                    if (jobs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 400,

                              width: 400,
                              child: Image.asset(
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.search);
                                },
                                'assets/images/optimized_search.png',
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              searchQuery.isEmpty
                                  ? 'Search for the Job'
                                  : 'No jobs match your search',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (searchQuery.isNotEmpty)
                              ElevatedButton.icon(
                                onPressed: () {
                                  _searchController.clear();
                                  performSearch(jobsNotifier, '');
                                },
                                icon: Icon(Icons.clear),
                                label: Text('Clear Search'),
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

                    // Success state - jobs available
                    return RefreshIndicator(
                      onRefresh: () async {
                        await jobsNotifier.refreshJobs();
                        performSearch(jobsNotifier, searchQuery);
                      },
                      color: Color(kDarkGrey.value),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          var job = jobs[index];
                          return _buildJobCard(context, job);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobDetails(job: job)),
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company row
                Row(
                  children: [
                    // Company Logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 46.h,
                        width: 46.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Image.network(
                          job.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.business,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Company name and location
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.company,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
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

                    // Period badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getJobTypeColor(job.period).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _getJobTypeColor(job.period).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        job.period,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: _getJobTypeColor(job.period),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                SizedBox(height: 12.h),

                // Job title
                Text(
                  job.title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 10.h),

                // Requirements preview
                if (job.requirements != null && job.requirements.isNotEmpty)
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children:
                        job.requirements.take(3).map<Widget>((req) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(kLightGrey.value),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              req.split(' ').take(3).join(' ') +
                                  (req.split(' ').length > 3 ? '...' : ''),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Color(kDarkGrey.value),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                SizedBox(height: 12.h),

                // Salary and details row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Salary
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 14.sp,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            job.salary.replaceAll(
                              '\$',
                              '',
                            ), // Remove duplicate $ if present
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // See details button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetails(job: job),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_forward, size: 16.sp),
                      label: Text('See details'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        backgroundColor: Colors.blue.shade50,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getJobTypeColor(String jobType) {
    jobType = jobType.toLowerCase();
    if (jobType.contains('full')) return Colors.blue;
    if (jobType.contains('part')) return Colors.purple;
    if (jobType.contains('contract')) return Colors.orange;
    if (jobType.contains('remote')) return Colors.teal;
    return Colors.blue;
  }
}
