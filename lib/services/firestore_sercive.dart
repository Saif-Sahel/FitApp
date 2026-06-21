import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> saveUserData({
  required String uid,
  required Map<String, dynamic> data,
}) async {
  await _firestore
      .collection('users')
      .doc(uid)
      .set(data, SetOptions(merge: true));
}

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getUserData(String uid) {

    return _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>
    getUserStream(String uid) {
  return _firestore
      .collection('users')
      .doc(uid)
      .snapshots();
}

Future<void> addCalories({
  required String uid,
  required int calories,
}) async {
  await _firestore
      .collection('users')
      .doc(uid)
      .update({
    'caloriesConsumed':
        FieldValue.increment(calories),
  });
}

Future<void> addMeal({
  required String uid,
  required String mealName,
  required int calories,
}) async {
  final docRef = _firestore.collection('users').doc(uid);

  await _firestore.runTransaction((transaction) async {
    final snapshot = await transaction.get(docRef);

    final data = snapshot.data();

    if (data == null) return;

    final rawMeals = data['meals'];

    List<Map<String, dynamic>> meals = [];

    if (rawMeals is List) {
      meals = List<Map<String, dynamic>>.from(rawMeals);
    }

    meals.add({
      'name': mealName,
      'calories': calories,
      'date': DateTime.now().toIso8601String(),
    });

    transaction.update(docRef, {
      'meals': meals,
      'caloriesConsumed': FieldValue.increment(calories),
    });
  });
}
  
}