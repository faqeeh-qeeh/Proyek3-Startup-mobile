class Client {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String whatsappNumber;
  final String gender;
  final String address;
  final String birthDate;

  Client({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.whatsappNumber,
    required this.gender,
    required this.address,
    required this.birthDate,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      email: json['email'],
      whatsappNumber: json['whatsapp_number'],
      gender: json['gender'],
      address: json['address'],
      birthDate: json['birth_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'email': email,
      'whatsapp_number': whatsappNumber,
      'gender': gender,
      'address': address,
      'birth_date': birthDate,
    };
  }
}