import 'package:flutter/material.dart';
import 'notifs.dart';
import 'day.dart';
import 'database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getData().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primaryColor: Colors.redAccent, primarySwatch: Colors.red),
      home: Menu(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentIndex = 0;
  bool isLoaded = true;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.redAccent,
          ),
          iconSize: 24,
          onPressed: () {
            setState(() {
              isLoaded = false;
            });
            getData().then((_) {
              setState(() {
                isLoaded = true;
                _currentIndex = 0;
              });
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.redAccent,
            ),
            iconSize: 24,
            onPressed: () {},
          )
        ],
      ),
      body: Center(
          child: !isLoaded
              ? CircularProgressIndicator()
              : PageView(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  children: <Widget>[
                    NotifPage(),
                    DayPage(day: 1),
                    DayPage(day: 2),
                    DayPage(day: 3),
                  ],
                )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 20,
        backgroundColor: Colors.white,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            _pageController.jumpToPage(value);
          });
        },
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels:
            false, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_none,
            ),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: bottonNavIcon(1),
            title: new Text('Day 1'),
          ),
          BottomNavigationBarItem(
            icon: bottonNavIcon(2),
            title: new Text('Day 2'),
          ),
          BottomNavigationBarItem(
            icon: bottonNavIcon(3),
            title: new Text('Day 3'),
          ),
        ],
      ),
    );
  }

  Widget bottonNavIcon(int num){
    return Container(
              height: 25,
              alignment: AlignmentDirectional.center,
              child: Text(
                "$num",
                style: TextStyle(
                    color: _currentIndex == num ? Colors.redAccent : Colors.grey,
                    fontFamily: 'raleway',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2,
                      color:
                          _currentIndex == num ? Colors.redAccent : Colors.grey)),
            );
  }
}
