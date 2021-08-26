import 'package:flutter/material.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/ui/create_post.dart';
import 'package:project_android/ui/dashboard_view.dart';
import 'package:project_android/ui/profile_view.dart';

class HomeBody extends StatelessWidget {
  HomeBody({Key? key}) : super(key: key);

  HomeBloc homeBloc = sl<HomeBloc>();

  PageController controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PageView(
      controller: homeBloc.pageController,
      children: [
        DashboardView(),
        CreatePostView(),
        ProfileView(),
      ],
    ));
  }
}
