import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: PHAT(),
));

enum RestrictDigit { Yes, No }

class PHAT extends StatefulWidget {
  @override
  _PHATState createState() => _PHATState();
}

class _PHATState extends State<PHAT> {
  final _formKey = GlobalKey<FormState>();
  String shaValue = '256';
  String numSystem = 'Hex';
  RestrictDigit _character = RestrictDigit.No;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('PHAT'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Text',
              ),
              validator: (value){
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
                }
              ),
            DropdownButton<String>(
              value: shaValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  shaValue = newValue;
                });
              },
              items: <String>['256', '384', '512']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
              }).toList(),

            ),
            DropdownButton<String>(
              value: numSystem,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  numSystem = newValue;
                });
              },
              items: <String>['Hex', 'Base64', 'Base58']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

            ),
            Text ('Restrict the Number of Output Digits?'),
            ListTile(
              title: const Text('Yes'),
              leading: Radio(
                value: RestrictDigit.Yes,
                groupValue: _character,
                onChanged: (RestrictDigit value){
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio(
               value: RestrictDigit.No,
               groupValue: _character,
               onChanged: (RestrictDigit value){
                 setState(() {
                   _character = value;
                 });
               },
              ),
            ),
            Text('Number of Output Digits'),

          ],
        ),
      )
    );
  }
}
