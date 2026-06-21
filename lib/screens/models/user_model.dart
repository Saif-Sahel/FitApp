class UserModel {
  final String name;
  final String email;
  final int weight;
  final int height;
  final String goal;

  UserModel({
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
    required this.goal,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      weight: json['weight'],
      height: json['height'],
      goal: json['goal'],
    );
  }
}