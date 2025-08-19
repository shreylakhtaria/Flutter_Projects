import 'package:flutter/material.dart'; 
import 'third.dart';
 
 class SecondScreen extends StatefulWidget {
    const SecondScreen({super.key});

    @override
    State<SecondScreen> createState() => _SecondScreenState();
  }

  class _SecondScreenState extends State<SecondScreen> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Second Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(context , 
              MaterialPageRoute(builder: (context) => ThirdScreen()),
              );
            }, 
            child: Tab(text: "ThirdScreen"),
            ),
          ],
        ),
      ),
    );
    }
  }