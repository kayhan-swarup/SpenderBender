class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? password;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String?,
      password: map['password'] as String?,
    );
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
