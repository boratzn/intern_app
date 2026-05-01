class StudentProfile {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? university;
  final String? department;
  final String? gradeYear;
  final double? gpa;
  final String? phone;
  final String? city;
  final String? about;
  final List<String>? skills;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? portfolioUrl;
  final bool isSeekingInternship;
  final String? cvUrl;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentProfile({
    required this.id,
    this.firstName,
    this.lastName,
    this.university,
    this.department,
    this.gradeYear,
    this.gpa,
    this.phone,
    this.city,
    this.about,
    this.skills,
    this.linkedinUrl,
    this.githubUrl,
    this.portfolioUrl,
    this.isSeekingInternship = true,
    this.cvUrl,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  static List<String>? _parseSkills(dynamic skillsData) {
    if (skillsData == null) return null;
    if (skillsData is List) {
      return skillsData.map((e) => e.toString()).toList();
    }
    if (skillsData is String) {
      return skillsData
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return null;
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      university: json['university'],
      department: json['department'],
      gradeYear: json['grade_year']?.toString(), // Ensure string
      gpa: json['gpa'] != null ? double.tryParse(json['gpa'].toString()) : null,
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      about: json['about']?.toString(),
      skills: _parseSkills(json['skills']),
      linkedinUrl: json['linkedin_url']?.toString(),
      githubUrl: json['github_url']?.toString(),
      portfolioUrl: json['portfolio_url']?.toString(),
      isSeekingInternship:
          json['is_seeking_internship'] == true ||
          json['is_seeking_internship'] == 'true',
      cvUrl: json['cv_url']?.toString(),
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'university': university,
      'department': department,
      'grade_year': gradeYear,
      'gpa': gpa,
      'phone': phone,
      'city': city,
      'about': about,
      'skills': skills,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'portfolio_url': portfolioUrl,
      'is_seeking_internship': isSeekingInternship,
      'cv_url': cvUrl,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
