import 'package:flutter/material.dart';
import 'package:job_look/controllers/jobs_provider.dart';
import 'package:job_look/views/screens/home/jobTile.dart';
import 'package:job_look/views/screens/home/job_details.dart';
import 'package:provider/provider.dart';

class PopularJobs extends StatefulWidget {
  const PopularJobs({super.key});

  @override
  State<PopularJobs> createState() => _PopularJobsState();
}

class _PopularJobsState extends State<PopularJobs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobsNotifier>().getJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Add fixed height
      child: Consumer<JobsNotifier>(
        builder: (context, jobsNotifier, child) {
          if (jobsNotifier.isLoading) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (jobsNotifier.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading jobs', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    jobsNotifier.error!,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      jobsNotifier.refreshJobs();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          final jobs = jobsNotifier.jobs;
          if (jobs == null || jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No jobs available', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      jobsNotifier.refreshJobs();
                    },
                    child: Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Success state - jobs available
          return RefreshIndicator(
            onRefresh: () => jobsNotifier.refreshJobs(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index];
                return Jobtiles(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JobDetails(job: job,)),
                    );
                  },
                  job: job,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
