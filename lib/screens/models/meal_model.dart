class MealModel {
  final String name;
  final int calories;
  final String type;

  MealModel({
    required this.name,
    required this.calories,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'type': type,
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      name: map['name'],
      calories: map['calories'],
      type: map['type'],
    );
  }
}