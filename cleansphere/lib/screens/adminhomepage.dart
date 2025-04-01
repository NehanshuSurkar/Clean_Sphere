import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Custom app bar height
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back,',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage everything from here.',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),
              _buildCard(
                title: 'Review Complaints',
                subtitle: 'View and manage user complaints.',
                icon: Icons.report_problem,
                onTap: () {
                  Navigator.pushNamed(context, '/complaints');
                },
              ),
              const SizedBox(height: 10),
              _buildCard(
                title: 'Truck Monitoring',
                subtitle: 'Track garbage trucks in real-time.',
                icon: Icons.local_shipping,
                onTap: () {
                  Navigator.pushNamed(context, '/tracking');
                },
              ),
              const SizedBox(height: 10),
              _buildCard(
                title: 'User Management',
                subtitle: 'Manage users and their access levels.',
                icon: Icons.group,
                onTap: () {
                  Navigator.pushNamed(context, '/user_management');
                },
              ),
              const SizedBox(height: 10),
              _buildCard(
                title: 'Reports & Analytics',
                subtitle: 'Generate and view reports.',
                icon: Icons.analytics,
                onTap: () {
                  Navigator.pushNamed(context, '/reports');
                },
              ),
            ],
          ),
        ),
      ),

      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: GridView.count(
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 16,
      //     mainAxisSpacing: 16,
      //     children: [
      //       // Review Complaints
      //       _buildAdminCard(
      //         icon: Icons.report_problem,
      //         title: 'Review Complaints',
      //         color: Colors.orange,
      //         onTap: () {
      //           // Navigate to complaints screen
      //           Navigator.pushNamed(context, '/complaints');
      //         },
      //       ),

      //       // Garbage Truck Monitoring
      //       _buildAdminCard(
      //         icon: Icons.local_shipping,
      //         title: 'Truck Monitoring',
      //         color: Colors.blue,
      //         onTap: () {
      //           Navigator.pushNamed(context, '/truck_monitoring');
      //         },
      //       ),

      //       // User Management
      //       _buildAdminCard(
      //         icon: Icons.group,
      //         title: 'User Management',
      //         color: Colors.green,
      //         onTap: () {
      //           Navigator.pushNamed(context, '/user_management');
      //         },
      //       ),

      //       // Reports
      //       _buildAdminCard(
      //         icon: Icons.analytics,
      //         title: 'Reports & Analytics',
      //         color: Colors.purple,
      //         onTap: () {
      //           Navigator.pushNamed(context, '/reports');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.green),
      //         child: Text(
      //           'Admin Menu',
      //           style: TextStyle(color: Colors.white, fontSize: 24),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.settings),
      //         title: const Text('Settings'),
      //         onTap: () {
      //           Navigator.pushNamed(context, '/settings');
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.logout),
      //         title: const Text('Logout'),
      //         onTap: () {
      //           // Handle logout
      //           Navigator.pushReplacementNamed(context, '/login');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'User data not found',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final String name = userData['name'] ?? 'Unknown User';
            final String email = userData['email'] ?? 'Unknown Email';
            final String role = userData['userType'] ?? 'No role';

            return SingleChildScrollView(
              // padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  // User Profile Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 60, bottom: 30),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,

                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundColor: Colors.black, // Border color
                        //   child: CircleAvatar(
                        //     radius: 37, // Slightly smaller for inner content
                        //     backgroundColor: Colors.white, // Inner circle color
                        //     child: const Icon(
                        //       Icons.person,
                        //       size: 50,
                        //       color: Colors.green, // Icon color
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          role,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // const Divider(color: Colors.black),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.black),
                    title: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/admin_home');
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.black),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //   Widget _buildAdminCard({
  //     required IconData icon,
  //     required String title,
  //     required Color color,
  //     required VoidCallback onTap,
  //   }) {
  //     return GestureDetector(
  //       onTap: onTap,
  //       child: Card(
  //         elevation: 5,
  //         color: color,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon, size: 50, color: Colors.white),
  //             const SizedBox(height: 10),
  //             Text(
  //               title,
  //               style: const TextStyle(fontSize: 18, color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.green,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}
