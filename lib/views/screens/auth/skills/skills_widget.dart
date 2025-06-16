import 'package:flutter/material.dart';
import 'package:job_look/models/request/auth/add_skills.dart';
import 'package:job_look/models/response/auth/skills.dart';
import 'package:job_look/services/helpers/auth_helper.dart';
import 'package:job_look/views/common/app_style.dart';
import 'package:job_look/views/common/reusable_text.dart';
import 'package:job_look/views/screens/auth/skills/skills_provider.dart';
import 'package:provider/provider.dart';

class SkillsWidget extends StatefulWidget {
  const SkillsWidget({super.key});

  @override
  State<SkillsWidget> createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<SkillsWidget> {
  TextEditingController userSkillsController = TextEditingController();
  late Future<List<Skills>> skills;
  @override
  void initState() {
    skills = getSkills();
    super.initState();
  }

  void refreshSkills() {
    setState(() {
      skills = getSkills();
    });
  }

  Future<List<Skills>> getSkills() {
    var skills = AuthHelper.getSkills();
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillsNotifier>(
      builder: (context, skillsNotifier, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReusableText(
                  text: 'Skills',
                  style: appStyle(18, Colors.black, FontWeight.w700),
                ),
                Expanded(child: SizedBox()),
                skillsNotifier.isaddpressed == false
                    ? InkWell(
                      onTap: () {
                        skillsNotifier.isaddpressed =
                            !(skillsNotifier.isaddpressed);
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade300,
                              Colors.blue.shade700,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    )
                    : InkWell(
                      onTap: () {
                        skillsNotifier.isaddpressed =
                            !(skillsNotifier.isaddpressed);
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade300, Colors.red.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
              ],
            ),
            SizedBox(height: 5),
            skillsNotifier.isaddpressed == true
                ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: userSkillsController,
                        decoration: InputDecoration(
                          hintText: "Add your skill...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.blue.shade200,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              width: 2,
                            ),
                          ),
                        ),
                        style: appStyle(14, Colors.black87, FontWeight.normal),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        if (userSkillsController.text.isEmpty == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.zero,
                              duration: Duration(seconds: 3),
                              dismissDirection: DismissDirection.horizontal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              action: SnackBarAction(
                                label: 'OK',
                                textColor: Colors.red,
                                onPressed: () {},
                              ),
                              clipBehavior: Clip.antiAlias,
                              showCloseIcon: true,
                              closeIconColor: Colors.white,
                              content: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade700,
                                      Colors.redAccent.shade400,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Skill cannot be empty',
                                      style: appStyle(
                                        14,
                                        Colors.white,
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        bool result = await skillsNotifier.addSkill(
                          AddSkill(skill: userSkillsController.text),
                        );
                        skillsNotifier.isaddpressed = false;
                        if (result == true) {
                          userSkillsController.clear();
                          refreshSkills();
                        }
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade700,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                )
                : SizedBox(height: 1),

            FutureBuilder(
              future: skills,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  print('no skills to show');
                  return Text('No Skills Added');
                } else {
                  print('${snapshot.data!.length}');
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 10,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.grey.shade100,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.1),
                                          blurRadius: 15,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.amber.shade700,
                                          size: 60,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Delete Skill',
                                          style: appStyle(
                                            20,
                                            Colors.black87,
                                            FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Are you sure you want to delete this skill?',
                                          textAlign: TextAlign.center,
                                          style: appStyle(
                                            16,
                                            Colors.black54,
                                            FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 25),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                  vertical: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: appStyle(
                                                    14,
                                                    Colors.black87,
                                                    FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                String id =
                                                    snapshot.data![index].id;
                                                bool result =
                                                    await skillsNotifier
                                                        .deleteSkill(id);
                                                Navigator.pop(context);
                                                if (result) {
                                                  refreshSkills();
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 25,
                                                  vertical: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.red.shade400,
                                                      Colors.red.shade700,
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.red
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  'Delete',
                                                  style: appStyle(
                                                    14,
                                                    Colors.white,
                                                    FontWeight.w600,
                                                  ),
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
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 5,
                            ),
                            height: 50,
                            constraints: BoxConstraints(minWidth: 100),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade600,
                                  Colors.indigo.shade800,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: Offset(0, -1),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: ReusableText(
                                      text: snapshot.data![index].skill,
                                      style: appStyle(
                                        13,
                                        Colors.white,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
