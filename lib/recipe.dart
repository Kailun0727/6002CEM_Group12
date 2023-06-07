import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_recipe_generator/RecipeModel.dart';

import 'package:random_recipe_generator/shopping_list.dart';

import 'package:random_recipe_generator/recipeBasicInfo.dart';



String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

class RecipePage extends StatefulWidget {
  const RecipePage(List<String> selectedAllergies, {Key? key}) : super(key: key);//receive the allergies item list

  @override
  State<RecipePage> createState() => _RecipePageState();
}

String name = "Recipe Name";

class _RecipePageState extends State<RecipePage> {

  FirebaseStorage storage = FirebaseStorage.instance;


  bool isBookmarked = false;
  String imageUrl = "https://spoonacular.com/recipeImages/654857-312x231.jpg";
  Set <dynamic> recipeName =  Set<dynamic>();
  Set <dynamic> recipeImageUrl =  Set<dynamic>();
  String ingredientInfo = "";
  String instructionInfo = "";
  String cuisine = "chinese";
  String amount = "";


  List<String> ingredientList = ["1 cup of coffee","2 spoon of tea"];
  TextEditingController searchRecipeConntroller = new TextEditingController();


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    setState(() {
        isBookmarked = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // Code for the first FAB
              Navigator.of(context).pushNamed(RecipeBasicInfoPage.routeName,arguments: name);


            },
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 16), // Add spacing between FABs
          FloatingActionButton(
            onPressed: () async {

              setState(() {
                isBookmarked = false;
              });

              // Code for the refresh recipe FAB

              var apiKey = 'a5329057d3ed4e7a95cc596a972aed58';
              var url =
                  'https://api.spoonacular.com/recipes/complexSearch?cuisine=$cuisine&number=100&apiKey=$apiKey';
              var response = await http.get(Uri.parse(url));
              if (response.statusCode == 200) {
                var data = json.decode(response.body);
                var results = data['results'] as List<dynamic>;

                if (results != null && results.isNotEmpty) {
                  // Shuffle the list
                  results.shuffle();

                  // Generate random numbers without duplication
                  int randomIndex = Random().nextInt(results.length);

                  var recipe = results[randomIndex];
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


                    String modifiedText = instructionStep.replaceAll('\n', '\n\n');

                    // Remove content within <>, for example : <ol> , <h1>
                    String filteredInstruction = modifiedText.replaceAll(RegExp(r'<.*?>'), '\n');



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

                        var amountValue = ingredientData['amount'].toString();
                        if (ingredientData['amount'] == ingredientData['amount'].roundToDouble()) {
                          // Remove decimal part if it's .0
                          amountValue = ingredientData['amount'].toStringAsFixed(0);
                        }

                        ingredientList.add(amountValue +
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
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 16), // Add spacing between FABs
          FloatingActionButton(

            onPressed: () async {





              String recipeKey = '';

              DatabaseReference databaseRef = FirebaseDatabase.instance.ref();




              if (isBookmarked) {
                // Delete the recipe from the database
                var snapshot = await databaseRef
                    .child('recipes')
                    .orderByChild('name')
                    .equalTo(name)
                    .once();


                var values = snapshot.snapshot.value;

                Map data = (values as Map);



                data.forEach((key, value) async {



                  // print("Key"+key);
                  // print("Value"+value.toString());

                  if (value['name'] == name) {
                    recipeKey = key;
                    // print("Found the object "+ value['name'] + "Key :"+key + "Url :"+value['imageUrl']);

                    var recipe = await databaseRef.child('recipes').child(recipeKey);

                    var values = recipe.key;

                    // print("The key is "+values.toString());

                    await databaseRef.child('recipes').child(recipeKey).remove();

                    setState(() {
                      isBookmarked = !isBookmarked; // Toggle the bookmark state
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed from bookmark'),
                        duration: Duration(seconds: 2), // Adjust the duration as needed
                      ),
                    );
                  }

                });


                // print("The values of snapshot :"+values.toString());

              }else{
                databaseRef.child('recipes').push().set({
                  'name': name,
                  'imageUrl': imageUrl,
                }).then((_) {
                  // Success callback
                  setState(() {
                    isBookmarked = !isBookmarked; // Toggle the bookmark state
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Recipe saved!'),
                      duration: Duration(seconds: 2), // Adjust the duration as needed
                    ),
                  );

                  print('Data stored successfully!');
                }).catchError((error) {
                  // Error callback
                  print('Failed to store data: $error');
                });
              }


              //retrieve all data from database
              var allSnapshot = await databaseRef
                  .child('recipes')
                  .once();

              var allValues = allSnapshot.snapshot.value;

              Map<dynamic, dynamic> allData = allValues as Map<dynamic, dynamic>;

              Set<dynamic> recipeImageUrl = Set<dynamic>();
              Set<dynamic> recipeName = Set<dynamic>();

              allData.values.forEach((value) {
                recipeImageUrl.add(value['imageUrl']);
                recipeName.add(value['name']);
              });


              print("All Recipe Image Url");
              print(recipeImageUrl);
              print("All Recipe Name");
              print(recipeName);
              print("\n\n\n");

              // print("All Data in database"+ allData.toString());

              //
              //
              // print("Recipe List : " + recipesList.toString());


            },
            child: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline,),
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


                Padding(
                  padding: const EdgeInsets.only(left:25),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: searchRecipeConntroller,
                      decoration: InputDecoration(
                        hintText: "Search Recipe",
                      ),
                    ),
                  ),
                ),

                //search logo
                InkWell(
                  onTap: () async {

                    setState(() {
                      isBookmarked = false; // Toggle the bookmark state
                    });


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

                          String modifiedText = instructionStep.replaceAll('\n', '\n\n');

                          // Remove content within <>, for example : <ol> , <h1>
                          String filteredInstruction = modifiedText.replaceAll(RegExp(r'<.*?>'), '\n');





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

                              var amountValue = ingredientData['amount'].toString();
                              if (ingredientData['amount'] == ingredientData['amount'].roundToDouble()) {
                                // Remove decimal part if it's .0
                                amountValue = ingredientData['amount'].toStringAsFixed(0);
                              }

                              ingredientList.add(amountValue +
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
                  fontSize: 24,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShoppingList(ingredientList: ingredientList)));
                  //print('Button pressed!');
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
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                              child: Text(
                                "Ingredient Info",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              )),
                        ),

                        SizedBox(height: 20), // Add some spacing
                        Divider(color: Colors.black,height: 10,),
                        SizedBox(height: 20), // Add some spacing

                        Center(
                          child:  Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              ingredientInfo,
                              style: TextStyle(fontSize: 16),
                            ),
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
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                              child: Text(
                                "Instructions",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              )),
                        ),

                        SizedBox(height: 20), // Add some spacing
                        Divider(color: Colors.black,height: 10,),
                        SizedBox(height: 20), // Add some spacing

                        Center(
                          child:  Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              instructionInfo,
                              style: TextStyle(fontSize: 16),
                            ),
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
