import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_android/blocs/editPostBloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/modules/post/edit_post_Provider.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/locationTextField.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditPost extends StatefulWidget {
  EditPost({Key? key, this.post}) : super(key: key);

  Post? post;

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> with InputDec {
  EditPostBloc _editPostBloc = sl<EditPostBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editPostBloc.lastSeenLocation =
        TextEditingController(text: widget.post!.lastSeen!.location!);
    _editPostBloc.title = TextEditingController(text: widget.post!.title);
    _editPostBloc.postDescription =
        TextEditingController(text: widget.post!.desc);
    _editPostBloc.lastSeenDateSink.add(widget.post!.lastSeen!.date!);
    _editPostBloc.oldImages = widget.post!.imgs;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditPostProvider>(
        create: (context) => EditPostProvider(post: widget.post),
        child: Consumer<EditPostProvider>(builder: (context, editPostProv, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Edit Post"),
            ),
            body: editPostProv.lastEvent!.state == EditPostEventState.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: ThemeColors.primary,
                    ),
                  )
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: editPostProv.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (String? value) => editPostProv
                                  .isEmptyValidator(value!, "Title"),
                              controller: editPostProv.title,
                              decoration: inputDec(hint: "Title"),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 150,
                              child: (editPostProv.oldImages!.length +
                                          editPostProv.memImages.length) ==
                                      0
                                  ? Center(
                                      child: InkWell(
                                        onTap: () {
                                          editPostProv.onImageUpload();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              ThemePadding.padBase),
                                          decoration: BoxDecoration(
                                              color: ThemeColors.primary,
                                              borderRadius: ThemeBorderRadius
                                                  .smallRadiusAll),
                                          child: Icon(Icons.add,
                                              color: ThemeColors.white),
                                        ),
                                      ),
                                    )
                                  : ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          // Check if length of old image plus new images is 8 (ie posts cannot contain more than 8 images)
                                          editPostProv.displayImages.length == 8
                                              ? editPostProv
                                                  .displayImages.length
                                              : (editPostProv
                                                      .displayImages.length) +
                                                  1, (index) {
                                        if (editPostProv.displayImages.length <
                                                8 &&
                                            index ==
                                                editPostProv
                                                    .displayImages.length) {
                                          return Center(
                                            child: InkWell(
                                              onTap: () {
                                                editPostProv.onImageUpload();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    ThemePadding.padBase),
                                                decoration: BoxDecoration(
                                                    color: ThemeColors.primary,
                                                    borderRadius:
                                                        ThemeBorderRadius
                                                            .smallRadiusAll),
                                                child: Icon(Icons.add,
                                                    color: ThemeColors.white),
                                              ),
                                            ),
                                          );
                                        }
                                        return Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: ThemeBorderRadius
                                                    .smallRadiusAll,
                                                border: Border.all(
                                                    color: ThemeColors.grey,
                                                    width: 1),
                                                image: (editPostProv
                                                            .displayImages[
                                                        index] is String)
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                            editPostProv
                                                                    .displayImages[
                                                                index]),
                                                        fit: BoxFit.cover)
                                                    : DecorationImage(
                                                        image: MemoryImage(
                                                            editPostProv
                                                                    .displayImages[
                                                                index])),
                                              ),
                                              width: 100,
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  editPostProv
                                                      .removeImage(index);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          ThemeBorderRadius
                                                              .bigRadiusAll,
                                                      color:
                                                          ThemeColors.accent),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: ThemeColors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })),
                            ),

                            //
                            SizedBox(height: 10),
                            Text(
                              "Last Seen:",
                              style: ThemeTexTStyle.regular(),
                            ),
                            SizedBox(height: 10),
                            Container(
                              // height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder<DateTime>(
                                      stream: _editPostBloc.lastSeenDateStream,
                                      builder: (context, snapshot) {
                                        _editPostBloc.lastSeenDate =
                                            snapshot.data ?? DateTime.now();
                                        return Text(snapshot.data != null
                                            ? DateFormat("MMM dd, yyy").format(
                                                snapshot.data ?? DateTime.now())
                                            : _editPostBloc.lastSeenDate != null
                                                ? DateFormat("MMM dd, yyy")
                                                    .format(_editPostBloc
                                                        .lastSeenDate)
                                                : "Select Date");
                                      }),
                                  ThemeButton.ButtonSec(
                                      text: "Select",
                                      onpressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: ThemeColors
                                                              .white),
                                                      child: Center(
                                                          child:
                                                              SfDateRangePicker(
                                                        showActionButtons: true,
                                                        onSubmit: (x) {
                                                          if (x is DateTime) {
                                                            _editPostBloc
                                                                .lastSeenDateSink
                                                                .add(x);
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        onCancel: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        selectionMode:
                                                            DateRangePickerSelectionMode
                                                                .single,
                                                        maxDate: DateTime.now(),
                                                        onSelectionChanged:
                                                            (DateRangePickerSelectionChangedArgs
                                                                x) {
                                                          _editPostBloc
                                                              .lastSeenDateSink
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
                            LocationTextField(
                              validator: (String? value) =>
                                  editPostProv.isEmptyValidator(
                                      value!, "Last Seen Location"),
                              hintText: "Last Seen Location",
                              controller: _editPostBloc.lastSeenLocation,
                              // resultSink:
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (String? value) => editPostProv
                                  .isEmptyValidator(value!, "Description"),
                              controller: _editPostBloc.postDescription,
                              maxLines: 5,
                              decoration: inputDec(hint: "Post Description"),
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey,
                              //       width: 1,
                              //       style: BorderStyle.solid,
                              //     ),
                              //   ),
                              //   hintText: "Post Description",
                              // ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<String>(
                                stream: _editPostBloc.statusStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    widget.post!.status = snapshot.data;
                                  return DropdownButton(
                                      isExpanded: true,
                                      onChanged: (String? value) {
                                        _editPostBloc.statusSink.add(value!);
                                      },
                                      value: snapshot.hasData
                                          ? snapshot.data
                                          : widget.post!.status,
                                      items: [
                                        DropdownMenuItem(
                                          value: "Not Found",
                                          child: Text("Not Found"),
                                        ),
                                        DropdownMenuItem(
                                            value: "Found",
                                            child: Text("Found"))
                                      ]);
                                }),
                            SizedBox(height: 10),
                            ThemeButton.longButtonPrim(
                                text: "Edit Post",
                                onpressed: () {
                                  editPostProv.onSubmitPost(context,
                                      widget.post!.id!, widget.post!.status!);
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        }));
  }
}
