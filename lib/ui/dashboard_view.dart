import 'package:flutter/material.dart';
import 'package:project_android/blocs/dashboard_bloc.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardBloc bloc = sl<DashboardBloc>();
  HomeBloc homeBloc = sl<HomeBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getFeedBody();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Post>>(
          stream: bloc.feedStream,
          builder: (context, snapshot) {
            return Container(
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
                    delegate: SliverChildListDelegate(snapshot.hasData &&
                            snapshot.data != null
                        ? List.generate(
                            snapshot.data!.length,
                            (index) => Container(
                              padding:
                                  EdgeInsets.all(ThemePadding.padBase * 2.0),
                              margin: EdgeInsets.symmetric(
                                  vertical: ThemePadding.padBase),
                              decoration: BoxDecoration(
                                color: ThemeColors.white,
                                borderRadius: ThemeBorderRadius.smallRadiusAll,
                                boxShadow: ThemeDropShadow.smallShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Status: ${snapshot.data![index].status}",
                                        style:
                                            ThemeTexTStyle.titleTextStyleBlack,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.more_horiz))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Title: ${snapshot.data![index].title}",
                                        style:
                                            ThemeTexTStyle.titleTextStyleBlack,
                                      ),
                                      Text(DateFormat("dd, MMM").format(
                                          snapshot.data![index].createdAt ??
                                              DateTime.now()))
                                    ],
                                  ),
                                  Text(
                                    "Last Seen12 Jun",
                                    style: ThemeTexTStyle.regular,
                                  ),
                                  SizedBox(
                                    height: ThemePadding.padBase,
                                  ),
                                  ImagesLogic(
                                    imgs: snapshot.data![index].imgs,
                                  ),
                                  SizedBox(
                                    height: ThemePadding.padBase,
                                  ),
                                  Text(
                                    snapshot.data![index].desc ?? "",
                                    style: ThemeTexTStyle.regular,
                                  ),
                                  Text(
                                    "Read More",
                                    style: ThemeTexTStyle.regularPrim,
                                  ),
                                  Container(
                                    // height: 50,
                                    padding:
                                        EdgeInsets.all(ThemePadding.padBase),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                          )
                        : [
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ]),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class ImagesLogic extends StatelessWidget {
  ImagesLogic({Key? key, this.imgs}) : super(key: key);

  List<String>? imgs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: imgs!.length == 2
          ? Column(
              children: [
                Expanded(
                  child: Row(children: [
                    Expanded(child: imageContainer(imgs![0])),
                    SizedBox(
                      width: ThemePadding.padBase / 2,
                    ),
                    Expanded(child: imageContainer(imgs![1])),
                  ]),
                ),
              ],
            )
          : imgs!.length == 3
              ? Row(
                  children: [
                    Expanded(
                      child: Column(children: [
                        Expanded(child: imageContainer(imgs![0])),
                        SizedBox(
                          height: ThemePadding.padBase / 2,
                        ),
                        Expanded(child: imageContainer(imgs![2])),
                      ]),
                    ),
                    SizedBox(
                      width: ThemePadding.padBase / 2,
                    ),
                    Expanded(
                      child: Column(children: [
                        Expanded(child: imageContainer(imgs![1])),
                      ]),
                    ),
                  ],
                )
              : imgs!.length > 4
                  ? Column(
                      children: [
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![0])),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(child: imageContainer(imgs![1])),
                          ]),
                        ),
                        SizedBox(
                          height: ThemePadding.padBase / 2,
                        ),
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![2])),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(
                                child: Stack(
                              children: [
                                imageContainer(imgs![3]),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        ThemeBorderRadius.smallRadiusAll,
                                    color: ThemeColors.black.withOpacity(0.5),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "More",
                                    style: ThemeTexTStyle.regularwhite,
                                  ),
                                )
                              ],
                            )),
                          ]),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![0])),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(child: imageContainer(imgs![1])),
                          ]),
                        ),
                        SizedBox(
                          height: ThemePadding.padBase / 2,
                        ),
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![2])),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(child: imageContainer(imgs![3])),
                          ]),
                        ),
                      ],
                    ),
    );
  }

  Container imageContainer(String src) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeColors.grey.withOpacity(0.5),
          borderRadius: ThemeBorderRadius.smallRadiusAll,
          image: DecorationImage(
              image: NetworkImage(
                src,
              ),
              fit: BoxFit.cover)),
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
