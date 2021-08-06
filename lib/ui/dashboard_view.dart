import 'package:flutter/material.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          clipBehavior: Clip.none,
          slivers: [
            SliverAppBar(
              floating: true,
              title: AppBarWidget(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: 20,
              shadowColor: ThemeColors.black,
              backgroundColor: ThemeColors.white,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  50,
                  (index) => Container(
                    padding: EdgeInsets.all(ThemePadding.padBase * 2.0),
                    margin:
                        EdgeInsets.symmetric(vertical: ThemePadding.padBase),
                    decoration: BoxDecoration(
                      color: ThemeColors.white,
                      borderRadius: ThemeBorderRadius.smallRadiusAll,
                      boxShadow: ThemeDropShadow.smallShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Title: Name",
                              style: ThemeTexTStyle.titleTextStyleBlack,
                            ),
                            IconButton(onPressed: () {}, icon: Icon(Icons.menu))
                          ],
                        ),
                        Text(
                          "12 Jun",
                          style: ThemeTexTStyle.regular,
                        ),
                        SizedBox(
                          height: ThemePadding.padBase,
                        ),
                        ImagesLogic(),
                        SizedBox(
                          height: ThemePadding.padBase,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eu at pulvinar ut ut neque, vel. Semper viverra eu eget nunc bibendum tellus id. Donec massa penatibus gravida feugiat id. ",
                          style: ThemeTexTStyle.regular,
                        ),
                        Text(
                          "Read More",
                          style: ThemeTexTStyle.regularPrim,
                        ),
                        Container(
                          // height: 50,
                          padding: EdgeInsets.all(ThemePadding.padBase),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.how_to_vote,
                                color: ThemeColors.grey,
                              ),
                              Icon(
                                Icons.share,
                                color: ThemeColors.grey,
                              ),
                              Icon(
                                Icons.comment,
                                color: ThemeColors.grey,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagesLogic extends StatelessWidget {
  const ImagesLogic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(children: [
              Expanded(child: imageContainer()),
              SizedBox(
                width: ThemePadding.padBase / 2,
              ),
              Expanded(child: imageContainer()),
            ]),
          ),
          SizedBox(
            height: ThemePadding.padBase / 2,
          ),
          Expanded(
            child: Row(children: [
              Expanded(child: imageContainer()),
              SizedBox(
                width: ThemePadding.padBase / 2,
              ),
              Expanded(child: imageContainer()),
            ]),
          ),
        ],
      ),
    );
  }

  Container imageContainer({Widget? image}) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.grey.withOpacity(0.5),
        borderRadius: ThemeBorderRadius.smallRadiusAll,
      ),
    );
  }
}

class AppBarWidget extends InputDec {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.menu,
          color: ThemeColors.primary,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            height: 40,
            child: TextField(
              decoration: inputDec(
                hint: "Search",
                prefixIcon: Icon(
                  Icons.search,
                  color: ThemeColors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Icon(
          Icons.settings,
          color: ThemeColors.primary,
        ),
      ],
    );
  }
}
