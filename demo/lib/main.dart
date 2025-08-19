import 'package:flutter/material.dart';
import 'second.dart';
import 'third.dart'; 

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    ); 
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  TextEditingController txt1 = new TextEditingController();
  TextEditingController txt2 = new TextEditingController();
  var myans = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/image/Screenshot (14).png',
            ),
            TextField(
              controller: txt1,
              decoration: InputDecoration(labelText: "Enter first number"),
            ),
            TextField(
              controller: txt2,
              decoration: InputDecoration(labelText: "Enter second number"),
            ),
            ElevatedButton(
              onPressed: () {
          setState(() {
            int num1 = int.parse(txt1.text);
            int num2 = int.parse(txt2.text);
            myans = (num1 + num2).toString();
          });
              },
              child: Text("Add"),
            ),
            Text("Result: $myans"),

            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(context , 
              MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            }, 
            child: Tab(text: "SecondScreen"),
            ),
          ],
        ),
      ),
  );
  }
}

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


  class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Third Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}