import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:random_recipe_generator/bookmark_model.dart';
import 'package:random_recipe_generator/bookmark_widget.dart';
import 'package:random_recipe_generator/recipe.dart';

List<BookmarkModel> modelList = [];

class BookmarkRecipe extends StatefulWidget {

  static String routeName = "/bookmarkPage";
  const BookmarkRecipe({Key? key}) : super(key: key);

  @override
  State<BookmarkRecipe> createState() => _BookmarkRecipeState();
}

class _BookmarkRecipeState extends State<BookmarkRecipe> {
  retrieveData() async {

    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    //retrieve all data from database
    var allSnapshot = await databaseRef
        .child('recipes')
        .once();

    var allValues = allSnapshot.snapshot.value;

    Map<dynamic, dynamic> allData = allValues as Map<dynamic, dynamic>;

    Set<dynamic> recipeImageUrl = Set<dynamic>();
    Set<dynamic> recipeName = Set<dynamic>();
    List<dynamic> imageList = [];
    List<dynamic> nameList = [];

    allData.values.forEach((value) {
      recipeImageUrl.add(value['imageUrl']);
      recipeName.add(value['name']);
    });

    imageList = recipeImageUrl.toList();
    nameList = recipeName.toList();

    modelList.clear();

    for(int i=0; i<recipeName.length; i++){

      BookmarkModel model = new BookmarkModel(imageSource: imageList[i], bookmarkName: nameList[i]);
      modelList.add(model);
    }


    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    retrieveData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => BookmarkWidget(
        mBookmarkModel: modelList[index]),
        itemCount: modelList.length,
      ),
      // SingleChildScrollView(
      //   child: Column(
          // children: [
          //   SizedBox(
          //     height: 20,
          //   ),
          //   Text(
          //     "Bookmarks",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 30,
          //   ),
          //   ),
          //   Divider(color: Colors.black,),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(20),
        //   child: Stack(
        //       children: [
        //         Image.network(
        //             modelList[2].imageSource,
        //             height: 150,
        //             width: double.infinity,
        //             fit: BoxFit.cover
        //         ),
        //         Padding(
        //             padding: EdgeInsets.only(left:20),
        //             child: Text(
        //               modelList[2].bookmarkName,
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 25,
        //                   fontWeight: FontWeight.bold,
        //                   fontStyle: FontStyle.italic
        //               ),)
        //         )
        //       ]
        //   ),
        // ),

    //       ],
    //     ),
    //   ),
    );
  }
}
