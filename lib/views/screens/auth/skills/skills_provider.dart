import 'package:flutter/material.dart';
import 'package:job_look/models/request/auth/add_skills.dart';
import 'package:job_look/services/helpers/auth_helper.dart';

class SkillsNotifier extends ChangeNotifier {
  bool _isaddpressed = false;
  bool get isaddpressed => _isaddpressed;

  set isaddpressed(bool newState) {
    _isaddpressed = newState;
    notifyListeners();
  }

  Future<bool> addSkill(AddSkill skill) async {
    print('inside add skill provideer');
    String model = addSkillToJson(skill);
    try {
      bool results = await AuthHelper.addSkill(model);
      print('addSkils ks result $results');
      if (results) {
        notifyListeners();
        return true;
      } else {
        throw Exception('could not add the skill');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteSkill(String id) async {
    try {
      bool result = await AuthHelper.deleteSkill(id);
      if (result) {
        notifyListeners();
        return true;
      } else {
        throw Exception('could not delete the skill');
      }
    } catch (error) {
      rethrow;
    }
  }
}
