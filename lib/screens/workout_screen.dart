import 'package:flutter/material.dart';
import 'package:fitapp/screens/home_screen.dart';
import 'package:fitapp/screens/nutrition_screen.dart';
import 'package:fitapp/screens/progress_screen.dart';
import 'package:fitapp/screens/exercise_details_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int currentIndex = 1;
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Abs'];

  final List<Map<String, dynamic>> workouts = [
    {
      'title': 'Chest', 
      'exercises': 8, 
      'image': 'assets/images/chest_workout_1781900465594.png',
      'exerciseName': 'Bench Press',
      'setsAndReps': '4 Sets \u00D7 10 Reps',
      'description': 'Strengthens your chest, shoulders, \nand triceps.',
      'instructions': [
        'Lie on the bench with your feet flat.',
        'Grip the bar slightly wider than \nshoulder width.',
        'Lower the bar to your chest.',
        'Push the bar back up to the \nstarting position.'
      ]
    },
    {
      'title': 'Back', 
      'exercises': 7, 
      'image': 'assets/images/back_workout_1781900476171.png',
      'exerciseName': 'Pull-Ups',
      'setsAndReps': '3 Sets \u00D7 8 Reps',
      'description': 'Builds a wide and thick back, \ntargeting the lats.',
      'instructions': [
        'Grab the pull-up bar with your palms \nfacing away from you.',
        'Hang with your arms fully extended.',
        'Pull yourself up until your chin \npasses the bar.',
        'Lower yourself slowly back down.'
      ]
    },
    {
      'title': 'Legs', 
      'exercises': 9, 
      'image': 'assets/images/legs_workout_1781900488301.png',
      'exerciseName': 'Squats',
      'setsAndReps': '4 Sets \u00D7 12 Reps',
      'description': 'The ultimate lower body exercise \nfor quads and glutes.',
      'instructions': [
        'Stand with feet shoulder-width apart.',
        'Rest the barbell on your upper back.',
        'Bend your knees and lower your hips \nlike sitting in a chair.',
        'Push through your heels to return \nto the starting position.'
      ]
    },
    {
      'title': 'Shoulders', 
      'exercises': 6, 
      'image': 'assets/images/shoulders_workout_1781900498613.png',
      'exerciseName': 'Overhead Press',
      'setsAndReps': '3 Sets \u00D7 10 Reps',
      'description': 'Develops massive shoulder width \nand upper body strength.',
      'instructions': [
        'Stand upright and hold a barbell \nat shoulder height.',
        'Press the bar straight up overhead.',
        'Lock your arms at the top.',
        'Slowly lower the bar back to \nyour shoulders.'
      ]
    },
    {
      'title': 'Arms', 
      'exercises': 7, 
      'image': 'assets/images/arms_workout_1781900508563.png',
      'exerciseName': 'Bicep Curls',
      'setsAndReps': '3 Sets \u00D7 12 Reps',
      'description': 'Isolates the biceps for growth \nand peak development.',
      'instructions': [
        'Hold dumbbells at your sides with \npalms facing forward.',
        'Keep your elbows tucked close \nto your torso.',
        'Curl the weights toward your shoulders.',
        'Lower them back down with control.'
      ]
    },
    {
      'title': 'Abs', 
      'exercises': 6, 
      'image': 'assets/images/abs_workout_1781900517844.png',
      'exerciseName': 'Crunches',
      'setsAndReps': '3 Sets \u00D7 20 Reps',
      'description': 'Targets the core muscles to build \na strong foundation.',
      'instructions': [
        'Lie on your back with knees bent.',
        'Place hands lightly behind your head.',
        'Lift your upper body toward your \nknees, contracting your abs.',
        'Lower yourself back down slowly.'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWorkouts = workouts;
    if (selectedFilter != 'All') {
      filteredWorkouts = workouts.where((w) => w['title'] == selectedFilter).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NutritionScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProgressScreen()),
            );
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6233D7),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Workouts"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Nutrition"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Workouts",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search workouts...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),

            // Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = selectedFilter == filter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6233D7) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            if (!isSelected)
                              BoxShadow(
                                color: Colors.grey.withOpacity(.1),
                                blurRadius: 5,
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Workouts List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                itemCount: filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = filteredWorkouts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailsScreen(workout: workout),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            workout['image'],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${workout['exercises']} Exercises",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}