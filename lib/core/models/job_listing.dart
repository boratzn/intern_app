import 'company_profile.dart';

class JobListing {
  final String id;
  final String companyId;
  final String title;
  final String department;
  final String location;
  final String workType;
  final String compensationType;
  final String duration;
  final String description;
  final String? requirements;
  final String? benefits;
  final DateTime? deadline;
  final bool isActive;
  final DateTime? createdAt;
  final CompanyProfile? company;
  final int? categoryId;

  JobListing({
    required this.id,
    required this.companyId,
    required this.title,
    required this.department,
    required this.location,
    required this.workType,
    required this.compensationType,
    required this.duration,
    required this.description,
    this.requirements,
    this.benefits,
    this.deadline,
    this.isActive = true,
    this.createdAt,
    this.company,
    this.categoryId,
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      title: json['title'] as String,
      department: json['department'] as String,
      location: json['location'] as String,
      workType: json['work_type'] as String,
      compensationType: json['compensation_type'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String?,
      benefits: json['benefits'] as String?,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      company: json['company_profiles'] != null
          ? CompanyProfile.fromJson(json['company_profiles'] as Map<String, dynamic>)
          : (json['company'] != null ? CompanyProfile.fromJson(json['company'] as Map<String, dynamic>) : null),
      categoryId: json['category_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'title': title,
      'department': department,
      'location': location,
      'work_type': workType,
      'compensation_type': compensationType,
      'duration': duration,
      'description': description,
      'requirements': requirements,
      'benefits': benefits,
      'deadline': deadline?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'company': company?.toJson(),
      'category_id': categoryId,
    };
  }

  JobListing copyWith({
    String? id,
    String? companyId,
    String? title,
    String? department,
    String? location,
    String? workType,
    String? compensationType,
    String? duration,
    String? description,
    String? requirements,
    String? benefits,
    DateTime? deadline,
    bool? isActive,
    DateTime? createdAt,
    CompanyProfile? company,
    int? categoryId,
  }) {
    return JobListing(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      department: department ?? this.department,
      location: location ?? this.location,
      workType: workType ?? this.workType,
      compensationType: compensationType ?? this.compensationType,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      deadline: deadline ?? this.deadline,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      company: company ?? this.company,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
