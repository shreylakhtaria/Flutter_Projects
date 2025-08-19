import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vegetable List',
      home: const VegetableListPage(),
    );
  }
}

class Vegetable {
  final String name;
  final String imagePath;
  const Vegetable({required this.name, required this.imagePath});
}



class VegetableListPage extends StatelessWidget {
  const VegetableListPage({super.key});

   // image list constructure 

  final List<Vegetable> vegetables = const [
    Vegetable(name: 'Tomato', imagePath: 'assets/images/tomato.jpg'),
    Vegetable(name: 'Carrot', imagePath: 'assets/images/carrot.jpg'),
    Vegetable(name: 'Broccoli', imagePath: 'assets/images/bracoli.jpg'),
    Vegetable(name: 'Onion', imagePath: 'assets/images/onion.jpg'),
    Vegetable(name: 'Potato', imagePath: 'assets/images/potato.jpg'),
    Vegetable(name: 'Pepper', imagePath: 'assets/images/Peper.jpg'),
    Vegetable(name: 'Cucumber', imagePath: 'assets/images/cucumber.jpg'),
    Vegetable(name: 'Lettuce', imagePath: 'assets/images/lettuce.jpg'),
    Vegetable(name: 'Corn', imagePath: 'assets/images/corn.jpg'),
    Vegetable(name: 'bringle', imagePath: 'assets/images/eggplant.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegetable List'),
      ),
      body: ListView.builder(
        itemCount: vegetables.length,
        itemBuilder: (context, index) {
          final vegetable = vegetables[index];
          return ListTile(
            leading: Image.asset(
              vegetable.imagePath,
              width: 50,
              height: 50,
            ),
            title: Text(vegetable.name),
          );
        },
      ),
    );
  }
}
