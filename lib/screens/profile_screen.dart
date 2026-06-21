import 'package:fitapp/services/auth_service.dart';
import 'package:fitapp/services/firestore_sercive.dart';
import 'package:flutter/material.dart';
import 'package:fitapp/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = AuthService().currentUser;
  int currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    if (user == null)
      return const Scaffold(body: Center(child: Text("Not logged in")));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6233D7);

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
        final age = userData?['age']?.toString() ?? '--';
        final height = userData?['height']?.toString() ?? '--';
        final weight = userData?['weight']?.toString() ?? '--';
        final goal = userData?['goal']?.toString() ?? '--';

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
            centerTitle: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark
                          ? Colors.white10
                          : Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        Icons.group_outlined,
                        'Age',
                        '$age',
                        isDark,
                      ),
                      const Divider(height: 30),
                      _buildStatRow(
                        Icons.height,
                        'Height',
                        '$height cm',
                        isDark,
                      ),
                      const Divider(height: 30),
                      _buildStatRow(
                        Icons.monitor_weight_outlined,
                        'Weight',
                        '$weight kg',
                        isDark,
                      ),
                      const Divider(height: 30),
                      _buildStatRow(Icons.track_changes, 'Goal', goal, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Menu Options
                _buildMenuItem(
                  Icons.edit_outlined,
                  'Edit Profile',
                  isDark,
                  () {},
                ),
                _buildMenuItem(
                  Icons.lock_outline,
                  'Change Password',
                  isDark,
                  () {},
                ),
                _buildMenuItem(
                  Icons.notifications_none,
                  'Notifications',
                  isDark,
                  () {},
                ),

                // Dark Mode Toggle
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        color: isDark ? primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      // Switch(
                      //   value: isDark,
                      //   activeColor: primaryColor,
                      //   onChanged: (value) {
                      //     ThemeService().toggleTheme();
                      //   },
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      await AuthService().signOut();
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(width: 15),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}