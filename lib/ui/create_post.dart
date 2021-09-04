import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_android/blocs/createPostBloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreatePostView extends StatefulWidget {
  CreatePostView({Key? key}) : super(key: key);

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
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
                StreamBuilder<List<Uint8List>>(
                    stream: createPostBloc.imagesStream,
                    builder: (context, snapshot) {
                      return Container(
                        height: 150,
                        child: snapshot.data == null ||
                                snapshot.data!.length == 0
                            ? Center(
                                child: InkWell(
                                    onTap: () {
                                      createPostBloc.onImageUpload();
                                    },
                                    child: Icon(Icons.add)),
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                    snapshot.data!.length == 8
                                        ? snapshot.data!.length
                                        : snapshot.data!.length + 1, (index) {
                                  if (snapshot.data!.length < 8 &&
                                      index == snapshot.data!.length) {
                                    return InkWell(
                                        onTap: () {
                                          createPostBloc.onMoreImageUpload();
                                        },
                                        child: Icon(Icons.add));
                                  }
                                  return Stack(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: ThemeBorderRadius
                                                .smallRadiusAll,
                                            border: Border.all(
                                                color: ThemeColors.grey,
                                                width: 1),
                                            image: DecorationImage(
                                                image: MemoryImage(
                                                    snapshot.data![index]),
                                                fit: BoxFit.cover)),
                                        width: 100,
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: InkWell(
                                              onTap: () {
                                                createPostBloc.removeImage(
                                                    index, snapshot.data ?? []);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        ThemeBorderRadius
                                                            .bigRadiusAll,
                                                    color: ThemeColors.accent),
                                                child: Icon(
                                                  Icons.close,
                                                  color: ThemeColors.white,
                                                ),
                                              )))
                                    ],
                                  );
                                })),
                      );
                    }),
                SizedBox(height: 10),
                Text(
                  "Last Seen:",
                  style: ThemeTexTStyle.regular(),
                ),
                SizedBox(height: 10),
                Container(
                  // height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<DateTime>(
                          stream: createPostBloc.lastSeenDateStream,
                          builder: (context, snapshot) {
                            createPostBloc.lastSeenDate =
                                snapshot.data ?? DateTime.now();
                            return Text(snapshot.data != null
                                ? DateFormat("MMM dd, yyy")
                                    .format(snapshot.data ?? DateTime.now())
                                : "Select Date");
                          }),
                      ThemeButton.ButtonSec(
                          text: "Select",
                          onpressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  // return Container(
                                  // child: SfDateRangePicker());

                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ThemeColors.white),
                                          child: Center(
                                              child: SfDateRangePicker(
                                            showActionButtons: true,
                                            onSubmit: (x) {
                                              if (x is DateTime) {
                                                createPostBloc.lastSeenDateSink
                                                    .add(x);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            onCancel: () {
                                              Navigator.of(context).pop();
                                            },
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .single,
                                            onSelectionChanged:
                                                (DateRangePickerSelectionChangedArgs
                                                    x) {
                                              createPostBloc.lastSeenDateSink
                                                  .add(x.value);
                                            },
                                          )),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: createPostBloc.lastSeenLocation,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    hintText: "Last Seen Location",
                  ),
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
