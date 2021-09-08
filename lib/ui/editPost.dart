import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_android/blocs/editPostBloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/locationTextField.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditPost extends StatefulWidget {
  EditPost({Key? key, this.post}) : super(key: key);

  Post? post;

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _editPostBloc.title,
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
                StreamBuilder<List<dynamic>>(
                    initialData: _editPostBloc.oldImages,
                    stream: _editPostBloc.imagesStream,
                    builder: (context, snapshot) {
                      return Container(
                        height: 150,
                        child: snapshot.data == null ||
                                snapshot.data!.length == 0
                            ? Center(
                                child: InkWell(
                                    onTap: () {
                                      _editPostBloc.onImageUpload();
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
                                          _editPostBloc.onMoreImageUpload();
                                        },
                                        child: Icon(Icons.add));
                                  }
                                  return Stack(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              ThemeBorderRadius.smallRadiusAll,
                                          border: Border.all(
                                              color: ThemeColors.grey,
                                              width: 1),
                                          image: (snapshot.data![index]
                                                  is String)
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      snapshot.data![index]),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: MemoryImage(
                                                      snapshot.data![index])),
                                        ),
                                        width: 100,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            _editPostBloc.removeImage(
                                                index, snapshot.data ?? []);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: ThemeBorderRadius
                                                    .bigRadiusAll,
                                                color: ThemeColors.accent),
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
                          stream: _editPostBloc.lastSeenDateStream,
                          builder: (context, snapshot) {
                            _editPostBloc.lastSeenDate =
                                snapshot.data ?? DateTime.now();
                            return Text(snapshot.data != null
                                ? DateFormat("MMM dd, yyy")
                                    .format(snapshot.data ?? DateTime.now())
                                : _editPostBloc.lastSeenDate != null
                                    ? DateFormat("MMM dd, yyy")
                                        .format(_editPostBloc.lastSeenDate)
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
                                                _editPostBloc.lastSeenDateSink
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
                                            maxDate: DateTime.now(),
                                            onSelectionChanged:
                                                (DateRangePickerSelectionChangedArgs
                                                    x) {
                                              _editPostBloc.lastSeenDateSink
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
                  hintText: "Last Seen Location",
                  controller: _editPostBloc.lastSeenLocation,
                  // resultSink:
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _editPostBloc.postDescription,
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
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<String>(
                    stream: _editPostBloc.statusStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) widget.post!.status = snapshot.data;
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
                                value: "Found", child: Text("Found"))
                          ]);
                    }),
                SizedBox(height: 10),
                ThemeButton.longButtonPrim(
                    text: "Edit Post",
                    onpressed: () {
                      _editPostBloc.onSubmitPost(
                          context, widget.post!.id!, widget.post!.status!);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
