import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key key, this.title, this.scaffoldKey, this.leading, this.trailing})
      : super(key: key);

  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
            leading: IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            trailing: trailing ?? SizedBox(),
          ),
          _buildElevation()
        ],
      ),
    );
  }

  Container _buildElevation() {
    return Container(
      height: 0.1,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
          ),
        ],
      ),
    );
  }
}
