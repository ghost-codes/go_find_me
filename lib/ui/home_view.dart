import 'package:flutter/material.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/components/home_body.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/create_post.dart';
import 'package:project_android/ui/dashboard_view.dart';
import 'package:project_android/ui/profile_view.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  HomeBloc homeBloc = sl<HomeBloc>();
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: pageController,
        children: [
          DashboardView(),
          CreatePostView(pageController: pageController),
          ProfileView(),
        ],
      )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     pageController.jumpToPage(1);
      //   },
      //   backgroundColor: ThemeColors.primary,
      //   isExtended: false,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.white,
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  pageController.jumpToPage(0);
                },
                icon: Icon(Icons.home),
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  pageController.jumpToPage(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: EdgeInsets.all(7),
                  child: Icon(
                    Icons.add,
                    color: ThemeColors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  pageController.jumpToPage(2);
                },
                icon: Icon(Icons.settings),
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
