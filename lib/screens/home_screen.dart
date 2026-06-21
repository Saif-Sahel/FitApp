import 'package:fitapp/screens/profile_screen.dart';
import 'package:fitapp/services/auth_service.dart';
import 'package:fitapp/services/firestore_sercive.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:fitapp/screens/workout_screen.dart';
import 'package:fitapp/screens/nutrition_screen.dart';
import 'package:fitapp/screens/progress_screen.dart';
import 'package:fitapp/screens/bmi_calculator_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final user = AuthService().currentUser;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6233D7);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirestoreService().getUserStream(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userData = snapshot.data?.data();
        final username = userData?['username'] ?? 'User';
        final consumed = (userData?['caloriesConsumed'] ?? 0).toDouble();
        final goal = (userData?['caloriesGoal'] ?? 2200).toDouble();
        final percent = (consumed / goal).clamp(0.0, 1.0);
        final waterConsumed = (userData?['waterConsumed'] ?? 0).toDouble();
        final waterGoal = (userData?['waterGoal'] ?? 8).toDouble();
        final waterPercent = (waterConsumed / waterGoal).clamp(0.0, 1.0);
        final weights = (userData?['weightHistory'] ?? []) as List;
        final weightHistory = weights.isNotEmpty
            ? weights.map((e) => (e as num).toDouble()).toList()
            : [80.0, 78.5, 79.0, 78.0]; // Fallback design data

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF8F8F8),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutScreen(),
                  ),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NutritionScreen(),
                  ),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgressScreen(),
                  ),
                );
              } else if (index == 4) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              } else {
                setState(() {
                  currentIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: "Workouts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: "Nutrition",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: "Progress",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Greeting Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Evening,',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  '👋',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  size: 28,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: isDark
                                  ? Colors.white10
                                  : Colors.grey.shade200,
                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: isDark ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Calories Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Calories',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${consumed.toInt()}",
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " / ${goal.toInt()} kcal",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 6,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: percent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: 45,
                            lineWidth: 10,
                            percent: percent,
                            progressColor: Colors.white,
                            backgroundColor: Colors.white24,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              '${(percent * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Water & Workout Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSmallCard(
                            'Water',
                            '${waterConsumed.toInt()} / ${waterGoal.toInt()}\nglasses',
                            Icons.water_drop,
                            Colors.lightBlue,
                            waterPercent,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(child: _buildWorkoutCard(isDark)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Weight Progress Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Weight Progress',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.close, size: 20, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${weightHistory.last} kg',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Current Weight',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 120,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        const days = [
                                          '10 Jun',
                                          '17 Jun',
                                          '24 Jun',
                                          '1 Jul',
                                        ];
                                        if (value.toInt() < days.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              days[value.toInt()],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: weightHistory
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) =>
                                              FlSpot(e.key.toDouble(), e.value),
                                        )
                                        .toList(),
                                    isCurved: true,
                                    color: primaryColor,
                                    barWidth: 4,
                                    dotData: const FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: primaryColor.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(
                          Icons.directions_run,
                          'Steps',
                          primaryColor,
                          isDark,
                        ),
                        _buildActionButton(
                          Icons.restaurant,
                          'Add Meal',
                          Colors.green,
                          isDark,
                        ),
                        _buildActionButton(
                          Icons.monitor_weight_outlined,
                          'Add Weight',
                          Colors.orange,
                          isDark,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BmiCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    double progress,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(icon, color: iconColor, size: 28),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
            color: iconColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Workout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Icon(
                Icons.fitness_center,
                color: Color(0xFF6233D7),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Push Day',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Chest & Triceps',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
