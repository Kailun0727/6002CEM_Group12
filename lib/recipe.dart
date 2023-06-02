import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_recipe_generator/RecipeModel.dart';


String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  String imageUrl = "https://spoonacular.com/recipeImages/654857-312x231.jpg";
  String name = "Recipe Name";
  String ingredientInfo = "";
  String instructionInfo = "";
  String amount = "";
  List<String> ingredientList = ["1 cup of coffee","2 spoon of tea"];
  TextEditingController searchRecipeConntroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Code for the first FAB
            },
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 16), // Add spacing between FABs
          FloatingActionButton(
            onPressed: () async {
              // Code for the first FAB
            },
            child: Icon(Icons.restaurant_menu),
          ),
          SizedBox(height: 16), // Add spacing between FABs
          FloatingActionButton(
            onPressed: () {
              // Code for the second FAB
            },
            child: Icon(Icons.bookmark),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Recipe Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: searchRecipeConntroller,
                    decoration: InputDecoration(
                      hintText: "Search Recipe",
                    ),
                  ),
                ),

                //search logo
                InkWell(
                  onTap: () async {
                    debugPrint("Inkwell clicked");

                    var searchRecipe = searchRecipeConntroller.text.toString();

                    //var apiKey = 'a5329057d3ed4e7a95cc596a972aed58';
                    var apiKey = '430e27f17fa0472194beeb74ebef1697';
                    var url =
                        'https://api.spoonacular.com/recipes/complexSearch?query=$searchRecipe&apiKey=$apiKey';
                    var response = await http.get(Uri.parse(url));
                    if (response.statusCode == 200) {
                      var data = json.decode(response.body);
                      var results = data['results'] as List<dynamic>;

                      if (results != null && results.isNotEmpty) {
                        var recipe = results[0];
                        var id = recipe['id'] as int?;
                        var title = recipe['title'] as String?;
                        var image = recipe['image'] as String?;

                        //use api to search recipe ingredient and instruction based on the id
                        var ingredientAndInstruction =
                            'https://api.spoonacular.com/recipes/$id/information?includeNutrition=false&apiKey=$apiKey';
                        var response =
                            await http.get(Uri.parse(ingredientAndInstruction));
                        if (response.statusCode == 200) {
                          var data = json.decode(response.body);

                          var instructionStep = data['instructions'] as String;


                          // Remove content within <>, for example : <ol> , <h1>
                          String filteredInstruction = instructionStep.replaceAll(RegExp(r'<.*?>'), '');

                          print(filteredInstruction);

                            var extendedIngredients =
                              data['extendedIngredients'] as List<dynamic>;

                          if (extendedIngredients != null &&
                              extendedIngredients.isNotEmpty) {
                            //save data from api into list

                            //clean the list
                            ingredientList.clear();

                            for (var ingredientData in extendedIngredients) {
                              var ingredientAmount =
                                  ingredientData['amount'] as double?;
                              var ingredientUnit =
                                  ingredientData['unit'] as String?;
                              var ingredientName =
                                  ingredientData['name'] as String?;

                              ingredientList.add(ingredientAmount!.toStringAsFixed(0) +
                                  " " +
                                  ingredientUnit! +
                                  " " +
                                  ingredientName!);
                            }
                            print(ingredientList);
                          }

                          if (id != null && title != null && image != null) {
                            RecipeModel recipeModel = RecipeModel(
                              id: id,
                              name: title,
                              imageUrl: image,
                            );

                            print(recipeModel.name);
                            print(recipeModel.imageUrl);

                            setState(() {
                              name = recipeModel.name;
                              imageUrl = recipeModel.imageUrl;
                              ingredientInfo = ingredientList
                                  .map((ingredient) => capitalize(ingredient))
                                  .join('\n');


                              instructionInfo = filteredInstruction;
                            });
                          } else {
                            throw Exception(
                                'Invalid data format in the API response');
                          }
                        } else {
                          throw Exception('No recipes found in the response');
                        }
                      } else {
                        throw Exception(
                            'API request failed with status code: ${response.statusCode}');
                      }
                    }
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/search_logo.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Add some spacing

            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 20), // Add some spacing
            SizedBox(
              child: Image.network(imageUrl),
            ),

            SizedBox(height: 20), // Add some spacing

            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Code to execute when the button is pressed
                  print('Button pressed!');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blueAccent), // Change background color
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Change text color

                  // Add additional styling properties as needed
                ),
                child: Text('Add to shopping list'),
              ),
            ),
            SizedBox(height: 20), // Add s

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 4,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),),

                  child: SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                              child: Text(
                                "Ingredient Info",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ),

                        SizedBox(height: 20), // Add some spacing
                        Divider(color: Colors.black,height: 10,),
                        SizedBox(height: 20), // Add some spacing

                        Center(
                          child:  Text(
                            ingredientInfo,
                            style: TextStyle(fontSize: 14),
                          ),),
                        SizedBox(height: 20), // Add some spacing
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 4,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),),

                  child: SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                              child: Text(
                                "Instructions",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ),

                        SizedBox(height: 20), // Add some spacing
                        Divider(color: Colors.black,height: 10,),
                        SizedBox(height: 20), // Add some spacing

                        Center(
                          child:  Text(
                            instructionInfo,
                            style: TextStyle(fontSize: 14),
                          ),),
                        SizedBox(height: 20), // Add some spacing
                      ],
                    ),
                  ),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
