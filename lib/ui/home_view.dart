import 'package:flutter/material.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/components/home_body.dart';
import 'package:project_android/themes/theme_colors.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(bloc: homeBloc),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeBloc.routeActionSink.add(RouterAction.Create);
        },
        backgroundColor: ThemeColors.primary,
        isExtended: false,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
                  homeBloc.routeActionSink.add(RouterAction.Dashboard);
                },
                icon: Icon(Icons.home),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  homeBloc.routeActionSink.add(RouterAction.Profile);
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
