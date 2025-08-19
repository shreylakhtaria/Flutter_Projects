import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
//home
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorscreenState createState() => _CalculatorscreenState();
}

// calculation logic 
class _CalculatorscreenState extends State<CalculatorScreen> {
  TextEditingController num1 = TextEditingController();
  TextEditingController num2 = TextEditingController();
  String result = '';

  void calculate(String operation) {
    int n1 = int.parse(num1.text);
    int n2 = int.parse(num2.text);
    int answer = 0;

    if (operation == 'Add') {
      answer = n1 + n2;
    } else if (operation == 'Subtract') {
      answer = n1 - n2;
    } else if (operation == 'Multiply') {
      answer = n1 * n2;
    } else if (operation == 'Divide') {
      answer = n1;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(result: answer.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: num1,
            ),
            SizedBox(height: 20),
            TextField(
              controller: num2,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => calculate('Add'),
              child: Text('Add'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => calculate('Subtract'),
              child: Text('Subtract'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => calculate('Multiply'),
              child: Text('Multiply'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => calculate('Divide'),
              child: Text('Divide'),
            ),
          ],
        ),
      ),
    );
  }
}

// I have created new screen in one file only we can also create a new file and then write mew screen code there

class ResultScreen extends StatelessWidget {
  final String result;

  ResultScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Answer: $result',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
