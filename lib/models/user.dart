class User {
  int? id;
  String username;
  String email;
  String password;
  String phone;

  User({this.id, required this.username, required this.email, required this.password, required this.phone});

  Map<String, dynamic> toMap() {
    final m = {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
    };
    if (id != null) m['id'] = id as String;
    return m;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
    );
  }
}
