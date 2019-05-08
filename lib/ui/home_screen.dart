import '../utils/string.dart';
import 'package:flutter/material.dart';
import 'widgets/goods_screen.dart';
import 'widgets/tiket_screen.dart';
import 'add_tikets.dart';
import 'package:login_program/ui/sport_screen.dart';
import 'package:flutter/material.dart';
import 'package:login_program/ui/lig_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_program/ui/login.dart';
import '../resources/login_bloc_provider.dart';
import 'package:login_program/resources/globals.dart' as globals;
import 'package:login_program/ui/auth_screen.dart';
import 'package:login_program/ui/widgets/sign_in_form.dart';
import 'package:login_program/ui/about_us_screens.dart';

class HomeScreen extends StatefulWidget {
  final String _emailAddress;

  HomeScreen(this._emailAddress);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  LoginBloc _bloc;
  SharedPreferences sharedPreferences;
  TabController _tabController;
  int HomeScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.remove("loginFacebook");
      //sharedPreferences.remove("login");
      //sharedPreferences.remove("loginGoogle");
    });
  }

  Widget build(BuildContext context) {
    final _ListPages = <Widget>[
      SportLigPage(widget._emailAddress),
      LigList(widget._emailAddress),
      TiketsScreen(widget._emailAddress),
      GoodsScreen(widget._emailAddress),
    ];
    final HomeScreenBottmonNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.list), title: Text('Sport list')),
      BottomNavigationBarItem(
          icon: Icon(Icons.filter_frames), title: Text('League list')),
      BottomNavigationBarItem(
          icon: Icon(Icons.library_books), title: Text('Tikets')),
      BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), title: Text('Carts')),
    ];
    assert(_ListPages.length == HomeScreenBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: HomeScreenBottmonNavBarItems,
      currentIndex: HomeScreenIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          HomeScreenIndex = index;
        });
      },
    );

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/Header-3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: ExactAssetImage('images/person.jpg'),
                radius: 100,
              ),
              accountName: Text(
                widget._emailAddress,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffd50000)),
              ),
            ),
            ListTile(
              leading: Image.asset(
                'images/team_icon.png',
                width: 45.0,
                height: 45.0,
              ),
              title: Text('About us',
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UsScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
                size: 45.0,
              ),
              //Image.asset('images/team_icon.png', width: 45.0, height: 45.0,),
              title: Text('Log out',
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
              onTap: () {
                getCredential();
                globals.isLogin = false;
                globals.loginName = null;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: _ListPages[HomeScreenIndex],
//      TabBarView(
//        controller: _tabController,
//        children: <Widget>[
//          PeopleHomeScreenScreen(),
//          MyHomeScreenScreen(widget._emailAddress),
//        ],
//      ),
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: _bottomButtons(),
    );
  }

  Widget _bottomButtons() {
    if (HomeScreenIndex == 2) {
      if (globals.admin == true) {
        return FloatingActionButton(
            backgroundColor: Color(0xffeceff1),
            child: Icon(Icons.add, color: Color(0xffd50000)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddGoalScreen(widget._emailAddress)));
            });
      }
    } else {
      return null;
    }
  }
}
