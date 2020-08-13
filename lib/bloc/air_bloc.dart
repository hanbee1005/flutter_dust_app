import 'package:flutter_dust_app/models/air_result.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

class AirBloc {
  // BehaviorSubject: stream의 마지막 데이터를 반환
  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc() {
    fetch();
  }

  void fetch() async {
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;

  Future<AirResult> fetchData() async {
    var response = await http.get('http://api.airvisual.com/v2/nearest_city?key={{YOUR_KEY}}');

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }
}