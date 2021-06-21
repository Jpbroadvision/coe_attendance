import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/custom_appbar.dart';
import '../components/drawer.dart';
import '../components/loading.dart';
import '../providers/service_providers.dart';

final attendanceRecordsCountProvider = FutureProvider.autoDispose<int>((ref) {
  final databaseService = ref.watch(dbServiceProvider);

  return databaseService.countAttendanceRecords();
});

final invigilatorRecordsCountProvider = FutureProvider.autoDispose<int>((ref) {
  final databaseService = ref.watch(dbServiceProvider);

  return databaseService.countInvigilatorRecords();
});

final attendantRecordsCountProvider = FutureProvider.autoDispose<int>((ref) {
  final databaseService = ref.watch(dbServiceProvider);

  return databaseService.countAttendantRecords();
});

final tARecordsCountProvider = FutureProvider.autoDispose<int>((ref) {
  final databaseService = ref.watch(dbServiceProvider);

  return databaseService.countTARecords();
});

final otherRecordsCountProvider = FutureProvider.autoDispose<int>((ref) {
  final databaseService = ref.watch(dbServiceProvider);

  return databaseService.countOtherRecords();
});

class HomePage extends StatelessWidget {
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
                            Consumer(
                              builder: (context, watch, child) {
                                final aRecords =
                                    watch(attendanceRecordsCountProvider);

                                return aRecords.map(
                                    data: (data) => buildCustomCard(
                                          context,
                                          number: data.value,
                                          category: 'Attendance Records',
                                          icon: Image.asset(
                                              'assets/images/attendance-record.png'),
                                        ),
                                    loading: (_) => Loading(),
                                    error: (_) => Text('ERROR'));
                              },
                            ),
                            Consumer(
                              builder: (context, watch, child) {
                                final iRecords =
                                    watch(invigilatorRecordsCountProvider);

                                return iRecords.map(
                                    data: (data) => buildCustomCard(
                                          context,
                                          number: data.value,
                                          category: 'Invigilators',
                                          icon: Image.asset(
                                              'assets/images/invigilator.png'),
                                        ),
                                    loading: (_) => Loading(),
                                    error: (_) => Text('ERROR'));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer(
                              builder: (context, watch, child) {
                                final atRecords =
                                    watch(attendantRecordsCountProvider);

                                return atRecords.map(
                                    data: (data) => buildCustomCard(
                                          context,
                                          number: data.value,
                                          category: 'Attendants',
                                          icon: Image.asset(
                                              'assets/images/attendant.png'),
                                        ),
                                    loading: (_) => Loading(),
                                    error: (_) => Text('ERROR'));
                              },
                            ),
                            Consumer(
                              builder: (context, watch, child) {
                                final tARecords = watch(tARecordsCountProvider);

                                return tARecords.map(
                                    data: (data) => buildCustomCard(
                                          context,
                                          number: data.value,
                                          category: 'Teaching Assistants',
                                          icon: Image.asset(
                                              'assets/images/teaching-assistant.png'),
                                        ),
                                    loading: (_) => Loading(),
                                    error: (_) => Text('ERROR'));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer(
                              builder: (context, watch, child) {
                                final otherRecords =
                                    watch(otherRecordsCountProvider);

                                return otherRecords.map(
                                    data: (data) => buildCustomCard(
                                          context,
                                          number: data.value,
                                          category: 'Others',
                                          icon: Image.asset(
                                              'assets/images/other.png'),
                                        ),
                                    loading: (_) => Loading(),
                                    error: (_) => Text('ERROR'));
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

  Widget buildCustomCard(BuildContext context,
      {int number, String category, Widget icon}) {
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
