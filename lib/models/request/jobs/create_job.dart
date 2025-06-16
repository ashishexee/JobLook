import 'dart:convert';

String createJobsRequestToJson(CreateJobsRequest data) =>
    json.encode(data.toJson());
CreateJobsRequest createJobsRequestFromJson(String str) =>
    CreateJobsRequest.fromJson(json.decode(str));

class CreateJobsRequest {
  CreateJobsRequest({
    required this.title,
    required this.location,
    required this.company,
    required this.hiring,
    required this.description,
    required this.salary,
    required this.period,
    required this.contact,
    required this.imageUrl,
    required this.agentId,
    required this.requirements,
  });

  final String title;
  final String location;
  final String company;
  final bool hiring;
  final String description;
  final String salary;
  final String period;
  final String contact;
  final String imageUrl;
  final String agentId;
  final List<String> requirements;

  factory CreateJobsRequest.fromJson(Map<String, dynamic> json) =>
      CreateJobsRequest(
        title: json["title"] ?? "",
        location: json["location"] ?? "",
        company: json["company"] ?? "",
        hiring: json["hiring"] ?? false,
        description: json["description"] ?? "",
        salary: json["salary"] ?? "",
        period: json["period"] ?? "",
        contact: json["contact"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        agentId: json["agentId"] ?? "",
        requirements:
            json["requirements"] != null
                ? List<String>.from(json["requirements"].map((x) => x))
                : [],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "location": location,
    "company": company,
    "hiring": hiring,
    "description": description,
    "salary": salary,
    "period": period,
    "contact": contact,
    "imageUrl": imageUrl,
    "agentId": agentId,
    "requirements": List<dynamic>.from(requirements.map((x) => x)),
  };
}
