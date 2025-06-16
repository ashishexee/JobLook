import 'package:job_look/models/response/jobs/get_job.dart';
import 'package:job_look/models/response/jobs/jobs_response.dart';
import 'package:http/http.dart' as https;
import 'package:job_look/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobHelper {
  Future<List<JobsResponse>> getJobs() async {
    var client = https.Client();

    Map<String, String> responseHeader = {'Content-Type': 'application/json'};
    var url = Uri.parse(Config.apiUrl + Config.jobs);
    var response = await client.get(url, headers: responseHeader);
    if (response.statusCode == 200) {
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Error occured');
    }
  }

  Future<GetJobRes> getJob(String jobID) async {
    var client = https.Client();

    Map<String, String> responseHeader = {'Content-Type': 'application/json'};
    var url = Uri.parse("${Config.apiUrl}/${Config.jobs}/$jobID");
    var response = await client.get(url, headers: responseHeader);
    if (response.statusCode == 200) {
      var jobDetails = getJobResFromJson(response.body);
      return jobDetails;
    } else {
      throw Exception('Error occured');
    }
  }

  Future<List<JobsResponse>> getRecent() async {
    var client = https.Client();
    Map<String, String> responseHeader = {'Content-Type': 'application.json'};

    var url = Uri.parse("${Config.apiUrl}${Config.jobs}?new=true");
    var response = await client.get(url, headers: responseHeader);
    if (response.statusCode == 200) {
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Error occured');
    }
  }

  Future<List<JobsResponse>> getSearchJob(String query) async {
    var client = https.Client();
    Map<String, String> responseHeader = {'Content-Type': 'application.json'};

    var url = Uri.parse("${Config.apiUrl}${Config.jobs}/search/$query");
    var response = await client.get(url, headers: responseHeader);
    if (response.statusCode == 200) {
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Error occured');
    }
  }

  static Future<bool> createJob(String model) async {
    var client = https.Client();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> responseHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };
    var url = Uri.parse(Config.apiUrl + Config.jobs);
    print('for adding a job : $url');
    var response = await client.post(url, body: model, headers: responseHeader);
    print('for creating a job : ${response.body}');
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('COuld not get user profile');
    }
  }
}
