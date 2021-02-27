import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:coe_attendance/components/footer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  var _sessions = ['1', '2', '3', '4', '5', '6', '7'];
  var _newSessionSelected = 'Select Session';
  var _currentSelectedDay = 'Select Day';
  String _value1;
  String _value2;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CoE INVIGILTORS ATTENDANCE",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      DropdownButton<String>(
                        // onChanged: selectedDayFunction,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).accentColor,
                        ),
                        value: _value1,
                        items: _daysOfWeek.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: _value1 = dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          /* call changed day function  */
                          selectedDayFunction(newValueSelected);
                        },
                        // _value1: _currentSelectedDay,
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        // onChanged: selectedSessionFunction,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).accentColor,
                        ),
                          value: _value2,
                        items: _sessions.map((String dropDownSessionItem) {
                          return DropdownMenuItem<String>(
                            value: _value2 = dropDownSessionItem,
                            child: Text(dropDownSessionItem),
                          );
                        }).toList(),
                        onChanged: (String newSessionSelected) {
                          /* call changed day function  */
                          selectedSessionFunction(newSessionSelected);
                        },
                        // value : _newSessionSelected,
                      ),
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.save),
                        iconSize: 10,
                        onPressed: () {
                          print("Save is clicked");
                        },
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Save when done",
                        style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(color: Theme.of(context).accentColor),
                            ),
                      ),
                      SizedBox(height: 20),
                      Footer()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void selectedDayFunction(String newValueSelected) {
    setState(() {
      /*...Your codes..._daysOfWeek*/
      this._currentSelectedDay = newValueSelected;
    });
  }

  void selectedSessionFunction(String newSessionSelected) {
    setState(() {
      /*...Your codes..._daysOfWeek*/
      this._newSessionSelected = newSessionSelected;
    });
  }
}
