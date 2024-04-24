import 'package:flutter/material.dart';
import 'package:password_manager/widgets/home_screen_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
      ),
      drawer: const HomeScreenDrawer(),
      body: const Center(
        child: Text('No passwords stored yet!'),
      ),
    );
  }
}