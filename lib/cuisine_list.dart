import 'package:flutter/material.dart';
import 'package:random_recipe_generator/homepage.dart';

class CuisineList extends StatelessWidget {

  final String cuisineType;
  final Function() onTap;

  const CuisineList({Key? key, required this.cuisineType, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {type = cuisineType;
      onTap();
      },
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(color: type == cuisineType? Colors.blue:Colors.grey,
          borderRadius: BorderRadius.circular(60),),

        child: Center(
            child: Text(cuisineType,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
            )
        ),
      ),
    );
  }
}
