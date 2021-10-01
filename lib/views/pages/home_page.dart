import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questt/helper/session.dart';
import 'package:questt/helper/string.dart';
import 'package:questt/views/pages/groups.dart';
import 'package:questt/views/pages/my_questt.dart';
import 'package:questt/views/pages/profile.dart';
import 'package:questt/views/widgets/logout_alert.dart';

import 'content_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;
  final scffoldKey = GlobalKey<ScaffoldState>();
  String name;

  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    name = await getPrefrence(USERNAME);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgets = [HomeContentPage(), MyQuestt(), Groups(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.teal[800]),
        onTap: _onItemTapped,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.request_page_outlined),
              label: "My Questt",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "Groups",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: "Profile",
              backgroundColor: Colors.white),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/introimage_b.png'),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Hi, Kanhaiya'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.help),
                        IconButton(
                          icon: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.notifications,
                                size: 20,
                                color: Colors.grey,
                              ),
                              Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: new Text(
                                      "2",
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                            ],
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Notifications()));
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alertDialog(context);
                              },
                            );
                          },
                          icon: Icon(
                            Icons.power_settings_new,
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: widgets[_selectedIndex])
          ],
        ),
      ),
    );
  }
}
