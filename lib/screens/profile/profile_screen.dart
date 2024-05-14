import 'package:flutter/material.dart';
import 'components/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileBody(),
    );
  }
}
