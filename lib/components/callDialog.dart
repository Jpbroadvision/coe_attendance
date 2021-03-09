import 'package:flutter/material.dart';

class CallSignatureDialog extends StatefulWidget {
  @override
  _CallSignatureDialogState createState() => _CallSignatureDialogState();
}

class _CallSignatureDialogState extends State<CallSignatureDialog> {
  // ignore: unused_field
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final TextEditingController _textEditingController = TextEditingController();

  Future<void> showInformationDialog(BuildContext context){
      }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: TextButton(style: TextStyle(fontStyle:  Colors.deepOrange,),
              
              onPressed: () async {
                await showInformationDialog(context);
              },
              child: Text(
                "Stateful Dialog",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
      ),
    );
  }
}
