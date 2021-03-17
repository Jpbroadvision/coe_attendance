import 'package:coe_attendance/models/inivigilators_details_model.dart';
import 'package:flutter/material.dart';

class InvigilatorCard extends StatelessWidget {
  final InvigilatorsDetailsModel invigilatorsDetails;
  final Function deleteFunction;

  InvigilatorCard({@required this.invigilatorsDetails, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      elevation: 2.0,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        childrenPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
        title: _buildTitle(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Session'),
              Text(
                '${invigilatorsDetails.session}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duration'),
              Text(
                '${invigilatorsDetails.duration}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Room'),
              Text(
                '${invigilatorsDetails.room}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date/Time'),
              Text(
                '${invigilatorsDetails.dateTime}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  // title with arrow icon for expanded card
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("${invigilatorsDetails.signImage}")),//assets/user-profile.png
              ),
              height: 50,
              width: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invigilatorsDetails.invigiName,
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${invigilatorsDetails.category}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            deleteFunction(invigilatorsDetails.id);
          },
        ),
      ],
    );
  }
}
