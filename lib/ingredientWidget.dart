
import 'package:flutter/material.dart';

class IngredientWidget extends StatelessWidget {
  final int index;
  final String ingredientInfo;
  const IngredientWidget({Key? key, required this.index, required this.ingredientInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            child: Text((index+1).toString()),
          ),

        ],
      );
  }
}
