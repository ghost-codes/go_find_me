import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_android/blocs/contributionBloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/padding.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/locationTextField.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Contribution extends StatelessWidget {
  Contribution({Key? key, this.postId = ""}) : super(key: key);
  ContributionBloc _contributionBloc = sl<ContributionBloc>();
  final String postId;

  @override
  Widget build(BuildContext context) {
    print(postId);
    return Scaffold(
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
    );
  }

  Widget contributionContent(BuildContext context, String postId) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         Navigator.of(context).pop();
          //       },
          //       child: Icon(Icons.close),
          //     )
          //   ],
          // ),
          LocationTextField(
            hintText: "Seen Location",
            controller: _contributionBloc.locationController,
            // resultSink:
          ),
          SizedBox(
            height: ThemePadding.padBase * 2,
          ),
          Text('Pick Time of sighting'),
          Container(
            // height: 70,
            child: TimePickerSpinner(
              onTimeChange: (time) {
                _contributionBloc.timeValue = time;
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
              StreamBuilder<DateTime>(
                  stream: _contributionBloc.dateStream,
                  builder: (context, snapshot) {
                    _contributionBloc.dateValue =
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
                            content: Container(
                              height: 350,
                              width: 350,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration:
                                        BoxDecoration(color: ThemeColors.white),
                                    child: Center(
                                        child: SfDateRangePicker(
                                      maxDate: DateTime.now(),
                                      initialSelectedDate: DateTime.now(),
                                      showActionButtons: true,
                                      onSubmit: (x) {
                                        if (x is DateTime) {
                                          _contributionBloc.dateSink.add(x);
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
                                        _contributionBloc.dateSink.add(x.value);
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
                _contributionBloc.postId = postId;
                print("hello");
                _contributionBloc.onSubmit(context);
              }),
        ],
      ),
    );
  }

  Widget queryView(BuildContext context) {
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
                      _contributionBloc.onViewSwitchRequest(true);
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
  }
}
