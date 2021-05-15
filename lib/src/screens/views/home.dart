import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../core/service/database_service.dart';
import '../components/custom_appbar.dart';
import '../components/drawer.dart';
import '../components/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

@override
class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = locator<DatabaseService>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(_scaffoldKey),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: screenHeight / 3.5,
                    width: screenWidth / 3.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/invigilators.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomAppBar(
                    title: 'Dashboard',
                    scaffoldKey: _scaffoldKey,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Hello! ",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset('assets/images/hand-emoji.png')
                          ],
                        ),
                        Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: _databaseService.countAttendanceRecords(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return buildCustomCard(
                                    number: snapshot.data,
                                    category: 'Attendance Records',
                                    icon: Image.asset('assets/images/attendance-record.png'),
                                  );
                                }

                                return Loading();
                              },
                            ),
                            FutureBuilder(
                              future:
                                  _databaseService.countInvigilatorRecords(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return buildCustomCard(
                                    number: snapshot.data,
                                    category: 'Invigilators',
                                    icon: Image.asset('assets/images/invigilator.png'),
                                  );
                                }

                                return Loading();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: _databaseService.countAttendantRecords(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return buildCustomCard(
                                    number: snapshot.data,
                                    category: 'Attendants',
                                    icon: Image.asset('assets/images/attendant.png'),
                                  );
                                }

                                return Loading();
                              },
                            ),
                            FutureBuilder(
                              future: _databaseService.countTARecords(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return buildCustomCard(
                                    number: snapshot.data,
                                    category: 'Teaching Assistants',
                                    icon: Image.asset('assets/images/teaching-assistant.png'),
                                  );
                                }

                                return Loading();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: _databaseService.countOtherRecords(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return buildCustomCard(
                                    number: snapshot.data,
                                    category: 'Others',
                                    icon: Image.asset('assets/images/other.png'),
                                  );
                                }

                                return Loading();
                              },
                            ),
                            /* FutureBuilder(
                              future: _databaseService.countRooms(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  return buildCustomCard(
                                    number: snapshot.data,
                                    category: 'Rooms',
                                    icon: Icon(Icons.person),
                                  );
                                }

                                return Loading();
                              },
                            ), */
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildCustomCard({int number, String category, Widget icon}) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 25,
      height: MediaQuery.of(context).size.width / 3.2,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ListTile(
            leading: icon,
            title: Text(
              '$number',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            subtitle: Text(category),
          ),
        ),
      ),
    );
  }
}
