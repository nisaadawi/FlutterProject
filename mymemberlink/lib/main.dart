import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:mymemberlink/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  EmailOTP.config(
    appName: 'MyMemberLink',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v2,
    otpLength: 4,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: 'My Member Link',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor:
              const Color.fromARGB(228, 19, 46, 126), 
          brightness: Brightness.light,
        ).copyWith(
          primary: const  Color.fromARGB(228, 19, 46, 126),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF4D73FF), // A lighter shade of primary for containers
          secondary: Colors.blue[800]!, // Use a complementary blue as secondary
          onSecondary: Colors.white,
          background: Colors.white,
          onBackground: Colors.black87,
          surface: Colors.blue[50]!,
          onSurface: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(228, 19, 46, 126),
          brightness: Brightness.dark,
        ).copyWith(
          primary:
              const Color(0xFF4D73FF), // Lighter primary color for dark mode
          onPrimary: Color.fromARGB(228, 19, 46, 126),
          primaryContainer:
              const Color.fromARGB(228, 19, 46, 126), // Darker primary container color
          secondary: Colors.blue[200]!,
          onSecondary: Colors.black87,
          background: Colors.black87,
          onBackground: Colors.white,
          surface: Colors.blueGrey[800]!,
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.black87,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}


