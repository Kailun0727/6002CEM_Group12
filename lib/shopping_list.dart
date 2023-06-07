import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({required this.ingredientList});

  final List<String> ingredientList;

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<bool> checkedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the checkedItems list with false for each ingredient
    checkedItems = List<bool>.filled(widget.ingredientList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50,right: 50,top: 50,),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                spreadRadius: 4,
                color: Colors.grey.withOpacity(0.2),
              )
            ]
          ),
          child: ListView.builder(
            itemCount: widget.ingredientList.length,
            itemBuilder: (context, index) {
              final ingredient = widget.ingredientList[index];
              return CheckboxListTile(
                value: checkedItems[index],
                onChanged: (value) {
                  setState(() {
                    checkedItems[index] = value!;
                  });
                },
                title: Text(ingredient),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(50),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 4,
                  color: Colors.grey.withOpacity(0.2),
                )
              ]
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                checkedItems = List<bool>.filled(widget.ingredientList.length, false);
              });
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
