import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/modules/post/contribution_provider.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/padding.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/locationTextField.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Contribution extends StatelessWidget {
  Contribution({Key? key, this.postId = ""}) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContributionsProvider>(
      create: (context) => ContributionsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Contribute"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: ThemePadding.padBase * 1.5,
                bottom: ThemePadding.padBase * 1.5,
                left: ThemePadding.padBase * 1.5,
                right: ThemePadding.padBase * 1.5),
            padding: EdgeInsets.all(ThemePadding.padBase * 1.5),
            decoration: BoxDecoration(
              color: ThemeColors.white,
              borderRadius: ThemeBorderRadius.smallRadiusAll,
            ),
            width: 500,
            child: Material(
              child: contributionContent(context, postId),
              // child: StreamBuilder<bool>(
              //     stream: _contributionBloc.contributionStream,
              //     builder: (context, snapshot) {
              //       return !snapshot.hasData || !snapshot.data!
              //           ? queryView(context)
              //           : contributionContent(context);
              //     }),
            ),
          ),
        ),
      ),
    );
  }

  Widget contributionContent(BuildContext context, String postId) {
    return Consumer<ContributionsProvider>(
        builder: (context, contributionsProv, _) {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            LocationTextField(
              hintText: "Seen Location",
              controller: contributionsProv.locationController,
              // resultSink:
            ),
            SizedBox(
              height: ThemePadding.padBase * 2,
            ),
            Text('Pick Time of sighting'),
            Container(
              child: TimePickerSpinner(
                onTimeChange: (time) {
                  contributionsProv.timeValue = time;
                },
                isForce2Digits: true,
                normalTextStyle: ThemeTexTStyle.regularPrim,
                highlightedTextStyle: ThemeTexTStyle.headerPrim,
                // spacing: 10,
                is24HourMode: false,
                time: DateTime.now(),
                itemHeight: 70,
              ),
            ),
            SizedBox(
              height: ThemePadding.padBase * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat("MMM dd, yyy")
                    .format(contributionsProv.dateValue ?? DateTime.now())),
                ThemeButton.ButtonSec(
                    text: "Select",
                    onpressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            // return Container(
                            // child: SfDateRangePicker());

                            return AlertDialog(
                              content: Container(
                                height: 350,
                                width: 350,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ThemeColors.white),
                                      child: Center(
                                          child: SfDateRangePicker(
                                        initialDisplayDate:
                                            contributionsProv.dateValue,
                                        maxDate: DateTime.now(),
                                        initialSelectedDate:
                                            contributionsProv.dateValue ??
                                                DateTime.now(),
                                        showActionButtons: true,
                                        onSubmit: (x) {
                                          if (x is DateTime) {
                                            contributionsProv.setDate(x);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        onCancel: () {
                                          Navigator.of(context).pop();
                                        },
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                        onSelectionChanged:
                                            (DateRangePickerSelectionChangedArgs
                                                x) {
                                          contributionsProv.setDate(x.value);
                                        },
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ],
            ),
            SizedBox(
              height: ThemePadding.padBase * 2,
            ),
            ThemeButton.longButtonPrim(
                text: "Submit",
                onpressed: () {
                  contributionsProv.postId = postId;
                  contributionsProv.onSubmit(context);
                }),
          ],
        ),
      );
    });
  }

  Widget queryView(BuildContext context) {
    return Consumer<ContributionsProvider>(
        builder: (context, contributionsProv, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Do you recognize the person??"),
          SizedBox(
            height: ThemePadding.padBase * 2,
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: ThemeButton.ButtonPrim(
                      text: "Yes",
                      onpressed: () {
                        // contributionsProv.onViewSwitchRequest(true);
                      }),
                ),
                SizedBox(
                  width: ThemePadding.padBase * 1.5,
                ),
                Expanded(
                  child: ThemeButton.ButtonSec(
                      text: "No",
                      onpressed: () {
                        Navigator.of(context).pop();
                      }),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}
