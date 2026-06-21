import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitapp/screens/models/meal_model.dart';

class MealService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addMeal({
    required String uid,
    required MealModel meal,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .add(meal.toMap());
  }

  Stream<QuerySnapshot<Map<String,dynamic>>> getMeals(
      String uid) {

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('meals')
        .snapshots();
  }

  Future<int> getTotalCalories(String uid) async {

  final snapshot = await _firestore
      .collection('users')
      .doc(uid)
      .collection('meals')
      .get();

  int total = 0;

  for (var doc in snapshot.docs) {
    total += (doc.data()['calories'] ?? 0) as int;
  }

  return total;
}
}