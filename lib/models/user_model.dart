// lib/models/user_model.dart
class UserModel {
  final String id;
  String name;
  String email;
  String phone;
  String? avatar;
  String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatar,
    this.address = '',
  });

  UserModel copyWith({String? name, String? email, String? phone, String? avatar, String? address}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email, 'phone': phone, 'address': address};
  factory UserModel.fromMap(Map<String, dynamic> m) =>
      UserModel(id: m['id'], name: m['name'], email: m['email'], phone: m['phone'] ?? '', address: m['address'] ?? '');
}