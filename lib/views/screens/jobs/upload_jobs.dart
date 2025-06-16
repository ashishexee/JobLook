import 'package:flutter/material.dart';
import 'package:job_look/models/request/jobs/create_job.dart';
import 'package:job_look/views/common/BackBtn.dart';
import 'package:job_look/views/common/app_bar.dart';
import 'package:job_look/views/screens/jobs/uploadJobs_provider.dart';
import 'package:provider/provider.dart';

class UploadJobsScreen extends StatefulWidget {
  const UploadJobsScreen({super.key});

  @override
  State<UploadJobsScreen> createState() => _UploadJobsScreenState();
}

class _UploadJobsScreenState extends State<UploadJobsScreen> {
  // Controllers for all text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController contractController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // Controllers for requirements
  final TextEditingController rq1Controller = TextEditingController();
  final TextEditingController rq2Controller = TextEditingController();
  final TextEditingController rq3Controller = TextEditingController();
  final TextEditingController rq4Controller = TextEditingController();
  final TextEditingController rq5Controller = TextEditingController();

  // Boolean for hiring status
  bool isHiring = true;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Flag for loading state
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose all controllers
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    salaryController.dispose();
    companyController.dispose();
    periodController.dispose();
    contactController.dispose();
    contractController.dispose();
    imageUrlController.dispose();
    rq1Controller.dispose();
    rq2Controller.dispose();
    rq3Controller.dispose();
    rq4Controller.dispose();
    rq5Controller.dispose();
    super.dispose();
  }

  Future<void> submitJob() async {
    var uploadjobNotifier = Provider.of<UploadNotifier>(context);
    final List<String> requirements =
        [
          rq1Controller.text,
          rq2Controller.text,
          rq3Controller.text,
          rq4Controller.text,
          rq5Controller.text,
        ].where((req) => req.isNotEmpty).toList();
    String model = createJobsRequestToJson(
      CreateJobsRequest(
        title: titleController.text,
        location: locationController.text,
        company: companyController.text,
        hiring: isHiring,
        description: descriptionController.text,
        salary: salaryController.text,
        period: periodController.text,
        contact: contactController.text,
        imageUrl: imageUrlController.text,
        agentId: await uploadjobNotifier.getAgentUid(),
        requirements: requirements,
      ),
    );
    uploadjobNotifier.createJob(context, model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(50, 50),
        child: CustomAppBar(text: 'Upload Job', child: BackBtn()),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 30),
          children: [
            textform(
              titleController,
              label: 'Job Title',
              hint: 'Enter job title',
              prefixIcon: Icons.work,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Job title is required';
                }
                return null;
              },
            ),
            textform(
              companyController,
              label: 'Company Name',
              hint: 'Enter company name',
              prefixIcon: Icons.business,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Company name is required';
                }
                return null;
              },
            ),
            textform(
              locationController,
              label: 'Location',
              hint: 'Enter job location',
              prefixIcon: Icons.location_on,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
            textform(
              descriptionController,
              label: 'Job Description',
              hint: 'Enter detailed job description',
              maxLines: 5,
              prefixIcon: Icons.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            textform(
              salaryController,
              label: 'Salary',
              hint: 'Enter salary range or amount',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Salary is required';
                }
                return null;
              },
            ),
            textform(
              periodController,
              label: 'Pay Period',
              hint: 'e.g., Monthly, Annual, Hourly',
              prefixIcon: Icons.date_range,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Period is required';
                }
                return null;
              },
            ),
            textform(
              contractController,
              label: 'Contract Type',
              hint: 'e.g., Full-time, Part-time',
              prefixIcon: Icons.contact_page,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Contract type is required';
                }
                return null;
              },
            ),

            // Hiring Status Dropdown
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.people, color: Colors.indigo.shade400),
                      SizedBox(width: 10),
                      Text(
                        'Hiring Status:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<bool>(
                          value: isHiring,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: true,
                              child: Text('Currently Hiring'),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Text('Not Hiring'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              isHiring = value ?? true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            textform(
              imageUrlController,
              label: 'Company Logo URL',
              hint: 'Enter image URL for company logo',
              prefixIcon: Icons.image,
            ),

            // Requirements Section
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Text(
                'Job Requirements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ),
            textform(
              rq1Controller,
              label: 'Requirement 1',
              hint: 'Enter first requirement',
              prefixIcon: Icons.check_circle_outline,
            ),
            textform(
              rq2Controller,
              label: 'Requirement 2',
              hint: 'Enter second requirement',
              prefixIcon: Icons.check_circle_outline,
            ),
            textform(
              rq3Controller,
              label: 'Requirement 3',
              hint: 'Enter third requirement',
              prefixIcon: Icons.check_circle_outline,
            ),
            textform(
              rq4Controller,
              label: 'Requirement 4',
              hint: 'Enter fourth requirement',
              prefixIcon: Icons.check_circle_outline,
            ),
            textform(
              rq5Controller,
              label: 'Requirement 5',
              hint: 'Enter fifth requirement',
              prefixIcon: Icons.check_circle_outline,
            ),

            // Submit Button
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                ),
                child:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'SUBMIT JOB',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textform(
    TextEditingController controller, {
    String? label,
    String? hint,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          labelStyle: TextStyle(
            color: Colors.indigo.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.indigo.shade400)
                  : null,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.indigo.shade500, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red.shade500, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        cursorColor: Colors.indigo,
      ),
    );
  }
}
