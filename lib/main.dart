import 'package:flutter/material.dart';
import 'package:coe_attendance/components/footer.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoE INVIGILTORS ATTENDANCE',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFFFFF),
        accentColor: const Color(0xFF9c27b0),
        canvasColor: const Color(0xFFECEFF1),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CoE INVIGILTORS ATTENDANCE'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 5),
                          blurRadius: 10)
                    ],
                  ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        
                        height: 20.0,
                      ),
                      DropdownButton<String>(
                        onChanged: popupButtonSelected,
                        value: "Child 1",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF202020),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                              value: "Child 1", child: const Text("Child 1")),
                          const DropdownMenuItem<String>(
                              value: "Child 2", child: const Text("Child 2")),
                          const DropdownMenuItem<String>(
                              value: "Child 3", child: const Text("Child 3")),
                        ],
                      ),
                      SizedBox(
                        
                        height: 20.0,
                      ),
                      DropdownButton<String>(
                        onChanged: popupButtonSelected,
                        value: "Child 1",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF202020),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                              value: "Child 1", child: const Text("Child 1")),
                          const DropdownMenuItem<String>(
                              value: "Child 2", child: const Text("Child 2")),
                          const DropdownMenuItem<String>(
                              value: "Child 3", child: const Text("Child 3")),
                        ],
                      ),
                      SizedBox(
                        
                        height: 20.0,
                        child: SizedBox(
                          
                          height: 100.0,
                        ),
                      ),
                      DropdownButton<String>(
                        onChanged: popupButtonSelected,
                        value: "Child 1",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF202020),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                              value: "Child 1", child: const Text("Child 1")),
                          const DropdownMenuItem<String>(
                              value: "Child 2", child: const Text("Child 2")),
                          const DropdownMenuItem<String>(
                              value: "Child 3", child: const Text("Child 3")),
                        ],
                      ),
                      SizedBox(
                        
                        height: 20.0,
                      ),
                      Text(
                        "Your name appears here",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                      ),
                      SizedBox(
                        
                        height: 20.0,
                      ),
                      Image.network(
                        'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        
                        height: 30.0,
                      ),
                      IconButton(
                        icon: const Icon(Icons.group_add),
                        onPressed: iconButtonPressed,
                        iconSize: 48.0,
                        color: const Color(0xFF000000),
                      ),
                      SizedBox(height: 20),
                      Footer()
                    ]),
                
                // alignment: Alignment.center,
              )
            ]),
      ),
    );
  }

  void popupButtonSelected(String value) {}

  void iconButtonPressed() {}
}
