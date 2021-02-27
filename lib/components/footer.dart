import 'package:flutter/material.dart';
// import 'package:user_profile_avatar/user_profile_avatar.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Text(
              'Developed by JPbroadvision',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .merge(TextStyle(color: Theme.of(context).accentColor)),
            ),
        ),
      ],
    );
  }
}
