// import 'package:ecommerce_app/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
//
//
// // 1. Create a StatefulWidget
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// // 2. This is the State class
// class _SignUpScreenState extends State<SignUpScreen> {
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> _signUp() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // 3. This is the same: create the user
//       final UserCredential userCredential =
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//
//       // 4. --- THIS IS THE NEW PART ---
//       // After creating the user, save their info to Firestore
//       if (userCredential.user != null) {
//         // 5. Create a document in a 'users' collection
//         //    We use the user's unique UID as the document ID
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'email': _emailController.text.trim(),
//           'role': 'user', // 6. Set the default role to 'user'
//           'createdAt': FieldValue.serverTimestamp(), // For our records
//         });
//       }
//       // 7. The AuthWrapper will handle navigation automatically
//       // ...
//
//
//
//
//
//
//     } on FirebaseAuthException catch (e) {
//       String message = 'An error occurred';
//       if (e.code == 'weak-password') {
//         message = 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'An account already exists for that email.';
//       }
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } catch (e) {
//       print(e);
//     }
//
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//
//
//   bool _isLoading = false;
//
//
//   // 3. Create a GlobalKey for the Form
//   final _formKey = GlobalKey<FormState>();
//
//   // 4. Create TextEditingControllers
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   // 5. Clean up controllers when the widget is removed
//   @override
//   Widget build(BuildContext context) {
//     // 1. A Scaffold provides the basic screen structure
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'), // CHANGE 1
//       ),
//       // 2. SingleChildScrollView prevents the keyboard from
//       //    causing a "pixel overflow" error
//       body: SingleChildScrollView(
//         child: Padding(
//           // 3. Add padding around the form
//           padding: const EdgeInsets.all(16.0),
//           // 4. The Form widget acts as a container for our fields
//           child: Form(
//             key: _formKey, // 5. Assign our key to the Form
//             // 6. A Column arranges its children vertically
//             child: Column(
//               // 7. Center the contents of the column
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 // 2. The Email Text Field
//                 TextFormField(
//                   controller: _emailController,
//                   // 3. Link the controller
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(), // 4. Nice border
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   // 5. Show '@' on keyboard
//                   // 6. Validator function
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null; // 'null' means the input is valid
//                   },
//                 ),
//
//                 // 7. A spacer
//                 const SizedBox(height: 16),
//
//                 // 8. The Password Text Field
//                 TextFormField(
//                   controller: _passwordController, // 9. Link the controller
//                   obscureText: true, // 10. This hides the password
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   // 11. Validator function
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 // ... (after the Password field)
//
//                 // 1. A spacer
//                 const SizedBox(height: 20),
//
//                 // 2. The Login Button
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size.fromHeight(50),
//                   ),
//                   onPressed: _isLoading ? null : _signUp,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   )
//                       : const Text('Sign Up'),
//                 ),
//
//
//                 // 6. A spacer
//                 const SizedBox(height: 10),
//
//                 // 7. The "Sign Up" toggle button
//                 TextButton(
//                   onPressed: () {
//                     // 3. Navigate BACK to the Login screen
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => const LoginScreen(),
//                       ),
//                     );
//                   },
//                   // CHANGE 4
//                   child: const Text("Already have an account? Login"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ecommerce_app/screens/home_screen.dart'; // ADD THIS IMPORT
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. Create a StatefulWidget
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// 2. This is the State class
class _SignUpScreenState extends State<SignUpScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _emailSent = false;
  User? _newUser;
  // === NEW: Variable for password visibility ===
  bool _passwordVisible = false;

  // 3. Create a GlobalKey for the Form
  final _formKey = GlobalKey<FormState>();

  // 4. Create TextEditingControllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _sendEmailVerification() async {
    if (_newUser != null) {
      try {
        await _newUser!.sendEmailVerification();
        setState(() {
          _emailSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent to ${_emailController.text}'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send verification email: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _checkEmailVerification() async {
    if (_newUser != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Reload user to get latest verification status
        await _newUser!.reload();
        final updatedUser = _auth.currentUser;

        if (updatedUser != null && updatedUser.emailVerified) {
          await _firestore.collection('users').doc(updatedUser.uid).update({
            'emailVerified': true,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email verified successfully! Welcome to Hakuna Tech'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email not verified yet. Please check your inbox and spam folder.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking verification status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _emailSent = false;
    });

    try {
      // 3. This is the same: create the user
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 4. --- THIS IS THE NEW PART ---
      // After creating the user, save their info to Firestore
      if (userCredential.user != null) {
        _newUser = userCredential.user;

        // 5. Create a document in a 'users' collection
        //    We use the user's unique UID as the document ID
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'role': 'user', // 6. Set the default role to 'user'
          'emailVerified': false, // NEW: Track verification status
          'createdAt': FieldValue.serverTimestamp(), // For our records
        });

        await _sendEmailVerification();
      }

    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. A Scaffold provides the basic screen structure
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'), // CHANGE 1
      ),
      // 2. SingleChildScrollView prevents the keyboard from
      //    causing a "pixel overflow" error
      body: SingleChildScrollView(
        child: Padding(
          // 3. Add padding around the form
          padding: const EdgeInsets.all(16.0),
          // 4. The Form widget acts as a container for our fields
          child: Form(
            key: _formKey, // 5. Assign our key to the Form
            // 6. A Column arranges its children vertically
            child: Column(
              // 7. Center the contents of the column
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                if (_emailSent) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.email, size: 48, color: Colors.blue),
                        SizedBox(height: 12),
                        Text(
                          'Verification Email Sent!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please check your email (${_emailController.text}) and click the verification link to activate your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, size: 16, color: Colors.orange[800]),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'If you don\'t see the email, check your spam folder',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: _sendEmailVerification,
                              child: Text('Resend Email'),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _checkEmailVerification,
                              child: _isLoading
                                  ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : Text('I\'ve Verified'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],

                // 2. The Email Text Field
                TextFormField(
                  controller: _emailController,
                  // 3. Link the controller
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(), // 4. Nice border
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // 5. Show '@' on keyboard
                  // 6. Validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null; // 'null' means the input is valid
                  },
                ),

                // 7. A spacer
                const SizedBox(height: 16),

                // 8. The Password Text Field
                TextFormField(
                  controller: _passwordController, // 9. Link the controller
                  obscureText: !_passwordVisible, // 10. This hides/shows the password
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock), // Lock icon
                    suffixIcon: IconButton( // NEW: Eye icon for visibility toggle
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // NEW: Toggle password visibility
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  // 11. Validator function
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                Container(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Password must be at least 6 characters long',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),

                // 1. A spacer
                const SizedBox(height: 20),

                // 2. The Sign Up Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: _emailSent ? Colors.grey : null,
                  ),
                  onPressed: _isLoading || _emailSent ? null : _signUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(_emailSent ? 'Account Created' : 'Sign Up'),
                ),

                // 6. A spacer
                const SizedBox(height: 10),

                // 7. The "Login" toggle button
                TextButton(
                  onPressed: () {
                    // 3. Navigate BACK to the Login screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  // CHANGE 4
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

