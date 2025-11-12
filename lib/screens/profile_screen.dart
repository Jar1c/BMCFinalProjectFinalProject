// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ecommerce_app/providers/theme_provider.dart'; // ADD THIS IMPORT
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   // 1. Get Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final User? _currentUser = FirebaseAuth.instance.currentUser;
//
//   // 2. Form key and controllers for changing password
//   final _formKey = GlobalKey<FormState>();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//
//   // 3. State variable for loading
//   bool _isLoading = false;
//
//   // ... (inside _ProfileScreenState)
//
//   // 1. This is the "Change Password" logic
//   Future<void> _changePassword() async {
//     // 2. Validate the form
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // 3. This is the Firebase command to update the password
//       await _currentUser!.updatePassword(_newPasswordController.text);
//
//       // 4. Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password changed successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       // Clear the fields
//       _formKey.currentState!.reset();
//       _newPasswordController.clear();
//       _confirmPasswordController.clear();
//
//     } on FirebaseAuthException catch (e) {
//       // 5. Handle errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to change password: ${e.message}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       print("Error changing password: ${e.code}");
//       // e.code 'requires-recent-login' is a common error
//       // This means the user's token is old.
//       // You can prompt them to log out and log back in.
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   // 6. This is the "Logout" logic
//   Future<void> _signOut() async {
//     // 2. Get the Navigator *before* the async call
//     final navigator = Navigator.of(context);
//
//     // 3. This is your existing code
//     await _auth.signOut();
//
//     // 4. --- THIS IS THE FIX ---
//     //    After signing out, pop all screens until we are
//     //    back at the very first screen (which is our AuthWrapper).
//     //    The AuthWrapper will then correctly show the LoginScreen.
//     navigator.popUntil((route) => route.isFirst);
//   }
//
//   // 4. Clean up controllers
//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context); // ADD THIS
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // 1. User Info Section
//             Text(
//               'Logged in as:',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Text(
//               _currentUser?.email ?? 'Not logged in',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24),
//
//             //
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Theme.of(context).dividerColor,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         'Dark Mode',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Switch(
//                     value: themeProvider.isDarkMode,
//                     onChanged: (value) {
//                       themeProvider.toggleTheme();
//                     },
//                     activeColor: Color(0xFF4169E1),
//                   ),
//                 ],
//               ),
//             ),
//             //
//
//             const SizedBox(height: 24),
//             const Divider(),
//             const SizedBox(height: 16),
//
//             // 2. Change Password Form
//             Text(
//               'Change Password',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // 3. New Password Field
//                   TextFormField(
//                     controller: _newPasswordController,
//                     obscureText: true,
//                     decoration:
//                     const InputDecoration(labelText: 'New Password'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   // 4. Confirm Password Field
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration:
//                     const InputDecoration(labelText: 'Confirm Password'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       // 5. Check if it matches the other field
//                       if (value != _newPasswordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // 6. "Change Password" Button
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Color(0xFF00008B),
//                   foregroundColor: Colors.white
//               ),
//               onPressed: _isLoading ? null : _changePassword,
//               child: _isLoading
//                   ? const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               )
//                   : const Text('Change Password'),
//             ),
//
//             const SizedBox(height: 40),
//             const Divider(),
//             const SizedBox(height: 20),
//
//             // 7. The "Logout" Button
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red[700], // Make it red
//                 foregroundColor: Colors.white,    // text color
//               ),
//               onPressed: _signOut,
//               child: const Text('Log Out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ADD THIS IMPORT
import 'package:ecommerce_app/providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 1. Get Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // ADD THIS
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // 2. Form key and controllers for changing password
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 3. State variable for loading
  bool _isLoading = false;

  // 4. --- NEW: Username controller and saving state ---
  final _usernameController = TextEditingController();
  bool _isSavingUsername = false;

  // 5. --- NEW: Load username when screen starts ---
  @override
  void initState() {
    super.initState();
    _loadUsername(); // ADD THIS
  }

  // 6. --- NEW: Function to load username from Firestore ---
  Future<void> _loadUsername() async {
    if (_currentUser == null) return;

    try {
      final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (doc.exists && doc.data() != null) {
        final username = doc.data()!['name'] ?? '';
        if (mounted) {
          setState(() {
            _usernameController.text = username;
          });
        }
      }
    } catch (e) {
      print("Error loading username: $e");
    }
  }

  // 7. --- NEW: Function to save username to Firestore ---
  Future<void> _saveUsername() async {
    if (_currentUser == null) return;
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSavingUsername = true;
    });

    try {
      // Save to Firestore
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'name': _usernameController.text.trim(),
        'email': _currentUser!.email,
        'role': 'user', // Make sure role is preserved
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // MERGE: Only update specified fields

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save username: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print("Error saving username: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSavingUsername = false;
        });
      }
    }
  }

  // 8. This is the "Change Password" logic
  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _currentUser!.updatePassword(_newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to change password: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
      print("Error changing password: ${e.code}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 9. This is the "Logout" logic
  Future<void> _signOut() async {
    final navigator = Navigator.of(context);
    await _auth.signOut();
    navigator.popUntil((route) => route.isFirst);
  }

  // 10. Clean up controllers
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. User Info Section - CENTERED
            Center(
              child: Column(
                children: [
                  // Profile Icon
                  Icon(
                    Icons.person,
                    size: 80,
                    color: const Color(0xFF4169E1),
                  ),
                  const SizedBox(height: 16),
                  // Username - CENTERED
                  Text(
                    _usernameController.text.isNotEmpty
                        ? _usernameController.text
                        : 'Username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email - CENTERED
                  Text(
                    _currentUser?.email ?? 'Not logged in',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. --- NEW: Username Field with Save Button ---
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Update UI when username changes
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Save Username Button
                _isSavingUsername
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _saveUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4169E1),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 3. Dark Mode Toggle
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: const Color(0xFF4169E1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // 4. Change Password Form
            Text(
              'Change Password',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // New Password Field
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. "Change Password" Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF00008B),
                foregroundColor: Colors.white,
              ),
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text('Change Password'),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            // 6. The "Logout" Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
              onPressed: _signOut,
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}