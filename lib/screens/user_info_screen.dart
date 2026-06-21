import 'package:fitapp/screens/home_screen.dart';
import 'package:fitapp/services/auth_service.dart';
import 'package:fitapp/services/calorie_service.dart';
import 'package:fitapp/services/firestore_sercive.dart';
import 'package:fitapp/widgets/choice_clip.dart';
import 'package:fitapp/widgets/info_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String selectedGender = '';
  String selectedGoal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us about yourself',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),

                const SizedBox(height: 8),

                Text(
                  'This helps us personalize\nyour experience',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.person, size: 50),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C63FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                UserInfoField(
                  label: 'Age',
                  controller: ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Age';
                    }

                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Age must be a number';
                    }

                    if (age <= 17 || age > 100) {
                      return 'Enter Your Real Age';
                    }
                    return null;
                  },
                  width: double.infinity,
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: UserInfoField(
                        label: 'Height',
                        controller: heightController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Height';
                          }

                          final height = int.tryParse(value);
                          if (height == null) {
                            return 'Height must be a number';
                          }

                          if (height <= 100 || height > 250) {
                            return 'Enter Your Height Correctly';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: UserInfoField(
                        label: 'Weight',
                        controller: weightController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Weight';
                          }

                          final weight = int.tryParse(value);
                          if (weight == null) {
                            return 'Weight must be a number';
                          }

                          if (weight <= 30 || weight > 200) {
                            return 'Enter Your Weight Correctly';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Gender',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: CustomChoiceChip(
                        text: 'Male',
                        isSelected: selectedGender == 'Male',
                        onTap: () {
                          setState(() {
                            selectedGender = 'Male';
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: CustomChoiceChip(
                        text: 'Female',
                        isSelected: selectedGender == 'Female',
                        onTap: () {
                          setState(() {
                            selectedGender = 'Female';
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Your Goal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    CustomChoiceChip(
                      text: 'Lose Weight',
                      //width: 100,
                      isSelected: selectedGoal == 'Lose Weight',
                      onTap: () {
                        setState(() {
                          selectedGoal = 'Lose Weight';
                        });
                      },
                    ),

                    CustomChoiceChip(
                      text: 'Maintain Weight',
                      isSelected: selectedGoal == 'Maintain Weight',
                      onTap: () {
                        setState(() {
                          selectedGoal = 'Maintain Weight';
                        });
                      },
                    ),

                    CustomChoiceChip(
                      text: 'Gain Weight',
                      isSelected: selectedGoal == 'Gain Weight',
                      onTap: () {
                        setState(() {
                          selectedGoal = 'Gain Weight';
                        });
                      },
                    ),

                    CustomChoiceChip(
                      text: 'Gain Muscle',
                      isSelected: selectedGoal == 'Gain Muscle',
                      onTap: () {
                        setState(() {
                          selectedGoal = 'Gain Muscle';
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      if (selectedGender.isEmpty || selectedGoal.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Select gender and goal'),
                          ),
                        );
                        return;
                      }

                      final user = AuthService().currentUser;

                      if (user == null) return;

                      final age = int.parse(ageController.text);
                      final height = double.parse(heightController.text);
                      final weight = double.parse(weightController.text);

                      final bmr = CalorieService.calculateBMR(
                        weight: weight,
                        height: height,
                        age: age,
                        gender: selectedGender,
                      );

                      final caloriesGoal = CalorieService.calculateCaloriesGoal(
                        bmr: bmr,
                        goal: selectedGoal,
                      );

                      await FirestoreService().saveUserData(
                        uid: user.uid,
                        data: {
                          'age': age,
                          'height': height,
                          'weight': weight,
                          'gender': selectedGender,
                          'goal': selectedGoal,

                          'caloriesGoal': caloriesGoal,
                          'caloriesConsumed': 0,

                          'waterConsumed': 0,
                          'waterGoal': 8,

                          'weightHistory': FieldValue.arrayUnion([weight]),
                        },
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
