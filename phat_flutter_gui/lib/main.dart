import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:fast_base58/fast_base58.dart';

void main() => runApp(MaterialApp(
  home: PHAT(),
));

String hashInput(String userText, String userSha) {
  var bytes = utf8.encode(userText);
  if (userSha == '256') {
    var digest1 = sha256.convert(bytes);
    String digest1str = digest1.toString();
    return digest1str;
  }
  else if (userSha == '384') {
    var digest2 = sha384.convert(bytes);
    String digest2str = digest2.toString();
    return digest2str;
  }
  else {
    var digest3 = sha512.convert(bytes);
    String digest3str = digest3.toString();
    return digest3str;
  }
}

  String numberSystemConvert (String userNumSys, String convHashText){
    List<int> bytes = hex.decode(convHashText);
    if (userNumSys == 'Hex'){
      return convHashText;
    }
    else if (userNumSys == 'Base64'){
      String base64text = base64.encode(bytes);
      return base64text;
    }
    else{
      String base58text = Base58Encode(bytes);
      return base58text;
    }
  }

String finalOutputText (String convertedText, double outputDigits){
  int outputDigitsInt = outputDigits.round();
  if (outputDigitsInt == 0){
    return convertedText;
  }
  else{
    int stringLength = convertedText.length;
    if (stringLength <= outputDigits){
      return convertedText;
    }
    else{
      String newString = convertedText.substring(0,outputDigitsInt);
      return newString;
    }
  }

}

enum RestrictDigit { Yes, No }

class PHAT extends StatefulWidget {
  @override
  _PHATState createState() => _PHATState();
}

class _PHATState extends State<PHAT> {
  final _formKey = GlobalKey<FormState>();
  String inputText = '';
  String shaValue = '256';
  String numSystem = 'Hex';
  RestrictDigit _character = RestrictDigit.No;
  double _valueRestrictDigit = 128;
  String outText = 'Output Text';
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
              onChanged: (String newValue){
                setState(() {
                  inputText = newValue;
                });
              },
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
            Text('Number of Output Digits: $_valueRestrictDigit'),
            Slider(
                min: 1,
                max: 128,
                divisions: 127,
                value: _valueRestrictDigit,
                //divisions: 10,
                onChanged: (double newValue) {
                  setState(() {
                    _valueRestrictDigit = newValue;
                  });
                },
            ),
            Text(outText),
            RaisedButton(
              child: Text('Calculate'),
              onPressed: () {
                setState(() {
                  //outText = '$inputText , $shaValue , $numSystem , $_character , $_valueRestrictDigit';
                  String _calcStep1 = hashInput(inputText, shaValue);
                  String _calcStep2 = numberSystemConvert(numSystem, _calcStep1);
                  if (_character == RestrictDigit.No) {
                    outText = _calcStep2;
                  }
                  else {
                    String _calcStep3 = finalOutputText(_calcStep2, _valueRestrictDigit);
                    outText = _calcStep3;
                  }

                });
              },
            ),

          ],
        ),
      )
    );
  }
}
