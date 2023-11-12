class User {
  final String username;
  final String password;

  const User({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

class NewUser {
  final String username;
  final String password;
  final String phoneNumber;

  const NewUser({
    required this.username,
    required this.password,
    required this.phoneNumber
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'phoneNumber' : phoneNumber,
  };
}