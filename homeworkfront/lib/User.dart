class User {
  final int userId;
  final String email;
  final String name;
  final String surname;
  final String birthdate;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.surname,
    required this.birthdate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userid'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      birthdate: json['birthdate'],
    );
  }
}
