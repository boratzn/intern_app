class CompanyProfile {
  final String id;
  final String companyName;
  final String? sector;
  final String? companySize;
  final String? website;
  final String? linkedinUrl;
  final String? phone;
  final String? email;
  final String? city;
  final String? country;
  final String? description;
  final String? logoUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? contactPerson;

  CompanyProfile({
    required this.id,
    required this.companyName,
    this.sector,
    this.companySize,
    this.website,
    this.linkedinUrl,
    this.phone,
    this.email,
    this.city,
    this.country,
    this.description,
    this.logoUrl,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.contactPerson,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      sector: json['sector'] as String?,
      companySize: json['company_size'] as String?,
      website: json['website'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      contactPerson: json['contact_person'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'sector': sector,
      'company_size': companySize,
      'website': website,
      'linkedin_url': linkedinUrl,
      'phone': phone,
      'email': email,
      'city': city,
      'country': country,
      'description': description,
      'logo_url': logoUrl,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'contact_person': contactPerson,
    };
  }

  CompanyProfile copyWith({
    String? id,
    String? companyName,
    String? sector,
    String? companySize,
    String? website,
    String? linkedinUrl,
    String? phone,
    String? email,
    String? city,
    String? country,
    String? description,
    String? logoUrl,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contactPerson,
  }) {
    return CompanyProfile(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      sector: sector ?? this.sector,
      companySize: companySize ?? this.companySize,
      website: website ?? this.website,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      city: city ?? this.city,
      country: country ?? this.country,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactPerson: contactPerson ?? this.contactPerson,
    );
  }
}
