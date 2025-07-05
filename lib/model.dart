class Patient {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String? address;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    this.address,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address']?['address'],
    );
  }
}
