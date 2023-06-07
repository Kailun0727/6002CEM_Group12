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

  choice(){

    error = '';

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

      case 'Italian':
        cuisineType = 'italian';
        print(cuisineType);
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
        error = "Please select a cuisine type";
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  'American', ]
                    .map((e) => CuisineList(cuisineType: e, onTap: () {setState(() {});},)).toList()
              //Expanded(child: CuisineList(cuisineType: e, onTap: () {setState(() {});},))).toList()
            ),
            SizedBox(
              height: 30,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  'Italian',
                  'Korean',
                  'Thai', ]
                    .map((e) => CuisineList(cuisineType: e, onTap: () {setState(() {});},)).toList()
            ),
          ],
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
