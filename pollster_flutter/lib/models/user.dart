class User {
  final String email;
  final String password;

  const User({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': email,
    'password': password,
  };
}

class NewUser {
  final String email;
  final String password;
  final String phoneNumber;

  const NewUser({
    required this.email,
    required this.password,
    required this.phoneNumber
  });

  Map<String, dynamic> toJson() => {
    'username': email,
    'password': password,
    'phoneNumber' : phoneNumber,
  };
}