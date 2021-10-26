import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/blocs/dashboard_bloc.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:intl/intl.dart';
import 'package:project_android/ui/contribution.dart';

class DashboardView extends StatefulWidget {
  DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardBloc bloc = sl<DashboardBloc>();
  HomeBloc homeBloc = sl<HomeBloc>();
  AuthenticationBloc authBloc = sl<AuthenticationBloc>();

  @override
  void initState() {
    bloc.getFeedBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Post>>(
          stream: bloc.feedStream,
          builder: (context, snapshot) {
            print(snapshot.data != null);
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
                                        "Missing: ${snapshot.data![index].title}",
                                        style:
                                            ThemeTexTStyle.titleTextStyleBlack,
                                      ),
                                      snapshot.data![index].userId ==
                                              authBloc.user?.id
                                          ? InkWell(
                                              onTap: () async {
                                                var res = await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Post Actions"),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                  "Edit Post"),
                                                              onTap: () async {
                                                                bool res = await Navigator.pushNamed(
                                                                    context,
                                                                    '/edit_post',
                                                                    arguments: snapshot
                                                                            .data![
                                                                        index]) as bool;
                                                                if (res)
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                              },
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                  "Delete Post"),
                                                              onTap: () {
                                                                bloc.deletePost(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id!,
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    });
                                                if (res) bloc.getFeedBody();
                                              },
                                              child: Icon(
                                                Icons.more_vert,
                                                color: ThemeColors.grey,
                                              ))
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Last Seen: ${DateFormat("dd, MMM").format(snapshot.data![index].lastSeen!.date ?? DateTime.now())} @ ${snapshot.data![index].lastSeen!.location}",
                                          style: ThemeTexTStyle.regular(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: ThemePadding.padBase),
                                      Text(DateFormat("dd, MMM").format(
                                          snapshot.data![index].createdAt ??
                                              DateTime.now()))
                                    ],
                                  ),
                                  Text(
                                    "Status: ${snapshot.data![index].status}",
                                    style: ThemeTexTStyle.regular(
                                        color: ThemeColors.grey),
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
                                    style: ThemeTexTStyle.regular(),
                                  ),
                                  Text(
                                    "Read More",
                                    style: ThemeTexTStyle.regular(
                                        color: ThemeColors.primary),
                                  ),
                                  Container(
                                    // height: 50,
                                    padding:
                                        EdgeInsets.all(ThemePadding.padBase),
                                    child: snapshot.data![index].userId ==
                                            authBloc.user?.id
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.how_to_vote,
                                                    color: ThemeColors.grey,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ThemePadding.padBase /
                                                            2,
                                                  ),
                                                  Text(
                                                    "${snapshot.data![index].contributions!.length}",
                                                    style:
                                                        ThemeTexTStyle.regular(
                                                            color: ThemeColors
                                                                .grey),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: ThemeColors.grey,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ThemePadding.padBase /
                                                            2,
                                                  ),
                                                  Text(
                                                    "${snapshot.data![index].shares!}",
                                                    style:
                                                        ThemeTexTStyle.regular(
                                                            color: ThemeColors
                                                                .grey),
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      '/postResultMap');
                                                },
                                                child: Icon(
                                                  Icons.list_alt,
                                                  color: ThemeColors.grey,
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: () async {
                                              //     bool response =
                                              //         await showDialog(
                                              //             context: context,
                                              //             builder: (context) {
                                              //               return Contribute(
                                              //                 images: snapshot
                                              //                     .data![index]
                                              //                     .imgs,
                                              //               );
                                              //             });
                                              //     if (response) {
                                              //       Navigator.pushNamed(context,
                                              //           "/contribution",
                                              //           arguments: snapshot
                                              //               .data![index].id);
                                              //     }
                                              //   },
                                              //   child: Icon(
                                              //     Icons.comment,
                                              //     color: ThemeColors.grey,
                                              //   ),
                                              // ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.how_to_vote,
                                                    color: ThemeColors.grey,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ThemePadding.padBase /
                                                            2,
                                                  ),
                                                  Text(
                                                    "${snapshot.data![index].contributions!.length}",
                                                    style:
                                                        ThemeTexTStyle.regular(
                                                            color: ThemeColors
                                                                .grey),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: ThemeColors.grey,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ThemePadding.padBase /
                                                            2,
                                                  ),
                                                  Text(
                                                    "${snapshot.data![index].shares!}",
                                                    style:
                                                        ThemeTexTStyle.regular(
                                                            color: ThemeColors
                                                                .grey),
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  bool response =
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Contribute(
                                                              images: snapshot
                                                                  .data![index]
                                                                  .imgs,
                                                            );
                                                          });
                                                  if (response) {
                                                    Navigator.pushNamed(context,
                                                        "/contribution",
                                                        arguments: snapshot
                                                            .data![index].id);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.comment,
                                                  color: ThemeColors.grey,
                                                ),
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
  BuildContext? context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      height: 200,
      child: imgs!.length == 2
          ? Column(
              children: [
                Expanded(
                  child: Row(children: [
                    Expanded(child: imageContainer(imgs![0], 0)),
                    SizedBox(
                      width: ThemePadding.padBase / 2,
                    ),
                    Expanded(child: imageContainer(imgs![1], 1)),
                  ]),
                ),
              ],
            )
          : imgs!.length == 3
              ? Row(
                  children: [
                    Expanded(
                      child: Column(children: [
                        Expanded(child: imageContainer(imgs![0], 0)),
                        SizedBox(
                          height: ThemePadding.padBase / 2,
                        ),
                        Expanded(child: imageContainer(imgs![2], 2)),
                      ]),
                    ),
                    SizedBox(
                      width: ThemePadding.padBase / 2,
                    ),
                    Expanded(
                      child: Column(children: [
                        Expanded(child: imageContainer(imgs![1], 1)),
                      ]),
                    ),
                  ],
                )
              : imgs!.length > 4
                  ? Column(
                      children: [
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![0], 0)),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(child: imageContainer(imgs![1], 1)),
                          ]),
                        ),
                        SizedBox(
                          height: ThemePadding.padBase / 2,
                        ),
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![2], 1)),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(
                                child: Stack(
                              children: [
                                imageContainer(imgs![3], 3),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DisplayImages(
                                            images: imgs,
                                            initialPage: 3,
                                          );
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          ThemeBorderRadius.smallRadiusAll,
                                      color: ThemeColors.black.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "+${imgs!.length - 4} More",
                                        style: ThemeTexTStyle.regular(
                                            color: ThemeColors.white),
                                      ),
                                    ),
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
                            Expanded(child: imageContainer(imgs![0], 1)),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(child: imageContainer(imgs![1], 1)),
                          ]),
                        ),
                        SizedBox(
                          height: ThemePadding.padBase / 2,
                        ),
                        Expanded(
                          child: Row(children: [
                            Expanded(child: imageContainer(imgs![2], 2)),
                            SizedBox(
                              width: ThemePadding.padBase / 2,
                            ),
                            Expanded(child: imageContainer(imgs![3], 3)),
                          ]),
                        ),
                      ],
                    ),
    );
  }

  InkWell imageContainer(String src, index) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context!,
            builder: (context) {
              return DisplayImages(
                images: imgs,
                initialPage: index,
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
            color: ThemeColors.grey.withOpacity(0.5),
            borderRadius: ThemeBorderRadius.smallRadiusAll,
            image: DecorationImage(
                image: NetworkImage(
                  src,
                ),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class DisplayImages extends StatelessWidget {
  DisplayImages({
    Key? key,
    @required this.images,
    this.initialPage,
  }) : super(key: key);
  final List<String>? images;
  final int? initialPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.black.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: ThemeColors.black.withOpacity(0.5),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: CarouselSlider.builder(
              itemCount: images!.length,
              options: CarouselOptions(
                initialPage: initialPage ?? 0,
                enlargeCenterPage: true,
                height: 500,
                autoPlay: false,
                enableInfiniteScroll: false,
              ),
              itemBuilder: (context, index, x) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: ThemeBorderRadius.smallRadiusAll,
                    image: DecorationImage(
                      image: NetworkImage(images![index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget with InputDec {
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

class Contribute extends StatelessWidget {
  const Contribute({Key? key, this.images}) : super(key: key);
  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(ThemePadding.padBase * 1.5),
        padding: EdgeInsets.all(ThemePadding.padBase * 1.5),
        decoration: BoxDecoration(
          color: ThemeColors.white,
          borderRadius: ThemeBorderRadius.smallRadiusAll,
        ),
        width: 500,
        child: Material(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Do you recognize the person??"),
            SizedBox(
              height: ThemePadding.padBase * 2,
            ),
            Center(
              child: CarouselSlider.builder(
                itemCount: images!.length,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 350,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                ),
                itemBuilder: (context, index, x) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: ThemeBorderRadius.smallRadiusAll,
                      image: DecorationImage(
                        image: NetworkImage(images![index]),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                          Navigator.of(context).pop(true);
                        }),
                  ),
                  SizedBox(
                    width: ThemePadding.padBase * 1.5,
                  ),
                  Expanded(
                    child: ThemeButton.ButtonSec(
                        text: "No",
                        onpressed: () {
                          Navigator.of(context).pop(false);
                        }),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
