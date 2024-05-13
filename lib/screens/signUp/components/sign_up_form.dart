import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/controllers/auth_provider.dart';
import 'package:resto/entry_point.dart';
import 'package:resto/models/user.dart';
import 'package:resto/screens/home/home_screen.dart';
import 'package:resto/screens/phoneLogin/phone_login_screen.dart';
import 'package:resto/services/auth_service.dart';
import '../../../constants.dart';

final roleList = ['user', 'restaurant'];

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  var roleController = roleList.first;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name Field
          TextFormField(
            controller: fullNameController,
            validator: requiredValidator,
            onSaved: (value) {},
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: "Full Name"),
          ),

          //User name
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: userNameController,
            validator: requiredValidator,
            onSaved: (value) {},
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: "User name"),
          ),
          const SizedBox(height: defaultPadding),

          // email Field
          TextFormField(
            controller: emailController,
            validator: emailValidator,
            onSaved: (value) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "User email"),
          ),
          const SizedBox(height: defaultPadding),

          // Password Field
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            validator: passwordValidator,
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off, color: bodyTextColor)
                    : const Icon(Icons.visibility, color: bodyTextColor),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Confirm Password Field
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off, color: bodyTextColor)
                    : const Icon(Icons.visibility, color: bodyTextColor),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          // Sign Up Button
          Row(
            children: [
              const Text("I am registered as: "),
              DropdownButton<String>(
                value: roleController,
                onChanged: (String? value) {
                  setState(() {
                    roleController = value!;
                  });
                },
                items: <String>['user', 'restaurant'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              var user = User(
                userID: 0,
                username: userNameController.text,
                password: passwordController.text,
                email: emailController.text,
                role: roleController,
                //missing data
                phoneNumber: "",
                address: "",
                postcode: "",
              );
              var currentUser = await AuthService.register(user);
              if (currentUser != null) {
                var loggedInUser = await AuthService.login(
                    currentUser.email, currentUser.password);
                if (loggedInUser != null) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .setUser(loggedInUser);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EntryPoint(),
                    ),
                    (_) => true,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Fail to login'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Fail to register'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Close',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                );
              }
            },
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
