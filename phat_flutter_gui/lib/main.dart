import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: PHAT(),
    ));

String hashInput(String userText, String? userSha) {
  var bytes = utf8.encode(userText);
  if (userSha == '256') {
    var digest1 = sha256.convert(bytes);
    String digest1str = digest1.toString();
    return digest1str;
  } else if (userSha == '384') {
    var digest2 = sha384.convert(bytes);
    String digest2str = digest2.toString();
    return digest2str;
  } else {
    var digest3 = sha512.convert(bytes);
    String digest3str = digest3.toString();
    return digest3str;
  }
}

String numberSystemConvert(String? userNumSys, String convHashText) {
  List<int> bytes = hex.decode(convHashText);
  if (userNumSys == 'Hex') {
    return convHashText;
  } else if (userNumSys == 'Base64') {
    String base64text = base64.encode(bytes);
    return base64text;
  } else {
    String base58text = Base58Encode(bytes);
    return base58text;
  }
}

String finalOutputText(String convertedText, double outputDigits) {
  int outputDigitsInt = outputDigits.round();
  if (outputDigitsInt == 0) {
    return convertedText;
  } else {
    int stringLength = convertedText.length;
    if (stringLength <= outputDigits) {
      return convertedText;
    } else {
      String newString = convertedText.substring(0, outputDigitsInt);
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
  String? shaValue = '256';
  String? numSystem = 'Hex';
  RestrictDigit? _character = RestrictDigit.No;
  double _valueRestrictDigit = 128;
  String printValue = '128';
  String outText = 'Output Text';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[600],
        appBar: AppBar(
          title: Text(
            'PHAT CALC',
            style: TextStyle(
                fontFamily: 'OverpassMono',
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'PHAT CALC Copyright (C) 2025 Lorne Cammack Version 2025.05.20 The purpose of this tool is to let an individual enter text and have a hashed output to use as the password to a site or program. The program will hash the input in SHA 256, 384, or 512 and then put output in hexadecimal, Base64, or Base58 numbering systems. The number of digits in the ouput is selectable in case a site can only have a certain number of digits in a password. The output can be copied to the clipboard so it can be pasted into the program or site and the clipboard can be cleared so that the password text does not remain there. This program comes with ABSOLUTELY NO WARRANTY; This is free software, and you are welcome to redistribute it under certain conditions. See https://www.gnu.org/licenses/ for more details. Icons made by srip from www.flaticon.com.',
              style: TextStyle(
                  fontFamily: 'OverpassMono',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
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
                        labelText: 'Enter Text',
                        hintText: 'Enter Text Here',
                      ),
                      style: TextStyle(
                          fontFamily: 'OverpassMono',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      onChanged: (String newValue) {
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
                            '   SHA   ',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: shaValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            underline: Container(
                              height: 2,
                              color: Colors.blue[800],
                            ),
                            onChanged: (String? newValue) {
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
                          Text(
                            ' Number System ',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: numSystem,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            underline: Container(
                              height: 2,
                              color: Colors.blue[800],
                            ),
                            onChanged: (String? newValue) {
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
                        child: Text(
                          'Restrict the Number of Output Digits?',
                          style: TextStyle(
                              fontFamily: 'OverpassMono',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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
                          title: const Text(
                            'Yes',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: Radio(
                            value: RestrictDigit.Yes,
                            groupValue: _character,
                            onChanged: (RestrictDigit? value) {
                              setState(() {
                                _character = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'No',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: Radio(
                            value: RestrictDigit.No,
                            groupValue: _character,
                            onChanged: (RestrictDigit? value) {
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
                        ' Number of Output Digits: $printValue ',
                        style: TextStyle(
                            fontFamily: 'OverpassMono',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
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
                        printValue = _valueRestrictDigit.toStringAsFixed(0);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 30.0),
                  child: Container(
                    child: SelectableText(
                      outText,
                      style: TextStyle(
                          fontFamily: 'OverpassMono',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.blue[200],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[200]),
                          child: Text(
                            'Calculate',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            setState(() {
                              //outText = '$inputText , $shaValue , $numSystem , $_character , $_valueRestrictDigit';
                              String _calcStep1 =
                                  hashInput(inputText, shaValue);
                              String _calcStep2 =
                                  numberSystemConvert(numSystem, _calcStep1);
                              if (_character == RestrictDigit.No) {
                                outText = _calcStep2;
                              } else {
                                String _calcStep3 = finalOutputText(
                                    _calcStep2, _valueRestrictDigit);
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[200]),
                          child: Text(
                            'Copy to Clipboard',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            //Clipboard.setData(ClipboardData(text: quote));

                            setState(() {
                              Clipboard.setData(ClipboardData(text: outText));
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[200]),
                          child: Text(
                            'Erase Clipboard',
                            style: TextStyle(
                                fontFamily: 'OverpassMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
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
          ),
        ));
  }
}
