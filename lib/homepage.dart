import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_recipe_generator/cuisine_list.dart';
import 'package:random_recipe_generator/select_allergies_page.dart';

class Homepage extends StatefulWidget {

  static String routeName = "/homePage";
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

String? type;
String cuisineType = '';

class _HomepageState extends State<Homepage> {

  String? error;
  List<dynamic> cuisineCode = ['chinese', 'japanese', 'american', 'korean', 'thai'];

  void reloadPage() {
    setState(() {
      // Add code here to reset or reload the page's state
    });
  }

  randomCuisineType(){
    int randomIndex = Random().nextInt(cuisineCode.length);

    cuisineType = cuisineCode[randomIndex].toString();
    print(cuisineType);
  }

  choice(){

    switch (type) {
      case 'Chinese':
        cuisineType = 'chinese';
        print(cuisineType);
        break;

      case 'Japanese':
        cuisineType = 'japanese';
        print(cuisineType);
        break;

      case 'American':
        cuisineType = 'american';
        print(cuisineType);
        break;

      case 'Random':
        randomCuisineType();
        break;

      case 'Korean':
        cuisineType = 'korean';
        print(cuisineType);
        break;

      case 'Thai':
        cuisineType = 'thai';
        print(cuisineType);
        break;

      default:
        randomCuisineType();

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Recipe Generator"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1559466273-d95e72debaf8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZCUyMHBvcnRyYWl0fGVufDB8fDB8fHww&w=1000&q=80"),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Text('Select Your Favourite Cuisine',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    'Chinese',
                    'Japanese',
                    'Thai', ]
                      .map((e) => CuisineList(cuisineType: e, onTap: () {setState(() {});},)).toList()
                //Expanded(child: CuisineList(cuisineType: e, onTap: () {setState(() {});},))).toList()
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    'American',
                    'Korean',
                    'Random', ]
                      .map((e) => CuisineList(cuisineType: e, onTap: () {setState(() {});},)).toList()
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectAllergiesPage(),
              )
          );
          choice();

        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
