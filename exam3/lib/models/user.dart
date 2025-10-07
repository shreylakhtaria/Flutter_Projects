class User {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final DateTime createdAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  User copyWith({
    int? id,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt)';
  }
}