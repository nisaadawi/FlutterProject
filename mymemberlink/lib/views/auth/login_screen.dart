import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlink/models/admin.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/auth/forgot_password_screen.dart';
import 'package:mymemberlink/views/bulletin/bulletin_screen.dart';
import 'package:mymemberlink/views/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final Admin admin;
  const LoginScreen({super.key, required this.admin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<Admin> adminList = [];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "MyMemberLink",
            style: GoogleFonts.lexendTera(
              color: const Color.fromARGB(252, 255, 255, 255),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              shadows: [
                const Shadow(
                  offset: Offset(2.0, 2.0), // Position of the shadow
                  blurRadius: 4.0, // Softness of the shadow
                  color: Color.fromARGB(
                      128, 63, 3, 85), // Shadow color with transparency
                ),
              ],
            ),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.0), // Rounded edges at the bottom
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/bg/memberlink.png'), // Your image here
                fit: BoxFit.cover, // Resize image to cover the area
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0), // Same rounded edges as above
              ),
            ),
          ),
          toolbarHeight: 145,
          automaticallyImplyLeading: false),
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(219, 255, 255, 255),
              Color.fromARGB(219, 214, 178, 241),
              Color.fromARGB(255, 80, 17, 148)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              color: Colors.white, // Changed card color to white
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/team.png',
                      height: 120, // adjust height as needed
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 127, 0, 200),
                        shadows: [
                          const Shadow(
                            offset: Offset(2.0, 2.0), // Position of the shadow
                            blurRadius: 4.0, // Softness of the shadow
                            color: Color.fromARGB(255, 214, 149,
                                237), // Shadow color with transparency
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.white),
                        hintText: "Email",
                        filled: true,
                        fillColor: Color.fromARGB(219, 183, 120,
                            255), // Purple background for TextField
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(
                            color: Colors.white), // White text in hint
                      ),
                      validator: (val) => val!.isEmpty ||
                              !val.contains("@") ||
                              !val.contains(".")
                          ? "Enter a valid email"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 92, 92, 92),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        hintText: "Password",
                        filled: true,
                        fillColor: Color.fromARGB(219, 183, 120,
                            255), // Purple background for TextField
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(
                            color: Colors.white), // White text in hint
                      ),
                      validator: (val) => validatePassword(val.toString()),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Color.fromARGB(219, 183, 120, 255),
                          value: rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              String email = emailController.text;
                              String pass = passwordController.text;
                              if (value!) {
                                if (email.isNotEmpty && pass.isNotEmpty) {
                                  storeSharedPrefs(value, email, pass);
                                } else {
                                  rememberMe = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Please enter your credentials"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                              } else {
                                email = "";
                                pass = "";
                                storeSharedPrefs(value, email, pass);
                              }
                              rememberMe = value;
                            });
                          },
                        ),
                        const Text("Remember me",
                            style: TextStyle(
                                color: Color.fromARGB(
                                    255, 80, 17, 148))), // White text
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            219, 183, 120, 255), // Purple color for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) =>
                                  ForgotPasswordScreen(admin: widget.admin)),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color.fromARGB(
                                255, 80, 17, 148), // White color for the text
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const RegisterScreen()),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            color: Color.fromARGB(
                                255, 80, 17, 148), // White color for the text
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regExp.hasMatch(value)) {
        return 'Password must be at least 6 characters, with uppercase, lowercase, number, and special character.';
      } else {
        return null;
      }
    }
  }

  void onLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    print("Attempting login with email: $email"); // Debug print

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }

    http.post(
      Uri.parse("${MyConfig.servername}/memberlink/api/user_login.php"),
      body: {"email": email, "password": password},
    ).then((response) {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          try {
            final adminData = jsonResponse['data']['admin'][0];
            Admin admin = Admin.fromJson(adminData);
            
            print("Login successful for: ${admin.adminemail}"); // Debug print
            
            if (admin.adminemail != email) {
              print("Warning: Returned email doesn't match input email"); // Safety check
            }

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Login Success"),
              backgroundColor: Colors.green,
            ));

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (content) => BulletinScreen(admin: admin),
              ),
            );
          } catch (e) {
            print("Error parsing admin data: $e");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error processing login data"),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          print("Login failed for email: $email"); // Debug print
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid email or password"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Server error occurred"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      print("Login error: $error");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to connect to server"),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      emailController.text = "";
      passwordController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString("email") ?? "";
    passwordController.text = prefs.getString("password") ?? "";
    rememberMe = prefs.getBool("rememberme") ?? false;
    setState(() {});
  }
}
