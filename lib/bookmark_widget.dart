import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_recipe_generator/bookmark_model.dart';
import 'package:random_recipe_generator/homepage.dart';
import 'package:random_recipe_generator/recipe.dart';
import 'package:random_recipe_generator/recipeBasicInfo.dart';

class BookmarkWidget extends StatelessWidget {

  final BookmarkModel mBookmarkModel; //create a bookmark model object

  const BookmarkWidget({Key? key, required this.mBookmarkModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(
              RecipeBasicInfoPage.routeName,
              arguments: {
                name : mBookmarkModel.bookmarkName
              }
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Stack(
                children: [
                  Image.network(
                      mBookmarkModel.imageSource,
                      height: 150,
                      width: 400,
                      fit: BoxFit.cover
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 60,
                      width: 400,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ]
                          )
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left:20),
                            child: Text(
                              mBookmarkModel.bookmarkName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic
                              ),)
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
        SizedBox(height: 10,)
      ]
    );
    // return Column(
    //   children: [
    //     Text(mBookmarkModel.bookmarkName),
    //     Text(mBookmarkModel.imageSource),
        // InkWell(
        //   onTap: () {
        //     Navigator.of(context).pushNamed(
        //       Homepage.routeName,
        //       arguments: {
        //         'name': mBookmarkModel.bookmarkName,
        //       });
        //   },
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(20),
        //     child: SizedBox(
        //       height: 20,
        //       child: Stack(
        //         children: [
        //           Image.network(mBookmarkModel.imageSource, width: 100, height: 50,),
        //           Positioned(
        //             bottom: 0,
        //             child: Container(
        //               height: 20,
        //               width: 220,
        //               decoration: BoxDecoration(
        //                 gradient:LinearGradient(
        //                   colors:[Colors.black, Colors.transparent]
        //                 )
        //               ),
        //               child: Align(
        //                 alignment: Alignment.centerLeft,
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 20),
        //                   child: Text(
        //                     mBookmarkModel.bookmarkName, style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 25,
        //                     fontWeight: FontWeight.bold,
        //                     fontStyle:FontStyle.italic
        //                   ),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // )
    //  ],
    // );
  }
}
