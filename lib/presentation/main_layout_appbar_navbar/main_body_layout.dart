import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/auth/auth_bloc.dart';
import '../../application/auth/user_profile/user_profile_bloc.dart';
import '../../injection.dart';
import '../favorites/favorites.dart';
import '../home/home.dart';
import '../people/people_screen.dart';
import '../routes/router.gr.dart';
import '../search/search_screen.dart';
import 'main_bottom_navigation_bar_widget.dart';

class MainBodyLayout extends StatefulWidget {
  @override
  _MainBodyLayoutState createState() => _MainBodyLayoutState();
}

class _MainBodyLayoutState extends State<MainBodyLayout> {
  int _currentIndex = 0;
  final _children = [
    const Home(),
    SearchScreen(),
    const Favorites(automaticallyImplyLeading: false),
    const PeopleScreen(automaticallyImplyLeading: false),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<UserProfileBloc>()
            ..add(const UserProfileEvent.watchProfileStarted()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                unAuthenticated: (_) => ExtendedNavigator.of(context)
                  ..pushAndRemoveUntil(Routes.signInScreen, (route) => false),
                orElse: () {},
              );
            },
          ),
        ],
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: MainBottomNavigationBar(
            currentIndex: _currentIndex,
            onTapTapped: onTabTapped,
          ),
        ),
      ),
    );
  }
}
