class Company {
  final String address;
  final String bio;
  final String email;
  final String name;
  final String phone;
  final String photoName;
  final String photoUrl;

  Company({
    required this.address,
    required this.bio,
    required this.email,
    required this.name,
    required this.phone,
    required this.photoName,
    required this.photoUrl,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      address: json['address'] ?? '',
      bio: json['bio'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      photoName: json['photoName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }
}
