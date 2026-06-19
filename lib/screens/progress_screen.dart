import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitapp/screens/home_screen.dart';
import 'package:fitapp/screens/workout_screen.dart';
import 'package:fitapp/screens/nutrition_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int currentIndex = 3;
  String selectedPeriod = 'Month';
  final List<String> periods = ['Week', 'Month', '3 Months', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WorkoutScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NutritionScreen()),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Progress",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selector
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: periods.map((period) {
                      final isSelected = selectedPeriod == period;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPeriod = period;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6233D7) : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            period,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),

                // Weight Section
                const Text(
                  "Weight (kg)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "78",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        "↓ -2 kg",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Line Chart
                SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withAlpha(50),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(color: Colors.grey, fontSize: 11);
                              Widget text;
                              switch (value.toInt()) {
                                case 0: text = const Text('10 Jun', style: style); break;
                                case 1: text = const Text('17 Jun', style: style); break;
                                case 2: text = const Text('24 Jun', style: style); break;
                                case 3: text = const Text('1 Jul', style: style); break;
                                default: text = const Text('', style: style); break;
                              }
                              return SideTitleWidget(meta: meta, child: text);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              if (value < 74 || value > 82) return const SizedBox.shrink();
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                                textAlign: TextAlign.right,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 3,
                      minY: 74,
                      maxY: 82,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 82),
                            FlSpot(1, 80),
                            FlSpot(2, 79),
                            FlSpot(3, 78),
                          ],
                          isCurved: true,
                          color: const Color(0xFF6233D7),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Calories Section
                const Text(
                  "Calories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Avg. 1800 kcal",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Bar Chart
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 2000,
                      minY: 0,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 500,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withAlpha(50),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(color: Colors.grey, fontSize: 11);
                              Widget text;
                              switch (value.toInt()) {
                                case 0: text = const Text('10 Jun', style: style); break;
                                case 1: text = const Text('17 Jun', style: style); break;
                                case 2: text = const Text('24 Jun', style: style); break;
                                case 3: text = const Text('1 Jul', style: style); break;
                                default: text = const Text('', style: style); break;
                              }
                              return SideTitleWidget(meta: meta, child: text);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 500,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox.shrink();
                              String text = '';
                              if (value == 1000) { text = '1k'; }
                              else if (value == 1500) { text = '1.5k'; }
                              else if (value == 2000) { text = '2k'; }
                              return Text(
                                text,
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                                textAlign: TextAlign.right,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        _buildBarGroup(0, 1500, 1800, 1600),
                        _buildBarGroup(1, 1700, 1900, 1800),
                        _buildBarGroup(2, 1600, 1750, 1900),
                        _buildBarGroup(3, 1800, 1800, 1800),
                      ],
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

  BarChartGroupData _buildBarGroup(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF6233D7),
          width: 6,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y2,
          color: const Color(0xFF8A5FF1),
          width: 6,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y3,
          color: const Color(0xFFB59AFA),
          width: 6,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}