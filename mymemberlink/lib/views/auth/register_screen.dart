
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/myconfig.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController= TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      appBar: AppBar(title: const Text("Registration Form",
      style: TextStyle(color: Colors.white),
      ), 
      backgroundColor:  Colors.blue[800],
      iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Card(
                     color: const Color.fromARGB(230, 154, 186, 219),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_2_outlined, color: Colors.blue[800]),
                              hintText: "Full Name",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) => val!.isEmpty || val.length < 3
                                ? "Name must be longer than 3 characters"
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.blue[800]),
                              hintText: "Email",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                                ? "Enter a valid email."
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android_outlined, color: Colors.blue[800]),
                              hintText: "Phone Number",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) => val!.isEmpty || val.length < 9
                                ? "Phone number must be longer than 9 characters"
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: dateOfBirthController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.blue[800]),
                              hintText: "Date of Birth",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                dateOfBirthController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                              }
                            },
                            validator: (val) => val == null || val.isEmpty
                                ? "Please select your date of birth"
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.home_outlined, color: Colors.blue[800]),
                              hintText: "Address",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) => val!.isEmpty || val.length < 3
                                ? "Address must be correctly entered"
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[800]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) => validatePassword(val.toString()),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[800]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: const Color.fromARGB(255, 92, 92, 92),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              hintText: "Confirm Password",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) => validatePassword(val.toString()),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: onRegisterDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 5,
                              ),
                              child: const Text(
                                "Register",
                                style: TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
      Future<void> checkEmailExistence(String email) async {
      final response = await http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/email_checker.php"), // Update with your PHP script path
        body: {'email': email},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'exist') {
          // Email exists, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email already exists, please use a different email."),
              backgroundColor: Colors.red,
            ),
          );
        } else if (data['status'] == 'not exist') {
          // Email does not exist, proceed with registration
          userRegistration();
        } else {
          // Unexpected response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("An unexpected error occurred."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server error. Please try again later."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  void onRegisterDialog() {
  String pass = passwordController.text;
  String pass2 = confirmPasswordController.text;

  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (pass != pass2) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Passwords do not match!"),
      backgroundColor: Colors.red,
    ));
    return;
  }

  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text("Register new account?"),
        content: const Text("Are you sure?"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              // Check if email exists before proceeding
              checkEmailExistence(emailController.text);

              Navigator.of(context).pop();
              
            },
            child: const Text("Yes"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
        ],
      );
    },
  );
}


  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regExp.hasMatch(value)) {
        return 'Please enter valid password. Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character (e.g., @, #, etc.).';
      } else {
        return null;
      }
    }

  }
  

  void userRegistration() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String dob = dateOfBirthController.text;
    String address = addressController.text;
    String pass = passwordController.text;

    http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/user_register.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "dob": dob,
          "address": address,
          "password": pass,
          }).then((response) {
      // print(response.statusCode);
      // print(response.body);
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Color.fromARGB(255, 44, 135, 63),
          ));
          Navigator.pushReplacementNamed(context, '/login');
          } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
          
        }

      }
    });
  }
 

}