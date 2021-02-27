import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:coe_attendance/components/footer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  bool _showPassword = false;

  Widget build(BuildContext context) {
    return Scaffold(
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
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Other Names',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Country',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'User name',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ), //shape: StadiumBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          // fillColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.text,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.text,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          filled: false,
                          contentPadding: EdgeInsets.all(12),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).accentColor)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.check_circle),
                        iconSize: 50,
                        onPressed: () {
                          print("Sign-up is clicked");
                        },
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        onPressed: () {
                          print("Sign-in is clicked");
                        },
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                  TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                            children: [
                              TextSpan(text: 'Already Registered?'),
                              TextSpan(
                                text: ' SIGN IN',
                                // style:
                                // TextStyle(fontWeight: FontWeight.w700)
                              ),
                            ],
                          ),
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
}


