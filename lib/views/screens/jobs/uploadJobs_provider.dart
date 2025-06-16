import 'package:flutter/material.dart';
import 'package:job_look/services/helpers/jobs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

// things needed  : agentName  , agentId
class UploadNotifier extends ChangeNotifier {
  Future<String> getUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? username = pref.getString('username');
    return username!;
  }

  Future<String> getAgentUid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? uid = pref.getString('uid');
    return uid!;
  }

  Future<bool> createJob(BuildContext context, String model) async {
    try {
      final bool result = await JobHelper.createJob(model);
      if (result == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Job Uploaded Successfully')));
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Provider : Could not create a Job');
    }
  }
}
