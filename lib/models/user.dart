class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  String? profileImageUrl;

  var balance;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required double balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
    };
  }
}
