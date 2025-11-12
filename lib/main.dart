// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:ecommerce_app/screens/login_screen.dart';
// import 'package:ecommerce_app/screens/signup_screen.dart';
// import 'package:ecommerce_app/screens/auth_wrapper.dart';
// import 'package:ecommerce_app/providers/cart_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart'; // 1. ADD THIS IMPORT
// import 'package:ecommerce_app/providers/theme_provider.dart'; // ADD THIS
//
//
// const Color kPrimary = Color(0xFF4169E1);
// const Color kPrimaryLight = Color(0xFF6A8DFF);
// const Color kPrimaryDark = Color(0xFF274B9F);
// const Color kSecondary = Color(0xFF00BFFF);
// const Color kBackground = Color(0xFFF5F7FA);
// const Color kSurface = Color(0xFFFFFFFF);
// const Color kTextPrimary = Color(0xFF1E1E1E);
// const Color kTextSecondary = Color(0xFF5A5A5A);
//
// // DARK MODE COLORS
// const Color kDarkBackground = Color(0xFF121212);
// const Color kDarkSurface = Color(0xFF1E1E1E);
// const Color kDarkTextPrimary = Color(0xFFFFFFFF);
// const Color kDarkTextSecondary = Color(0xFFB0B0B0);
//
//
//
// void main() async {
//   // 1. Preserve splash screen (Unchanged)
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//
//   // 2. Initialize Firebase (Unchanged)
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // 3. Set web persistence (Unchanged)
//   await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
//
//   // 4. --- THIS IS THE FIX ---
//   // We manually create the CartProvider instance *before* runApp
//   final cartProvider = CartProvider();
//
//   // 5. We call our new initialize method *before* runApp
//   cartProvider.initializeAuthListener();
//
//   // 6. This is the old, buggy code we are replacing:
//   /*
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => CartProvider(), // <-- This was the problem
//       child: const MyApp(),
//     ),
//   );
//   */
//
//   // 7. This is the NEW code for runApp
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(value: cartProvider),
//         ChangeNotifierProvider(create: (context) => ThemeProvider()), // ADD THIS
//       ],
//       child: const MyApp(),
//     ),
//   );
//
//   // 10. Remove splash screen (Unchanged)
//   FlutterNativeSplash.remove();
// }
//
// // MyApp class should be declared OUTSIDE main()
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'eCommerce App',
//
//       // 1. --- THIS IS THE NEW, COMPLETE THEME ---
//       theme: ThemeData(
//         // 2. Set the main color scheme
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: kPrimary,
//             brightness: Brightness.light,
//             primary: kPrimary,
//             onPrimary: Colors.white,
//             secondary: kSecondary,
//             background: kBackground,
//           ),
//         useMaterial3: true,
//
//         // 3. Set the background color for all screens
//         scaffoldBackgroundColor: kBackground,
//
//         // 4. --- (FIX) APPLY THE GOOGLE FONT ---
//         // This applies "Lato" to all text in the app
//         textTheme: GoogleFonts.latoTextTheme(
//           Theme.of(context).textTheme,
//         ),
//
//         // 5. --- (FIX) GLOBAL BUTTON STYLE ---
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: kPrimary,
//             foregroundColor: Colors.white, // Text color
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12), // Rounded corners
//             ),
//           ),
//         ),
//
//         // 6. --- (FIX) GLOBAL TEXT FIELD STYLE ---
//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey[400]!),
//           ),
//           labelStyle: TextStyle(
//             color: kTextSecondary,
//             fontSize: 16,
//           ),
//           hintStyle: TextStyle(
//             color: kTextSecondary.withOpacity(0.6), //
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: kPrimary, width: 2.0),
//           ),
//         ),
//
//         // 7. --- (FIX) GLOBAL CARD STYLE ---
//         // cardTheme: CardTheme(
//         //   elevation: 1, // A softer shadow
//         //   color: kSurface,
//         //   shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.circular(12),
//         //   ),
//         //   // 8. This ensures the images inside the card are rounded
//         //   clipBehavior: Clip.antiAlias,
//         // ),
//
//         // 9. --- (NEW) GLOBAL APPBAR STYLE ---
//         appBarTheme: const AppBarTheme(
//           backgroundColor: kSurface,
//           foregroundColor: kTextPrimary,
//           elevation: 0, // No shadow, modern look
//           centerTitle: true,
//         ),
//       ),
//       // --- END OF NEW THEME ---
//
//       home: const AuthWrapper(),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/signup_screen.dart';
import 'package:ecommerce_app/screens/auth_wrapper.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/theme_provider.dart'; // ADD THIS
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


const Color kPrimary = Color(0xFF4169E1);
const Color kPrimaryLight = Color(0xFF6A8DFF);
const Color kPrimaryDark = Color(0xFF274B9F);
const Color kSecondary = Color(0xFF00BFFF);
const Color kBackground = Color(0xFFF5F7FA);
const Color kSurface = Color(0xFFFFFFFF);
const Color kTextPrimary = Color(0xFF1E1E1E);
const Color kTextSecondary = Color(0xFF5A5A5A);

// DARK MODE COLORS
const Color kDarkBackground = Color(0xFF121212);
const Color kDarkSurface = Color(0xFF1E1E1E);
const Color kDarkTextPrimary = Color(0xFFFFFFFF);
const Color kDarkTextSecondary = Color(0xFFB0B0B0);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  final cartProvider = CartProvider();
  cartProvider.initializeAuthListener();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartProvider),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( // WRAP WITH CONSUMER
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'eCommerce App',
          theme: _buildLightTheme(), // USE METHOD
          darkTheme: _buildDarkTheme(), // USE METHOD
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // ADD THIS LINE
          home: const AuthWrapper(),
        );
      },
    );
  }

  // ADD LIGHT THEME METHOD
  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimary,
        brightness: Brightness.light,
        primary: kPrimary,
        onPrimary: Colors.white,
        secondary: kSecondary,
        background: kBackground,
        surface: kSurface,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: kBackground,
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData.light().textTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        labelStyle: TextStyle(
          color: kTextSecondary,
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: kTextSecondary.withOpacity(0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimary, width: 2.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kSurface,
        foregroundColor: kTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  // ADD DARK THEME METHOD
  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimary,
        brightness: Brightness.dark,
        primary: kPrimary,
        onPrimary: Colors.white,
        secondary: kSecondary,
        background: kDarkBackground,
        surface: kDarkSurface,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: kDarkBackground,
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData.dark().textTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        labelStyle: TextStyle(
          color: kDarkTextSecondary,
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: kDarkTextSecondary.withOpacity(0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimary, width: 2.0),
        ),
        fillColor: kDarkSurface,
        filled: true,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kDarkSurface,
        foregroundColor: kDarkTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
