import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter/services.dart';

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
      backgroundColor: Colors.blue[600],
      appBar: AppBar(
        title: Text('PHAT'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
                'PHAT Copyright (C) 2020 Lorne Cammack This program comes with ABSOLUTELY NO WARRANTY; This is free software, and you are welcome to redistribute it under certain conditions. See https://www.gnu.org/licenses/ for more details.',
                textScaleFactor: 1.5,
            ),
          ),

        ),
    body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
              child: Container(
                color: Colors.blue[200],
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Text',
                  ),
                  onChanged: (String newValue){
                    setState(() {
                      inputText = newValue;
                    });
                  },

                  ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Container(
                  color: Colors.blue[200],
                  child: Column(
                    children: <Widget>[
                      Text(
                          '      SHA      ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
                Container(
                  color: Colors.blue[200],
                  child: Column(
                    children: <Widget>[
                      Text (
                          '   Number System   ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              ],
            ),
            Text(''),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.blue[200],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
                    child: Text (
                        'Restrict the Number of Output Digits?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              color: Colors.blue[200],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(130.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                  ],
                ),
              ),
            ),
            Text(''),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    color: Colors.blue[200],
                    child: Text(
                        '   Number of Output Digits: $_valueRestrictDigit   ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                ),
              ],
            ),
            Container(
              color: Colors.blue[200],
              child: Slider(
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 30.0),
              child: Container(
                child: SelectableText(
                    outText,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                color: Colors.blue[200],
              ),
            ),

            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.blue[200],
                      child: Text(
                          'Calculate',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.blue[200],
                      child: Text(
                          'Copy to Clipboard',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                      onPressed: () {
                        //Clipboard.setData(ClipboardData(text: quote));

                        setState(() {
                          Clipboard.setData(ClipboardData(text: outText));

                        });
                      },
                    ),
                    RaisedButton(
                      color: Colors.blue[200],
                      child: Text(
                          'Erase Clipboard',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                      onPressed: () {
                        //Clipboard.setData(ClipboardData(text: quote));

                        setState(() {
                          Clipboard.setData(ClipboardData(text: ''));


                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      )
    );
  }
}