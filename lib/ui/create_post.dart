import 'package:flutter/material.dart';
import 'package:project_android/blocs/createPostBloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/theme_colors.dart';

class CreatePostView extends StatelessWidget {
  CreatePostView({Key? key}) : super(key: key);

  CreatePostBloc createPostBloc = CreatePostBloc();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Form(
            child: Column(
              children: [
                TextField(
                  controller: createPostBloc.title,
                  maxLines: 1,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: "Title"),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  color: ThemeColors.grey,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: createPostBloc.postDescription,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    hintText: "Post Description",
                  ),
                ),
                SizedBox(height: 10),
                ThemeButton.longButtonPrim(
                    text: "Create Post",
                    onpressed: () {
                      createPostBloc.createPostActionsSink
                          .add(CreatePostActions.CreatePost);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
