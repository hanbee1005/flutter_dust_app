import 'package:flutter/material.dart';
import 'package:flutter_dust_app/models/air_result.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult _result;

  Future<AirResult> fetchData() async {
    var response = await http.get('http://api.airvisual.com/v2/nearest_city?key={{YOUR_KEY}}');

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _result == null ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '${_result.data.state} Air Quality',
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${_result.data.location.coordinates[0]} | ${_result.data.location.coordinates[1]}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            getIcon(_result),
                            color: Colors.white70,
                            size: 80,
                          ),
                          Text(
                            '${_result.data.current.pollution.aqius}',
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            getString(_result),
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      color: getColor(_result),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.network(
                                'https://airvisual.com/images/${_result.data.current.weather.ic}.png',
                                width: 32,
                                height: 32,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                '${_result.data.current.weather.tp}도',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            '습도 ${_result.data.current.weather.hu}%',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '풍속 ${_result.data.current.weather.ws}m/s',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: RaisedButton(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  color: Colors.orange,
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    fetchData().then((airResult) {
                      setState(() {
                        _result = airResult;
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return '좋음';
    } else if (result.data.current.pollution.aqius <= 100) {
      return '보통';
    } else if(result.data.current.pollution.aqius <= 150) {
      return '나쁨';
    } else {
      return '매우 나쁨';
    }
  }

  IconData getIcon(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Icons.sentiment_satisfied;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Icons.sentiment_neutral;
    } else if(result.data.current.pollution.aqius <= 150) {
      return Icons.sentiment_dissatisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Colors.blue;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Colors.amber;
    } else if(result.data.current.pollution.aqius <= 150) {
      return Colors.redAccent;
    } else {
      return Colors.blueGrey;
    }
  }
}
