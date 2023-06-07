import 'package:flutter/material.dart';
import 'package:random_recipe_generator/recipe.dart';



class SelectAllergiesPage extends StatefulWidget {
  SelectAllergiesPage({Key? key}) : super(key: key);

  @override
  State<SelectAllergiesPage> createState() => _SelectAllergiesPageState();
}

class _SelectAllergiesPageState extends State<SelectAllergiesPage> {
  List<String> selectedAllergies = []; //store the selected allergies

  void _allergiesSelection(String food) { //selection function:handle selecting food and deselecting food
    setState(() {
      if (selectedAllergies.contains(food)) { //if nothing
        selectedAllergies.remove(food); //remove = nothing
      } else {
        selectedAllergies.add(food); //else add = store food inside
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Allergies'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select Allergies Item:"),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FoodButton(                                       //when user click this button,gestureDetector will detect user click this button
                  food: 'Egg',                                    //the value "egg"
                  isSelected: selectedAllergies.contains('Egg'),  //check "'egg" ady inside the list? if yes inside the button color change to blue.
                  onTap: () => _allergiesSelection('Egg'),        //triggered the button is tapped
                ),
                SizedBox(width: 20,),
                FoodButton(
                  food: 'Peanut',
                  isSelected: selectedAllergies.contains('Peanut'),
                  onTap: () => _allergiesSelection('Peanut'),
                ),
                SizedBox(width: 20,),
                FoodButton(
                  food: 'Dairy',
                  isSelected: selectedAllergies.contains('Dairy'),
                  onTap: () => _allergiesSelection('Dairy'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FoodButton(
                  food: 'Soy',
                  isSelected: selectedAllergies.contains('Soy'),
                  onTap: () => _allergiesSelection('Soy'),
                ),
                SizedBox(width: 20,),
                FoodButton(
                  food: 'Sesame',
                  isSelected: selectedAllergies.contains('Sesame'),
                  onTap: () => _allergiesSelection('Sesame'),
                ),
                SizedBox(width: 20,),
                FoodButton(
                  food: 'Wheat',
                  isSelected: selectedAllergies.contains('Wheat'),
                  onTap: () => _allergiesSelection('Wheat'),
                ),
              ],

            ),
            SizedBox(height: 20),
            const Text("Allergies Item Selected:"),
            Column(
              children:
              selectedAllergies.map((food) {
                return Text(food, style: TextStyle(fontSize: 16));
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _navigateToAnswerPage,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipePage(selectedAllergies))); //bring the allergies list to recipe page
        },
        child: const Text("Next"),
      ),
    );
  }
}


class FoodButton extends StatelessWidget {
  final String food; //declare
  final bool isSelected;
  final VoidCallback onTap;

  FoodButton({
    required this.food,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.grey, //is selected? true= blue,false= grey
        ),
        child: Center(
          child: Text(
            food,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
