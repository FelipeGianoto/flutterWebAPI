import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  static const String url = "http://192.168.15.18:3001/";
  static const String resource = "journals";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    Uri uri = Uri.parse(getUrl());
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonJournal,
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<List<Journal>> getAll() async {
    Uri uri = Uri.parse(getUrl());
    var response = await client.get(uri);
    if(response.statusCode != 200){
      throw Exception();
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for(var jsonMap in listDynamic){
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }
}
