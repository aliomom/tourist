import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:tourists/generated/l10n.dart';
import 'package:tourists/module_authorization/authorization_routes.dart';
import 'package:tourists/module_guide/ui/screen/guide_list/guide_list_screen.dart';
import 'package:tourists/module_home/ui/widget/bottom_navigation_bar/buttom_navigation_bar.dart';
import 'package:tourists/module_locations/ui/screens/event_list/event_list.dart';
import 'package:tourists/module_locations/ui/screens/location_list/location_list_screen.dart';
import 'package:tourists/module_persistence/sharedpref/shared_preferences_helper.dart';

@provide
class HomeScreen extends StatefulWidget {
  final GuideListScreen _guideListScreen;
  final EventListScreen _eventListScreen;
  final LocationListScreen _locationListScreen;
  final SharedPreferencesHelper _preferencesHelper;

  HomeScreen(this._locationListScreen, this._guideListScreen,
      this._eventListScreen, this._preferencesHelper);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int position;
  bool loggedIn = false;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    widget._preferencesHelper.getUserUID().then((value) {
      loggedIn = (value != null);
      setState(() {});
    });

    Widget bottomNavBar = CustomBottomNavigationBar(
        pagePosition: position != null ? position : 0);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('سياح'),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, AuthorizationRoutes.loginTypeSelector);
              },
              child: Icon(loggedIn ? Icons.person : Icons.perm_identity),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 56,
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  widget._locationListScreen,
                  widget._guideListScreen,
                  widget._eventListScreen
                ],
                onPageChanged: (pos) {
                  // Update the Home Page
                  position = pos;
                  bottomNavBar = CustomBottomNavigationBar(
                    pagePosition: position != null ? position : 0,
                    onLocationChanged: (int position) {
                      setActivePage(position);
                    },
                  );
                  setState(() {});
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: bottomNavBar,
            )
          ],
        ),
      ),
    );
  }

  moveToPage(int position) {
    _pageController.jumpToPage(position);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.of(context).are_you_sure),
            content: new Text(S.of(context).exit_msg),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(S.of(context).no),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text(S.of(context).yes),
              ),
            ],
          ),
        ) ??
        false;
  }

  setActivePage(int position) {
    setState(() {
      this.position = position;
    });
  }
}