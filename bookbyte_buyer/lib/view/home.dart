import 'package:flutter/material.dart';
import '../model/user.dart';

class HomePage extends StatefulWidget {
  final User userdata;
  const HomePage({super.key, required this.userdata});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Text("BookByte"),),
      body: Center(
        child: Column(
          children: [
            Text(widget.userdata.username.toString())
          ],
        ),
      ),
    );
  }
}