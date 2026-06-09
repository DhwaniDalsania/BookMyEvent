class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? organizerId;
  final String? organizerName;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    this.organizerId,
    this.organizerName,
    this.createdAt,
  });

  bool get isOrganizer => role == 'ORGANIZER' || role == 'ADMIN';
  String get displayName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final organizer = json['organizer'] as Map<String, dynamic>?;
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      organizerId: organizer?['id'],
      organizerName: organizer?['name'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email,
      role: role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      organizerId: organizerId,
      organizerName: organizerName,
      createdAt: createdAt,
    );
  }
}
