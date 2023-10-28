class UserModel {
  String? name;
  String? id;
  String? email;
  int? age;

  UserModel({
    this.name,
    this.id,
    this.email,
    this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "age": age,
    };
  }
}
