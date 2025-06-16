import 'dart:convert';

List<JobsResponse> jobsResponseFromJson(String str) => List<JobsResponse>.from(
  json.decode(str).map((x) => JobsResponse.fromJson(x)),
);

class JobsResponse {
  JobsResponse({
    required this.id,
    required this.title,
    required this.location,
    required this.agentName,
    required this.company,
    required this.hiring,
    required this.description,
    required this.salary,
    required this.period,
    required this.contact,
    required this.requirements,
    required this.imageUrl,
    required this.agentId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String location;
  final String agentName;
  final String company;
  final String hiring; // Changed from bool to String
  final String description;
  final String salary;
  final String period;
  final String contact; // Added missing field
  final List<String> requirements;
  final String imageUrl;
  final String agentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory JobsResponse.fromJson(Map<String, dynamic> json) => JobsResponse(
    id: json["_id"]?.toString() ?? '',
    title: json["title"]?.toString() ?? '',
    location: json["location"]?.toString() ?? '',
    agentName: json["agentName"]?.toString() ?? '',
    company:
        json["company"]?.toString() ??
        'Not specified', // Provide default since API doesn't have this field
    hiring: json["hiring"]?.toString() ?? '', // Changed to handle string
    description:
        json["description"]?.toString() ??
        'No description available', // Provide default
    salary: json["salary"]?.toString() ?? '',
    period: json["period"]?.toString() ?? '',
    contact: json["contact"]?.toString() ?? '', // Added missing field
    requirements:
        json["requirements"] != null
            ? List<String>.from(
              json["requirements"].map((x) => x?.toString() ?? ''),
            )
            : [],
    imageUrl: json["imageUrl"]?.toString() ?? '',
    agentId: json["agentId"]?.toString() ?? '',
    createdAt:
        json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
    updatedAt:
        json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "location": location,
    "agentName": agentName,
    "company": company,
    "hiring": hiring,
    "description": description,
    "salary": salary,
    "period": period,
    "contact": contact,
    "requirements": List<dynamic>.from(requirements.map((x) => x)),
    "imageUrl": imageUrl,
    "agentId": agentId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
